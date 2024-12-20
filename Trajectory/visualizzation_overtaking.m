
% Load and display background image
bg = imread('background.jpg');
figure;
set(gcf, 'Position', [100, 100, 1000, 800]); % Set figure size (Width: 1000, Height: 800)

% Display image
%imshow(bg);
imshow(bg, 'InitialMagnification', 'fit'),
% Set axis properties to ensure the image fills the figure
axis on;  % Turn on the axis
axis image;  % Maintain aspect ratio of the image
set(gca, 'Position', [0 0 1 1]); % Remove axis margins to fill the window

hold on;

% Plot the interpolated path (main trajectory) - blue line
plot(x_t, y_t, 'b-', 'LineWidth', 2); 
plot(obstacle_x, obstacle_y, 'go', 'MarkerSize', 15, 'MarkerFaceColor', 'g'); % Obstacle

% Add labels and title
xlabel('x(t)');
ylabel('y(t)');
title('Smooth Continuous Path with Obstacle Avoidance');
legend('Interpolated Path', 'Obstacle');

% Plot the parking lot
parkX = 290;  % x-coordinate of the lower-left corner
parkY = 80;   % y-coordinate of the lower-left corner
width = 60;   % Width of the rectangle
height = 30;  % Height of the rectangle
rectangle('Position', [parkX, parkY, width, height], 'FaceColor', 'blue', 'EdgeColor', 'black');
text(parkX + width/2, parkY + height/2, 'Parking Lot', 'Color', 'white', 'HorizontalAlignment', 'center');

% Unicycle state from simulation
x = out.uni_state.signals.values(:, 1); % x-coordinates
y = out.uni_state.signals.values(:, 2); % y-coordinates
theta = out.uni_state.signals.values(:, 3); % orientation (theta)

% Triangle representation of the unicycle
triangle_size = 20; % Size of the triangle
base_width = triangle_size / 2; % Width of the triangle base
local_vertices = [
    triangle_size, 0;                % Front tip
    -base_width, -base_width/2;      % Back-left
    -base_width,  base_width/2       % Back-right
];
global_vertices = local_vertices;
global_vertices(:, 1) = global_vertices(:, 1) + x(1); % Initial position
global_vertices(:, 2) = global_vertices(:, 2) + y(1); % Initial position
unicycle = fill(global_vertices(:, 1), global_vertices(:, 2), 'r', 'EdgeColor', 'k'); % Unicycle visualization

% Create the red overtaking line (trapezoidal portion)
if ~isempty(overtaking_start_idx) && ~isempty(overtaking_end_idx)
    % Calculate the red trapezoidal portion data in advance (like the blue path)
    red_x = new_x(overtaking_start_idx:overtaking_end_idx);
    red_y = new_y(overtaking_start_idx:overtaking_end_idx);
    
    % Plot the overtaking path in red (this will be shown immediately)
    plot(red_x, red_y, 'r-', 'LineWidth', 2);
end

% Animation loop
for i = 1:(size(x, 1)-1)
    % Rotation matrix for unicycle orientation
    R = [cos(theta(i)), -sin(theta(i)); sin(theta(i)), cos(theta(i))];
    
    % Apply rotation and translation
    global_vertices = (R * local_vertices')';
    global_vertices(:, 1) = global_vertices(:, 1) + x(i); % Translate x
    global_vertices(:, 2) = global_vertices(:, 2) + y(i); % Translate y
    
    % Update unicycle position and orientation in the plot
    set(unicycle, 'XData', global_vertices(:, 1), 'YData', global_vertices(:, 2));
    
    % Real-time visualization of the unicycle path
    drawnow;
    pause(dt); % Adjust to match real-time simulation
end

hold off;

