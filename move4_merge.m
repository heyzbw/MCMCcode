function Out = move4_merge(W_init, H, T, K, G, v_bar)
% 在时刻H执行轨迹合并的操作

global Y % 从帧1到H（当前）

neartaus = zeros(K, 4); % 会有K!个可能的轨迹对，但是对于太多的标记，这是昂贵的，因此我们只考虑K个可能性
tf = zeros(K); % 最终时刻
c = 1; % 如果计数器添加行到矩阵
for k1 = 1:K
    for g = H - T:G % 考虑滑动窗口
        if tauexist(W_init, g, k1) && ~isempty(W_init.track(g).tau(k1).islast) % 对于每个最终时刻tauk1(tf)
            tf(k1) = g;
            for k2 = 1:K
                if k2 ~= k1 && g + 1 <= G % 避免G<2和未来的过度
                    for h = g + 1:G % 在向前的时刻中查找
                        if tauexist(W_init, h, k2) && W_init.track(h).tau(k2).frame == 1 % 如果找到某个轨迹的第一个帧
                            if pdist([Y(g).data(W_init.track(g).tau(k1).y, :); Y(h).data(W_init.track(h).tau(k2).y, :)]) <= (h - g) * v_bar
                                neartaus(c, :) = [k1 g k2 h];
                                c = c + 1;
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
    return; % 如果没有可能的轨迹对，拒绝该变动
end

% neartaus(Msp,:)=[k1 g k2 h];
q = neartaus(randi(c - 1), :);

K1 = q(1);
tf1 = q(2);

K2 = q(3);
ti2 = q(4);
tf2 = tf(K2);

W_init.track(tf1).tau(K1).islast = [];
n = W_init.track(tf1).tau(K1).frame;
b = 1;

for o = ti2:tf2
    if tauexist(W_init, o, K2)
        W_init.track(o).tau(K1).y = W_init.track(o).tau(K2).y; % 轨迹K2变为轨迹K1
        W_init.track(o).tau(K1).frame = n + b;
        W_init.track(o).tau(K2).y = []; % 清空K2
        W_init.track(o).tau(K2).frame = [];
        b = b + 1;
    end
end
W_init.track(tf2).tau(K1).islast = 1;
W_init.track(tf2).tau(K1).AAA = 'mossa4'; 

% 不执行 W_init.tracks = K-1;，因为K是已经存在或存在的所有轨迹的数量

Out = W_init;

end
