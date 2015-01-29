%%La idea es tomar un archivo .csv sacado del fotometro
M = csvread(input('archivo a optimizar?'),1,0);
fi=input('Nombre archivo?');
j = 0;
k = 1;
l = 1;
m = zeros(2*length(M(:,1)),length(M(1,:)));
for i=1:(length(M(:,1)))
    if datenum(M(i,1:6)) + datenum([0 0 0 0 5 0]) < datenum(M(i,1:6))
        j = j + 1;
    else 
        if j == 0
            j = 1;
        end
        yel = find(max(M(k:j,7)));
        blu = find(max(M(k:j,8)));
        a = m(l,:);
        b = M(yel,:);
        for a=1:length(M(1,:))
        m(l,a) = m(l,a) + M(k-1+yel,a);
        m(l+1,a) = m(l+1,a) + M(k-1+blu,a);
        end
        k = j+1;
        j = j+1;
        l=l+2;
    end
    
end
csvwrite(fi,m(1:l-1,:));

