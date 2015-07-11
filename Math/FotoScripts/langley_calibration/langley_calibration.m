clear all;

load AOT_falvey_cor.mat

time_ini = datenum(2014,2,1,0,0,0);
time_fin = datenum(2016,2,8,13,0,0);

% Filtrar por masa de aire
index = find( calan_data.AirMass > 1 & calan_data.AirMass < 8000 );

% V1 sensor amarillo, V2 sensor azul
V1 = calan_data.Sens_556_nm(index);
V2 = calan_data.Sens_414_nm(index);

lnV1 = log(V1);
lnV2 = log(V2);

% Airmass
airmass = calan_data.AirMass(index);

% Correccion distancia tierra sol
SDC = calan_data.SunDistCORR(index); % (R/R0)^2

% hora
udate = calan_data.udate(index);

% presion
P = calan_data.Pressure_Pa;
P0 = 101325;

% Calibracion
[coef_1 S1] = polyfit(airmass, lnV1, 1)
[coef_2 S2] = polyfit(airmass, lnV2, 1)

% Cte calibracion
V0_1 = exp( coef_1(2) ) * mean(SDC)
V0_2 = exp( coef_2(2) ) * mean(SDC)

% Coef Rayleigh a nivel del mar
ray_1 = -1 * coef_1(1) * P0 / mean(P)
ray_2 = -1 * coef_2(1) * P0 / mean(P)

% Determinacion coef. regresion R^2
f_1 = polyval(coef_1, airmass);
f_2 = polyval(coef_2, airmass);

r2_1 = rsquare(lnV1, f_1)
r2_2 = rsquare(lnV2, f_2)

hold on
x = 0:0.001: ( max(airmass) + 0.1 );

plot(airmass, lnV1,'*r')
plot(x, coef_1(1)*x + coef_1(2), 'r');

plot(airmass, lnV2,'*b')
plot(x, coef_2(1)*x + coef_2(2), 'b');

grid on

%Titulo
% Langley Plot prototipo Falvey utilizando todos los datos
% Mediciones en la manana del 07-02-2015, La Parva

hold off
