% Inizializza i dati per più simulazioni
num_simulations = 4; % Numero di simulazioni
B_values = [ 0.2, 1, 3, 10]; % Valori del parametro B
color_map = lines(num_simulations); % Crea una mappa di colori distinti
all_omega = cell(1, num_simulations); % Memorizza i valori di Omega
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
    omega = reshape(simOut.omega_data.signals.values, [], 1); % Valori di Omega
    time_omega = simOut.omega_data.time; % Tempo corrispondente per Omega
    
    % Verifica che le lunghezze coincidano
    if length(time_omega) ~= length(omega)
        error('Length of time vector and omega vector do not match.');
    end
    
    % Memorizza i risultati
    all_omega{run} = omega;
    time_all{run} = time_omega;
end

% Crea un unico grafico con tutte le variabili Omega
figure;

% Plot Omega per ogni simulazione
for run = 1:num_simulations
    plot(time_all{run}, all_omega{run}, '-', 'Color', color_map(run, :), 'DisplayName', sprintf('Omega (B = %.1f)', B_values(run)));
    hold on;
end

% Configurazioni del grafico
xlabel('Time [s]');
ylabel('Omega [rad/s]');
legend show; % Mostra la legenda
grid on;
grid minor;
title('Comparison of Omega for Different B Values');

% Aggiungi il riquadro di zoom sui valori di Omega
axes('position', [.17 .45 .25 .45]); % Posizione del riquadro
box on;

% Zoom su un intervallo specifico
indexOfInterest = (time_all{1} >= 0.8) & (time_all{1} <= 3); % Intervallo temporale per lo zoom
for run = 1:num_simulations
    plot(time_all{run}(indexOfInterest), all_omega{run}(indexOfInterest), '-', 'Color', color_map(run, :));
    hold on;
end
grid on;
grid minor;
axis tight;
ylim([min(cellfun(@(x) min(x(indexOfInterest)), all_omega)) - 0.5, max(cellfun(@(x) max(x(indexOfInterest)), all_omega)) + 0.5]); % Limiti asse Y
hold off;

axes('position', [.65 .45 .25 .45]); % Posizione del riquadro
box on;

% Zoom su un intervallo specifico
indexOfInterest = (time_all{1} >= 4.9) & (time_all{1} <= 5.2); % Intervallo temporale per lo zoom
for run = 1:num_simulations
    plot(time_all{run}(indexOfInterest), all_omega{run}(indexOfInterest), '-', 'Color', color_map(run, :));
    hold on;
end
% Configurazione asse zoom
grid on;
grid minor;
axis tight;
ylim([min(cellfun(@(x) min(x(indexOfInterest)), all_omega)) - 0.5, max(cellfun(@(x) max(x(indexOfInterest)), all_omega)) + 0.5]); % Limiti asse Y
hold off;
