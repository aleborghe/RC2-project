% Circuit Parameters
a = 365;       % Length of straight sections
b = 135;       % Width of straight sections
num_points = 500; % Number of points for smoothness
x_start = 125;
y_start = 60;

% Second lane circuit (used for overtaking)
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
overtake_length = 800;

overtake_trajectory = createOvertake(overtake_length);


% Background and visualization
bg = imread('background.jpg');
figure;
imshow(bg);
hold on;

% Plot the original path (blue)
plot(x_t, y_t, 'b-', 'LineWidth', 2); 
plot(x2_t, y2_t, 'r-', 'LineWidth', 2);

% Plot the obstacle (green circle)
h_obstacle = plot(obstacle_x,obstacle_y, 'go', 'MarkerSize', 20, 'MarkerFaceColor', 'g'); 

% Labels and legend
xlabel('x(t)');
ylabel('y(t)');
title('Smooth Continuous Path with Obstacle Avoidance');

% Create legend only if the respective objects exist
legend_entries = {'Original Path', 'Obstacle'};

% Display the legend
legend(legend_entries);

% Plot the parking lot (blue rectangle)
parkX = 290;  
parkY = 80;   
width = 60;   
height = 30;  
rectangle('Position', [parkX, parkY, width, height], 'FaceColor', 'blue', 'EdgeColor', 'black');
text(parkX + width/2, parkY + height/2, 'Parking Lot', 'Color', 'white', 'HorizontalAlignment', 'center');

dt = mean(diff(fine_t));
t_velocity = fine_t(1:end-1);

% Data for timeseries
data = [x_t(1:end-1); y_t(1:end-1)]'; % [x, y, heading]
time = t_velocity'; % Time column
data2 = [x2_t(1:end-1); y2_t(1:end-1)]'; % [x, y, heading]

% Create timeseries objects
ref_data = timeseries(data, time);
ref_data.Name = 'ReferenceData'; % Optional name
second_lane = timeseries(data2, time);
current_time = timeseries(time, time);
overtake_time = time(1:length(overtake_trajectory));
overtake_data = overtake_trajectory;
% Save to the root folder
save('../ref_data.mat', 'ref_data');

run("gains.m");

function overtake = createOvertake(length)
    t = linspace(-7, 7, 3000); % Adjust range for smoothness
    x1 = 1 ./ (1 + exp(-t));
    x2 = exp(-t) ./ (1 + exp(-t));
    overtake = [0, x1, x1(end)*ones(1,length), x2];
end