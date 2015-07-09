Arduino = serial('COM10');
fopen(Arduino);
fwrite(Arduino, input('conectar (1)'));
[fi,texto]=fopen(input('Nombre archivo'),'w');
while true
    b=fscanf(Arduino);
    if b == '@'
        break;
    end
    fprintf(fi,b);
end
st = fclose(fi);
fclose(Arduino);
delete(Arduino);
clear();