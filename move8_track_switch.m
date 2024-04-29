function Out = move8_track_switch(W_init, H, T, K, G, d_bar, v_bar)
% 执行轨迹切换的操作

global Y % 从第1帧到第H帧（当前）

neartaupairs = zeros(K * K, 4); % 可能的轨迹切换对数，但对于太多的标记物，这是昂贵的，因此我们设置为K * K的可能性
c = 1; % 如果计数器向矩阵添加行

% 时间顺序：[ t_{p} <--> t_{q} ]  >-->  [ t_{p+1} <--> t_{q+1} ]
for k1 = 1:K
    for g = H - T:G % t_{p}，考虑到滑动窗口
        if tauexist(W_init, g, k1) && isempty(W_init.track(g).tau(k1).islast) % 如果是k1的瞬时时刻，而不是最后时刻
            n1 = W_init.track(g).tau(k1).frame;
            for g1 = g + 1:G % t_{p+1}
                if tauexist(W_init, g1, k1) && W_init.track(g1).tau(k1).frame == n1 + 1 % 寻找下一个瞬时时刻
                    for k2 = 1:K
                        for h = g1 + 1:G % t_{q}，0 < h-g1
                            if tauexist(W_init, h, k2) && isempty(W_init.track(h).tau(k2).islast) % 如果是k2的瞬时时刻，而不是最后时刻
                                if h - g1 <= d_bar % 0 < h-g1 <= d_bar
                                    if pdist([Y(h).data(W_init.track(h).tau(k2).y, :); Y(g1).data(W_init.track(g1).tau(k1).y, :)]) <= (h - g1) * v_bar % 如果tauK1(t_{p+1})属于L_{t_{p+1}-t_{q}}(tauK2(t_{q}))，距离关联树
                                        n2 = W_init.track(h).tau(k2).frame;
                                        if g + 1 <= G
                                            for h1 = g + 1:G % t_{q+1}
                                                if tauexist(W_init, h1, k2)
                                                    if W_init.track(h1).tau(k2).frame == n2 + 1 % 寻找下一个瞬时时刻
                                                        if h1 - g <= d_bar
                                                            if pdist([Y(h1).data(W_init.track(h1).tau(k2).y, :); Y(g).data(W_init.track(g).tau(k1).y, :)]) <= (h1 - g) * v_bar % 如果tauK2(t_{q+1})属于L_{t_{q+1}-t_{p}}(tauK1(t_{p}))，距离关联树
                                                                neartaupairs(c, :) = [k1, g1, k2, h1]; % 我们需要的是后续时刻
                                                                c = c + 1;
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

if c == 1
    Out = 666;
    return % 如果没有可能的轨迹切换对，拒绝该移动
end

q = neartaupairs(randi(c - 1), :);

K1 = q(1);
tp1 = q(2);
n1 = W_init.track(tp1).tau(K1).frame;
b1 = 1; % n1之后的帧数的索引

K2 = q(3);
tq1 = q(4);
n2 = W_init.track(tq1).tau(K2).frame;
b2 = 1; % n2之后的帧数的索引

last1OR2 = 0;
for o = min(tp1, tq1):G
    if tauexist(W_init, o, K1) && tauexist(W_init, o, K2)
        SWAP = W_init.track(o).tau(K2).y;
        W_init.track(o).tau(K2).y = W_init.track(o).tau(K1).y; % 轨迹K1变成轨迹K2
        W_init.track(o).tau(K2).frame = n2 + b2;
        b2 = b2 + 1;
        W_init.track(o).tau(K1).y = SWAP; % 轨迹K2变成轨迹K1
        W_init.track(o).tau(K2).frame = n1 + b1;
        b1 = b1 + 1;
    elseif tauexist(W_init, o, K1)
        W_init.track(o).tau(K2).y = W_init.track(o).tau(K1).y; % 轨迹K1变成轨迹K2
        W_init.track(o).tau(K2).frame = n2 + b2;
        b2 = b2 + 1;
        W_init.track(o).tau(K1).y = []; % 清空K1
        W_init.track(o).tau(K1).frame = [];
    elseif tauexist(W_init, o, K2)
        W_init.track(o).tau(K1).y = W_init.track(o).tau(K2).y; % 轨迹K2变成轨迹K1
        W_init.track(o).tau(K1).frame = n1 + b1;
        b1 = b1 + 1;
        W_init.track(o).tau(K2).y = []; % 清空K1
        W_init.track(o).tau(K2).frame = [];
    end

    if tauexist(W_init, o, K1) && ~isempty(W_init.track(o).tau(K1).islast)
        W_init.track(o).tau(K1).islast = [];
        W_init.track(o).tau(K2).islast = 1;
        W_init.track(o).tau(K1).AAA = 'mossa8'; 
        if ~last1OR2
            last1OR2 = 1;
        else
            break % 到达两者之间的最后轨迹的最终时刻
        end
    end
    if tauexist(W_init, o, K2) && ~isempty(W_init.track(o).tau(K2).islast)
        W_init.track(o).tau(K2).islast = [];
        W_init.track(o).tau(K1).islast = 1;
        W_init.track(o).tau(K2).AAA = 'mossa8'; 
        if ~last1OR2
            last1OR2 = 1;
        else
            break % 到达两者之间的最后轨迹的最终时刻
        end
    end
end

Out = W_init;

end
