clear all
close all
clc

data_path=strcat(pwd,'\data');
dirname = fullfile(data_path,'*.xlsx');
datalist = dir(dirname);
%尾矿监测数据的含氧量作为源项，读取尾矿监测数据
data_type='2021';
for i=1:length(datalist)
    if regexp(datalist(i).name,data_type)
        S_data=datalist(i).name;
    end
end
source_mine=xlsread(S_data);


G_mine=readmine();
nodes_mine=G_mine.Nodes;
G_water=readwater();
nodes_water=G_water.Nodes;
InterEdges=readlink();

multiLayerNetwork=struct();
multiLayerNetwork.Layer1=G_mine;
multiLayerNetwork.Layer2=G_water;
multiLayerNetwork.InterLayerEdges=InterEdges;

mine_degreeCentrality=centrality(G_mine,'degree');%计算矿山节点的度
%%
%矿山网络中数据处理
A_mine=adjacency(G_mine,'weighted');%矿山加权邻接矩阵，权重值为两点之间的距离
N_mine=size(A_mine,1);%矿山网络节点数量
D_mine=diag(sum(A_mine,2)); %矿山网络的度矩阵 
L_mine=D_mine-A_mine;%拉普拉斯矩阵代表扩散项

D_PM=0.01;%PM10的自扩散系数
D_Pop=0.01;%人口密度的交叉扩散系数

%计算矿山网络中扩散的源项
S=zeros(N_mine,1);
m=size(source_mine,1);
for i=1:m
    S(source_mine(i,13))=source_mine(i,2);
end
%未受污染的自然水体常压下溶解氧约为9.17mg/l
S=S/9.17;
%%
%水体网络中数据处理
G_water_simply=simplify(G_water);%删除环路
A_water=111*adjacency(G_water_simply,'weighted'); %计算加权邻接矩阵,乘以111表示将边的权重值从度转换为公里
N_water=size(A_water,1);%水体网络节点数量

D_water=6.48;%水体的自动扩散系数，根据溶解氧的分子扩散系数为1.8*10^-9m^2/s;转化为6.48km^2/h
v_water=3.6*ones(N_water,1);%水体的移流速度项,水体流速为1m/s,由于后面距离是km，故转化为3.6km/h


%计算度矩阵
outdegree=sum(G_water_simply.adjacency,2);%计算每个节点的出度权重之和
Dwater=diag(outdegree);%构建度矩阵
%计算加权拉普拉斯矩阵
L_water=Dwater-A_water;

source_water=zeros(N_water,1);
water_point=G_water.Edges.EndNodes;




%%
%计算层间扩散的对流项系数
%%计算对流项系数（即扩散的速度），即生态阻力值的归一化之后，
%用1减去当前生态阻力值，因为生态阻力值越大，对流越困难，扩散越慢；
x=log(InterEdges(:,3));
v_temp=1-rescale(x,0,1);
v=zeros(N_mine,1);%对流速度，每个节点对应一个值
for i=1:length(v)
    N_temp=find(InterEdges(:,2)==i);
    if(size(N_temp,1)>1)
        v(i)=min(v_temp(N_temp));
    else
        if(size(N_temp,1)==1)
            v(i)=v_temp(N_temp);
        end
    end
end
%%
u_mine=G_mine.Nodes.PM10;
log_mine=log(u_mine);
minlog=min(log_mine);
maxlog=max(log_mine);
u_mine=(log_mine-minlog)/(maxlog-minlog);

u_pop=G_mine.Nodes.Pop;
log_pop=log(u_pop);
minlog=min(log_pop);
maxlog=max(log_pop);
u_pop=(log_pop-minlog)/(maxlog-minlog);

u_water=zeros(N_water,1);
dt=0.04;
T=1;
numSteps=T/dt;
%层间扩散
diffusion_mine=zeros(N_mine,1);
convection_mine=zeros(N_mine,1);
convection_water=zeros(N_water,1);
state_mine=zeros(numSteps,N_mine);
state_water=zeros(numSteps,N_water);
self_clean=0.01;%水体的自净能力
for t=1:numSteps   
    
    %计算矿山网络层间的扩散
    diffusion_mine=D_PM*L_mine*u_mine+D_Pop*L_mine*u_pop;
    convection_mine=v.*u_mine;
    u_mine=u_mine+dt*(diffusion_mine-convection_mine+S);
    u_mine(u_mine<0)=0;
    state_mine(t,:)=u_mine;
    
    %计算水体层的扩散  
    %先获得从矿山层传上来的数据,看着水体污染的源项
    for i=1:length(InterEdges(:,1))
        source_water(InterEdges(i,1))=u_mine(InterEdges(i,2));
    end  
    source_water(source_water<0)=0;

    du=D_water*L_water*u_water;
    u_water=u_water+dt*(du+source_water-v_water.*u_water-self_clean*u_water);
    u_water(u_water<0)=0;
    state_water(t,:)=u_water;
end
G_water.Nodes.state=u_water;
G_mine.Nodes.state=u_mine;
