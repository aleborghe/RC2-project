% First structure
% x = out.uni_state.signals.values(:, 1); % Coordinate x (first structure)
% y = out.uni_state.signals.values(:, 2); % Coordinate y (first structure)
% theta = out.uni_state.signals.values(:, 3); % Orientation (theta) (first structure)
% 
% Extract time data
% time1 = out.uni_state.time;
% 
% Permute and reshape the 2x1x501 array to 501x3
% ref_signals = reshape(permute(out.reference.signals.values, [3, 1, 2]), 501, 1);
% 
% Extract individual reference signals
% x_ref = ref_signals(:, 1); % Reference x
% y_ref = ref_signals(:, 2); % Reference y
% theta_ref = 0 * ones(501, 1); % Set constant reference theta, since it's not in the array
% 
% Create the plot for X
% figure;
% plot(time1, x_ref, 'b-', 'LineWidth', 1.5);
% hold on;
% plot(time1, x, 'r-', 'LineWidth', 1.5);
% xlabel('Time [s]');
% ylabel('X position [m]');
% legend("Reference x(t)", "x(t)", 'Location', 'Best'); % Add legend for clarity
% grid on;
% grid minor;
% 
% Small box with zoomed part
% axes('position', [.40 .25 .25 .25]); % Position of the zoom box
% box on; % Put box around new pair of axes
% indexOfInterest = (time1 >= 10) & (time1 <= 10.5); % Range of time to zoom
% plot(time1(indexOfInterest), x_ref(indexOfInterest), 'b-');
% hold on;
% plot(time1(indexOfInterest), x(indexOfInterest), 'r-');
% axis tight;
% ylim([260 285]);
% grid on; % Ensure grid is on in zoomed area
% grid minor;
% hold off;
% 
% Create the plot for Y
% figure;
% plot(time1, y_ref, 'b-', 'LineWidth', 1.5);
% hold on;
% plot(time1, y, 'r-', 'LineWidth', 1.5);
% xlabel('Time [s]');
% ylabel('Y position [m]');
% legend("Reference y(t)", "y(t)", 'Location', 'Best'); % Add legend for clarity
% grid on;
% grid minor;
% 
% Small box with zoomed part
% axes('position', [.50 .15 .25 .25]); % Position of the zoom box
% box on; % Put box around new pair of axes
% indexOfInterest = (time1 >= 10) & (time1 <= 10.5); % Range of time to zoom
% plot(time1(indexOfInterest), y_ref(indexOfInterest), 'b-');
% hold on;
% plot(time1(indexOfInterest), y(indexOfInterest), 'r-');
% axis tight;
% ylim([80 97]);
% grid on;
% grid minor;
% hold off;
% 
% Create the plot for Theta
% figure;
% plot(time1, theta_ref, 'b-', 'LineWidth', 1.5);
% hold on;
% plot(time1, theta, 'r-', 'LineWidth', 1.5);
% xlabel('Time [s]');
% ylabel('Theta position [rad]');
% legend("Reference theta(t)", "theta(t)", 'Location', 'Best'); % Add legend for clarity
% grid on;
% grid minor;
% 
% Small box with zoomed part
% axes('position', [.60 .25 .25 .25]); % Position of the zoom box
% box on; % Put box around new pair of axes
% indexOfInterest = (time1 >= 10.5) & (time1 <= 11.5); % Range of time to zoom
% plot(time1(indexOfInterest), theta_ref(indexOfInterest), 'b-');
% hold on;
% plot(time1(indexOfInterest), theta(indexOfInterest), 'r-');
% axis tight;
% ylim([3 3.5]);
% grid on;
% grid minor;
% hold off;% Extracting data for rho, gamma, and delta (5001x3 matrix)
rho = out.uni_state.signals.values(:, 1);   % rho (first variable)
gamma = out.uni_state.signals.values(:, 2); % gamma (second variable)
delta = out.uni_state.signals.values(:, 3); % delta (third variable)

% Extract time data (assuming this is 1D matching the data points)
time1 = out.uni_state.time;

% Create the plot for Rho, Gamma, and Delta
figure;
subplot(3,1,1); % First subplot for rho
plot(time1, rho, 'r-', 'LineWidth', 1.5);
xlabel('Time [s]');
ylabel('Rho [m]');
legend("rho(t)", 'Location', 'Best');
grid on;
grid minor;

subplot(3,1,2); % Second subplot for gamma
plot(time1, gamma, 'r-', 'LineWidth', 1.5);
xlabel('Time [s]');
ylabel('Gamma [rad]');
legend("gamma(t)", 'Location', 'Best');
grid on;
grid minor;

subplot(3,1,3); % Third subplot for delta
plot(time1, delta, 'r-', 'LineWidth', 1.5);
xlabel('Time [s]');
ylabel('Delta [unit]');
legend("delta(t)", 'Location', 'Best');
grid on;
grid minor;




