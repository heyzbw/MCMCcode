function plot_pww(pww, Hfinal, Nmc)
% 联合概率值的对数随蒙特卡洛采样数的变化曲线
% 设置图形的大小
figure('Position', [100, 100, 1000, 800]);

% 绘制三维曲面，其中 t 和 n 分别作为 x 轴和 y 轴，而 pww(t, n) 的对数作为 z 轴
[X_pww, Y_pww] = meshgrid(1:Hfinal, 1:Nmc);
surf(X_pww, Y_pww, log(pww'));

% 设置坐标轴标签和标题的字体、大小和颜色
xlabel('滑动帧数', 'FontSize', 14, 'FontName', '楷体', 'FontWeight', 'bold');
ylabel('蒙特卡洛采样数', 'FontSize', 14, 'FontName', '楷体', 'FontWeight', 'bold');
zlabel('联合概率值的对数', 'FontSize', 14, 'FontName', '楷体', 'FontWeight', 'bold');
title('联合概率值的对数随蒙特卡洛采样数的变化', 'FontSize', 16, 'FontName', 'SimSun', 'Color', [0.85 0.33 0.1]);

% 设置坐标轴的粗细
set(gca, 'LineWidth', 1.5);

% 添加图例，并设置图例的字体和大小
legend('目标间联合概率值', 'Location', 'northeast', 'FontSize', 14);

% 设置坐标轴的字体和大小
set(gca, 'FontSize', 16, 'FontName', 'Arial');

% 其他可能的设置，例如坐标轴的范围和网格线
% axis equal; % 使三个坐标轴的单位长度相等
grid on; % 显示网格线
end