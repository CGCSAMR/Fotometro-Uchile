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
lamtxt={'556_nm','414_nm'};

lam=[570,400]; % LONGITUD DE ONDA DE MEDICION EN nm

aodtxt={'AOT_556_nm','AOT_414_nm'};
sigtxt={'Sens_556_nm','Sens_414_nm'};

% CONSTANTES DE CALIBRACION
V0 = [1000 1356.3];

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

%% CALCULO SCATTERING RAYLEIGH

lammic=lam/1000;
% gravity calc

lat = raw_data.Latitude(index);
altitude= raw_data.Altitude_m(index);


g0cms=980.6160*(1-0.0026373.*cosd(2*lat) +0.0000059.*(cosd(2.*lat).^2) ...
                ); %cm/s
g0=g0cms/100; %m/s

gcms=g0cms-( 3.085462e-4 + 2.27e-7.*cosd(2*lat)).*altitude ...
     + (7.254e-11 + 1e-13.*cosd(2*lat)).*altitude ...
     - (1.517e-17 + 6e-20.*cosd(2*lat)).*altitude ;
g=gcms/100;

% 
Av= 6.0221367.*1e23 ; % avogadro     

sig=1e-28.*( 1.0455996 - 341.29061.*lammic.^-2 - 0.90230850.*lammic.^2 ...
             )./(1+  0.0027059889.*lammic.^-2 ...
                 - 85.968563.*lammic.^2); ...
%cm^2
CO2=360; % en ppm   
ma=15.0556.*CO2.*1e-6+28.9595; % gm/mol
for i=1:length(V0)
    tauRbod{i}=(sig(i).*1e-4).*(raw_data.Pressure_Pa(index).*Av)./( ma*1e-3.*g );
    % mejor que el de ichoku
end


%% CORRECCION AOT (RECORDAR QUE HAY QUE RECALIBRAR LOS VALORES DE V0)

for i=1:length(V0)
    
    AOT{i}=(log(V0(i)) - log(raw_data.(sigtxt{i})(index).* SDCORR'))...
                                     ./AMzdun' ...
                                     - tauRbod{i};
    
    for j=1:size(AOT{i},1)
        if ~isreal(AOT{i}(j))
            AOT{i}(j)=NaN;
        end
    end
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
    calan_data.otros.tauR =  tauRbod;
    calan_data.otros.idcam=index;
    calan_data.otros.lamtxt=lamtxt;
    calan_data.otros.lam=lam;
    calan_data.otros.aodtxt=aodtxt;
    calan_data.otros.sigtxt=sigtxt;
    calan_data.otros.raw_data=raw_data;

    c = calan_data;
    
save( ['AOT_' name '.mat' ] , 'calan_data' , '-v7' );



