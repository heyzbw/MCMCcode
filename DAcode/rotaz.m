function [ R ] = rotaz( a, b, c )
%ROTAZ 旋转矩阵生成
%   根据给定的旋转角度a、b、c，生成绕三个坐标轴之一的旋转矩阵。

    % 绕X轴的旋转矩阵
    rx = [1 0 0; 0 cos(a) -sin(a); 0 sin(a) cos(a)];
    
    % 绕Y轴的旋转矩阵
    ry = [cos(b) 0 sin(b); 0 1 0; -sin(b) 0 cos(b)];
    
    % 绕Z轴的旋转矩阵
    rz = [cos(c) -sin(c) 0; sin(c) cos(c) 0; 0 0 1];

    % 将三个旋转矩阵按照 ZYX 顺序相乘得到总的旋转矩阵
    R = rz * ry * rx;
end
