% Circuit Parameters
a = 365;       % Length of straight sections
b = 130;       % Width of straight sections
num_points = 500; % Number of points for smoothness
x_start = 125;
y_start = 60;

x_start2 = x_start;
y_start2 = y_start - 35;

squared_corner = true;  %change to have a squared corner or round corner

if squared_corner
    bg = imread('background.jpg');
    % Generate NASCAR Circuit
    [x_waypoint, x1_waypoint, y_waypoint, y1_waypoint] = square_circuit(a, b, num_points, x_start, y_start);
    % Second lane circuit (used for overtaking)
    [x_waypoint2, x1_waypoint2, y_waypoint2, y1_waypoint2] = square_circuit(a, b + 70, num_points, x_start2, y_start2);
    num_points1 = size(x_waypoint, 2);
    num_points2 = size(x1_waypoint, 2);
    % Waypoints
    T = linspace(0, 10, num_points1+num_points2); % Seconds
    T1 = T(1:num_points1);
    T2 = T(num_points1+1:end);
    fine_t = linspace(0, 10, (num_points1+num_points2)*100); % Seconds
    fine_t1 = fine_t(1:num_points1*100);
    fine_t2 = fine_t(num_points1*100+1:end);
%     % Interpolation
    x_t = [spline(T1, x_waypoint, fine_t1), spline(T2, x1_waypoint, fine_t2)];          % Interpolate x(t)
    y_t = [spline(T1, y_waypoint, fine_t1), spline(T2, y1_waypoint, fine_t2)];             % Interpolate y(t)
    x2_t = [spline(T1, x_waypoint2, fine_t1), spline(T2, x1_waypoint2, fine_t2)];           % Interpolate x(t) for overtaking
    y2_t = [spline(T1, y_waypoint2, fine_t1), spline(T2, y1_waypoint2, fine_t2)];          % Interpolate y(t) for overtaking
else
    bg = imread('background2.jpg');
    % Generate NASCAR Circuit
    [x_waypoint, y_waypoint] = nascar_circuit(a, b, num_points, x_start, y_start);
    % Second lane circuit (used for overtaking)
    [x_waypoint2, y_waypoint2] = nascar_circuit(a, b + 70, num_points, x_start2, y_start2);
    num_points = size(x_waypoint, 2);
    % Waypoints
    T = linspace(0, 10, num_points); % Seconds
    fine_t = linspace(0, 10, num_points * 100);
    % Interpolation
    x_t = spline(T, x_waypoint, fine_t);             % Interpolate x(t)
    y_t = spline(T, y_waypoint, fine_t);             % Interpolate y(t)
    x2_t = spline(T, x_waypoint2, fine_t);           % Interpolate x(t) for overtaking
    y2_t = spline(T, y_waypoint2, fine_t);           % Interpolate y(t) for overtaking
end

% Obstacle parameters
obstacle_x = x_start+a/2;
obstacle_y = y_start;

% Modify trajectory with obstacle avoidance
[new_x, new_y, overtaking_start_idx, overtaking_end_idx] = obstacle_avoidance_with_early_detection(x_t, y_t, x2_t, y2_t, obstacle_x, obstacle_y);

% Ensure the trajectory ends at the starting point
new_x(end) = x_t(1);  % Ensure final x matches starting x
new_y(end) = y_t(1);  % Ensure final y matches starting y

% Background and visualization

figure;
imshow(bg);
hold on;

% Plot the original path (blue)
plot(x_t, y_t, 'b-', 'LineWidth', 2); 
plot(x2_t, y2_t, 'r-', 'LineWidth', 2); 

%Plot the overtaking path (only the trapezoidal portion in red)
if ~isempty(overtaking_start_idx)
    % Trapezoidal portion of the overtaking path (only the avoidance part)
    plot(new_x(overtaking_start_idx:overtaking_end_idx), new_y(overtaking_start_idx:overtaking_end_idx), 'r-', 'LineWidth', 2);
end

% Plot the obstacle (green circle)
h_obstacle = plot(obstacle_x, obstacle_y, 'go', 'MarkerSize', 20, 'MarkerFaceColor', 'g'); 

