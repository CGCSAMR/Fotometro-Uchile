clear all

filename = input('Enter file name (without extension): ','s')

cd scripts
read_raw_data(filename)
process_raw_data(filename)

cd ..