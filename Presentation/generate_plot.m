
x = out.uni_state.signals.values(:, 1); % Coordinate x (prima struttura)
y = out.uni_state.signals.values(:, 2); % Coordinate y (prima struttura)
theta = out.uni_state.signals.values(:, 3); % Orientamento (theta) (prima struttura)

x1 = out.uni_state1.signals.values(:, 1); % Coordinate x (seconda struttura)
y1 = out.uni_state1.signals.values(:, 2); % Coordinate y (seconda struttura)
theta1 = out.uni_state1.signals.values(:, 3); % Orientamento (seconda struttura)

indeces = (1:81);
% Extract data from the file
time1 = out.uni_state.time;
time2 = out.uni_state1.time;

ref_signals = reshape(permute(out.reference.signals.values, [3, 1, 2]), 1000, 3);

x_ref = ref_signals(:, 1);
y_ref = ref_signals(:, 2); %reference y 
theta_ref = ref_signals(:, 3); %reference theta

% Create the plot
figure;
plot(time1, x_ref, 'b-')
hold on;
plot(time1, x, 'r-')

xlabel('Time [s]');
ylabel('X position [m]');
legend("Reference x(t)", "x(t)");         % Add legend for clarity
grid on;
grid minor;
%Small box with zoomed part
axes('position',[.65 .25 .25 .25])         %Position of the box
box on; % put box around new pair of axes
indexOfInterest = (time1 >= 4.5) & (time1 <= 5.5); % range of time to zoom
plot(time1(indexOfInterest), x_ref(indexOfInterest), 'b-');
hold on
plot(time1(indexOfInterest), x(indexOfInterest), 'r-');
axis tight
hold off


figure;
plot(time1, y_ref, 'b-')
hold on;
plot(time1, y, 'r-')

xlabel('Time [s]');
ylabel('Y position [m]');
legend("Reference y(t)", "y(t)");         % Add legend for clarity
grid on;
grid minor;
%Small box with zoomed part
axes('position',[.65 .25 .25 .25])         %Position of the box
box on; % put box around new pair of axes
indexOfInterest = (time1 >= 4.5) & (time1 <= 5.5); % range of time to zoom
plot(time1(indexOfInterest), y_ref(indexOfInterest), 'b-');
hold on
plot(time1(indexOfInterest), y(indexOfInterest), 'r-');
axis tight
hold off

figure;
plot(time1, theta_ref, 'b-')
hold on;
plot(time1, theta, 'r-')

xlabel('Time [s]');
ylabel('Theta position [rad]');
legend("Reference theta(t)", "theta(t)");         % Add legend for clarity
grid on;
grid minor;

%Small box with zoomed part
axes('position',[.65 .25 .25 .25])         %Position of the box
box on; % put box around new pair of axes
indexOfInterest = (time1 >= 4.5) & (time1 <= 5.5); % range of time to zoom
plot(time1(indexOfInterest), theta_ref(indexOfInterest), 'b-');
hold on
plot(time1(indexOfInterest), theta(indexOfInterest), 'r-');
axis tight
ylim([1.2 3.3]); % Adjust y-axis limits for the zoomed-in plot
hold off;