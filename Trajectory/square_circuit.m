function [x, x1, y, y1] = square_circuit(a, b, num_points, x_start, y_start)
% nascar_circuit - Parametrizes a NASCAR-shaped circuit.
%
% Inputs:
%   a - Length of the straight sections (along x-axis).
%   b - Width of the straight sections (along y-axis).
%   num_points - Total number of points for the parametrization.
%   x_start, y_start - starting positions
%
% Outputs:
%   x, y - Parametrized x and y coordinates of the circuit.

    % Ensure input sanity
    if a <= 0 || b <= 0
        error('All dimensions (a, b) must be positive.');
    end
    
    % Number of points for each section
    n_straight = floor(num_points*0.3); % Points per straight segment
    n_curve = floor(num_points*0.2);   % Points per curved segment
    
    % Curve angles for the arcs
    theta1 = linspace(5*pi/2, 2*pi, n_curve/2);         % Bottom-left curve
    theta2 = linspace(3*pi/2, pi/2, n_curve);      % Top-right curve
    
    x_angle = (x_start+a+b/2)* ones(1, n_curve - n_curve/2);
    y_angle = linspace(y_start+b/2, y_start+b, n_curve/2);

    % Parametrize the bottom-left curve (circle arc)
    x_curve1 = x_start+ a + b/2 * cos(theta1);
    y_curve1 = y_start+ b/2 - b/2 * sin(theta1);
    
    % Parametrize the top-right curve (circle arc)
    x_curve2 = x_start + b/2 * cos(theta2);
    y_curve2 = y_start + b/2 - b/2 * sin(theta2);
    
    % Parametrize the straight sections
    x_straight1 = linspace(x_start, x_start+a, n_straight); % Bottom straight
    y_straight1 = y_start* ones(1, n_straight);
    
    x_straight2 = linspace(x_start+a+b/2, x_start, n_straight); % Top straight
    y_straight2 = (y_start+b)* ones(1, n_straight);
    
    % Combine all segments into a closed loop
    x = [x_straight1(1:end-1), x_curve1, x_angle(2:end-1)];
    x1 = [x_straight2(2:end-1), x_curve2(1:end-1)];
    y = [y_straight1(1:end-1), y_curve1, y_angle(2:end-1)];
    y1 = [y_straight2(2:end-1), y_curve2(1:end-1)];
    
    % Ensure closed loop
    x1(end+1) = x(1);
    y1(end+1) = y(1);
end