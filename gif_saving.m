% 创建一个新的大图形
figure('Position', [100, 100, 1000, 800]);

pic_num = 1;
for z = 1:pnum
    plot3(points(1,:,z), points(2,:,z), points(3,:,z), '*', 'Color', [0.2 0.4 0.6], 'MarkerSize', 8, 'LineWidth', 1); % 设置点的颜色为蓝色，大小为8，粗细为1
%     axis([-1 4 -2 2 0 4]);
    grid on;
    hold on;
    axis equal; 
    hold on;

    % 设置坐标轴字体和大小，并加粗坐标轴
    xlabel('X轴', 'FontSize', 14, 'FontName', '楷体', 'FontWeight', 'bold');
    ylabel('Y轴', 'FontSize', 14, 'FontName', '楷体', 'FontWeight', 'bold');
    zlabel('Z轴', 'FontSize', 14, 'FontName', '楷体', 'FontWeight', 'bold');
    set(gca, 'LineWidth', 1.5); % 坐标轴粗细
    
    % 添加标题
    title(['第 ', num2str(z), ' 帧'], 'FontSize', 16, 'FontName', 'SimSun', 'Color', [0.85 0.33 0.1]); % 设置标题为橙色
    
    % 设置图例字体和大小，并将图例放在右上角，并调整图例大小
    legend('数据点', 'Location', 'northeast', 'FontSize', 14); % 将图例放在右上角
    
    set(gca, 'FontSize', 16, 'FontName', 'Arial');
    
    F = getframe(gcf);
    I = frame2im(F);
    [I, map] = rgb2ind(I, 256);

    if pic_num == 1
        imwrite(I, map, 'test.gif', 'gif', 'Loopcount', inf, 'DelayTime', 0.2);
    else
        imwrite(I, map, 'test.gif', 'gif', 'WriteMode', 'append', 'DelayTime', 0.2);
    end

    pic_num = pic_num + 1;

end
