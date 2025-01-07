% Inizializza i dati per più simulazioni
num_simulations = 5; % Numero di simulazioni
B_values = [0.1, 0.2, 1, 3, 10]; % Valori del parametro B
color_map = lines(num_simulations); % Crea una mappa di colori distinti
all_x = cell(1, num_simulations); % Memorizza i valori di X
all_y = cell(1, num_simulations); % Memorizza i valori di Y
all_theta = cell(1, num_simulations); % Memorizza i valori di Theta
time_all = cell(1, num_simulations); % Memorizza i tempi per ogni simulazione

% Assicurati che il modello Simulink sia caricato
load_system('feedback_yd'); % Carica il modello Simulink

% Ciclo per eseguire tutte le simulazioni
for run = 1:num_simulations
    % Imposta il parametro B
    B = B_values(run); % Assegna il valore di B alla workspace
    
    % Esegui il modello Simulink
    simOut = sim('feedback_yd'); % Salva i risultati della simulazione
    
    % Estrai i dati della simulazione
    x = simOut.uni_state.signals.values(:, 1); % Coordinate X
    y = simOut.uni_state.signals.values(:, 2); % Coordinate Y
    theta = simOut.uni_state.signals.values(:, 3); % Orientamento Theta
    time1 = simOut.uni_state.time; % Tempo della simulazione
    
    % Memorizza i risultati
    all_x{run} = x;
    all_y{run} = y;
    all_theta{run} = theta;
    time_all{run} = time1;
    
    % Memorizza i segnali di riferimento una sola volta
    if run == 1
        ref_signals = reshape(permute(simOut.reference.signals.values, [3, 1, 2]), 1000, 3);
        x_ref = ref_signals(:, 1);
        y_ref = ref_signals(:, 2);
        theta_ref = ref_signals(:, 3);
    end
end

% Crea un unico grafico con tutte le variabili
figure;

% Plot X
for run = 1:num_simulations
    plot(time_all{run}, all_x{run}, '-', 'Color', color_map(run, :), 'DisplayName', sprintf('X (B = %.1f)', B_values(run)));
    hold on;
end
plot(time_all{1}, x_ref, 'b--', 'LineWidth', 1.5); % Riferimento X

% Plot Y
for run = 1:num_simulations
    plot(time_all{run}, all_y{run}, '-', 'Color', color_map(run, :), 'DisplayName', sprintf('Y (B = %.1f)', B_values(run)));
    hold on;
end
plot(time_all{1}, y_ref, 'r--', 'LineWidth', 1.5); % Riferimento Y

% Plot Theta
for run = 1:num_simulations
    plot(time_all{run}, all_theta{run}, '-', 'Color', color_map(run, :), 'DisplayName', sprintf('Theta (B = %.1f)', B_values(run)));
    hold on;
end
plot(time_all{1}, theta_ref, 'g--', 'LineWidth', 1.5); % Riferimento Theta

% Configurazioni del grafico
xlabel('Time [s]');
ylabel('Values');
legend show; % Mostra la legenda
grid on;
grid minor;
title('Comparison of X, Y, and Theta for Different B Values');

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

