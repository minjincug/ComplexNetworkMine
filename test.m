% 
% Y=1:1:152;
% X=mine_degreeCentrality';
% stem(X,Y)
% 
% % ����X��ķ�Χ
% xlim([0, 5]); % ����X����ʾ��0��10


% ����edges��һ��N*2�ľ��󣬱�ʾ����ߣ�N�Ǳߵ�����
edges =G_water.Edges.EndNodes;

% ��ȡ�ڵ�����
numNodes = max(max(edges));

% ��ʼ�����Ⱥ����
outDegree = zeros(numNodes, 1);
inDegree = zeros(numNodes, 1);

% ������Ⱥ����
for i = 1:size(edges, 1)
    outDegree(edges(i, 1)) = outDegree(edges(i, 1)) + 1;
    inDegree(edges(i, 2)) = inDegree(edges(i, 2)) + 1;
end

% ������Ⱥ����������
outDegreeCentrality = outDegree / (N - 1);
inDegreeCentrality = inDegree / (N - 1);

% ������
disp('����:');
disp(outDegreeCentrality);
disp('���:');
disp(inDegreeCentrality);


Y=1:1:1290;
X=inDegree';
stem(X,Y)


% ����X��ķ�Χ
xlim([0, 6]); % ����X����ʾ��0��10






% �ڵ������ֵ
nodeValues = G_water.Nodes.state;

% ��������ͼ����
G = G_water;

% ����ڵ��С
minSize = 2; % ��С�ڵ��С
maxSize = 7; % ���ڵ��С
nodeSizes = minSize + (nodeValues - min(nodeValues)) / (max(nodeValues) - min(nodeValues)) * (maxSize - minSize);

% ʹ�� jet ��ɫͼ
myColormap = jet(numnodes(G));  % Ϊÿ���ڵ㴴��һ����ɫ
colorIndices = round((nodeValues - min(nodeValues)) / (max(nodeValues) - min(nodeValues)) * (numnodes(G) - 1)) + 1;
nodeColors = myColormap(colorIndices, :);

% ����ͼ
figure;
p=plot(G, 'XData', G.Nodes.Longitude, 'YData', G.Nodes.Latitude);
p.MarkerSize = nodeSizes; % ���ýڵ��С
hold on;

% Ϊÿ���ڵ�������ɫ
for i = 1:numnodes(G)
    highlight(p, i, 'NodeColor', nodeColors(i, :));
end

colorbar; % ��ʾ��ɫ�����˽�Ȩ�غ���ɫ�Ķ�Ӧ��ϵ
caxis([min(nodeValues) max(nodeValues)]);


hold off;

xlabel('Longitude');
ylabel('Latitude');
title('Directed Graph Visualization with Node Sizes and Colors Based on Attributes');
