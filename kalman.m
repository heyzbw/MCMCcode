function [xhat, Pout] = kalman(y, start_i, end_i)
% KALMAN( Y, start_i, end_i ) 
% 计算每个时刻从start_i到end_i的目标状态的预测和方差

global P0 A C Q R
% 所有变量都设置为全局变量

% 定义状态转移矩阵 A、测量矩阵 C、过程噪声协方差矩阵 Q、测量噪声协方差矩阵 R
% P0、A、C、Q、R 可以在函数外进行初始化

% [n, ~] = size(y);
n = end_i - start_i + 1;

xhat = zeros(6, n);
P = P0;
Pout = P0;

for cont = 1:n
    if ~isnan(y(cont, 1))
        % 更新步骤
        K = P * ((C') / (C * P * C' + R));
        xhat(:, cont) = xhat(:, cont) + K * (y(cont, :)' - C * xhat(:, cont));
        P = P - K * C * P;
    end
    
    % 预测步骤
    xhat(:, cont + 1) = A * xhat(:, cont);
    P = A * P * A' + Q;
    
    Pout(:, :, cont) = P;
end

end
