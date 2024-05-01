function Out = move3_split(W_init, H, T, K, G)
% 在时刻H执行轨迹拆分的操作

% 选择具有超过4个帧的轨迹   重新使用taui的帧字段进行
longtaus = zeros(K, G);
for k = 1:K
    for g = H - T:G % 考虑滑动窗口
        if tauexist(W_init, g, k) 
            longtaus(k, g) = 1;
        end
    end
end

Ltau = find(sum(longtaus, 2) >= 4); % 返回满足长度条件的轨迹
if isempty(Ltau)
    Out = 666;
    return; % 如果至少有4个帧中没有轨迹存在，拒绝该变动
end

s = Ltau(randi(length(Ltau))); % 从中选择一条轨迹，tau_s
Ts = find(longtaus(s, :) == 1); % tau_s的所有有效时刻
line = length(Ts); % tau_s出现的时刻数
r = randi(line); % tr=Ts(r); % 在有效时刻中随机选择一个中间时刻的索引
while r == 1 || r == line || r == line - 1  % tr==Ts(1) || tr==Ts(line) || tr==Ts(line-1) || tr==Ts(line-2) % 中间时刻必须在帧[2,...,abs(taui)-2]中，否则重新选择
    r = randi(line); % tr=Ts(r);
end

% 轨迹s保留从第1到第r帧
W_init.track(Ts(r)).tau(s).islast = 1;

for o = r + 1:line 
    W_init.track(Ts(o)).tau(K + 1).y = W_init.track(Ts(o)).tau(s).y;  % track2 = 从中间到结束的轨迹
    W_init.track(Ts(o)).tau(K + 1).frame = o - r; % 告诉tauK1的第o-r个观测对应的帧数
    W_init.track(Ts(o)).tau(s).y = []; % 从关联中移除
    W_init.track(Ts(o)).tau(s).frame = []; 
end      
W_init.track(Ts(line)).tau(K + 1).islast = 1;
W_init.track(Ts(line)).tau(s).islast = [];
W_init.track(Ts(line)).tau(K + 1).AAA = 'mossa3'; 
W_init.tracks = K + 1; % 现在总共有K+1条已经存在或者存在的轨迹

Out = W_init;

end
