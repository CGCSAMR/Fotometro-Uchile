clear all;



% SE DECLARA FECHA DE INICIO Y TERMINO DE CAMPAÑA

time_ini = datenum(2015,1,28,12,0,0);
time_fin = datenum(2015,1,29,0,0,0);

% FIJAR UTC RESPECTO A HORA LOCAL (NO MODIFICAR, FUNCIONA BIEN ASI)
UTC = 0;

% FIJAR INTERVALO MINIMO ENTRE MEDICIONES (minutos)
intervalMin = datenum(0,0,0,0,2,0);

% Selección de índices de mediciones


%%

load aeronet_28_ene.lev10.mat

hold on


beta440 = aeronet.AOT_440 .* ( 0.44 .^ aeronet.AOT340_440Angstrom);


AOT_cimel_414 = beta440 .* ( 0.414  .^ ( -1 .* aeronet.AOT340_440Angstrom ) );

plot(aeronet.udate, AOT_cimel_414, '-*' )
%plot(aeronet.udate, aeronet.AOT_440, '-g*' )


load AOT_datos_marcos.mat
% INDEX POR FECHA
index = find( calan_data.udate > time_ini & calan_data.udate < time_fin );
%plot(calan_data.udate(index), calan_data.AOT_414_nm(index), '-g*');

load AOT_datos_roberto.mat
index = find( calan_data.udate > time_ini & calan_data.udate < time_fin );
%plot(calan_data.udate(index), calan_data.AOT_556_nm(index), '-r*');

load AOT_datos_falvey.mat
index = find( calan_data.udate > time_ini & calan_data.udate < time_fin );
plot(calan_data.udate(index), calan_data.AOT_556_nm(index), '-y*');

hold off

datetick;