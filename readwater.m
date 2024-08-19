function [G_water]=readwater()

data_path=strcat(pwd,'\data');
dirname = fullfile(data_path,'*.csv');
datalist = dir(dirname);
% water_data=readtable(datalist(2).name);


data_type='waternet';
for i=1:length(datalist)
    if regexp(datalist(i).name,data_type)
        data=datalist(i).name;
    end
end

water_data=readtable(data);

data_type='DEM';
for i=1:length(datalist)
    if regexp(datalist(i).name,data_type)
        data2=datalist(i).name;
    end
end
water_DEM=readtable(data2);


nodeID=water_data{:,'pointId'};
m=length(nodeID);
for i=1:m
    if(nodeID(i)>221)
        nodeID(i)=nodeID(i)-1;
    end
end
water_data.('pointId')=nodeID;



%ˮ������ڵ��ʼ��
% ��ȡ�ڵ�����

water_nodeID=unique(water_data{:,'pointId'});
temppoint=[water_data{:,'X'},water_data{:,'Y'},water_data{:,'pointId'}];
DEM=[water_DEM{:,'DEM_MEAN'}];
m=length(water_nodeID);
water_nodeX=zeros(m,1);
water_nodeY=zeros(m,1);
water_dem=zeros(m,1);
for i=1:m
    lineID=find(water_data{:,'pointId'}==water_nodeID(i));
    water_nodeX(i)=temppoint(lineID(1),1);
    water_nodeY(i)=temppoint(lineID(1),2);
    water_dem(i)=DEM(i);
end
% ����һ��������洢��Щ����
water_nodes=table(water_nodeID, water_nodeX, water_nodeY,water_dem, 'VariableNames', {'nodeID', 'Longitude', 'Latitude','DEM'});



%ˮ������߳�ʼ��
ID=water_data{:,'lineID'};
cost=water_data{:,'Shape_Length'};
edge_number=unique(ID);
m=length(edge_number);
for i=1:m
    edge_point=find(ID==edge_number(i));
    linepoint=temppoint(edge_point,3);%���ÿһ���������˵Ľڵ�
    linepoint_dem=water_dem(linepoint);
    s=find(linepoint_dem==max(linepoint_dem));%��ʼ�ڵ�
    e=find(linepoint_dem==min(linepoint_dem));%�����ڵ㣬ˮ��Ӹ�DEM�������DEM��
    if (length(s)==2||isempty(s))
        water_E(i,1)=linepoint(1);
        water_E(i,2)=linepoint(2);
    else
        water_E(i,1)=linepoint(s);
        water_E(i,2)=linepoint(e);
    end
    water_E(i,3)=cost(edge_point(1));
end
 
G=digraph(water_E(:,1),water_E(:,2),water_E(:,3));%water_E(:,1)��ʼ�ڵ㣬water_E(:,2)�����ڵ㣬water_E(:,3)�ߵ�Ȩ��
G.Nodes=water_nodes;
G_water=G;