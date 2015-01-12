clear all;

% ANTES DE USAR SE DEBE GUARDAR EL ARCHIVO DBT DE MICROTOPS COMO CSV USANDO
% EXCEL Y LUEGO CAMBIAR TODOS LOS '/' Y ':' POR ',' CON ALGUN EDITOR DE
% TEXTO O SCRIPT. DESPUES DE ESTO EJECUTAR ESTE PROGRAMA CON EL ARCHIVO EN
% LA MISMA CARPETA


filename = 'cimel_full.NSU'; %se asume .csv
headerFile = 'header.txt';

dataFormat = '';

for i=1:2
    dataFormat=[dataFormat ' %s'];    
end

for i = 3:33
   dataFormat = [dataFormat ' %f']; 
end


fid = fopen(filename);

dataraw = textscan(fid, dataFormat, 'headerlines',1,'delimiter',',','CollectOutput',0);


fclose(fid);

 fid=fopen(headerFile);
 
formatoleer='';

for i=1:33
    formatoleer=[formatoleer ' %s']; 
 end
 
 headdummy=textscan(fid,formatoleer,1,'delimiter',',','CollectOutput', ...
                    0,'headerlines',0,'TreatAsEmpty','NA');
 head='';
 
 for i=1:33
     head{i}=headdummy{i}{1};
 end
 fclose(fid);
 
 sizeHead = size(head);
 
 for i=1:sizeHead(1,2)
     cimel.(head{i})=dataraw{:,i};
 end
 

cimel.udate=datenum(strcat(cimel.Date, cimel.Time), 'dd/mm/yyyyHH:MM:SS');

save('/home/felipe/Documents/MATLAB/CIMEL/scripts/rawFullDataCimel.mat','cimel','-v7');
