% Load and display the background image
figure;
set(gcf, 'Position', [100, 100, 1000, 800]); % Set the window size

% Display the image
imshow(bg, 'InitialMagnification', 'fit');
axis on;  % Show the axes
axis image;  % Maintain the aspect ratio
set(gca, 'Position', [0 0 1 1]); % Remove axis margins to fill the window

hold on;

% Plot the interpolated path (main trajectory) - blue line
interpolated_path = plot(x_t, y_t, 'b-', 'LineWidth', 2, 'DisplayName', 'Interpolated Path');

%plot(new_x(overtaking_start_idx:overtaking_end_idx), new_y(overtaking_start_idx:overtaking_end_idx), 'r-', 'LineWidth', 2); %Overtake path
if obstacle
    % Plot the obstacle
    obstacle_marker = plot(obstacle_x, obstacle_y, 'go', 'MarkerSize', 15, 'MarkerFaceColor', 'g', 'DisplayName', 'Obstacle');
end
% Add labels and title
xlabel('x(t)');
ylabel('y(t)');
%title('Smooth Continuous Path with Obstacle Avoidance');

% Draw the parking lot
parkX = 250;  % Bottom-left X coordinate
parkY = 80;   % Bottom-left Y coordinate
width = 60;   % Width of the rectangle
height = 30;  % Height of the rectangle

% Draw the rectangle
rectangle('Position', [parkX, parkY, width, height], 'FaceColor', 'cyan', 'EdgeColor', 'black');

% Add dividing lines for three vertical triangles
line([parkX + width/3, parkX + width/3], [parkY, parkY + height], 'Color', 'white', 'LineWidth', 1.5);
line([parkX + 2*width/3, parkX + 2*width/3], [parkY, parkY + height], 'Color', 'white', 'LineWidth', 1.5);

% Add text at the center of the rectangle
%text(parkX + width/2, parkY + height/2, 'Parking Lot', 'Color', 'white', 'HorizontalAlignment', 'center');

% Vehicle state from the first dataset (original path)
x = out.uni_state.signals.values(:, 1); % x-coordinates (first dataset)
y = out.uni_state.signals.values(:, 2); % y-coordinates (first dataset)
theta = out.uni_state.signals.values(:, 3); % Orientation (theta) (first dataset)

% Data from the second dataset
x1 = out.uni_state1.signals.values(:, 1); % x-coordinates (second dataset)
y1 = out.uni_state1.signals.values(:, 2); % y-coordinates (second dataset)
theta1 = out.uni_state1.signals.values(:, 3); % Orientation (second dataset)

% Interpolate the second dataset to align with the time steps of the first dataset
t1 = linspace(1, length(x), length(x)); % Time steps for the first dataset (1000 points)
t2 = linspace(1, length(x1), length(x1)); % Time steps for the second dataset (501 points)

% Interpolate the second dataset over the time steps of the first
x1_interp = interp1(t2, x1, t1, 'linear', 'extrap');
y1_interp = interp1(t2, y1, t1, 'linear', 'extrap');
theta1_interp = interp1(t2, theta1, t1, 'linear', 'extrap'); % Interpolate theta1

% Convert x, y, x1_interp, y1_interp into columns (1000x1)
x = x(:); % Column
y = y(:); % Column
theta = theta(:); % Column
x1_interp = x1_interp(:); % Column
y1_interp = y1_interp(:); % Column
theta1_interp = theta1_interp(:); % Column

% Concatenate the data (combining the first and second paths)
x_combined = [x; x1_interp]; % Both are now columns (1000x1)
y_combined = [y; y1_interp]; % Both are now columns (1000x1)
theta_combined = [theta; theta1_interp]; % Use the interpolated theta1

% Vehicle triangular representation
triangle_size = 20; % Triangle size
base_width = triangle_size / 2; % Base width of the triangle
local_vertices = [
    triangle_size, 0;                % Front tip
    -base_width, -base_width/2;      % Rear left
    -base_width,  base_width/2       % Rear right
];
global_vertices = local_vertices;
global_vertices(:, 1) = global_vertices(:, 1) + x_combined(1); % Initial position
global_vertices(:, 2) = global_vertices(:, 2) + y_combined(1); % Initial position
unicycle = fill(global_vertices(:, 1), global_vertices(:, 2), 'r', 'EdgeColor', 'k', 'DisplayName', 'Vehicle'); % Vehicle visualization

% Static triangular vehicles on the sides of the parking lot
% First static triangle (left slot)
dy = -3;
R_static1 = [cos(pi/2), -sin(pi/2); sin(pi/2), cos(pi/2)]; % Rotation matrix (facing upward)
global_vertices_static1 = (R_static1 * local_vertices')';
global_vertices_static1(:, 1) = global_vertices_static1(:, 1) + (parkX + width/6); % Translate x (left slot)
global_vertices_static1(:, 2) = global_vertices_static1(:, 2) + (parkY + height/2 + dy); % Translate y (centered vertically)
fill(global_vertices_static1(:, 1), global_vertices_static1(:, 2), 'r', 'EdgeColor', 'k', 'HandleVisibility', 'off');

% Second static triangle (right slot)
R_static2 = [cos(pi/2), -sin(pi/2); sin(pi/2), cos(pi/2)]; % Rotation matrix (facing upward)
global_vertices_static2 = (R_static2 * local_vertices')';
global_vertices_static2(:, 1) = global_vertices_static2(:, 1) + (parkX + 5 * width / 6); % Translate x (right slot)
global_vertices_static2(:, 2) = global_vertices_static2(:, 2) + (parkY + height / 2 + dy); % Translate y (centered vertically)
fill(global_vertices_static2(:, 1), global_vertices_static2(:, 2), 'r', 'EdgeColor', 'k', 'HandleVisibility', 'off');

% Ensure that theta_combined matches the length of x_combined
assert(length(x_combined) == length(theta_combined), 'x_combined and theta_combined must have the same length.');

% Animation loop
for i = 1:min(length(x_combined), length(theta_combined))-1
    % Rotation matrix for the vehicle orientation
    R = [cos(theta_combined(i)), -sin(theta_combined(i)); sin(theta_combined(i)), cos(theta_combined(i))];
    
    % Apply rotation and translation
    global_vertices = (R * local_vertices')';
    global_vertices(:, 1) = global_vertices(:, 1) + x_combined(i); % Translate x
    global_vertices(:, 2) = global_vertices(:, 2) + y_combined(i); % Translate y
    
    % Update the vehicle's position and orientation in the plot
    set(unicycle, 'XData', global_vertices(:, 1), 'YData', global_vertices(:, 2));
    
    % Real-time visualization of the vehicle's path
    drawnow;
    pause(dt/2); % Adjust to match real-time simulation
end

% if obstacle
%     % Add legend for the relevant elements
%     legend([interpolated_path, obstacle_marker, unicycle]);
% else
%     legend([interpolated_path, unicycle]);
% end
hold off;



