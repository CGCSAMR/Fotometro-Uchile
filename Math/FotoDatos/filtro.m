%%La idea es tomar un archivo .csv sacado del fotometro
format long
M = csvread(input('archivo a optimizar?'),1,0); %Ingreso archivo desde fotometro
fi=input('Nombre archivo?'); %Nombre archivo optimizado
j = 1; %indice superior de agrupación
k = 1; %indice inferior de agrupacion
l = 1; %line de matriz a remplazar
m = zeros(2*length(M(:,1)),length(M(1,:))); %memoria reservada para datos optimos
for i=1:(length(M(:,1))-1)
    if ( datenum(M(i,1:6)) + datenum([0 0 0 0 2 0]) ) > datenum(M(i+1,1:6)) %Comparamos fecha de la medicion con la siguiente
        j = j + 1; %de cumplirse agregamos el indice al grupo
    else  %si no cerramos el grupo y buscamos el optimo
        yel = find(max(M(k:j,7))); %optimo sensor amarillo
        blu = find(max(M(k:j,8))); %optimo sensor azul
        for a=1:length(M(1,:))
            m(l,a) = m(l,a) + M(k-1+yel,a); %escribimos los datos obtenidos en lam matriz
            m(l+1,a) = m(l+1,a) + M(k-1+blu,a);
        end
        k = j+1; %inicializamos para buscar en el siguiente grupo
        j = j+1; 
        l=l+2;%desplazamos la linea de escritura
    end
    
end
if k == length(M(:,1)) %puede que el ultimo dato forme un grupo en si mismo
   for a=1:length(M(1,:))
       m(l,a) = m(l,a) + M(k-1+yel,a);
       m(l+1,a) = m(l+1,a) + M(k-1+blu,a);
   end
end
csvwrite(fi,m(1:l-1,:)); %escribimos los datos obtenidos 
clear() %limpieamos el espacio de opercacion
format short
