function points = points_define()
% 创建多维数据集_自定义:

% 顶点 a b c d e f g h
% 定义三维空间中的8个顶点的坐标
p3d = [ 0 1 1 0 0 1 1 0 ;   % x 坐标
        0 0 0 0 1 1 1 1 ;   % y 坐标
        0 0 1 1 1 1 0 0 ];  % z 坐标

% 定义沿z轴的步进
passoz = 0.03;
% 定义沿x轴的步进
passox = 0.02;
% 定义绕z轴旋转的角度（弧度制）
degz = pi * 2 / 100;

% 初始化点的坐标
points = p3d;

% 进行100次迭代
for z = 1:100
    % 创建绕z轴旋转的旋转矩阵
    R = rotaz(0, 0, z * degz);
    % 创建平移向量
    T = [z * passox, 0, z * passoz]';
    % 创建齐次变换矩阵
    pt_trasl = [R, T; [0, 0, 0, 1]] * [p3d; ones(1, 8)];
    % 应用变换并存储结果
    points(:,:,z) = pt_trasl(1:3,:);
end

end
