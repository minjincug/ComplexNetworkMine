% % 示例邻接矩阵（无向图）
% A = [0 1 0; 1 0 1; 0 1 0];

% 节点的属性值
% nodeValues = [1, 3, 2];
nodeValues = G_mine.Nodes.PM10;

% 创建无向图对象
% G = graph(A);
G = G_mine;

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
title('Undirected Graph Visualization with Node Sizes and Colors Based on Attributes');
