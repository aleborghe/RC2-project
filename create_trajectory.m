% Load and display background image
bg = imread('background.jpg');
figure;
imshow(bg);
hold on;

% Circuit Parameters
a = 365;       % Length of straight sections
b = 130;       % Width of straight sections
num_points = 500; % Number of points for smoothness
x_start = 125;
y_start = 60;

% Generate NASCAR Circuit
[x, y] = nascar_circuit(a, b, num_points, x_start, y_start);

%Plot parking lot
parkX = 290;  % x-coordinate of the lower-left corner
parkY = 80;  % y-coordinate of the lower-left corner
width = 60;  % Width of the rectangle
height = 30; % Height of the rectangle
rectangle('Position', [parkX, parkY, width, height], 'FaceColor', 'blue', 'EdgeColor', 'black');

% Waypoints
T = 0:num_points; % Example time values
fine_t = linspace(0, num_points, (num_points+1)*10);

% Interpolation
x_t = spline(T, x, fine_t);             % Interpolate x(t)
y_t = spline(T, y, fine_t);             % Interpolate y(t)

% Plot
plot(x_t, y_t, 'b-', x, y, 'ro');
xlabel('x(t)');
ylabel('y(t)');
title('Smooth Continuous Path');
legend('Interpolated Path', 'Waypoints');