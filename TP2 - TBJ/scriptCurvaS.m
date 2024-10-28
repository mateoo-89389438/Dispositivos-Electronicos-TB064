close all; clear all; clc;


%% Lectura del archivo
archivo = 'curvaS.txt';

% Leo el archivo. Salteo la primera fila ya que esa tiene los nombres de las columnas
data = dlmread(archivo, '\t', 1, 0); % Nombre del archivo, delimitador

% Asigno datos
VCE = data(:, 1); % Aca elegir la columna que represente los datos de tension colector emisor
VCE_directa = VCE(VCE>0);
IC = data(:, 2); % Aca elegir la columna que represente los datos de corriente de colector

%////////////////////////////////////////////////////////////////////////////////

%% Gráfico de la corriente de colector en ESCALA LINEAL con la curva ajustada
% //////////////////////// AJUSTE ////////////////////////

% Seleccionar vMin y vMax para elegir un rango de puntos a ajustar por una recta.
vMin = -3; % Valor minimo del rango (en volts)
vMax = -1; % Valor maximo del rango (en volts)

% Me quedo con los puntos entre vMin y vMax
indicesAjuste = (VCE > vMin) & (VCE < vMax);

% Tomo los datos en el intervalo elegido
VCE_ajuste = VCE(indicesAjuste);
IC_ajuste = IC(indicesAjuste);

% Ajusto una recta a esos puntos y obtengo los coeficientes
coefAjuste = polyfit(VCE_ajuste, IC_ajuste, 1);

% Calculo la raiz (punto de corte con el eje X)
VA = -coefAjuste(2) / coefAjuste(1);

% Muestro la raiz
fprintf('VA = %f V\n', VA);

%% Gráfico de la corriente de colector IC en ESCALA LINEAL
% Extiende la curva ajustada a lo largo de todo el gráfico
IC_ajuste_extendida = polyval(coefAjuste, VCE);

% Multiplica por 1e3 la corriente para pasarla a mA
figure();
plot(VCE, IC, '-b','LineWidth', 1, 'DisplayName', 'Corriente de colector (IC). VCE(SAT) = -250 mV');
hold on;  % Mantengo el gráfico abierto para agregar otra curva
plot(VCE_ajuste, IC_ajuste, '-r','LineWidth', 1, 'DisplayName', 'Datos elegidos para el ajuste');
hold on;  % Mantengo el gráfico abierto para agregar otra curva
plot(VCE, IC_ajuste_extendida, '--g','LineWidth', 2, 'DisplayName', ['Curva ajustada. VA = ' num2str(VA) ' V' ]);
grid minor
ylabel('Corriente [A]');
xlabel('Tension VCE [V]');
xlim([-4 0]);
ylim([-0.002 0]);
legend('location', 'northwest');




