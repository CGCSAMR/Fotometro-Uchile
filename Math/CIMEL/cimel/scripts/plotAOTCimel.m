clear all;

%load('dataCimel.mat')

load('fullDataCimel.mat')


% LOCAL TIME
%fechas = c.udate - datenum(0,0,0,3,0,0);



time_ini = datenum(2014,1,29,0,0,0);
time_fin = datenum(2014,1,30,0,0,0);

index = find( c.udate > time_ini & c.udate < time_fin);

hold on

plot(c.udate(index),c.AOT380(index),'-*m')

plot(c.udate(index),c.AOT440(index),'-*b')

plot(c.udate(index),c.AOT500(index),'-*y')

plot(c.udate(index),c.AOT675(index),'-*r')

plot(c.udate(index),c.AOT870(index),'-*k')

datetick('x', 'dd HH:MM')

grid on

title('Espesor Optico de Aerosoles en el tiempo, DGF 29 Enero 2014')
xlabel('Tiempo (hora local verano)')
ylabel('AOT')
legend('AOT380','AOT440','AOT500','AOT675','AOT870')

hold off



datetick('x', 'HH:MM')
