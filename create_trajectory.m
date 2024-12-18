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
fine_t = linspace(0, 10, num_points*10);

%Parking lot
parkX = 290;  % x-coordinate of the lower-left corner
parkY = 80;  % y-coordinate of the lower-left corner
width = 60;  % Width of the rectangle
height = 30; % Height of the rectangle

% Interpolation
x_t = spline(T, x_waypoint, fine_t);             % Interpolate x(t)
y_t = spline(T, y_waypoint, fine_t);             % Interpolate y(t)

%compute velocity
dt = mean(diff(fine_t));
v_x = diff(x_t) / dt;  
v_y = diff(y_t) / dt;

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
data = [x_t(1:end-1); y_t(1:end-1); theta_ref]'; % Transponiamo per avere [N, 3]
time = t_velocity'; % Il tempo deve essere una colonna

% Creiamo una timeseries con le dimensioni appropriate
ref_data = timeseries(data, time);
ref_data.Name = 'ReferenceData';  % Nome opzionale per la variabile
v_input = timeseries(v, time);
v_input.Name = 'V-input';  % Nome opzionale per la variabile
