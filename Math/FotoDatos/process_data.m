get_data

%% Process raw_data to obtain AOT

% SE DECLARA FECHA DE INICIO Y TERMINO DE CAMPAÑA

time_ini = datenum(2013,1,1,0,0,0);
time_fin = datenum(2016,3,30,0,0,0);

% FIJAR UTC RESPECTO A HORA LOCAL (NO MODIFICAR, FUNCIONA BIEN ASI)
UTC = 0;

% FIJAR INTERVALO MINIMO ENTRE MEDICIONES (minutos)
intervalMin = 1;

%% Selección de índices de mediciones

% INDEX POR FECHA
index = find( raw_data.udate > time_ini & raw_data.udate < time_fin );

% Se filtra escogiendo el "mejor" dato dentro de intervalos de intervalMin
% minutos. Para esto escoge la medicion en la que el canal de XXXX nm
% registra la respuesta más alta.

newudate = raw_data.udate(index);

%% CONSTANTES Y STRINGS UTILES

P0=1013.25; % PRESION n.d.m.
lamtxt={'380','440'};

lam=[380,440]; % LONGITUD DE ONDA DE MEDICION

aodtxt={'AOT_380','AOT_440'};

% CONSTANTES DE CALIBRACION
V0 = [28385 23474];

%% CALCULO DEL DIA DEL AÑO (NO DIA JULIANO, NO SE LLAMA ASI)

doy = newudate-datenum(year(newudate),1,1)+1;

% CALCULO AIRMASS Y CORRECCION POR DIST SOL

gamma=2*pi*(doy-1)/365;
decl=(0.006918 - ...
      0.399912*cos(gamma)+ ...
      0.070257*sin(gamma)- ...
      0.006758*cos(2*gamma) + ...
      0.000907*sin(2*gamma)- ...
      0.002697*cos(3*gamma)+ ...
      0.00148*sin(3*gamma));%%%en radianes...%%%%*(180/pi);

  % para calcular SZA
for i=1:length(newudate)
    time.year=year(newudate(i));
    time.month=month(newudate(i));
    time.day=day(newudate(i));
    time.hour=hour(newudate(i));
    time.min=minute(newudate(i));
    time.sec=second(newudate(i));
    time.UTC=UTC;
              
    location.longitude = raw_data.Longitude(i);
    location.latitude = raw_data.Latitude(i);
    location.altitude = raw_data.Altitude_m(i);
         
     
         
     [sun test] = sun_position(time, location);
     sunzenith(i)=sun.zenith;
     sunazimuth(i)=sun.azimuth;
     sunrad(i)=test.radius;
end

SZA = sunzenith;      % ANGULO ZENITAL
SDCORR = sunrad.^2;   % CORRECCION POR DISTANCIA AL SOL
nu0 = (180-SZA);    %*pi/180;
mu0 = cosd(SZA);
AMzdun = (abs(mu0)+0.50572.*(nu0-83.92).^-1.6364  ).^-1;  % Airmass



