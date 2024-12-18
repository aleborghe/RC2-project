
% Parametri della simulazione
T = 10;  % Tempo totale (secondi)
dt = 0.1;  % Passo temporale (secondi)
t = 0:dt:T;  % Vettore temporale

% Parametri della traiettoria
v = 2;  % Velocità costante per la traiettoria rettilinea (m/s)
y0 = 3;  % Posizione costante lungo y

% Genera la traiettoria di riferimento
[x_ref, y_ref, theta_ref] = generate_trajectory(t, v, y0);

% Creazione della struttura per 'From Workspace'
% Usando 'timeseries' per creare un formato compatibile con Simulink
data = [x_ref; y_ref; theta_ref]'; % Transponiamo per avere [N, 3]
time = t'; % Il tempo deve essere una colonna

% Creiamo una timeseries con le dimensioni appropriate
ref_data = timeseries(data, time);
ref_data.Name = 'ReferenceData';  % Nome opzionale per la variabile
v_input=timeseries(v,time);
% Supponiamo che i dati della simulazione siano già nel workspace
% x_sim, y_sim, theta_sim sono i dati di uscita dal modello Unicycle

% Traccia le traiettorie per il confronto
% figure;
% 
% % Posizione lungo x
% subplot(3,1,1);
% plot(t, x_ref, 'r', t, x_sim, 'b');
% title('Posizione lungo x');
% legend('Riferimento', 'Simulazione');
% 
% % Posizione lungo y
% subplot(3,1,2);
% plot(t, y_ref, 'r', t, y_sim, 'b');
% title('Posizione lungo y');
% legend('Riferimento', 'Simulazione');
% 
% % Angolo theta
% subplot(3,1,3);
% plot(t, theta_ref, 'r', t, theta_sim, 'b');
% title('Angolo \theta');
% legend('Riferimento', 'Simulazione');

% Funzione per la generazione della traiettoria
function [x_ref, y_ref, theta_ref] = generate_trajectory(t, v, y0)
    % Parametri della traiettoria
    % Velocità costante lungo x
    x_ref = v * t;  % Posizione lungo x (movimento rettilineo)
    
    % Posizione costante lungo y
    y_ref = y0 * ones(size(t));  % Posizione lungo y (costante, y0)
    
    % Orientamento costante (orizzontale)
    theta_ref = zeros(size(t));  % Angolo costante (orizzontale)
end
