data1 = nom_direct_50ms;              %name of the file real
data2 = out.scopeData1;             %Direct simulation
data3 = nomin_50ms;                  %Emulation
%data4 = rob_direct_50ms;

indeces = (1:81);
% Extract data from the file
time = data1.time(indeces); % Extracting the first 501 values,change in accord to the plot time
signals = data1.signals(2).values(indeces);
ref = data1.signals(1).values(indeces); %reference
signals2 = data2.signals(2).values(indeces);
%signals3 = data3.signals(2).values(indeces);
%signals4 = data4.signals(2).values(indeces);

% Create the plot
figure;
stairs(time, signals, 'b');
hold on;
stairs(time, signals2, 'r');
%stairs(time, signals3, 'g');
%stairs(time, signals4, 'c');
stairs(time, ref, 'm');
xlabel('Time [s]');
ylabel('Motor hub angle [degrees]');
h = legend("Result using real motor with direct design method", "Result using simulated motor"+ newline +"with direct design method", "Reference signal", "Position", [0.3244 0.7044 0.65 0.1956]);         % Add legend for clarity
%"Result using real motor with emulation method"
grid on;
grid minor;
hold off;


%Small box with zoomed part
axes('position',[.65 .25 .25 .25])         %Position of the box
box on % put box around new pair of axes
indexOfInterest = (time >= 0) & (time <= 1); % range of time to zoom
%plot(time(indexOfInterest), signals(indexOfInterest), 'b', time(indexOfInterest), signals2(indexOfInterest), 'r', time(indexOfInterest), signals3(indexOfInterest), 'g', time(indexOfInterest), ref(indexOfInterest), 'm');
stairs(time(indexOfInterest), signals(indexOfInterest), 'b')
hold on;
stairs(time(indexOfInterest), signals2(indexOfInterest), 'r');
stairs(time(indexOfInterest), ref(indexOfInterest), 'm');
%stairs(time(indexOfInterest), signals3(indexOfInterest), 'g');
%stairs(time(indexOfInterest), signals4(indexOfInterest), 'c');
axis tight
grid on;
grid minor;
hold off;