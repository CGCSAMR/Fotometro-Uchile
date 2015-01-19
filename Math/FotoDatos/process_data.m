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
lamtxt={'400','500'};

lam=[400,500]; % LONGITUD DE ONDA DE MEDICION

aodtxt={'AOT_400','AOT_500'};
sigtxt={'Sens1','Sens2'};

% CONSTANTES DE CALIBRACION
V0 = [1000 800];

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
    calan_data.SIG380     =  raw_data.Sens1(index)         ;  
    calan_data.SIG440     =  raw_data.Sens2(index)         ;  
    

    cimelcorregido.AOT380     =  AOT{1}         ;  
    cimelcorregido.AOT440     =  AOT{2}         ;  
    cimelcorregido.AOT500     =  AOT{3}         ;  
    cimelcorregido.AOT675     =  AOT{4}         ;  
    cimelcorregido.AOT870     =  AOT{5}         ;
    cimelcorregido.AOT936     =  AOT{6}         ;
    cimelcorregido.AOT1020    =  AOT{7}         ;
    cimelcorregido.AOT1020i   =  AOT{8}         ;
    cimelcorregido.AOT1640i   =  AOT{9}         ;
    
    
    cimelcorregido.udate      =  newudate       ;              
    cimelcorregido.otros.tauR =  tauRbod;
    cimelcorregido.otros.idcam=index;
    cimelcorregido.otros.lamtxt=lamtxt;
    cimelcorregido.otros.lam=lam;
    cimelcorregido.otros.aodtxt={'AOT_380_SI','AOT_440_SI','AOT_500_SI','AOT_675_SI','AOT_870_SI','AOT_936_SI','AOT_1020_SI','AOT_1020_InGaAs','AOT_1640_InGaAs'};
    cimelcorregido.otros.sigtxt={'SUN_380_SI','SUN_440_SI','SUN_500_SI','SUN_675_SI','SUN_870_SI','SUN_936_SI','SUN_1020_SI','SUN_1020_InGaAs','SUN_1640_InGaAs'};
    cimelcorregido.otros.ctes={'LNV01','LNV02','LNV03','LNV04','LNV05'};
    cimelcorregido.otros.cimeloriginal=cimel;

    c = cimelcorregido;
    
save('/home/felipe/Documents/MATLAB/CIMEL/scripts/correctedData/fullDataCimel.mat','c','-v7');