% Labels and legend
xlabel('x(t)');
ylabel('y(t)');
title('Smooth Continuous Path with Obstacle Avoidance');

% Create legend only if the respective objects exist
legend_entries = {'Original Path', 'Obstacle'};
if ~isempty(overtaking_start_idx)
    legend_entries{end+1} = 'Overtaking Path (Trapezoidal Portion)'; % Add overtaking path if plotted
end

% Display the legend
legend(legend_entries);
% Compute velocity


% Plot the parking lot (blue rectangle)
parkX = 290;  
parkY = 80;   
width = 60;   
height = 30;  
rectangle('Position', [parkX, parkY, width, height], 'FaceColor', 'blue', 'EdgeColor', 'black');
text(parkX + width/2, parkY + height/2, 'Parking Lot', 'Color', 'white', 'HorizontalAlignment', 'center');

dt = mean(diff(fine_t));
v_x = diff(new_x) / dt;
v_y = diff(new_y) / dt;

% Time vector for velocity (shorter by one point)
t_velocity = fine_t(1:end-1);

% Compute heading and speed
theta_ref = atan2(v_y, v_x);
v = sqrt(v_x.^2 + v_y.^2);

% Data for timeseries
data = [new_x(1:end-1); new_y(1:end-1); theta_ref]'; % [x, y, heading]
time = t_velocity'; % Time column

% Create timeseries objects
ref_data = timeseries(data, time);
ref_data.Name = 'ReferenceData'; % Optional name
v_input = timeseries(v, time);
v_input.Name = 'V-input'; % Optional name

% Save to the root folder
save('../ref_data.mat', 'ref_data');

% Function to handle obstacle avoidance
function [new_x, new_y, overtaking_start_idx, overtaking_end_idx] = obstacle_avoidance_with_early_detection(x_t, y_t, x2_t, y2_t, obstacle_x, obstacle_y)
    % Parameters for early detection and avoidance
    t = linspace(-7, 7, 3000); % Adjust range for smoothness
    x1 = 1 ./ (1 + exp(-t));
    x2 = exp(-t) ./ (1 + exp(-t));
    trapezoid = [x1, x1(end)*ones(1,800), x2];
    detection_margin_x = 80; % Detection range in x-direction
    detection_margin_y = 50; % Detection range in y-direction
    early_detection_distance = 50; % Distance ahead of obstacle to start overtaking
    size_trap = length(trapezoid); % Length of avoidance maneuver

    % Initialize new trajectory
    new_x = x_t; % Start with the original trajectory
    new_y = y_t;

    % Detect the obstacle earlier (at a distance ahead of it)
    overtaking_done = false;  % Flag to indicate if overtaking was performed
    overtaking_start_idx = 0; % Index of overtaking start
    overtaking_end_idx = 0;   % Index of overtaking end

    for i = 1:length(x_t)
        % Check if obstacle is within detection range and ahead of the obstacle
        if (abs(x_t(i) - obstacle_x) < detection_margin_x && abs(y_t(i) - obstacle_y) < detection_margin_y) && x_t(i) < obstacle_x + early_detection_distance
            % Perform overtaking (avoidance maneuver)
            overtaking_start_idx = i;
            range = i:(i + size_trap - 1);
            range(range > length(x_t)) = []; % Ensure range doesn't exceed trajectory length
            new_x(range) = new_x(range) + (x2_t(range) - x_t(range)) .* trapezoid(1:length(range));
            new_y(range) = new_y(range) + (y2_t(range) - y_t(range)) .* trapezoid(1:length(range));
            overtaking_end_idx = range(end);
            overtaking_done = true;
            break; % Exit loop after avoidance is applied
        end
    end

    % If overtaking was performed, reset to original trajectory after overtaking
    if overtaking_done
        % Reset to the original path after the overtaking maneuver
        if overtaking_end_idx < length(x_t)
            new_x(overtaking_end_idx + 1:end) = x_t(overtaking_end_idx + 1:end);  % Restore original path
            new_y(overtaking_end_idx + 1:end) = y_t(overtaking_end_idx + 1:end);  % Restore original path
        end
    end
end



