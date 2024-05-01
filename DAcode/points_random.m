function points = points_random()
% 创建多维数据集_随机:

% 设置移动速度
speed = 0.02;
% 设置时间步数
Nt = 100;
% 设置点的数量
Np = 8;

% 初始化一个全零的3xNp矩阵，用于存储第Nt个时间步的点的位置
points(:,:,Nt) = zeros(3, Np);
% 随机生成一个3xNp的矩阵，每个元素都是(0,1)之间的随机数，代表点的初始位置
points(:,:,1) = rand(3, Np) / 1;

% 从第二个时间步开始迭代
% 点扩散过程
for cont = 2:Nt
    % 随机决定每个点在三个方向上的移动是正方向、负方向还是保持不变
    % randi(3, 3,Np)生成的是(1,3)之间的随机整数，减去2后得到-1, 0, 1
    passo = randi(5, 3, Np) - 3;

    points(:,:,cont-1) = points(:,:,cont-1) + points(:,:,cont-1) / 240;
    
    % 更新点的位置，根据随机步长和速度
    points(:,:,cont) = points(:,:,cont-1) + passo * speed;
end

% 点收缩过程
for cont = (Nt/2 + 1) :Nt
    % 随机决定每个点在三个方向上的移动是正方向、负方向还是保持不变
    % randi(3, 3,Np)生成的是(1,3)之间的随机整数，减去2后得到-1, 0, 1
    passo = randi(5, 3, Np) - 3;

    points(:,:,cont-1) = points(:,:,cont-1) - points(:,:,cont-1) / 200;
    
    % 更新点的位置，根据随机步长和速度
    points(:,:,cont) = points(:,:,cont-1) + passo * speed * 1.2;
end

end
