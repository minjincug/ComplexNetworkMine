function cross_diffusion_with_source
    % 参数设置
    D1 = 1; % 第一种物质的扩散系数
    D2 = 1; % 第二种物质的扩散系数
    alpha = 0.01; % 交叉扩散参数
    S1 = 0.05; % 第一种物质的源项
    S2 = -0.03; % 第二种物质的源项

    % 空间和时间网格
    x = linspace(0, 10, 100);
    t = linspace(0, 20, 100);

    % 初始条件
    u0 = ones(length(x), 2);
    u0(:, 1) = 2*u0(:, 1); % 初始第一种物质的分布
    u0(:, 2) = 0.5*u0(:, 2); % 初始第二种物质的分布

    % 求解PDE
    sol = pdepe(0, @pdefun, @pdeic, @pdebc, x, t);
    U = sol(:,:,1);
    V = sol(:,:,2);

    % 绘图
    figure;
    surf(x, t, U, 'EdgeColor', 'none');
    title('第一种物质的浓度');
    xlabel('空间');
    ylabel('时间');
    zlabel('浓度');

    figure;
    surf(x, t, V, 'EdgeColor', 'none');
    title('第二种物质的浓度');
    xlabel('空间');
    ylabel('时间');
    zlabel('浓度');

    % PDE函数
    function [c,f,s] = pdefun(x, t, u, DuDx)
        c = [1; 1];
        f = [D1; D2].*DuDx + alpha*DuDx.*flip(u); % 添加交叉扩散项
        s = [S1; S2]; % 添加源项
    end

    % 初始条件函数
    function u0 = pdeic(x)
        u0 = [2; 0.5];
    end

    % 边界条件函数
    function [pl, ql, pr, qr] = pdebc(xl, ul, xr, ur, t)
        pl = [0; 0];
        ql = [1; 1];
        pr = [0; 0];
        qr = [1; 1];
    end
end
