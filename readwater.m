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



%水体网络节点初始化
% 提取节点属性

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
% 创建一个表格来存储这些属性
water_nodes=table(water_nodeID, water_nodeX, water_nodeY,water_dem, 'VariableNames', {'nodeID', 'Longitude', 'Latitude','DEM'});



%水体网络边初始化
ID=water_data{:,'lineID'};
cost=water_data{:,'Shape_Length'};
edge_number=unique(ID);
m=length(edge_number);
for i=1:m
    edge_point=find(ID==edge_number(i));
    linepoint=temppoint(edge_point,3);%获得每一条连边两端的节点
    linepoint_dem=water_dem(linepoint);
    s=find(linepoint_dem==max(linepoint_dem));%开始节点
    e=find(linepoint_dem==min(linepoint_dem));%结束节点，水体从高DEM处流向低DEM处
    if (length(s)==2||isempty(s))
        water_E(i,1)=linepoint(1);
        water_E(i,2)=linepoint(2);
    else
        water_E(i,1)=linepoint(s);
        water_E(i,2)=linepoint(e);
    end
    water_E(i,3)=cost(edge_point(1));
end
 
G=digraph(water_E(:,1),water_E(:,2),water_E(:,3));%water_E(:,1)开始节点，water_E(:,2)结束节点，water_E(:,3)边的权重
G.Nodes=water_nodes;
G_water=G;