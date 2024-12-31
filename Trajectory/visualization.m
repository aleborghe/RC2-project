% Load and display background image
figure;
imshow(bg);
hold on;

% Plot
plot(x_t, y_t, 'b-');
xlabel('x(t)');
ylabel('y(t)');
title('Smooth Continuous Path');
legend('Interpolated Path');

%Plot parking lot
parkX = 290;  % x-coordinate of the lower-left corner
parkY = 80;  % y-coordinate of the lower-left corner
width = 60;  % Width of the rectangle
height = 30; % Height of the rectangle
rectangle('Position', [parkX, parkY, width, height], 'FaceColor', 'blue', 'EdgeColor', 'black');

% Visualization

x = out.uni_state.signals.values(:, 1);
y = out.uni_state.signals.values(:, 2);
theta = out.uni_state.signals.values(:, 3);

xp = out.uni_state1.signals.values(:, 1);
yp = out.uni_state1.signals.values(:, 2);
thetap = out.uni_state1.signals.values(:, 3);

triangle_size = 20; % Size of the triangle
base_width = triangle_size / 2; % Width of the triangle base
local_vertices = [
        triangle_size, 0;                % Front tip
       -base_width, -base_width/2;       % Back-left
       -base_width,  base_width/2       % Back-right
    ];
global_vertices = local_vertices;
global_vertices(:, 1) = global_vertices(:, 1) + x(1);
global_vertices(:, 2) = global_vertices(:, 2) + y(1);
unicycle = fill(global_vertices(:, 1), global_vertices(:, 2), 'r', 'EdgeColor', 'k');
for i = 1:size(x,1)
     % Rotation matrix for orientation
     R = [cos(theta(i)), -sin(theta(i)); sin(theta(i)), cos(theta(i))];  
     % Rotate and translate the triangle
     global_vertices = (R * local_vertices')';
     global_vertices(:, 1) = global_vertices(:, 1) + x(i);
     global_vertices(:, 2) = global_vertices(:, 2) + y(i);
     
     % Draw the triangle
     set(unicycle, 'X', global_vertices(:, 1), 'Y', global_vertices(:, 2))
     % Update unicycle position and orientation
        
     drawnow;
     pause(dt); % Adjust for real-time animation
end
for i = 1:size(xp,1)
     % Rotation matrix for orientation
     R = [cos(thetap(i)), -sin(thetap(i)); sin(thetap(i)), cos(thetap(i))];  
     % Rotate and translate the triangle
     global_vertices = (R * local_vertices')';
     global_vertices(:, 1) = global_vertices(:, 1) + xp(i);
     global_vertices(:, 2) = global_vertices(:, 2) + yp(i);
     
     % Draw the triangle
     set(unicycle, 'X', global_vertices(:, 1), 'Y', global_vertices(:, 2))
     % Update unicycle position and orientation
        
     drawnow;
     pause(dt); % Adjust for real-time animation
end
hold off;