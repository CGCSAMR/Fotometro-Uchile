Arduino = serial('COM9');
fopen(Arduino);
fwrite(Arduino, input('conectar (1)'));
a = fscanf(Arduino);
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