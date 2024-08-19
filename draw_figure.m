% ����ߵ�Ȩ��
weights=10*G_water.Edges.Weight;

% ��������Ȩ�ص�����ͼ
G = G_water;

% ����ߵ������յ�
s=G_water.Edges.EndNodes(:,1);
t=G_water.Edges.EndNodes(:,2);

% ��ȡ�ߵ�Ȩ�أ�������Ȩ�����ñߵĴ�ϸ
LWidths = 5 * G.Edges.Weight / max(G.Edges.Weight);

% ����ߵ���ɫ�����磺����Ȩ�صĻҶȣ�
colors = repmat(weights / max(weights), 1, 1);


% ����ͼ
figure;
p=plot(G, 'XData', G_water.Nodes.Longitude, 'YData', G_water.Nodes.Latitude, 'NodeColor', 'red', 'LineWidth', LWidths, 'ArrowSize', 10);

% ���ñߵ���ɫ
p.EdgeCData=colors;

% �����������ǩ�ͱ���
xlabel('Longitude');
ylabel('Latitude');
title('Directed Graph Visualization Based on Geographic Coordinates');

