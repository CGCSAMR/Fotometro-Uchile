clear all

path = fileparts(mfilename('fullpath'))

cd(path)

filename = input('Enter file name (without extension): ','s')
%lat = input('Enter latitude D.DDDD°: ')
%long = input('Enter longitude D.DDDD°: ')

lat = 33;
long = 33;

mkdir(['output/' filename])
mkdir(['output/' filename '/others'])

cd scripts
read_raw_data(filename, path);
process_raw_data(filename, lat, long,path)

cd ..