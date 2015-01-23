clear all;


% Nombre de archivo
filename = '22_Ene_DGF.lev10';

% Cantidad de columnas
N = 45;

%% Leer encabezado

dataFormat = '';

for i = 1:N   
    dataFormat = [ dataFormat ' %s' ];
end

fid = fopen(filename);
dataraw = textscan(fid, dataFormat, 'headerlines',4, 'delimiter' , ',' , 'CollectOutput' ,0);
fclose(fid);

for i=1:N
    header{i}=dataraw{i}{1};
end

%% Leer datos

dataFormat = '';

% Columnas 1-2 String
for i = 1:2
    dataFormat = [ dataFormat ' %s' ];
end

% Columnas 3-7 double
for i = 3:7
    dataFormat = [ dataFormat ' %f' ];
end

% Columnas 8-12 Nan
for i = 8:12
   dataFormat = [ dataFormat ' %s' ];
end

% Columna 13 double
dataFormat = [ dataFormat ' %f' ];

% Columna 14-15 Nan
for i = 14:15
    dataFormat = [ dataFormat ' %s' ];
end

% Columna 16 double
dataFormat = [ dataFormat ' %f' ];

% Columna 17 Nan
dataFormat = [ dataFormat ' %s' ];

% Columnas 18-24 double
for i = 18:24
    dataFormat = [ dataFormat ' %f' ];
end

% Columna 25-29 Nan
for i = 25:29
    dataFormat = [ dataFormat ' %s' ];
end

% Columna 30 double
dataFormat = [ dataFormat ' %f' ];

% Columna 31-32 Nan
for i = 31:32
    dataFormat = [ dataFormat ' %s' ];
end

% Columna 33 double
dataFormat = [ dataFormat ' %f' ];

% Columna 34 Nan
dataFormat = [ dataFormat ' %s' ];

% Columnas 35-42 double
for i = 35:42
    dataFormat = [ dataFormat ' %f' ];
end

% Columna 43 Nan, 44 fecha termino
for i = 43:44
    dataFormat = [ dataFormat ' %s' ];
end

% Columna 45 double
dataFormat = [ dataFormat ' %f' ];


fid = fopen(filename);
dataraw = textscan(fid, dataFormat, 'headerlines',5, 'delimiter' , ',' , 'CollectOutput' ,0);
fclose(fid);


%% Corregir headers

header{1} = 'date'; % Corrige Date(dd-mm-yy)
header{2} = 'time'; % Corrige Time(hh:mm:ss)
header{20} = 'Water_cm'; % Corrige Water(cm)

for i = 21:37
   header{i} = header{i}(2:end); % Elimina los % de %TripletVa...
end

for i = 38:43
    header{i}(4) = '_'; % Reemplaza '-' por '_'
    header{i} = [ 'AOT' header{i} ]; % Agrega strings al inicio del nombre
end

header{43} = [ header{43}(1:18) '_polar' ]; % Reemplaza (polar) por _polar

header{44} = 'last_processing_date';

for i=1:N
     aeronet.(header{i})=dataraw{:,i};
end
 
aeronet.udate=datenum(strcat(aeronet.date, aeronet.time), 'dd:mm:yyyyHH:MM:SS');

save( [ filename '.mat' ],'aeronet','-v7');
