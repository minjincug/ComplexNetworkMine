clear all
close all
clc

data_path=strcat(pwd,'\data');
dirname = fullfile(data_path,'*.xlsx');
datalist = dir(dirname);
%β�������ݵĺ�������ΪԴ���ȡβ��������
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

mine_degreeCentrality=centrality(G_mine,'degree');%�����ɽ�ڵ�Ķ�
%%
%��ɽ���������ݴ���
A_mine=adjacency(G_mine,'weighted');%��ɽ��Ȩ�ڽӾ���Ȩ��ֵΪ����֮��ľ���
N_mine=size(A_mine,1);%��ɽ����ڵ�����
D_mine=diag(sum(A_mine,2)); %��ɽ����ĶȾ��� 
L_mine=D_mine-A_mine;%������˹���������ɢ��

D_PM=0.01;%PM10������ɢϵ��
D_Pop=0.01;%�˿��ܶȵĽ�����ɢϵ��

%�����ɽ��������ɢ��Դ��
S=zeros(N_mine,1);
m=size(source_mine,1);
for i=1:m
    S(source_mine(i,13))=source_mine(i,2);
end
%δ����Ⱦ����Ȼˮ�峣ѹ���ܽ���ԼΪ9.17mg/l
S=S/9.17;
%%
%ˮ�����������ݴ���
G_water_simply=simplify(G_water);%ɾ����·
A_water=111*adjacency(G_water_simply,'weighted'); %�����Ȩ�ڽӾ���,����111��ʾ���ߵ�Ȩ��ֵ�Ӷ�ת��Ϊ����
N_water=size(A_water,1);%ˮ������ڵ�����

D_water=6.48;%ˮ����Զ���ɢϵ���������ܽ����ķ�����ɢϵ��Ϊ1.8*10^-9m^2/s;ת��Ϊ6.48km^2/h
v_water=3.6*ones(N_water,1);%ˮ��������ٶ���,ˮ������Ϊ1m/s,���ں��������km����ת��Ϊ3.6km/h


%����Ⱦ���
outdegree=sum(G_water_simply.adjacency,2);%����ÿ���ڵ�ĳ���Ȩ��֮��
Dwater=diag(outdegree);%�����Ⱦ���
%�����Ȩ������˹����
L_water=Dwater-A_water;

source_water=zeros(N_water,1);
water_point=G_water.Edges.EndNodes;




%%
%��������ɢ�Ķ�����ϵ��
%%���������ϵ��������ɢ���ٶȣ�������̬����ֵ�Ĺ�һ��֮��
%��1��ȥ��ǰ��̬����ֵ����Ϊ��̬����ֵԽ�󣬶���Խ���ѣ���ɢԽ����
x=log(InterEdges(:,3));
v_temp=1-rescale(x,0,1);
v=zeros(N_mine,1);%�����ٶȣ�ÿ���ڵ��Ӧһ��ֵ
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
%�����ɢ
diffusion_mine=zeros(N_mine,1);
convection_mine=zeros(N_mine,1);
convection_water=zeros(N_water,1);
state_mine=zeros(numSteps,N_mine);
state_water=zeros(numSteps,N_water);
self_clean=0.01;%ˮ����Ծ�����
for t=1:numSteps   
    
    %�����ɽ���������ɢ
    diffusion_mine=D_PM*L_mine*u_mine+D_Pop*L_mine*u_pop;
    convection_mine=v.*u_mine;
    u_mine=u_mine+dt*(diffusion_mine-convection_mine+S);
    u_mine(u_mine<0)=0;
    state_mine(t,:)=u_mine;
    
    %����ˮ������ɢ  
    %�Ȼ�ôӿ�ɽ�㴫����������,����ˮ����Ⱦ��Դ��
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
