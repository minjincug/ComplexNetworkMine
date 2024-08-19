% 定义边的权重
weights=10*G_water.Edges.Weight;

% 创建带有权重的有向图
G = G_water;

% 定义边的起点和终点
s=G_water.Edges.EndNodes(:,1);
t=G_water.Edges.EndNodes(:,2);

% 获取边的权重，并根据权重设置边的粗细
LWidths = 5 * G.Edges.Weight / max(G.Edges.Weight);

% 计算边的颜色（例如：基于权重的灰度）
colors = repmat(weights / max(weights), 1, 1);


% 绘制图
figure;
p=plot(G, 'XData', G_water.Nodes.Longitude, 'YData', G_water.Nodes.Latitude, 'NodeColor', 'red', 'LineWidth', LWidths, 'ArrowSize', 10);

% 设置边的颜色
p.EdgeCData=colors;

% 设置坐标轴标签和标题
xlabel('Longitude');
ylabel('Latitude');
title('Directed Graph Visualization Based on Geographic Coordinates');

