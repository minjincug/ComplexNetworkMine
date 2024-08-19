% % ʾ���ڽӾ�������ͼ��
% A = [0 1 0; 1 0 1; 0 1 0];

% �ڵ������ֵ
% nodeValues = [1, 3, 2];
nodeValues = G_mine.Nodes.PM10;

% ��������ͼ����
% G = graph(A);
G = G_mine;

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
title('Undirected Graph Visualization with Node Sizes and Colors Based on Attributes');
