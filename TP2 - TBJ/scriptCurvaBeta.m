close all;
clear all;
clc;

%% Lectura del archivo
archivo = 'curvaT.txt';

% Leo el archivo. Salteo la primera fila ya que esa tiene los nombres de las columnas
data = dlmread(archivo, '\t', 1, 0); % Nombre del archivo, delimitador '\t' para tabulaciones

% Asigno datos
VBE = data(:, 1); % Aca elegir la columna que represente los datos de tension
IC = data(:, 2); % Aca elegir la columna que represente los datos de corriente de colector
IB = data(:, 3); % Aca elegir la columna que represente los datos de corriente de base
beta = IC ./ IB;

%//AJUSTE
% Seleccionar vMin y vMax para elegir un rango de puntos a ajustar por una recta.
vMin = -0.7; %//Valor minimo del rango (en volts)
vMax = -0.5; %//Valor maximo del rango (en volts)

% Me quedo con los puntos entre vMin y vMax
indicesAjuste = (VBE > vMin) & (VBE < vMax);

% Tomo los datos en el intervalo elegido
VBE_ajuste = VBE(indicesAjuste);
beta_ajuste = beta(indicesAjuste);

% Ajuste lineal
p = polyfit(VBE_ajuste, beta_ajuste, 1); % Ajuste de una línea recta de primer orden (y = ax + b)
beta_f = p(2);
disp(['Ajuste de beta = ' num2str(beta_f)]);


% Evaluar la recta en el rango de interés
VBE_rango = linspace(vMin, vMax, 100); % Crear un vector de puntos VBE en el rango
beta_rango = polyval(p, VBE_rango); % Evaluar la recta en el rango de VBE




% Evaluar la recta en todo el rango de VBE
VBE_rango_todos = linspace(min(VBE), max(VBE), 100); % Crear un vector de puntos VBE en todo el rango
beta_rango_todos = polyval(p, VBE_rango_todos); % Evaluar la recta en todo el rango de VBE



% Graficar la curva beta
figure;
plot(VBE, beta, '-b', 'LineWidth', 1); % Curva 3: beta
hold on; % Mantener la figura actual
% Graficar la recta de ajuste
plot(VBE_rango_todos, beta_rango_todos, '--m', 'LineWidth', 1); % Recta de ajuste extendida
hold off; % Liberar la figura para futuras modificaciones
grid on; % Activar cuadrícula en el gráfico
xlabel('Tensión VBE [V)]'); % Etiqueta del eje x
ylabel('IC / IB '); % Etiqueta del eje y
legend('Corriente de colector (IC)', ['Curva ajustada. \beta = ' num2str(beta_f)], 'location', 'southwest'); % Leyenda





