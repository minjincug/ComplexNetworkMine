function [Edges]=readlink()

data_path=strcat(pwd,'\data');
dirname = fullfile(data_path,'*.csv');
datalist = dir(dirname);

data_type='link';
for i=1:length(datalist)
    if regexp(datalist(i).name,data_type)
        data=datalist(i).name;
    end
end
link_data=readtable(data);

m=length(link_data{:,'TARGET_FID'});
interEdges=zeros(m,3);
for i=1:m
    interEdges(i,1)=link_data{i,'waterId'};
    interEdges(i,2)=link_data{i,'mineId'};
    interEdges(i,3)=link_data{i,'PATHCOST'};
end
Edges=interEdges;


