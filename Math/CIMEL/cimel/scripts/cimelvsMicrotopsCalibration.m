clear all;

load rawDataCimel.mat
load dataMicrotopsvsCimel.mat

load dataCimel.mat

lamtxt={'380','440','500','675','870'};
aodtxt={'AOT380','AOT440','AOT500','AOT670','AOT870'};

indicem=[];
indicec=[];


% INDICE i ES DEL MICROTOPS, j DEL CIMEL

for i = 1:length(m.udate)
    
    for j = 1:length(c.udate)
        
        if abs(m.udate(i) - cimel.udate(j)) < datenum(0,0,0,0,3,0);
            
            indicem = [indicem i];
            indicec = [indicec j];
            
            break;
        end
        
    end
    
end

m.udate(1) = [];
m.AOT380(1) = [];
m.AOT440(1) = [];
m.AOT500(1) = [];
m.AOT675(1) = [];
m.AOT870(1) = [];

m.AOT670 = m.AOT675;

for i = 1:5

h=figure(i);

hold on

plot(c.udate,c.(aodtxt{i}),'-*g')

plot(m.udate,m.(aodtxt{i}),'-*b')

title(['Comparacion AOT 2 Jan 2014 ' lamtxt{i} 'nm'])
legend(['AOT Cimel ' lamtxt{i} 'nm'],['AOT Microtops '  lamtxt{i} 'nm'])

datetick('x','HH:MM')

grid on

hold off

saveas(h, ['MicrotopsVsCimel-' lamtxt{i} '.png'],'png');

end









