% Pensado para los Fotometros Calan

get_data

%% Process raw_data to obtain AOT

% SE DECLARA FECHA DE INICIO Y TERMINO DE CAMPAÑA

time_ini = datenum(2013,1,1,0,0,0);
time_fin = datenum(2016,3,30,0,0,0);

% FIJAR UTC RESPECTO A HORA LOCAL (NO MODIFICAR, FUNCIONA BIEN ASI)
UTC = 0;

% FIJAR INTERVALO MINIMO ENTRE MEDICIONES (minutos)
intervalMin = datenum(0,0,0,0,2,0);

%% Selección de índices de mediciones

% INDEX POR FECHA
index = find( raw_data.udate > time_ini & raw_data.udate < time_fin );

% Se filtra escogiendo el "mejor" dato dentro de intervalos de intervalMin
% minutos. Para esto escoge la medicion en la que el canal de XXXX nm
% registra la respuesta más alta.
    
newudate = raw_data.udate(index);

%% CONSTANTES Y STRINGS UTILES

P0=1013.25; % PRESION n.d.m.
lamtxt={'556_nm','414_nm'};

lam=[556,414]; % LONGITUD DE ONDA DE MEDICION EN nm

aodtxt={'AOT_556_nm','AOT_414_nm'};
sigtxt={'Sens_556_nm','Sens_414_nm'};

% CONSTANTES DE CALIBRACION FALVEY
% V0 = [ 679.9633 733.5996];

% % CONSTANTES ROBERTO
%  V0 = [ 709.2878 737.1295 ];

% CONSTANTES MARCOS
V0 = [ 768.3368 769.4022 ];

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
SDCORR = sunrad.^2;   % CORRECCION POR DISTANCIA AL SOL (R/R0)^2
nu0 = (180-SZA);    %*pi/180;
mu0 = cosd(SZA);
AMzdun = (abs(mu0)+0.50572.*(nu0-83.92).^-1.6364  ).^-1;  % Airmass

% CALCULO SCATTERING RAYLEIGH

% Longitudes de onda lam en nm

for i = 1:length(lam)
   
    if lam(i) <= 500
        A = 6.50362e-3;
        B = 3.55212;
        C = 1.35579;
        D = 0.11563;
    end
    
    if lam(i) > 500
       A = 8.64627e-3;
       B = 3.99668;
       C = 1.10298e-2;
       D = 2.71393e-2;
    end
    
    % se pasa presion a hPa
    pressure = raw_data.Pressure_Pa(index) / 100;
    
    % se pasa lambda a micrometro
    lam_um = lam(i) / 1000;
    
    tauR(:,i) = ( pressure / P0 ) * A * lam_um ^ ( -B - C*lam_um - D/lam_um ) ;
    
end

% Usando datos empiricos

% % FALVEY
%  tauR(:,1) = tauR(:,1) * 0 + 0.1338; 
%  tauR(:,2) = tauR(:,2) * 0 + 0.2732;

% % ROBERTO
% tauR(:,1) = tauR(:,1) * 0 + 0.1037; 
% tauR(:,2) = tauR(:,2) * 0 + 0.2538;
% % 
% MARCOS
tauR(:,1) = tauR(:,1) * 0 + 0.1515; 
tauR(:,2) = tauR(:,2) * 0 + 0.2486;


%% CORRECCION AOT (RECORDAR QUE HAY QUE RECALIBRAR LOS VALORES DE V0)

for i=1:length(V0)
    
    AOT{i}= ( log( V0(i)./SDCORR(index)' ) - log( raw_data.( sigtxt{i} )(index) ) - ...
            tauR(:,i) .* ( pressure/P0 ) .* AMzdun' ) ./ AMzdun';
    
%     for j=1:size(AOT{i},1)
%         if ~isreal(AOT{i}(j))
%             AOT{i}(j)=NaN;
%         end
%     end

end

%% Guardar datos procesados

    calan_data.Latitude   =  raw_data.Latitude(index)       ;  
    calan_data.Longitude  =  raw_data.Longitude(index)     ;  
    calan_data.Altitude_m   =  raw_data.Altitude_m(index)       ;
    calan_data.Pressure_Pa   =  raw_data.Pressure_Pa(index)       ;
         
    calan_data.Sun_Zenith_Angle        =  SZA'            ;  
    calan_data.Temperature_C       =  raw_data.Temperature_C(index)           ;  
    calan_data.AirMass         =  AMzdun'             ;  
    calan_data.SunDistCORR     =  SDCORR'         ;  
  
    % Arreglar NOMBRES de Sensores en programa arduino
    calan_data.Sens_556_nm     =  raw_data.Sens_556_nm(index)         ;  
    calan_data.Sens_414_nm     =  raw_data.Sens_414_nm(index)         ;  
    

    calan_data.AOT_556_nm     =  AOT{1}         ;  
    calan_data.AOT_414_nm     =  AOT{2}         ;  
   
    calan_data.V0=V0;
    
    calan_data.udate      =  newudate       ;              
    calan_data.otros.tauR =  tauR;
    calan_data.otros.idcam=index;
    calan_data.otros.lamtxt=lamtxt;
    calan_data.otros.lam=lam;
    calan_data.otros.aodtxt=aodtxt;
    calan_data.otros.sigtxt=sigtxt;
    calan_data.otros.raw_data=raw_data;

    c = calan_data;
    
save( ['AOT_' name '.mat' ] , 'calan_data' , '-v7' );

