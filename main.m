clear;
clc;

points = points_define();
% points = points_random();
[~,~,pnum] = size(points);

%% 马尔可夫数据关联初始化
 
% 初始化参数
global Ts sigmaW sigmaV P0 A C Q R Y pd pz Tmax nt L_Birth L_False Nmc Hfinal d_bar v_bar
Ts = 1; 
Y = [];
sigmaW = 0.0002; % 系统噪声方差
sigmaV = 0.0001; % 测量噪声方差
P0 = 1000*eye(6); % 初始协方差矩阵

L_Birth = 0.000001; % 新目标出生概率
L_False = 0.00001; % 假报警概率

Nmc = 30; % 蒙特卡洛样本数

Hfinal = 97; % 滑动窗口大小

Tmax = 10; % 最大轨迹长度

A = [1 Ts 0 0 0 0;
     0 1 0 0 0 0;
     0 0 1 Ts 0 0;
     0 0 0 1 0 0;
     0 0 0 0 1 Ts;
     0 0 0 0 0 1];

C = [1 0 0 0 0 0;
     0 0 1 0 0 0;
     0 0 0 0 1 0];

Q = sigmaW * eye(6); % 系统噪声协方差矩阵
R = sigmaV * eye(3); % 测量噪声协方差矩阵

pd = 0.99; % 目标检测概率
pz = 0.01; % 虚假报警概率

d_bar = 1; % 数据关联窗口大小
v_bar = 0.15; % 最大目标运动速度

% 读取目标运动轨迹数据
for n = 1:pnum
   Y(n).data = points(:,:,n)';
end

numyyy = size(Y);
[Ny ~] = size(Y(1).data);

% 初始化权重
wt = struct();
W = struct('track', wt, 'frame', 1, 'tracks', 0);
for t = 1:Hfinal+2
   for k = 1:Ny^2
      if t == 1 && k <= 8 
         W.track(1).tau(k).y = k;
         W.track(1).tau(k).frame = 1;
         W.track(1).tau(k).islast = 1;
         W.track(1).tau0 = [];
      else
         W.track(t).tau0 = [];
      end
   end
end
W.frame = 2;
W.tracks = Ny;

% 获取每帧目标数量
for h = 1:Hfinal
   [nt(h), ~] = size(Y(h).data);
end

% 初始化权重
W.tracks = Ny;

% 初始化混淆矩阵
confusion_matrix = zeros(2, 2);

%% 开始多目标跟踪数据关联
acc = zeros(Hfinal, Nmc);
pww = zeros(Hfinal, Nmc);
% 创建一个进度条
h = waitbar(0, '正在进行计算...');

tic;
for t = 1:Hfinal
   W_init = W;
   W_W = W_init;
   W_hat = W_init;
   for n = 1:Nmc
      % 根据 W_prev 提出 W_prop
      W_primo = proposal_distribution(W_hat);
      U = rand;
      pww(t, n) = PW_Y(W_W);
      pwp = PW_Y(W_primo);
      acc(t, n) = acceptancePw(pww(t, n), pwp);
    
      if U < acc(t, n)  % 如果在接受属性之下
          W_W = W_primo;
          pww(t, n) = PW_Y(W_W);
%           disp('ACCEPT');
      end    

      pwh = PW_Y(W_hat);
      if pww(t, n) > pwh % 如果 W_W 概率大于 W_hat
          W_hat = W_W;
%           disp('PASSPROB');
      end 
  end

  W_hat.frame = W_hat.frame + 1; % 这是因为正在提议W直到当前Y（时刻H）
  W = W_hat;
  % 更新进度条
  waitbar(t / Hfinal, h, sprintf('进度: %d%%', round(t / Hfinal * 100)));
end

elapsed_time = toc;
fprintf('计算完成，总耗时 %.2f 秒。\n', elapsed_time);


%% 求F1，正确（TP）、误检（FP）、漏检（FN）
[TP, FP, FN] = compare_point_sets(points, W, Y);

% 计算精确率
precision = TP / (TP + FP);
% 计算召回率
recall = TP / (TP + FN);
% 计算 F1 分数
F1 = 2 * (precision * recall) / (precision + recall);

% 输出 F1 分数
disp(F1);

%% 绘制关联实验结果图
plotW(W, Y);

%% 绘制联合概率值的对数随蒙特卡洛采样数的变化曲线
plot_pww(pww, Hfinal, Nmc);

