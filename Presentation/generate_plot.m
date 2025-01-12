% % First structure
% x = out.uni_state.signals.values(:, 1); % Coordinate x (first structure)
% y = out.uni_state.signals.values(:, 2); % Coordinate y (first structure)
% theta = out.uni_state.signals.values(:, 3); % Orientation (theta) (first structure)
% 
% % Second structure
% x1 = out.uni_state1.signals.values(:, 1); % Coordinate x (second structure)
% y1 = out.uni_state1.signals.values(:, 2); % Coordinate y (second structure)
% theta1 = out.uni_state1.signals.values(:, 3); % Orientation (theta) (second structure)
% 
% % Extract data
% time1 = out.uni_state.time;
% time2 = out.uni_state1.time;
% 
% ref_signals = reshape(permute(out.reference.signals.values, [3, 1, 2]), 1250, 3);
% 
% x_ref = ref_signals(:, 1);
% y_ref = ref_signals(:, 2); % Reference y
% theta_ref = ref_signals(:, 3); % Reference theta
% 
% % Create the plot for X
% figure;
% plot(time1, x_ref, 'b-');
% hold on;
% plot(time1, x, 'r-');
% xlabel('Time [s]');
% ylabel('X position [m]');
% legend("Reference x(t)", "x(t)");         % Add legend for clarity
% grid on;
% grid minor;
% 
% % Small box with zoomed part
% axes('position', [.62 .62 .25 .25]); % Position of the zoom box
% box on; % Put box around new pair of axes
% indexOfInterest = (time1 >= 4.9) & (time1 <= 5.5); % Range of time to zoom
% plot(time1(indexOfInterest), x_ref(indexOfInterest), 'b-');
% hold on;
% plot(time1(indexOfInterest), x(indexOfInterest), 'r-');
% axis tight;
% grid on; % Ensure grid is on in zoomed area
% grid minor; % Minor grid lines in zoomed area
% hold off;
% 
% % Small box with zoomed part
% axes('position', [.25 .25 .25 .25]); % Position of the zoom box
% box on; % Put box around new pair of axes
% indexOfInterest = (time1 >= 0.8) & (time1 <= 2.5); % Range of time to zoom
% plot(time1(indexOfInterest), x_ref(indexOfInterest), 'b-');
% hold on;
% plot(time1(indexOfInterest), x(indexOfInterest), 'r-');
% axis tight;
% ylim([248 560]); % Adjust y-axis limits for the zoomed-in plot
% grid on; % Ensure grid is on in zoomed area
% grid minor; % Minor grid lines in zoomed area
% hold off;
% 
% % Create the plot for Y
% figure;
% plot(time1, y_ref, 'b-');
% hold on;
% plot(time1, y, 'r-');
% xlabel('Time [s]');
% ylabel('Y position [m]');
% legend("Reference y(t)", "y(t)");         % Add legend for clarity
% grid on;
% grid minor;
% 
% % Small box with zoomed part
% axes('position', [.50 .25 .25 .25]); % Position of the zoom box
% box on; % Put box around new pair of axes
% indexOfInterest = (time1 >= 4.9) & (time1 <= 5.5); % Range of time to zoom
% plot(time1(indexOfInterest), y_ref(indexOfInterest), 'b-');
% hold on;
% plot(time1(indexOfInterest), y(indexOfInterest), 'r-');
% axis tight;
% grid on; % Ensure grid is on in zoomed area
% grid minor; % Minor grid lines in zoomed area
% hold off;
% 
% % Small box with zoomed part
% axes('position', [.15 .65 .25 .25]); % Position of the zoom box
% box on; % Put box around new pair of axes
% indexOfInterest = (time1 >= 0.8) & (time1 <= 2.5); % Range of time to zoom
% plot(time1(indexOfInterest), y_ref(indexOfInterest), 'b-');
% hold on;
% plot(time1(indexOfInterest), y(indexOfInterest), 'r-');
% axis tight;
% ylim([20 62]); % Adjust y-axis limits for the zoomed-in plot
% grid on; % Ensure grid is on in zoomed area
% grid minor; % Minor grid lines in zoomed area
% hold off;
% 
% % Create the plot for Theta
% figure;
% plot(time1, theta_ref, 'b-');
% hold on;
% plot(time1, theta, 'r-');
% xlabel('Time [s]');
% ylabel('Theta position [rad]');
% legend("Reference theta(t)", "theta(t)");         % Add legend for clarity
% grid on;
% grid minor;
% 
% % Small box with zoomed part
% axes('position', [.60 .18 .25 .35]); % Position of the zoom box
% box on; % Put box around new pair of axes
% indexOfInterest = (time1 >= 4.8) & (time1 <= 5.2); % Range of time to zoom
% plot(time1(indexOfInterest), theta_ref(indexOfInterest), 'b-');
% hold on;
% plot(time1(indexOfInterest), theta(indexOfInterest), 'r-');
% axis tight;
% ylim([1.2 4.8]); % Adjust y-axis limits for the zoomed-in plot
% grid on; % Ensure grid is on in zoomed area
% grid minor; % Minor grid lines in zoomed area
% hold off;
% 
% % Small box with zoomed part
% axes('position', [.15 .65 .25 .25]); % Position of the zoom box
% box on; % Put box around new pair of axes
% indexOfInterest = (time1 >= 0.8) & (time1 <= 2.5); % Range of time to zoom
% plot(time1(indexOfInterest), theta_ref(indexOfInterest), 'b-');
% hold on;
% plot(time1(indexOfInterest), theta(indexOfInterest), 'r-');
% axis tight;
% ylim([-1.5 1.5]); % Adjust y-axis limits for the zoomed-in plot
% grid on; % Ensure grid is on in zoomed area
% grid minor; % Minor grid lines in zoomed area
% hold off;

