% Circuit Parameters
a = 365;       % Length of straight sections
b = 130;       % Width of straight sections
num_points = 500; % Number of points for smoothness
x_start = 125;
y_start = 60;

squared_corner = true;  %change to have a squared corner or round corner

if squared_corner
    bg = imread('background.jpg');
    % Generate NASCAR Circuit
    [x_waypoint, x1_waypoint, y_waypoint, y1_waypoint] = square_circuit(a, b, num_points, x_start, y_start);
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
else
    bg = imread('background2.jpg');
    % Generate NASCAR Circuit
    [x_waypoint, y_waypoint] = nascar_circuit(a, b, num_points, x_start, y_start);
    
    num_points = size(x_waypoint, 2);
    % Waypoints
    T = linspace(0, 10, num_points); % Seconds
    fine_t = linspace(0, 10, num_points * 100);
    % Interpolation
    x_t = spline(T, x_waypoint, fine_t);             % Interpolate x(t)
    y_t = spline(T, y_waypoint, fine_t);             % Interpolate y(t)
end

figure;
imshow(bg);
hold on;

% Plot the original path (blue)
plot(x_t, y_t, 'b-', 'LineWidth', 2); 

% Labels and legend
xlabel('x(t)');
ylabel('y(t)');
title('Smooth Continuous Path');

% Plot the parking lot (blue rectangle)
parkX = 290;  
parkY = 80;   
width = 60;   
height = 30;  
rectangle('Position', [parkX, parkY, width, height], 'FaceColor', 'blue', 'EdgeColor', 'black');
text(parkX + width/2, parkY + height/2, 'Parking Lot', 'Color', 'white', 'HorizontalAlignment', 'center');

dt = mean(diff(fine_t));
v_x = diff(x_t) / dt;
v_y = diff(y_t) / dt;

% Time vector for velocity (shorter by one point)
t_velocity = fine_t(1:end-1);

% Compute heading and speed
theta_ref = atan2(v_y, v_x);
v = sqrt(v_x.^2 + v_y.^2);

% Data for timeseries
data = [x_t(1:end-1); y_t(1:end-1); theta_ref]'; % [x, y, heading]
time = t_velocity'; % Time column

% Create timeseries objects
ref_data = timeseries(data, time);
ref_data.Name = 'ReferenceData'; % Optional name
v_input = timeseries(v, time);
v_input.Name = 'V-input'; % Optional name