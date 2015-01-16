clear all

%cd(fileparts(mfilename('fullpath')))

filename = input('Enter file name (without extension): ','s')
lat = input('Enter latitude D.DDDD°: ')
long = input('Enter longitude D.DDDD°: ')

mkdir(['output/' filename])
mkdir(['output/' filename '/others'])

cd scripts
read_raw_data(filename);
process_raw_data(filename, lat, long)

cd ..