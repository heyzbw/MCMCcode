function Out = move2_death(W_init, H, T, K, G)
% 在时刻H执行轨迹消失的操作

aliveK = zeros(K, 1);
c = 1;
for k = 1:K
    for g = H - T:G % 考虑滑动窗口
        if tauexist(W_init, g, k) && W_init.track(g).tau(k).frame == 1 % 如果轨迹当前存在
            aliveK(c) = k;
            c = c + 1;
            break;
        end         
    end
end

if c == 1 % 所有轨迹都已经消失
    Out = 666;
    return;
end
kdead = aliveK(randi(c - 1));

for o = H - T:G
    if tauexist(W_init, o, kdead)
        if isfield(W_init.track(o), 'tau0') && ~isempty(W_init.track(o).tau0)
            W_init.track(o).tau0 = [W_init.track(o).tau0, W_init.track(o).tau(kdead).y]; % 添加到虚警中
        else
            W_init.track(o).tau0 = W_init.track(o).tau(kdead).y;
        end
        W_init.track(o).tau(kdead).y = []; % 从关联中移除
        W_init.track(o).tau(kdead).frame = []; % 清空关联的索引
        if ~isempty(W_init.track(o).tau(kdead).islast) % 如果是最后一次关联
            W_init.track(o).tau(kdead).islast = [];
            W_init.track(o).tau(kdead).AAA = 'mossa2'; 
            break
        end
    end
end
% 不执行 W_init.tracks = K-1;，因为K是所有已存在或存在的轨迹的数量
Out = W_init;

end
