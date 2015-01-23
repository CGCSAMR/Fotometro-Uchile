clear all;

load 22_Ene_DGF.lev10.mat

hold on

plot(aeronet.udate, aeronet.AOT_440, '-*' )

load AOT_datos_marcos_fix.mat
plot(calan_data.udate, calan_data.AOT_414_nm, '-g*');

load AOT_datos_roberto_fix.mat
plot(calan_data.udate, calan_data.AOT_414_nm, '-r*');

load AOT_datos_falvey_fix.mat
plot(calan_data.udate, calan_data.AOT_414_nm, '-y*');

hold off

datetick;