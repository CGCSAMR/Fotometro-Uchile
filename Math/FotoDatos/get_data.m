clear all

path = fileparts(mfilename('fullpath'));
cd(path);

%% User inputs

name = input('Enter file name (without extension): ','s');

%lat = input('Enter latitude D.DDDD°: ')
%long = input('Enter longitude D.DDDD°: ')

latitud = -33.2738;
longitud = -70.3942;

% Numero columnas
N = 13;

%% Read Header

filename = [ name '.CSV'];
fid = fopen(filename);

lineFormat = '';

for i = 1:N
   lineFormat = [ lineFormat '%s' ]; 
end

headdummy = textscan(fid,lineFormat,1,'delimiter',',','CollectOutput', ...
                    0,'headerlines',0,'TreatAsEmpty','NA');
                
head='';
 
 for i=1:N
     head{i}=headdummy{i}{1};
 end
 
 %% Read Data
 
 lineFormat = '';
 
 for i = 1:N
   lineFormat = [ lineFormat '%f' ]; 
end

data = textscan(fid, lineFormat, 'headerlines',1,'delimiter',',','CollectOutput',0);

fclose(fid);

%% Save raw_data as .mat file

for i=1:size(head')
     raw_data.(head{i})=data{:,i};
end

raw_data.udate = datenum(raw_data.Year, raw_data.Month, raw_data.Day, ...
            raw_data.Hour, raw_data.Minute, raw_data.Second);


% En caso de altura manual
foo = input('¿Desea ingresar altura manualmente? s/n: ', 's');
if strcmp(foo,'s')
   altura = input('Ingrese altura del sitio de medición (m): '); 
   raw_data.Altitude_m = raw_data.Altitude_m.*0 + altura;
end

raw_data.Latitude = raw_data.udate.*0 + latitud;
raw_data.Longitude = raw_data.udate.*0 + longitud;

save( [ name '.mat' ] , 'raw_data' , '-v7' );
