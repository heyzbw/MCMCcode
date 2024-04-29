function [TP, FP, FN] = compare_point_sets(points, W, Y)

% 初始化 TP、FP 和 FN 的数量
TP = 0;
FP = 0;
FN = 0;

for t = 1:W.frame - 1 
    % 初始化每帧的点集
    points_hat_t = [];
    for k = 1:W.tracks 
        if tauexist(W, t, k) 
            % 获取点的坐标
            x = Y(t).data(W.track(t).tau(k).y, 1);
            y = Y(t).data(W.track(t).tau(k).y, 2);
            z = Y(t).data(W.track(t).tau(k).y, 3);

            % 将点添加到当前帧的点集中
            points_hat_t = cat(2, points_hat_t, [x; y; z]);
        
            mat2str(size(points_hat_t))
            % 比较两个点集
            if ~isempty(points_hat_t) && size(points_hat_t, 2) >= k
                if isequal(points(:, k, t), points_hat_t(:, k))
                    TP = TP + 1; % 存在且分对
                else
                    FP = FP + 1; % 存在但分错
                end
            else
                FP = FP + 1; % 存在但分错
            end
        else
            FN = FN + 1; % 不存在，漏检
        end
      
    end

end

end

