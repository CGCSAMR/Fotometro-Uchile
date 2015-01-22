clear all;
% Este programa compara los datos de cimel con datos simultaneos de los
% fotometros calan para realizar calibracion lado a lado

% Cargar datos de CIMEL
load camp_control_calidad.lev10.mat

% Cargar datos de Calan
load AOT_DATALOG_FALVEY.mat

% Longitud de onda sensor a calibrar
lambda = 414;

% Indice de medicion Calan escogida para calibracion
index = 5;

% FIJAR INTERVALO MINIMO ENTRE MEDICIONES (minutos)
[dummy aeroindex] = min( abs( calan_data.udate(index) - aeronet.udate ) );

%% Calculo de coef de angstrom

if ( 340 < lambda ) && ( lambda < 440 )
   
    angstrom = aeronet.AOT340_440Angstrom(aeroindex);
    
    aot340 = aeronet.AOT_340(aeroindex);
    aot675 = aeronet.AOT_440(aeroindex);
    
    % Volaje medido en sensor azul
    V_medido = calan_data.Sens_414_nm(index);
    
    % AOT rayleigh, sensor amarillo: {1}, sensor azul: {2}
    AOT_r = calan_data.otros.tauR{2}(index);
    
    beta340 = aot340 * 0.34 ^ angstrom;
    beta440 = aot675 * 0.44 ^ angstrom;
    
    beta = mean( [ beta340 beta440 ] );
    
elseif ( 440 < lambda ) && ( lambda < 675 )
        
    angstrom = aeronet.AOT440_675Angstrom(aeroindex);
    
    aot440 = aeronet.AOT_440(aeroindex);
    aot675 = aeronet.AOT_675(aeroindex);
    
    % Voltaje medido en sensor amarillo
    V_medido = calan_data.Sens_556_nm(index);
    
    % AOT rayleigh, sensor amarillo: {1}, sensor azul: {2}
    AOT_r = calan_data.otros.tauR{1}(index);
    
    beta440 = aot440 * 0.44 ^ angstrom;
    beta675 = aot675 * 0.675 ^ angstrom;
    
    beta = mean( [ beta440 beta675 ] );
    
end

% AOT esperado
AOT_e = beta * ( lambda/1000 ) ^ ( -1 * angstrom );

% Correccio distancia tierra-sol ( R0 / R ) ^ 2
SDC = calan_data.SunDistCORR(index);

% Programa de correccion de datos ya ajusta Raileigh por presion
% P = calan_data.Pressure_Pa(index);
% P0 = 1013.25 * 100; % Presion ndm en pascales

AirM = calan_data.AirMass(index);

% Constante de calibracion!

V0 = V_medido * exp( ( AOT_e + AOT_r ) * AirM )/ SDC

    
    