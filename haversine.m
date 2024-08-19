function distance = haversine(lat1, lon1, lat2, lon2)
    % ����γ��ת��Ϊ����
    lat1 = deg2rad(lat1);
    lon1 = deg2rad(lon1);
    lat2 = deg2rad(lat2);
    lon2 = deg2rad(lon2);
    
    % ���㾭γ�Ȳ�
    dLat = lat2 - lat1;
    dLon = lon2 - lon1;
    
    % Ӧ��Haversine��ʽ
    a = sin(dLat/2)^2 + cos(lat1) * cos(lat2) * sin(dLon/2)^2;
    c = 2 * atan2(sqrt(a), sqrt(1-a));
    R = 6371; % ����뾶�����
    
    % �������
    distance = R * c;
end

% % ʾ��������������γ�ȵ�֮��ľ���
% lat1 = 39.9042; % ����γ��
% lon1 = 116.4074; % ��������
% lat2 = 34.0522; % ��ɼ�γ��
% lon2 = -118.2437; % ��ɼ����
% 
% distance = haversine(lat1, lon1, lat2, lon2);
% fprintf('����֮��ľ����ǣ�%f����\n', distance);
