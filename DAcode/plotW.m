function plotW(W, Y)
% 绘制多目标跟踪结果
%   W: 跟踪结果结构
%   Y: 包含所有测量数据的结构

% 创建一个新的大图形
figure('Position', [100, 100, 1000, 800]);

x = zeros(1, 1);
y = zeros(1, 1);
z = zeros(1, 1);

for t = 1:W.frame - 1
    for k = 1:W.tracks
        if tauexist(W, t, k)
            kcolor = [0.7 0.5 0.2];
            switch k
                case 1
                    kcolor = [0 0 1];
                case 2
                    kcolor = [1 0 0];
                case 3
                    kcolor = [0 1 0];
                case 4
                    kcolor = [0 1 1];
                case 5
                    kcolor = [1 0 1];
                case 6
                    kcolor = [1 0.5 0];
                case 7
                    kcolor = [0 0.5 0.5];
                case 8
                    kcolor = [0 0 0];
            end

            x(1, k, t) = Y(t).data(W.track(t).tau(k).y, 1);
            y(2, k, t) = Y(t).data(W.track(t).tau(k).y, 2);
            z(3, k, t) = Y(t).data(W.track(t).tau(k).y, 3);
            plot3(x(1, k, t), y(2, k, t), z(3, k, t), '*', 'color', kcolor);
            hold on;
            axis equal; 
            hold on;
        end
    end
end
grid on;

% 设置坐标轴字体和大小，并加粗坐标轴
xlabel('X轴', 'FontSize', 14, 'FontName', '楷体', 'FontWeight', 'bold');
ylabel('Y轴', 'FontSize', 14, 'FontName', '楷体', 'FontWeight', 'bold');
zlabel('Z轴', 'FontSize', 14, 'FontName', '楷体', 'FontWeight', 'bold');
set(gca, 'LineWidth', 1.5); % 坐标轴粗细

% 添加标题
title('多目标跟踪结果', 'FontSize', 16, 'FontName', 'SimSun', 'Color', [0.85 0.33 0.1]); % 设置标题为橙色

% 设置图例字体和大小，并将图例放在右上角，并调整图例大小
legend('轨迹1', '轨迹2', '轨迹3', '轨迹4', '轨迹5', '轨迹6', '轨迹7', '轨迹8', 'Location', 'northeast', 'FontSize', 14); % 将图例放在右上角

set(gca, 'FontSize', 16, 'FontName', 'Arial');
end
