function tauexistance = tauexist(W, t, k)
%TAUEXIST 检查轨迹是否存在
%   根据输入的时间步 t 和轨迹索引 k，检查在该时刻是否存在轨迹。

global Hfinal

% 初始化标志位
tauexistance = t <= Hfinal && ~isempty(W.track(t).tau);

if tauexistance
   % 检查轨迹索引是否在有效范围内
   tauexistance = tauexistance && k <= length(W.track(t).tau);
   
   if tauexistance
      % 检查轨迹结构是否存在且非空
      tauexistance = tauexistance && ~isempty(W.track(t).tau(k));
      
      if tauexistance
         % 检查轨迹中的测量索引是否存在且非空
         tauexistance = tauexistance && isfield(W.track(t).tau(k), 'y') && ~isempty(W.track(t).tau(k).y);
      end
   end
end

end
