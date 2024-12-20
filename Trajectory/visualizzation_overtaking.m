% Carica e visualizza l'immagine di sfondo
bg = imread('background.jpg');
figure;
set(gcf, 'Position', [100, 100, 1000, 800]); % Imposta la dimensione della finestra

% Visualizza l'immagine
imshow(bg, 'InitialMagnification', 'fit');
axis on;  % Mostra gli assi
axis image;  % Mantieni il rapporto di aspetto
set(gca, 'Position', [0 0 1 1]); % Rimuovi i margini degli assi per riempire la finestra

hold on;

% Traccia il percorso interpolato (traiettoria principale) - linea blu
plot(x_t, y_t, 'b-', 'LineWidth', 2);
plot(obstacle_x, obstacle_y, 'go', 'MarkerSize', 15, 'MarkerFaceColor', 'g'); % Ostacolo

% Aggiungi etichette e titolo
xlabel('x(t)');
ylabel('y(t)');
title('Smooth Continuous Path with Obstacle Avoidance');
legend('Interpolated Path', 'Obstacle');

% Traccia il parcheggio
parkX = 290;  % Coordinate del basso sinistro
parkY = 80;   % Coordinate del basso sinistro
width = 60;   % Larghezza del rettangolo
height = 30;  % Altezza del rettangolo
rectangle('Position', [parkX, parkY, width, height], 'FaceColor', 'blue', 'EdgeColor', 'black');
text(parkX + width/2, parkY + height/2, 'Parking Lot', 'Color', 'white', 'HorizontalAlignment', 'center');

% Stato del veicolo dalla prima struttura (percorso originale)
x = out.uni_state.signals.values(:, 1); % Coordinate x (prima struttura)
y = out.uni_state.signals.values(:, 2); % Coordinate y (prima struttura)
theta = out.uni_state.signals.values(:, 3); % Orientamento (theta) (prima struttura)

% Dati dalla seconda struttura
x1 = out.uni_state1.signals.values(:, 1); % Coordinate x (seconda struttura)
y1 = out.uni_state1.signals.values(:, 2); % Coordinate y (seconda struttura)

% Interpolazione dei dati della seconda struttura per allinearsi ai passi temporali della prima struttura
t1 = linspace(1, length(x), length(x)); % Passi temporali della prima struttura (1000 punti)
t2 = linspace(1, length(x1), length(x1)); % Passi temporali della seconda struttura (501 punti)

% Interpoliamo i dati della seconda struttura sui passi temporali della prima
x1_interp = interp1(t2, x1, t1, 'linear', 'extrap');
y1_interp = interp1(t2, y1, t1, 'linear', 'extrap');

% Trasformiamo x, y, x1_interp, y1_interp in colonne (1000x1)
x = x(:); % Colonna
y = y(:); % Colonna
theta = theta(:); % Colonna
x1_interp = x1_interp(:); % Colonna
y1_interp = y1_interp(:); % Colonna

% Concatenamento dei dati (unendo il primo e il secondo percorso)
x_combined = [x; x1_interp]; % Ora entrambi sono colonne (1000x1)
y_combined = [y; y1_interp]; % Ora entrambi sono colonne (1000x1)
theta_combined = [theta; theta(end) * ones(size(x1_interp))]; % Mantieni theta costante per la seconda parte

% Rappresentazione triangolare del veicolo
triangle_size = 20; % Dimensione del triangolo
base_width = triangle_size / 2; % Larghezza della base del triangolo
local_vertices = [
    triangle_size, 0;                % Punta anteriore
    -base_width, -base_width/2;      % Retro sinistro
    -base_width,  base_width/2       % Retro destro
];
global_vertices = local_vertices;
global_vertices(:, 1) = global_vertices(:, 1) + x_combined(1); % Posizione iniziale
global_vertices(:, 2) = global_vertices(:, 2) + y_combined(1); % Posizione iniziale
unicycle = fill(global_vertices(:, 1), global_vertices(:, 2), 'r', 'EdgeColor', 'k'); % Visualizzazione del veicolo

% Linea rossa di sorpasso (porzione trapezoidale)
if ~isempty(overtaking_start_idx) && ~isempty(overtaking_end_idx)
    % Calcola la porzione trapezoidale dei dati in anticipo (come il percorso blu)
    red_x = new_x(overtaking_start_idx:overtaking_end_idx);
    red_y = new_y(overtaking_start_idx:overtaking_end_idx);
    
    % Traccia il percorso di sorpasso in rosso (questo verrà mostrato immediatamente)
    plot(red_x, red_y, 'r-', 'LineWidth', 2);
end

% Ciclo di animazione
for i = 1:(length(x_combined)-1)
    % Matrice di rotazione per l'orientamento del veicolo
    R = [cos(theta_combined(i)), -sin(theta_combined(i)); sin(theta_combined(i)), cos(theta_combined(i))];
    
    % Applica rotazione e traslazione
    global_vertices = (R * local_vertices')';
    global_vertices(:, 1) = global_vertices(:, 1) + x_combined(i); % Trasla x
    global_vertices(:, 2) = global_vertices(:, 2) + y_combined(i); % Trasla y
    
    % Aggiorna la posizione e l'orientamento del veicolo nel grafico
    set(unicycle, 'XData', global_vertices(:, 1), 'YData', global_vertices(:, 2));
    
    % Visualizzazione in tempo reale del percorso del veicolo
    drawnow;
    pause(dt); % Regola per corrispondere alla simulazione in tempo reale
end

hold off;

