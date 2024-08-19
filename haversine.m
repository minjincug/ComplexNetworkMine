function distance = haversine(lat1, lon1, lat2, lon2)
    % 将经纬度转换为弧度
    lat1 = deg2rad(lat1);
    lon1 = deg2rad(lon1);
    lat2 = deg2rad(lat2);
    lon2 = deg2rad(lon2);
    
    % 计算经纬度差
    dLat = lat2 - lat1;
    dLon = lon2 - lon1;
    
    % 应用Haversine公式
    a = sin(dLat/2)^2 + cos(lat1) * cos(lat2) * sin(dLon/2)^2;
    c = 2 * atan2(sqrt(a), sqrt(1-a));
    R = 6371; % 地球半径（公里）
    
    % 计算距离
    distance = R * c;
end

% % 示例：计算两个经纬度点之间的距离
% lat1 = 39.9042; % 北京纬度
% lon1 = 116.4074; % 北京经度
% lat2 = 34.0522; % 洛杉矶纬度
% lon2 = -118.2437; % 洛杉矶经度
% 
% distance = haversine(lat1, lon1, lat2, lon2);
% fprintf('两点之间的距离是：%f公里\n', distance);
