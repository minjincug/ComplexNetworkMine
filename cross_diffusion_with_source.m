function cross_diffusion_with_source
    % ��������
    D1 = 1; % ��һ�����ʵ���ɢϵ��
    D2 = 1; % �ڶ������ʵ���ɢϵ��
    alpha = 0.01; % ������ɢ����
    S1 = 0.05; % ��һ�����ʵ�Դ��
    S2 = -0.03; % �ڶ������ʵ�Դ��

    % �ռ��ʱ������
    x = linspace(0, 10, 100);
    t = linspace(0, 20, 100);

    % ��ʼ����
    u0 = ones(length(x), 2);
    u0(:, 1) = 2*u0(:, 1); % ��ʼ��һ�����ʵķֲ�
    u0(:, 2) = 0.5*u0(:, 2); % ��ʼ�ڶ������ʵķֲ�

    % ���PDE
    sol = pdepe(0, @pdefun, @pdeic, @pdebc, x, t);
    U = sol(:,:,1);
    V = sol(:,:,2);

    % ��ͼ
    figure;
    surf(x, t, U, 'EdgeColor', 'none');
    title('��һ�����ʵ�Ũ��');
    xlabel('�ռ�');
    ylabel('ʱ��');
    zlabel('Ũ��');

    figure;
    surf(x, t, V, 'EdgeColor', 'none');
    title('�ڶ������ʵ�Ũ��');
    xlabel('�ռ�');
    ylabel('ʱ��');
    zlabel('Ũ��');

    % PDE����
    function [c,f,s] = pdefun(x, t, u, DuDx)
        c = [1; 1];
        f = [D1; D2].*DuDx + alpha*DuDx.*flip(u); % ��ӽ�����ɢ��
        s = [S1; S2]; % ���Դ��
    end

    % ��ʼ��������
    function u0 = pdeic(x)
        u0 = [2; 0.5];
    end

    % �߽���������
    function [pl, ql, pr, qr] = pdebc(xl, ul, xr, ur, t)
        pl = [0; 0];
        ql = [1; 1];
        pr = [0; 0];
        qr = [1; 1];
    end
end
