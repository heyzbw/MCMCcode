function Out = move7_track_update(W_init, H, T, K, G, v_bar, d_bar)
% 执行轨迹更新的操作

global pz
aliveK = zeros(K, 2);
c = 1;
for k = 1:K
    for g = H - T:G % 考虑滑动窗口
        if tauexist(W_init, g, k) && ~isempty(W_init.track(g).tau(k).islast) % 如果航迹存在并且处于最后时刻
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
k2tu = aliveK(a, 1);
Nk2tu = aliveK(a, 2);

r = randi(Nk2tu);
tfk2tu = [];

% 删除从第r帧开始的关联
for g = H - T:G % 考虑滑动窗口
    if tauexist(W_init, g, k2tu)
        if W_init.track(g).tau(k2tu).frame == r
            tfk2tu = g; % 传递给后续的birth
        elseif W_init.track(g).tau(k2tu).frame > r
            if isfield(W_init.track(g), 'tau0') && ~isempty(W_init.track(g).tau0)
                W_init.track(g).tau0 = [W_init.track(g).tau0, W_init.track(g).tau(k2tu).y]; % 加入到虚警中
            else
                W_init.track(g).tau0 = W_init.track(g).tau(k2tu).y;
            end
            W_init.track(g).tau(k2tu).y = []; % 从关联中清空
            W_init.track(g).tau(k2tu).frame = []; % 关联索引号清空
            if ~isempty(W_init.track(g).tau(k2tu).islast)
                W_init.track(g).tau(k2tu).islast = [];
                W_init.track(g).tau(k2tu).AAA = 'mossa7'; %%%%%%%%%%%%
                break;
            end
        end
    end
end

% 现在将其视为一次birth move
Out = move1_birth(W_init, H, T, K, d_bar, v_bar, pz, k2tu, tfk2tu, r);

end
