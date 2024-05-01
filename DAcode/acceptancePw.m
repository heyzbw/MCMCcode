function [ P_acc ] = acceptancePw(pww, pwp)
% ACCEPTANCE( W0, W1 ) 
% 计算新的可行关联集W1相对于先前接受的可行解集W0的接受概率

global mprev mcurr xsiprev xsicurr % 在此之前已经准备好

qh = xsicurr(mcurr);
qw = xsiprev(mprev);

% 如果先前的接受概率为空，将其设为1
if isempty(qw)
    qh = 1;
    qw = 1;
end

% 计算接受概率
P_acc = min(1, (pwp/pww)*(qh/qw));

% 显示接受概率
% msg = strcat('Prob. acceptance = ',' ',num2str(P_acc));
% disp(msg);
end
