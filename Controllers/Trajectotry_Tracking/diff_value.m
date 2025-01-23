% Inizializza i dati per più simulazioni
num_simulations = 5; % Numero di simulazioni
kv_values = [1, 20, 40, 80, 100]; % Valori del parametro k_v
kw_values = [100, 80, 50, 20, 1]; % Valori del parametro k_w
color_map = lines(num_simulations); % Crea una mappa di colori distinti
all_x = cell(1, num_simulations); % Memorizza i valori di X
all_y = cell(1, num_simulations); % Memorizza i valori di Y
all_theta = cell(1, num_simulations); % Memorizza i valori di Theta
time_all = cell(1, num_simulations); % Memorizza i tempi per ogni simulazione

% Assicurati che il modello Simulink sia caricato
load_system('feedback_yd'); % Carica il modello Simulink

% Ciclo per eseguire tutte le simulazioni
for run = 1:num_simulations
    % Imposta i parametri k_v e k_w
    kv = kv_values(run); % Assegna il valore di k_v alla workspace
    kw = kw_values(run); % Assegna il valore di k_w alla workspace
    assignin('base', 'kv', kv); % Passa kv alla workspace
    assignin('base', 'kw', kw); % Passa kw alla workspace
    
    % Esegui il modello Simulink
    simOut = sim('feedback_yd'); % Salva i risultati della simulazione
    
    % Estrai i dati della simulazione
    x = simOut.ScopeData1.signals(1).values(:, 1); % Coordinate X
    y = simOut.ScopeData1.signals(1).values(:, 2); % Coordinate Y
    theta = simOut.ScopeData1.signals(1).values(:, 3); % Orientamento Theta
    time1 = simOut.tout; % Access the time vector from the simulation output
    
    % Memorizza i risultati
    all_x{run} = x;
    all_y{run} = y;
    all_theta{run} = theta;
    time_all{run} = time1;
    
    % Memorizza i segnali di riferimento una sola volta
    if run == 1
        ref_signals = simOut.ScopeData1.signals(2).values; % Riferimento (2x1x501)
        x_ref = squeeze(ref_signals(1, 1, :)); % Estrai il riferimento X
        y_ref = squeeze(ref_signals(2, 1, :)); % Estrai il riferimento Y
    end
end

% Crea un unico grafico con tutte le variabili
figure;

% Plot X
for run = 1:num_simulations
    plot(time_all{run}, all_x{run}, '-', 'Color', color_map(run, :), ...
        'DisplayName', sprintf('X (kv = %.1f, kw = %.1f)', kv_values(run), kw_values(run)));
    hold on;
end
plot(time_all{1}, x_ref, 'b--', 'LineWidth', 1.5); % Riferimento X

% Plot Y
for run = 1:num_simulations
    plot(time_all{run}, all_y{run}, '-', 'Color', color_map(run, :), ...
        'DisplayName', sprintf('Y (kv = %.1f, kw = %.1f)', kv_values(run), kw_values(run)));
    hold on;
end
plot(time_all{1}, y_ref, 'r--', 'LineWidth', 1.5); % Riferimento Y

% Plot Theta
for run = 1:num_simulations
    plot(time_all{run}, all_theta{run}, '-', 'Color', color_map(run, :), ...
        'DisplayName', sprintf('Theta (kv = %.1f, kw = %.1f)', kv_values(run), kw_values(run)));
    hold on;
end

% Configurazioni del grafico
xlabel('Time [s]');
ylabel('Values');
legend show; % Mostra la legenda
grid on;
grid minor;
title('Comparison of X, Y, and Theta for Different kv and kw Values');

% Aggiungi il riquadro di zoom sui valori di Y
axes('position', [.65 .25 .25 .25]); % Posizione del riquadro
box on;

% Zoom su un intervallo specifico (solo Y)
indexOfInterest = (time_all{1} >= 0.8) & (time_all{1} <= 3); % Intervallo temporale per lo zoom
for run = 1:num_simulations
    plot(time_all{run}(indexOfInterest), all_y{run}(indexOfInterest), '-', 'Color', color_map(run, :));
    hold on;
end
plot(time_all{1}(indexOfInterest), y_ref(indexOfInterest), 'r--', 'LineWidth', 1.5); % Zoom Riferimento Y

% Configurazione asse zoom
grid on;
grid minor;
axis tight;
ylim([min(y_ref(indexOfInterest)) - 0.5, max(y_ref(indexOfInterest)) + 0.5]); % Limiti asse Y
hold off;
