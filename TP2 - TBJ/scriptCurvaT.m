close all; clear all; clc;

%% Constantes
k = 1.3806e-23; % [J/K] Constante del Boltzmann
q = 1.60223e-19; % [C] Carga del electron
T = 300; % [K] Temperatura de trabajo
vth = k*T/q; % [V] Tensión termica

%% Lectura del archivo
archivo = 'curvaT.txt';

% Leo el archivo. Salteo la primera fila ya que esa tiene los nombres de las columnas
data = dlmread(archivo, '\t', 1, 0); % Nombre del archivo, delimitador '\t' para tabulaciones

% Asigno datos

VBE = data(:, 1); % Aca elegir la columna que represente los datos de tension
VBE_directa = VBE(VBE>0);
IC = data(:, 2); % Aca elegir la columna que represente los datos de corriente de colector
logIC = log(abs(IC)); % Tomo el logaritmo natural del valor absoluto de la corriente de colector
IB = data(:, 3); % Aca elegir la columna que represente los datos de corriente de base
logIB = log(abs(IB)); % Tomo el logaritmo natural del valor absoluto de la corriente de base

% //////////////////////// AJUSTE ////////////////////////

% Hay que elegir los puntos en directa a ajustar con una recta.
% Seleccionar vMin y vMax para elegir un rango de puntos a ajsutar por una recta.
% Este debe ser el rango de tensiones donde la recta del diodo en escala semilog se parece a una recta
vMin = -0.65; % Valor minimo del rango (en volts)
vMax = -0.45; % Valor maximo del rango (en volts)

% Me quedo con los puntos entre vMin y vMax
indicesAjuste = (VBE > vMin) & (VBE < vMax);


% Tomo los datos en el intervalo elegido
VBE_ajuste = VBE(indicesAjuste);
IC_ajuste = IC(indicesAjuste);
logIC_ajuste = logIC(indicesAjuste);

% Ajusto una recta a esos puntos y obtengo los coeficientes
coefAjuste = polyfit(VBE_ajuste, logIC_ajuste, 1);
%// coefAjuste: y = mx + b
%// coefAjuste(1): m
%// coefAjuste(2): b


% Calculo la corriente del diodo usando los parametros ajustados y el modelo exponencial
logIS = coefAjuste(2);
IS = exp(logIS); % Corriente de saturación en inversa
IC_ajustada = IS*exp(-VBE/(vth));
Vth = -(inv(coefAjuste(1)))*1e3;

% Imprimo el valor de IS en la consola
disp(['Ajuste de IS = ' num2str(IS) ' A']);
disp(['Ajuste de Vth = ' num2str(Vth) ' mV']);


% Grafico de las IC en ESCALA SEMILOG con ajuste
figure()
semilogy(VBE, abs(IC), '-b','LineWidth', 1), %Corriente de Colector
hold on;
plot(VBE_ajuste, abs(IC_ajuste), '-m','LineWidth', 1)  %Datos utilizados para el ajuste
plot(VBE, IC_ajustada, '--g', 'LineWidth', 2) %Curva de ajuste
hold on; % Mantengo el gráfico abierto para agregar otra curva
semilogy(VBE, abs(IB), '-r', 'LineWidth', 1, 'DisplayName', 'Corriente de base (IB)'); % Grafico IB
grid minor
ylabel('Corriente [A]');
xlabel('Tensión VBE [V]');
legend('Corriente de colector (IC)', 'Datos elegidos para el ajuste', ['Curva ajustada. IS = ' num2str(IS) ' A || Vth = ' num2str(Vth) ' mV' ],'Corriente de base (IB)', 'location', 'southwest');
xlim([min(VBE) max(VBE_ajuste)]) % Establece el límite x para el rango de datos experimentales
ylim([1e-8 1]);
legend; % Muestro la leyenda

