% 
% Y=1:1:152;
% X=mine_degreeCentrality';
% stem(X,Y)
% 
% % 设置X轴的范围
% xlim([0, 5]); % 设置X轴显示从0到10


% 假设edges是一个N*2的矩阵，表示有向边，N是边的数量
edges =G_water.Edges.EndNodes;

% 获取节点数量
numNodes = max(max(edges));

% 初始化出度和入度
outDegree = zeros(numNodes, 1);
inDegree = zeros(numNodes, 1);

% 计算出度和入度
for i = 1:size(edges, 1)
    outDegree(edges(i, 1)) = outDegree(edges(i, 1)) + 1;
    inDegree(edges(i, 2)) = inDegree(edges(i, 2)) + 1;
end

% 计算出度和入度中心性
outDegreeCentrality = outDegree / (N - 1);
inDegreeCentrality = inDegree / (N - 1);

% 输出结果
disp('出度:');
disp(outDegreeCentrality);
disp('入度:');
disp(inDegreeCentrality);


Y=1:1:1290;
X=inDegree';
stem(X,Y)


% 设置X轴的范围
xlim([0, 6]); % 设置X轴显示从0到10






% 节点的属性值
nodeValues = G_water.Nodes.state;

% 创建无向图对象
G = G_water;

% 计算节点大小
minSize = 2; % 最小节点大小
maxSize = 7; % 最大节点大小
nodeSizes = minSize + (nodeValues - min(nodeValues)) / (max(nodeValues) - min(nodeValues)) * (maxSize - minSize);

% 使用 jet 颜色图
myColormap = jet(numnodes(G));  % 为每个节点创建一个颜色
colorIndices = round((nodeValues - min(nodeValues)) / (max(nodeValues) - min(nodeValues)) * (numnodes(G) - 1)) + 1;
nodeColors = myColormap(colorIndices, :);

% 绘制图
figure;
p=plot(G, 'XData', G.Nodes.Longitude, 'YData', G.Nodes.Latitude);
p.MarkerSize = nodeSizes; % 设置节点大小
hold on;

% 为每个节点设置颜色
for i = 1:numnodes(G)
    highlight(p, i, 'NodeColor', nodeColors(i, :));
end

colorbar; % 显示颜色条以了解权重和颜色的对应关系
caxis([min(nodeValues) max(nodeValues)]);


hold off;

xlabel('Longitude');
ylabel('Latitude');
title('Directed Graph Visualization with Node Sizes and Colors Based on Attributes');
