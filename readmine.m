function [G_mine]=readmine()
data_path=strcat(pwd,'\data');
dirname = fullfile(data_path,'*.csv');
datalist = dir(dirname);

data_type='minenet';
for i=1:length(datalist)
    if regexp(datalist(i).name,data_type)
        data1=datalist(i).name;
    end
end

mine_data=readtable(data1);

data_type='landscan';
for i=1:length(datalist)
    if regexp(datalist(i).name,data_type)
        data2=datalist(i).name;
    end
end
mine_attri=readtable(data2);

%矿山网络节点初始化
% 提取节点属性

mine_nodeID=unique(mine_data{:,'point1'});
temppoint=[mine_data{:,'X'},mine_data{:,'Y'},mine_data{:,'point1'}];
Attri=[mine_attri{:,'POP_MEAN'},mine_attri{:,'PM10_MEAN'}];
m=length(mine_nodeID);
mine_nodeX=zeros(m,1);
mine_nodeY=zeros(m,1);
mine_nodePOP=zeros(m,1);
mine_nodePM10=zeros(m,1);
for i=1:m
    lineID=find(mine_data{:,'point1'}==mine_nodeID(i));
    mine_nodeX(i)=temppoint(lineID(1),1);
    mine_nodeY(i)=temppoint(lineID(1),2);
    mine_nodePOP(i)=Attri(i,1);
    mine_nodePM10(i)=Attri(i,2);
end
% 创建一个表格来存储这些属性
mine_nodes=table(mine_nodeID, mine_nodeX, mine_nodeY,mine_nodePOP,mine_nodePM10,'VariableNames', {'nodeID', 'Longitude', 'Latitude','Pop','PM10'});


%矿山网络边初始化
ID=mine_data{:,'PATHID'};
edge_number=unique(ID);
cost=zeros(length(edge_number),1);
s=zeros(length(edge_number),1);
e=zeros(length(edge_number),1);

for i=1:length(edge_number)
    index_line_point=find(ID==edge_number(i));
    s(i)=mine_data{index_line_point(1),'point1'};
    e(i)=mine_data{index_line_point(2),'point1'};
    sx=mine_data{index_line_point(1),'X'};
    sy=mine_data{index_line_point(1),'Y'};
    ex=mine_data{index_line_point(2),'X'};
    ey=mine_data{index_line_point(2),'Y'};
    cost(i)=haversine(sy,sx,ey,ex);
end
G=graph(s,e,cost);
G.Nodes=mine_nodes;
G_mine=G;
% plot(G_mine, 'XData', G_mine.Nodes.Longitude, 'YData', G_mine.Nodes.Latitude);

% cost=mine_data{:,'PATHCOST'};
% edge_number=unique(ID);
% m=length(edge_number);
% for i=1:m
%     edge_point=find(ID==edge_number(i));
%     for j=1:length(edge_point)
%         mine_E(i,j)=temppoint(edge_point(j),3);
%     end
%     mine_E(i,3)=cost(edge_point(j));
% end

% G=graph(mine_E(:,1),mine_E(:,2),mine_E(:,3));
% G.Nodes=mine_nodes;
% G_mine=G;

% for i=1:m
%     newWeight(i)=
% end

% s=G.Edges.EndNodes(:,1);
% t=G.Edges.EndNodes(:,2);
% G_mine=graph(s,t,)

