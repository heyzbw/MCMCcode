function [ prob ] = PW_Y( W )
% PW_Y( W ): P(w|Y)
% 计算给定所有历史量测Y条件下满足条件的关联w的概率
% 量测Y和概率Pz,Pd,L_Birth和L_False为脚本内可见的全局变量

global C Y pz pd L_Birth L_False Tmax randomw

% W=struct('track', A, 'frame', H-1, 'tracks', K)
% A = [w1 ,..., w{H-1}] 每一帧关联结构的矩阵
% K 是已存在或当前存在的所有轨迹数
%
% w1 将每个测量关联到一个目标
%
% wt = struct('tau0', false_alarms, 'tau1', 1st_track, ..., 'frame', Hw)
%
% wt.tau0 = [ a1, .., aU] 包含U个与 (..., Y(t).data(ai,:) ,... ) 相关的虚假警报
%
% wt.taui = struct('y', bi,'frame', n, 'islast', []) 第n帧中，目标i与Y(t).data(bi,:)相关，
% islast 是一个布尔值，如果是目标i的最后一个测量，则为1，否则为空字段
% W.track(t).(tau(i)).y 是与第t帧中的目标i相关的测量bi的索引
% 假设在单个时刻中每个目标只有一个可能的测量（目标非重叠的假设）
% 一个新的轨迹可能在不出现的时刻没有关联字段，
% 或者在某一时刻被删除

%  W.track(t).(tau(i)).y  >>>>>  Y(t).data(W.track(t).(tau(i)).y,:)=[x y z]
product_tracks = 1;
%% 轨迹测量和预测

Ntracks = W.tracks;
% 精确的总时刻数H
G=W.frame; % G = H-1 
H=G+1;
        
% 滑动窗口，随着G增加至最大值Tmax
if H<=Tmax
   T=G;
else
   T=Tmax;
end
    
for i = 1:Ntracks
   %% 初始化
   % i = 轨迹索引
   start_i=0;
   end_i=0;

   measure = zeros(H,3);  % 预先分配的测量矩阵
   Tau = zeros(G,1);      % 预先分配的Tau索引向量



   %% 从结构体W中提取第i条轨迹的索引
   for cont=H-T:G          

      if ~tauexist(W,cont,i) % emptyW( W, cont, i )            
         Tau(cont) = NaN;
      else
         if start_i == 0
            % 提取轨迹i的起始索引
            % 开始保持Tau(cont)~=NaN
            start_i = cont;
         end

         Tau(cont) = W.track(cont).tau(i).y; 
         end_i=cont;   % 提取轨迹i的终止索引:
         % 最后保持Tau(cont)~=NaN
      end

   end

   % 轨迹长度
   len_taui = end_i -start_i + 1;

   %% 提取和第i条轨迹相关的所有测量
   for cont=H-T:G   % H当前时刻
      if ~isempty(randomw)
         if isnan(Tau(cont))  || (~isnan(Tau(cont)) && length(Y(cont).data) > Tau(cont))
            y=[NaN NaN NaN];  % 未检测到
         else
            y = Y(cont).data(Tau(cont) , :);
         end

         measure(cont,:) = y;
      else
         if isnan(Tau(cont))
            y=[NaN NaN NaN];  % 未检测到标记
         else
            y = Y(cont).data(Tau(cont) , :);
         end

         measure(cont,:) = y;
      end


   end

   %% 使用卡尔曼滤波计算每个时刻的预测值
   [ xhat, P ] = kalman( measure, start_i, end_i );
   yhat = C * xhat;

   %% Product N1
   product_instants = 1;
   for cont=2:len_taui % 
      % 第一次迭代中cont=2因为cont=1时新的轨迹起始给新的标签 and the
      % 在cont=1时的目标属于新轨迹的概率为1

      % 高斯多变量评估
      if ~isnan(measure(cont,1)')
         B = C * P(:,:,cont) * C';

         x = measure(cont,:)';        
         %             factor = 1/(sqrt((2*pi)^3 * det(B))) * exp(-0.5* (x-yhat(:,cont))'...
         %                 *  (eye(3)/B) * (x-yhat(:,cont))   );

         % 使用多元正态分布密度函数计算因子
         % factor = mvncdf(x + 0.1, yhat(:, cont), B) - mvncdf(x - 0.1, yhat(:, cont), B);
         % 或者直接使用密度函数
         % factor = mvncdf(x, yhat(:, cont), B);
         factor = mvnpdf(x, yhat(:, cont), B);

         % 将每个时刻的因子相乘得到 product_instants
         product_instants = product_instants * factor; 
      end
   end

   product_tracks = product_tracks * product_instants;

end

%% 环境概率         

Et = 0;
product_env = 1;

% 循环遍历时间窗口内的时刻
for cont = H - T + 1:H
    % 获取当前时刻的观测数据大小
    [Nt, ~] = size(Y(cont).data);  %  # of observations

    Zt = 0; %  终止的轨迹数目
    At = 0; %  新的轨迹数目
    Dt = 0; %  检测到的轨迹数目
    Ct = 0;

    % 遍历每一条轨迹
    for i = 1:Ntracks
        % 如果当前轨迹在当前时刻被检测到，增加检测到的轨迹数目
        if tauexist(W, cont, i)
            Dt = Dt + 1;
        end  

        % 如果轨迹在前一时刻存在，但在当前时刻不存在，说明轨迹终止，增加终止轨迹数目
        if ~tauexist(W, cont, i) && tauexist(W, cont - 1, i)
            Ct = Ct + 1;
        end

        % 如果轨迹在当前时刻存在，但是是第一次出现，说明是新的轨迹，增加新的轨迹数目
        if tauexist(W, cont, i) && W.track(cont).tau(i).frame == 1
            At = At + 1;
        end

        % 如果轨迹在当前时刻存在，且是最后一次出现，说明轨迹终止，增加终止轨迹数目
        if tauexist(W, cont, i) && ~isempty(W.track(cont).tau(i).islast)
            Zt = Zt + 1;
        end
    end   

    % 计算当前时刻的 birth 概率 L_B
    if cont == 1
        L_B = 1;
    else
        L_B = L_Birth;
    end
    
    % 计算当前时刻的 false alarm 数目 Ft
    Ft = length(find(~isnan(W.track(cont).tau0))); % Nt - Dt;

    % 计算未检测到的轨迹数目 Ut
    if Et - Zt + At - Dt > 0
        Ut = Et - Zt + At - Dt;
    else
        Ut = 0;
    end

    % 计算环境概率的部分并乘到 product_env 中
    product_env = product_env * pz^Zt * (1 - pz)^Ct * pd^Dt * (1 - pd)^Ut * L_B^At * L_False^Ft;

    % 更新当前时刻的 Marker 数目 Et
    Et = Nt - Ft;
end

% 计算整体概率，包括环境概率和轨迹概率
prob = product_env * product_tracks;

end

