function [] = read_raw_data(filename)

name = ['../raw_data/' filename '.CSV'];

fid = fopen(name);

%% Read Header

lineFormat = '';

for i = 1:13
   lineFormat = [ lineFormat '%s' ]; 
end

headdummy = textscan(fid,lineFormat,1,'delimiter',',','CollectOutput', ...
                    0,'headerlines',0,'TreatAsEmpty','NA');
                
head='';
 
 for i=1:13
     head{i}=headdummy{i}{1};
 end
 
 
 
  
 %% Read Data
 
 lineFormat = '';
 
 for i = 1:13
   lineFormat = [ lineFormat '%f' ]; 
end

data = textscan(fid, lineFormat, 'headerlines',1,'delimiter',',','CollectOutput',0);

fclose(fid);

%% Save Data as .mat file

for i=1:size(head')
     raw_data.(head{i})=data{:,i};
end

mkdir(['../output/' filename])

save(['../output/' filename '/raw_' filename '.mat'],'raw_data','-v7');

 


