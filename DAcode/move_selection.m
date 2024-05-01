function m = move_selection(K, nobirth)
% 选择移动操作的分布xsi，它取决于有多少个K

global xsicurr
global randomw

if nargin == 1
   if K==0
      m=1; % 只有航迹产生变换
   else
      if K==1
         xsicurr=[1/6 1/6 1/6 0 1/6 1/6 1/6 0];  % 没有合并或者交叉变换
         P = [1 2 3 3 4 5 6 6]./6; % 为提高速度，提前创建分布
         d = rand;   % [0,1]之间随机数
         [~,m] = max(P>d);
      else 
         if isempty(randomw)
            xsicurr =[1 1 2 2 9 5 5 5]./30; %for i=1:8 P(i)=sum(xsi(1:i)); end
            P = [0.0333    0.0667    0.1333    0.2000    0.5000    0.6667    0.8333    1.0000]; % 为提高速度，提前创建分布
            d = rand;
            [~,m] = max(P>d);
         else
            xsicurr = [1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8];
            m = randi(8); % 如果random walk
         end
      end
   end
elseif strcmp(nobirth, 'nobirth') % 无法产生新生
   if K==0
      m=666; % 没有航迹，也没有出生: 所有对象都已离开视野
   else
      if K==1
         xsicurr =[0 1/5 1/5 0 1/5 1/5 1/5 0];  % 无合并或轨迹切换移动
         P = [0 1 2 2 3 4 5 5]./5; % 分布 % 为提高速度，提前创建分布
         d = rand;
         [~,m] = max(P>d);
      else 
         xsicurr = [0 1/7 1/7 1/7 1/7 1/7 1/7 1/7];
         P = [0 1 2 3 4 5 6 7]./7; % 分布 % 为提高速度，提前创建分布
         d = rand;
         [~,m] = max(P>d);
      end
   end
end

end
