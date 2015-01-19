function [] = read_raw_data(filename,path)

name = [ path '/raw_data/' filename '.csv'];

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

raw_data.udate = datenum(raw_data.Year, raw_data.Month, raw_data.Day, ...
            raw_data.Hour, raw_data.Minute, raw_data.Second);

save([ path '/output/' filename '/others/raw_' filename '.mat'],'raw_data','-v7');

end