% Extract data
rho = out.ScopeData1.signals(1).values; % Extract the rho signal (first column of data)
velocity = out.ScopeData1.signals(2).values(:); % Flatten the velocity values
time = out.ScopeData1.time; % Assuming the time data is stored in out.ScopeData1.time

% Create the main plot for rho and velocity
figure;

% Plot rho (blue)
plot(time, rho, 'b-', 'LineWidth', 1.5);
hold on;

% Plot velocity (red)
plot(time, velocity, 'r-', 'LineWidth', 1.5);

% Add labels and title
xlabel('Time [s]');
ylabel('Signal Value');
title('Rho and Velocity Signals Over Time');
legend('Rho', 'Velocity');
grid on;
grid minor;

% Small box with zoomed part for Rho and Velocity
% Position of the zoom box for Rho
axes('position', [.35 .62 .50 .25]); % Position of the zoom box
box on; % Put box around new pair of axes
indexOfInterest = (time >= 10) & (time <= 10.5); % Range of time to zoom for Rho and Velocity
plot(time(indexOfInterest), rho(indexOfInterest), 'b-', 'LineWidth', 1.5);
hold on;
plot(time(indexOfInterest), velocity(indexOfInterest), 'r-', 'LineWidth', 1.5);
axis tight;
grid on; % Ensure grid is on in zoomed area
grid minor; % Minor grid lines in zoomed area
hold off;






% % Extract data from ScopeData1
% x = out.ScopeData1.signals(1).values(:, 1); % Coordinate x
% y = out.ScopeData1.signals(1).values(:, 2); % Coordinate y
% theta = out.ScopeData1.signals(1).values(:, 3); % Orientation (theta)
% 
% % Extract reference data from ScopeData1
% ref_signals = squeeze(out.ScopeData1.signals(2).values); % Reshape to 3x5001 matrix
% x_ref = ref_signals(1, :); % Reference x
% y_ref = ref_signals(2, :); % Reference y
% theta_ref = ref_signals(3, :); % Reference theta
% 
% % Time data (assuming same time vector for both signals)
% time = out.ScopeData1.time; % Time vector (same for both signals)
% 
% % Create the plot for X
% figure;
% plot(time, x_ref, 'b-'); % Plot reference x
% hold on;
% plot(time, x, 'r-'); % Plot x
% xlabel('Time [s]');
% ylabel('X position [m]');
% legend("Reference x(t)", "x(t)"); % Add legend for clarity
% grid on;
% grid minor;
% 
% % Small box with zoomed part
% axes('position', [.62 .35 .25 .25]); % Position of the zoom box
% box on; % Put box around new pair of axes
% indexOfInterest = (time >= 10.2) & (time <= 10.4); % Range of time to zoom
% plot(time(indexOfInterest), x_ref(indexOfInterest), 'b-');
% hold on;
% plot(time(indexOfInterest), x(indexOfInterest), 'r-');
% axis tight;
% grid on;
% grid minor;
% hold off;
% 
% 
% % Create the plot for Y
% figure;
% plot(time, y_ref, 'b-'); % Plot reference y
% hold on;
% plot(time, y, 'r-'); % Plot y
% xlabel('Time [s]');
% ylabel('Y position [m]');
% legend("Reference y(t)", "y(t)"); % Add legend for clarity
% grid on;
% grid minor;
% 
% % Small box with zoomed part
% axes('position', [.50 .25 .25 .25]); % Position of the zoom box
% box on; % Put box around new pair of axes
% indexOfInterest = (time >= 10.2) & (time <= 10.5); % Range of time to zoom
% plot(time(indexOfInterest), y_ref(indexOfInterest), 'b-');
% hold on;
% plot(time(indexOfInterest), y(indexOfInterest), 'r-');
% axis tight;
% grid on;
% grid minor;
% hold off;
% 
% 
% 
% % Create the plot for Theta
% figure;
% plot(time, theta_ref, 'b-'); % Plot reference theta
% hold on;
% plot(time, theta, 'r-'); % Plot theta
% xlabel('Time [s]');
% ylabel('Theta position [rad]');
% legend("Reference theta(t)", "theta(t)"); % Add legend for clarity
% grid on;
% grid minor;
% 
% % Small box with zoomed part
% axes('position', [.60 .18 .25 .35]); % Position of the zoom box
% box on; % Put box around new pair of axes
% indexOfInterest = (time >= 10.2) & (time <= 10.4); % Range of time to zoom
% plot(time(indexOfInterest), theta_ref(indexOfInterest), 'b-');
% hold on;
% plot(time(indexOfInterest), theta(indexOfInterest), 'r-');
% axis tight;
% ylim([0.8 2]); % Adjust y-axis limits for the zoomed-in plot
% grid on;
% grid minor;
% hold off;
% 
% 
% 
