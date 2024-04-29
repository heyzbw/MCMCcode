function Out = move6_reduction(W_init, H, T, K, G)
% 执行轨迹缩减的操作

aliveK = zeros(K, 2);
c = 1;
for k = 1:K
    for g = H - T:G % 考虑滑动窗口
        if tauexist(W_init, g, k) && ~isempty(W_init.track(g).tau(k).islast) && W_init.track(g).tau(k).frame ~= 1
            aliveK(c, :) = [k, W_init.track(g).tau(k).frame];
            c = c + 1;
            break;
        end
    end
end

if c == 1 % 所有轨迹都已经消失
    Out = 666;
    return;
end
a = randi(c - 1);
k2red = aliveK(a, 1);
Nf2kred = aliveK(a, 2);

if Nf2kred == 2
    r = 2; % 在(2, Nf2kred-1)范围内随机选择r
else
    r = randi(Nf2kred - 2) + 1; % 在(2, Nf2kred-1)范围内随机选择r
end

% 第r帧之后的关联被消除
for g = H - T:G % 考虑滑动窗口
    if tauexist(W_init, g, k2red)
        if W_init.track(g).tau(k2red).frame == r
            W_init.track(g).tau(k2red).islast = 1;
        elseif W_init.track(g).tau(k2red).frame > r
            if isfield(W_init.track(g), 'tau0') && ~isempty(W_init.track(g).tau0)
                W_init.track(g).tau0 = [W_init.track(g).tau0, W_init.track(g).tau(k2red).y]; % 加入到虚警中
            else
                W_init.track(g).tau0 = W_init.track(g).tau(k2red).y;
            end
            W_init.track(g).tau(k2red).y = []; % 从关联中清空
            W_init.track(g).tau(k2red).frame = []; % 关联索引号清空
            if ~isempty(W_init.track(g).tau(k2red).islast)
                W_init.track(g).tau(k2red).islast = [];
                W_init.track(g).tau(k2red).AAA = 'mossa6'; 
                break
            end
        end
    end
end

Out = W_init;

end
