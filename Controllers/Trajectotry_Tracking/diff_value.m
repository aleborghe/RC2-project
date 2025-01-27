% % Inizializza i dati per più simulazioni
% num_simulations = 4; % Numero di simulazioni
% B_values = [ 0.2, 1, 3, 10]; % Valori del parametro B
% color_map = lines(num_simulations); % Crea una mappa di colori distinti
% all_omega = cell(1, num_simulations); % Memorizza i valori di Omega
% time_all = cell(1, num_simulations); % Memorizza i tempi per ogni simulazione
% 
% % Assicurati che il modello Simulink sia caricato
% load_system('feedback_yd'); % Carica il modello Simulink
% 
% % Ciclo per eseguire tutte le simulazioni
% for run = 1:num_simulations
%     % Imposta il parametro B
%     B = B_values(run); % Assegna il valore di B alla workspace
%     
%     % Esegui il modello Simulink
%     simOut = sim('feedback_yd'); % Salva i risultati della simulazione
%     
%     % Estrai i dati della simulazione
%     omega = reshape(simOut.omega_data.signals.values, [], 1); % Valori di Omega
%     time_omega = simOut.omega_data.time; % Tempo corrispondente per Omega
%     
%     % Verifica che le lunghezze coincidano
%     if length(time_omega) ~= length(omega)
%         error('Length of time vector and omega vector do not match.');
%     end
%     
%     % Memorizza i risultati
%     all_omega{run} = omega;
%     time_all{run} = time_omega;
% end
% 
% % Crea un unico grafico con tutte le variabili Omega
% figure;
% 
% % Plot Omega per ogni simulazione
% for run = 1:num_simulations
%     plot(time_all{run}, all_omega{run}, '-', 'Color', color_map(run, :), 'DisplayName', sprintf('Omega (B = %.1f)', B_values(run)));
%     hold on;
% end
% 
% % Configurazioni del grafico
% xlabel('Time [s]');
% ylabel('Omega [rad/s]');
% legend show; % Mostra la legenda
% grid on;
% grid minor;
% title('Comparison of Omega for Different B Values');
% 
% % Aggiungi il riquadro di zoom sui valori di Omega
% axes('position', [.17 .45 .25 .45]); % Posizione del riquadro
% box on;
% 
% % Zoom su un intervallo specifico
% indexOfInterest = (time_all{1} >= 0.8) & (time_all{1} <= 3); % Intervallo temporale per lo zoom
% for run = 1:num_simulations
%     plot(time_all{run}(indexOfInterest), all_omega{run}(indexOfInterest), '-', 'Color', color_map(run, :));
%     hold on;
% end
% grid on;
% grid minor;
% axis tight;
% ylim([min(cellfun(@(x) min(x(indexOfInterest)), all_omega)) - 0.5, max(cellfun(@(x) max(x(indexOfInterest)), all_omega)) + 0.5]); % Limiti asse Y
% hold off;
% 
% axes('position', [.65 .45 .25 .45]); % Posizione del riquadro
% box on;
% 
% % Zoom su un intervallo specifico
% indexOfInterest = (time_all{1} >= 4.9) & (time_all{1} <= 5.2); % Intervallo temporale per lo zoom
% for run = 1:num_simulations
%     plot(time_all{run}(indexOfInterest), all_omega{run}(indexOfInterest), '-', 'Color', color_map(run, :));
%     hold on;
% end
% % Configurazione asse zoom
% grid on;
% grid minor;
% axis tight;
% ylim([min(cellfun(@(x) min(x(indexOfInterest)), all_omega)) - 0.5, max(cellfun(@(x) max(x(indexOfInterest)), all_omega)) + 0.5]); % Limiti asse Y
% hold off;


% Define the specific Kv and Kw values for 4 simulations
Kv_values = [1, 10, 40, 100]; % Kv values
Kw_values = [100, 50, 10, 1]; % Kw values
num_simulations = 4;

% Create a color map for distinct colors
color_map = lines(num_simulations);

% Initialize storage for output signals and time
all_outputs = cell(num_simulations, 1);
all_references = cell(num_simulations, 1);
all_time = cell(num_simulations, 1);

% Ensure Simulink model is loaded
load_system('feedback_yd'); % Replace with your actual model name

% Loop over all simulations
for run = 1:num_simulations
    % Set Kv and Kw in the workspace
    Kv = Kv_values(run);
    Kw = Kw_values(run);
    assignin('base', 'Kv', Kv); % Assign Kv to the base workspace
    assignin('base', 'Kw', Kw); % Assign Kw to the base workspace

    % Run the simulation
    simOut = sim('feedback_yd'); % Replace with your actual model name

    % Extract output signals and time
    output = simOut.ScopeData1.signals(1).values; % 2001x3
    time = simOut.ScopeData1.time;               % 2001x1

    % Extract and reshape the reference signal
    reference = squeeze(simOut.ScopeData1.signals(2).values); % Reshape to 2x2001

    % Store results
    all_outputs{run} = output;        % Save output signals (X, Y, Theta)
    all_references{run} = reference'; % Save reference signals (X, Y)
    all_time{run} = time;             % Save time
end

% Plot results: X, Y signals comparison
figure;
hold on;

% Store plot handles for legend customization
legend_handles = zeros(1, num_simulations * 2);

for run = 1:num_simulations
    % Extract stored data
    time = all_time{run};
    output = all_outputs{run};
    reference = all_references{run};

    % Plot output X and Y (as solid lines)
    plot_handle1 = plot(time, output(:, 1), '-', 'Color', color_map(run, :), ...
        'DisplayName', sprintf('X (Kv=%.1f, Kw=%.1f)', Kv_values(run), Kw_values(run)));
    plot_handle2 = plot(time, output(:, 2), '-', 'Color', color_map(run, :), ...
        'DisplayName', sprintf('Y (Kv=%.1f, Kw=%.1f)', Kv_values(run), Kw_values(run)));

    % Plot reference X and Y (as dashed lines)
    plot_handle3 = plot(time, reference(:, 1), '--', 'Color', color_map(run, :), ...
        'DisplayName', sprintf('Reference X (Kv=%.1f, Kw=%.1f)', Kv_values(run), Kw_values(run)));
    plot_handle4 = plot(time, reference(:, 2), '--', 'Color', color_map(run, :), ...
        'DisplayName', sprintf('Reference Y (Kv=%.1f, Kw=%.1f)', Kv_values(run), Kw_values(run)));

    % Store the plot handles
    legend_handles((run-1)*4+1) = plot_handle1;
    legend_handles((run-1)*4+2) = plot_handle2;
    legend_handles((run-1)*4+3) = plot_handle3;
    legend_handles((run-1)*4+4) = plot_handle4;
end

xlabel('Time [s]');
ylabel('X, Y [m]');
legend(legend_handles(1:2:end), 'Location', 'best'); % Show only X and Y outputs
grid minor;
title('Comparison of X and Y Signals for Different Kv and Kw (With References)');

% Plot results: Theta signals
figure;
hold on;

for run = 1:num_simulations
    % Extract stored data
    time = all_time{run};
    output = all_outputs{run};

    % Plot Theta (as solid lines)
    plot(time, output(:, 3), '-', 'Color', color_map(run, :), ...
        'DisplayName', sprintf('Theta (Kv=%.1f, Kw=%.1f)', Kv_values(run), Kw_values(run)));
end

xlabel('Time [s]');
ylabel('Theta [rad]');
legend show;
grid minor;
title('Comparison of Theta for Different Kv and Kw');
