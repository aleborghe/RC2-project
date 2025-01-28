% signals = reshape(permute(out.uni_state1.signals.values, [3, 1, 2]), 1251, 3);
% 
% % First structure
% x = signals(:, 1); % Coordinate x (first structure)
% y = signals(:, 2); % Coordinate y (first structure)
% theta = signals(:, 3); % Orientation (theta) (first structure)
% 
% % % Second structure
% % x1 = out.uni_state2.signals.values(:, 1); % Coordinate x (second structure)
% % y1 = out.uni_state2.signals.values(:, 2); % Coordinate y (second structure)
% % theta1 = out.uni_state2.signals.values(:, 3); % Orientation (theta) (second structure)
% 
% % Extract data
% time1 = out.uni_state1.time;
% %time2 = out.uni_state2.time;
% 
% %ref_signals = reshape(permute(out.reference1.signals.values, [3, 1, 2]), 1251, 3);
% 
% % x_ref = ref_signals(:, 1);
% % y_ref = ref_signals(:, 2); % Reference y
% % theta_ref = ref_signals(:, 3);
% index = (time1 <= 12.5);
% % Create the plot for X
% figure;
% %plot(time1(index), x_ref(index), 'b-');
% hold on;
% plot(time1(index), x(index), 'r-');
% xlabel('Time [s]');
% ylabel('Roh');
% legend("Roh");         % Add legend for clarity
% grid on;
% grid minor;
% 
% % % Small box with zoomed part
% % axes('position', [.65 .45 .25 .25]); % Position of the zoom box
% % box on; % Put box around new pair of axes
% % indexOfInterest = (time1 >= 9.9) & (time1 <= 10.6); % Range of time to zoom
% % plot(time1(indexOfInterest), x_ref(indexOfInterest), 'b-');
% % hold on;
% % plot(time1(indexOfInterest), x(indexOfInterest), 'r-');
% % axis tight;
% % grid on; % Ensure grid is on in zoomed area
% % grid minor; % Minor grid lines in zoomed area
% % hold off;
% 
% % Create the plot for Y
% figure;
% plot(time1(index), theta(index), 'b-');
% hold on;
% plot(time1(index), y(index), 'r-');
% xlabel('Time [s]');
% ylabel('Gamma, delta [rad]');
% legend("Gamma(t)", "Delta(t)");         % Add legend for clarity
% grid on;
% grid minor;
% 
% % % Small box with zoomed part
% % axes('position', [.65 .45 .25 .25]); % Position of the zoom box
% % box on; % Put box around new pair of axes
% % indexOfInterest = (time1 >= 9.9) & (time1 <= 10.6); % Range of time to zoom
% % plot(time1(indexOfInterest), y_ref(indexOfInterest), 'b-');
% % hold on;
% % plot(time1(indexOfInterest), y(indexOfInterest), 'r-');
% % axis tight;
% % grid on; % Ensure grid is on in zoomed area
% % grid minor; % Minor grid lines in zoomed area
% % hold off;
% 
% % % Create the plot for Theta
% % figure;
% % plot(time1(index), theta_ref(index), 'b-');
% % hold on;
% % plot(time1(index), theta(index), 'r-');
% % xlabel('Time [s]');
% % ylabel('Theta position [rad]');
% % legend("Reference theta(t)", "theta(t)");         % Add legend for clarity
% % grid on;
% % grid minor;
% % 
% % % Small box with zoomed part
% % axes('position', [.65 .25 .25 .25]); % Position of the zoom box
% % box on; % Put box around new pair of axes
% % indexOfInterest = (time1 >= 0.8) & (time1 <= 3); % Range of time to zoom
% % plot(time1(indexOfInterest), theta_ref(indexOfInterest), 'b-');
% % hold on;
% % plot(time1(indexOfInterest), theta(indexOfInterest), 'r-');
% % axis tight;
% % ylim([1.2 3.3]); % Adjust y-axis limits for the zoomed-in plot
% % grid on; % Ensure grid is on in zoomed area
% % grid minor; % Minor grid lines in zoomed area
% % hold off;
% % omega = reshape(permute(out.ScopeData1.signals.values, [3, 1, 2]), 5001, 1);
% % figure;
% % hold on;
% % plot(time1(index), omega(index), 'r-');
% % xlabel('Time [s]');
% % ylabel('Omega [rad/s]');
% % legend("Omega(t)");         % Add legend for clarity
% % grid on;
% % grid minor;
% Reshape omega data from out.omega_data.signals.values (1x1x10000) to a 1D array
% omega = reshape(out.omega_data.signals.values, [], 1); % Convert to 10000x1 vector
% 
% % Extract the corresponding time vector for omega
% time_omega = out.omega_data.time; % Ensure this is the correct time vector for omega
% 
% % Check if lengths match
% if length(time_omega) ~= length(omega)
%     error('Length of time vector and omega vector do not match.');
% end
% 
% % Create the plot for Omega
% figure;
% plot(time_omega, omega, 'r-');
% xlabel('Time [s]');
% ylabel('Omega [rad/s]');
% legend('Omega(t)'); % Add legend for clarity
% grid on;
% grid minor;
% 
% Reshape and extract the data
v = reshape(out.ScopeData1.signals(1).values, [50001, 1]); % Velocity v
e_p_n = out.ScopeData1.signals(2).values; % e_p^T n, already 50001x1

% Define the time vector (10 to 15 seconds for the scope data)
time = linspace(10, 15, 50001); % Time starts at 10 and ends at 15 seconds

% Plot Velocity (v) and e_p^T n together
figure;
hold on;
plot(time, v, 'r-', 'LineWidth', 1.5); % Velocity v in red
plot(time, e_p_n, 'b-', 'LineWidth', 1.5); % e_p^T n in blue
xlabel('Time [s]');
ylabel('Values');
legend("Velocity (v) [m/s]", "e_p^T n", 'Location', 'best'); % Units added in legend
title('Velocity and Error Signal Over Time');
grid on;
grid minor;

% Small box with zoomed part
axes('position', [.38 .30 .50 .25]); % Position of the zoom box
box on; % Put box around new pair of axes
indexOfInterest = (time >= 10 & time <= 10.2); % Range of time for zoomed area
plot(time(indexOfInterest), v(indexOfInterest), 'r-', 'LineWidth', 1.5); % Zoomed velocity
hold on;
plot(time(indexOfInterest), e_p_n(indexOfInterest), 'b-', 'LineWidth', 1.5); % Zoomed error signal
ylim([0 700]); % Ensure y-axis is limited to [0, 700]
xlim([10 10.2]); % Ensure x-axis covers the zoomed time range
grid on; % Ensure grid is on in zoomed area
grid minor; % Minor grid lines in zoomed area
hold off;


% Small box with zoomed part
axes('position', [.38 .60 .50 .25]); % Position of the zoom box
box on; % Put box around new pair of axes
indexOfInterest = (time >= 10 & time <= 10.2); % Range of time for zoomed area
plot(time(indexOfInterest), v(indexOfInterest), 'r-', 'LineWidth', 1.5); % Zoomed velocity
hold on;
plot(time(indexOfInterest), e_p_n(indexOfInterest), 'b-', 'LineWidth', 1.5); % Zoomed error signal
ylim([0 700]); % Ensure y-axis is limited to [0, 700]
xlim([10 10.2]); % Ensure x-axis covers the zoomed time range
grid on; % Ensure grid is on in zoomed area
grid minor; % Minor grid lines in zoomed area
hold off;