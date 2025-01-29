% Extract the theta values (third column)
theta = out.ScopeData1.signals(1).values(:, 3); % Extracting theta (50001x1)
reference_signal = zeros(50001, 1); % Reference signal (zero)

% Define the time vector (10 to 15 seconds for the scope data)
time = linspace(10, 15, 50001); % Time starts at 10 and ends at 15 seconds

% Plot theta and reference signal together
figure;
hold on;
plot(time, theta, 'r-', 'LineWidth', 1.5); % Theta in red
plot(time, reference_signal, 'b--', 'LineWidth', 1.5); % Reference signal in blue dashed line
xlabel('Time [s]');
ylabel('Theta [rad]');
legend("Theta [rad]", "Reference Signal", 'Location', 'best');
title('Theta and Reference Signal Over Time');
grid on;
grid minor;

% Small box with zoomed part
axes('position', [.38 .30 .50 .25]); % Position of the zoom box
box on; % Put box around new pair of axes
indexOfInterest = (time >= 10.5 & time <= 11); % Range of time for zoomed area
plot(time(indexOfInterest), theta(indexOfInterest), 'r-', 'LineWidth', 1.5); % Zoomed theta
hold on;
plot(time(indexOfInterest), reference_signal(indexOfInterest), 'b--', 'LineWidth', 1.5); % Zoomed reference signal
ylim([3 3.5]); % Adjust y-axis limits for better visibility
xlim([10.5 11]); % Ensure x-axis covers the zoomed time range
grid on; % Ensure grid is on in zoomed area
grid minor; % Minor grid lines in zoomed area
hold off;
