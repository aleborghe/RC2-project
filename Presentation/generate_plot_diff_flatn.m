% First structure
x = out.uni_state.signals.values(:, 1); % Coordinate x (first structure)
y = out.uni_state.signals.values(:, 2); % Coordinate y (first structure)
theta = out.uni_state.signals.values(:, 3); % Orientation (theta) (first structure)

% Second structure
x1 = out.uni_state1.signals.values(:, 1); % Coordinate x (second structure)
y1 = out.uni_state1.signals.values(:, 2); % Coordinate y (second structure)
theta1 = out.uni_state1.signals.values(:, 3); % Orientation (theta) (second structure)

% Extract data
time1 = out.uni_state.time;
time2 = out.uni_state1.time;

ref_signals = reshape(permute(out.reference.signals.values, [3, 1, 2]), 5000, 3);

x_ref = ref_signals(:, 1);
y_ref = ref_signals(:, 2); % Reference y
theta_ref = ref_signals(:, 3); % Reference theta

% Create the plot for X
figure;
plot(time1, x_ref, 'b-');
hold on;
plot(time1, x, 'r-');
xlabel('Time [s]');
ylabel('X position [m]');
legend("Reference x(t)", "x(t)");         % Add legend for clarity
grid on;
grid minor;

% Small box with zoomed part
axes('position', [.30 .20 .25 .25]); % Position of the zoom box
box on; % Put box around new pair of axes
indexOfInterest = (time1 >= 4.8) & (time1 <= 5.2); % Range of time to zoom
plot(time1(indexOfInterest), x_ref(indexOfInterest), 'b-');
hold on;
plot(time1(indexOfInterest), x(indexOfInterest), 'r-');
axis tight;
grid on; % Ensure grid is on in zoomed area
grid minor; % Minor grid lines in zoomed area
hold off;

% Create the plot for Y
figure;
plot(time1, y_ref, 'b-');
hold on;
plot(time1, y, 'r-');
xlabel('Time [s]');
ylabel('Y position [m]');
legend("Reference y(t)", "y(t)");         % Add legend for clarity
grid on;
grid minor;

% Small box with zoomed part
axes('position', [.50 .25 .25 .25]); % Position of the zoom box
box on; % Put box around new pair of axes
indexOfInterest = (time1 >= 4.8) & (time1 <= 5.2); % Range of time to zoom
plot(time1(indexOfInterest), y_ref(indexOfInterest), 'b-');
hold on;
plot(time1(indexOfInterest), y(indexOfInterest), 'r-');
xlim tight;
grid on; % Ensure grid is on in zoomed area
grid minor; % Minor grid lines in zoomed area
hold off;

% Create the plot for Theta
figure;
plot(time1, theta_ref, 'b-');
hold on;
plot(time1, theta, 'r-');
xlabel('Time [s]');
ylabel('Theta position [rad]');
legend("Reference theta(t)", "theta(t)");         % Add legend for clarity
grid on;
grid minor;

% Small box with zoomed part
axes('position', [.18 .60 .30 .30]); % Position of the zoom box
box on; % Put box around new pair of axes
indexOfInterest = (time1 >= 0.7) & (time1 <= 2.3); % Range of time to zoom
plot(time1(indexOfInterest), theta_ref(indexOfInterest), 'b-');
hold on;
plot(time1(indexOfInterest), theta(indexOfInterest), 'r-');
axis tight;
grid on; % Ensure grid is on in zoomed area
grid minor; % Minor grid lines in zoomed area
hold off;

% Small box with zoomed part
axes('position', [.58 .20 .30 .30]); % Position of the zoom box
box on; % Put box around new pair of axes
indexOfInterest = (time1 >= 4.9) & (time1 <= 5.1); % Range of time to zoom
plot(time1(indexOfInterest), theta_ref(indexOfInterest), 'b-');
hold on;
plot(time1(indexOfInterest), theta(indexOfInterest), 'r-');
xlim tight;
grid on; % Ensure grid is on in zoomed area
grid minor; % Minor grid lines in zoomed area
hold off;

%% omega

w = out.omega.signals.values(:);
timeomega = out.omega.time;

% Create the plot for Theta
figure;
plot(time1, theta_ref, 'b-');
hold on;
plot(time1, theta, 'r-');
xlabel('Time [s]');
ylabel('Theta position [rad]');
legend("Reference theta(t)", "theta(t)");         % Add legend for clarity
grid on;
grid minor;

% Small box with zoomed part
axes('position', [.58 .20 .30 .30]); % Position of the zoom box
box on; % Put box around new pair of axes
indexOfInterest = (timeomega >= 4.9) & (timeomega <= 5.1); % Range of time to zoom
plot(timeomega(indexOfInterest), w(indexOfInterest), 'm-');
hold on;
xlim tight;
legend("Omega [rad/s]"); 
grid on; % Ensure grid is on in zoomed area
grid minor; % Minor grid lines in zoomed area
hold off;
