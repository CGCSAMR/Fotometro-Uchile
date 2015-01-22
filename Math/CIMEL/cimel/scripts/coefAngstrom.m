clear all;

load('fullDataCimel.mat')

% CALCULO DEL COEFICIENTE ALPHA


time_ini = datenum(2014,1,17,0,0,0);
time_fin = datenum(2014,1,19,0,0,0);

index = find( c.udate > time_ini & c.udate < time_fin);

fechas = c.udate(index);

AOT380 = c.AOT380(index);
AOT440 = c.AOT440(index);
AOT500 = c.AOT500(index);
AOT675 = c.AOT675(index);
AOT870 = c.AOT870(index);

alpha380x440 = -log(AOT380./AOT440)./(log(380/440));

alpha440x500 = -log(AOT440./AOT500)./(log(440/500));

alpha500x675 = -log(AOT500./AOT675)./(log(500/675));

alpha675x870 = -log(AOT675./AOT870)./(log(675/870));

figure(1)
hold on

plot(fechas,alpha380x440,'-*m')

plot(fechas,alpha440x500,'-*b')

plot(fechas,alpha500x675,'-*y')

plot(fechas,alpha675x870,'-*r')

alphaTodos = [alpha380x440; alpha440x500; alpha500x675; alpha675x870];



datetick('x', 'HH:MM')

grid on

title('Angstrom alpha coefficient, DGF 29/01/2014')
xlabel('Tiempo UTC')
ylabel('Coef Angstrom')
legend('alpha380x440','alpha440x500','alpha500x675','alpha675x870')
datetick('x', 'HH:MM')
hold off


% CALCULO DEL COEFICIENTE BETA

for j = 1:length(alpha380x440)

beta380(j) = AOT380(j)*(0.380)^(alpha380x440(j));

beta440(j) = AOT440(j)* (.440)^((alpha380x440(j)+alpha440x500(j))/2);

beta500(j) = AOT500(j)* (.500)^((alpha440x500(j)+alpha500x675(j))/2);

beta675(j) = AOT675(j)* (.675)^((alpha500x675(j)+alpha675x870(j))/2);

beta870(j) = AOT870(j)* (0.870)^(alpha675x870(j));

end

betaTodos = [beta380 beta440 beta500 beta675 beta870];

figure(2)
hold on

plot(fechas,beta380,'-*m')

plot(fechas,beta440,'-*b')

plot(fechas,beta500,'-*y')

plot(fechas,beta675,'-*r')

plot(fechas,beta870,'-*k')

datetick('x', 'HH:MM')


grid on

title('Angstrom Beta coefficient, DGF 29/01/2014')
xlabel('Tiempo UTC')
ylabel('Coef Angstrom')
legend('beta380','beta440','beta500','beta675','beta870')
datetick('x', 'HH:MM')
hold off
% 
% figure(3)
% 
% hist(alphaTodos,15)
% 
% figure(4)
% 
% hist(betaTodos,15)