% Circuit Parameters
a = 365;       % Length of straight sections
b = 130;       % Width of straight sections
num_points = 500; % Number of points for smoothness
x_start = 125;
y_start = 60;

% Generate NASCAR Circuit
[x_waypoint, y_waypoint] = nascar_circuit(a, b, num_points, x_start, y_start);
num_points = size(x_waypoint, 2);
% Waypoints
T = linspace(0, 10, num_points); % Seconds
fine_t = linspace(0, 10, num_points*100);

% Second lane circuit
x_start2 = x_start;
y_start2 = y_start - 35;
[x_waypoint2, y_waypoint2] = nascar_circuit(a, b+70, num_points, x_start2, y_start2);

%Parking lot
parkX = 290;  % x-coordinate of the lower-left corner
parkY = 80;  % y-coordinate of the lower-left corner
width = 60;  % Width of the rectangle
height = 30; % Height of the rectangle

% Interpolation
x_t = spline(T, x_waypoint, fine_t);             % Interpolate x(t)
y_t = spline(T, y_waypoint, fine_t);             % Interpolate y(t)
x2_t = spline(T, x_waypoint2, fine_t);             % Interpolate x(t)
y2_t = spline(T, y_waypoint2, fine_t);             % Interpolate y(t)

length = 300;

obstacle_x = 250;
obstacle_y = y_start;
start_x = obstacle_x-100;
start_y = obstacle_y;

[new_x, new_y] = obstacle_avoidance(x_t, y_t, x2_t, y2_t, length, start_x, start_y);


bg = imread('background.jpg');
figure;
imshow(bg);
hold on;

% Plot
plot(x_t, y_t, 'b-', new_x, new_y, 'r-', obstacle_x, obstacle_y, 'go', 'MarkerSize', 15, 'MarkerFaceColor', 'g');
xlabel('x(t)');
ylabel('y(t)');
title('Smooth Continuous Path');
legend('Interpolated Path', 'Obstacle overtake', 'Obstacle');

%compute velocity
dt = mean(diff(fine_t));
v_x = diff(new_x) / dt;  
v_y = diff(new_y) / dt;

% Time vector for velocity (shorter by one point)
t_velocity = fine_t(1:end-1);

% figure
% plot(t_velocity, v_x, 'r', t_velocity, v_y, 'b');
% title('Velocity Components');
% legend('v_x', 'v_y');
% xlabel('Time (s)');
% ylabel('Velocity');

theta_ref = atan2(v_y, v_x);

v = sqrt(v_x.^2 + v_y.^2);
%data = [x_t(1:end-1); y_t(1:end-1); theta_ref]'; % Transponiamo per avere [N, 3]
data = [new_x(1:end-1); new_y(1:end-1); theta_ref]'; % Transponiamo per avere [N, 3]

time = t_velocity'; % Il tempo deve essere una colonna

% Creiamo una timeseries con le dimensioni appropriate
ref_data = timeseries(data, time);
ref_data.Name = 'ReferenceData';  % Nome opzionale per la variabile
v_input = timeseries(v, time);
v_input.Name = 'V-input';  % Nome opzionale per la variabile

function [new_x, new_y] = obstacle_avoidance(x_t, y_t, x2_t, y2_t, length, start_x, start_y)
    t = linspace(-5, 5, 300); % Adjust range for smoothness
    x1 = 1 ./ (1 + exp(-t));
    x2 = exp(-t) ./ (1 + exp(-t));
    trapezoid = [x1, x1(end)*ones(1,length), x2];
    index = find(abs(x_t - start_x) < 0.2);
    index = index(1);
    size_trap = size(trapezoid, 2);
    range = index:index+size_trap-1;
    new_x = x_t;
    new_y = y_t;
    new_x(range) = new_x(range) + (x2_t(range) - x_t(range)).*trapezoid;
    new_y(range) = new_y(range) + (y2_t(range) - y_t(range)).*trapezoid;
end
