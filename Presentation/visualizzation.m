signals = post2_5_20_4.ScopeData3.signals(1).values;
signals2 = post2_10_40_8.ScopeData3.signals(1).values;
signals3 = post2_20_90_10.ScopeData3.signals(1).values;

time = post2_10_40_8.ScopeData3.time;
index = (time < 12.3);

figure
plot(time(index), signals(index, 1:2), 'r-');
hold on;
plot(time(index), signals2(index, 1:2), 'g-');
plot(time(index), signals3(index, 1:2), 'b-');
l = legend("K1 = 5, K2 = 10, K3 = 2","", "K1 = 10, K2 = 40, K3 = 8","", "K1 = 100, K2 = 100, K3 = 30");
fontsize(l, 14,"points");
fontsize(gca, 14, "points");
grid minor;
xlabel('Time [s]');
ylabel('X , Y [m]');

figure
plot(time(index), signals(index, 3), 'r-');
hold on;
plot(time(index), signals2(index, 3), 'g-');
plot(time(index), signals3(index, 3), 'b-');
l = legend("K1 = 5, K2 = 10, K3 = 2", "K1 = 10, K2 = 40, K3 = 8", "K1 = 100, K2 = 100, K3 = 30");
fontsize(l, 14,"points");
fontsize(gca, 14, "points");
grid minor;
axis 
xlabel('Time [s]');
ylabel('Theta [rad]');