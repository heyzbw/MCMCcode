function W_out = proposal_distribution(W_init)
% proposal_distribution 提议分布函数

G = W_init.frame; % G为当前帧的上一帧
H = G + 1;
K = W_init.tracks;

global Tmax
% 滑动窗口，随着G的变化最大为Tmax，直到H>Tmax
if H <= Tmax
    T = G;
else
    T = Tmax;
end

global pd pz d_bar v_bar mprev mcurr xsiprev xsicurr

%%%%%%%%
mprev = mcurr;
xsiprev = xsicurr;

%% 随机选择移动类型

m = move_selection(K);

mcurr = m;

if m == 1 % 新目标出生移动
    Out = move1_birth(W_init, H, T, K, d_bar, v_bar, pz); 
    if isnumeric(Out) && Out == 666 % 没有轨迹且没有新目标出生：所有目标已经移出视野，或者如果创建的轨迹少于2个点，则拒绝此移动
        W_out = W_init;
        return
    elseif isnumeric(Out) && Out ~= 666 % 如果返回另一个移动类型的编号
        m = Out; % 这样可以避免使用 switch
        mcurr = m;
    else 
        W_out = Out;
    end
end

if m == 2 % 目标死亡移动
    Out = move2_death(W_init, H, T, K, G);
    if isnumeric(Out) && Out == 666 % 所有轨迹都已死亡
        W_out = W_init;
        return
    else 
        W_out = Out;
    end
end

if m == 3 % 目标分裂移动
    Out = move3_split(W_init, H, T, K, G);
    if isnumeric(Out) && Out == 666 % 无法扩展
        W_out = W_init;
        return
    else 
        W_out = Out;
    end
end

if m == 4 % 目标合并移动
    Out = move4_merge(W_init, H, T, K, G, v_bar);
    if isnumeric(Out) && Out == 666 % 如果没有可能的轨迹对，拒绝此移动
        W_out = W_init;
        return
    else 
        W_out = Out;
    end    
end

if m == 5 % 轨迹扩展移动
    Out = move5_extension(W_init, H, T, K, G, v_bar, d_bar);
    if isnumeric(Out) && Out == 666 % 所有轨迹都已死亡
        W_out = W_init;
        return
    else 
        W_out = Out;
    end    
end

if m == 6 % 轨迹缩短移动
    Out = move6_reduction(W_init, H, T, K, G);
    if isnumeric(Out) && Out == 666 % 所有轨迹都已死亡
        W_out = W_init;
        return
    else 
        W_out = Out;
    end    
end

if m == 7 % 轨迹更新移动
    Out = move7_track_update(W_init, H, T, K, G, v_bar, d_bar);
    if isnumeric(Out) && Out == 666 % 所有轨迹都已死亡
        W_out = W_init;
        return
    else 
        W_out = Out;
    end    
end

if m == 8 % 轨迹切换移动
    Out = move8_track_switch(W_init, H, T, K, G, d_bar, v_bar);
    if isnumeric(Out) && Out == 666 % 如果没有可能的轨迹对，拒绝此移动
        W_out = W_init;
        return
    else 
        W_out = Out;
    end    
end
% 
% disp('m = '); 
% disp(m); 

end
