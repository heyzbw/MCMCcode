function m = move_selection(K, nobirth)
% ѡ���ƶ������ķֲ�xsi����ȡ�����ж��ٸ�K

global xsicurr
global randomw

if nargin == 1
   if K==0
      m=1; % ֻ�к��������任
   else
      if K==1
         xsicurr=[1/6 1/6 1/6 0 1/6 1/6 1/6 0];  % û�кϲ����߽���任
         P = [1 2 3 3 4 5 6 6]./6; % Ϊ����ٶȣ���ǰ�����ֲ�
         d = rand;   % [0,1]֮�������
         [~,m] = max(P>d);
      else 
         if isempty(randomw)
            xsicurr =[1 1 2 2 9 5 5 5]./30; %for i=1:8 P(i)=sum(xsi(1:i)); end
            P = [0.0333    0.0667    0.1333    0.2000    0.5000    0.6667    0.8333    1.0000]; % Ϊ����ٶȣ���ǰ�����ֲ�
            d = rand;
            [~,m] = max(P>d);
         else
            xsicurr = [1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8];
            m = randi(8); % ���random walk
         end
      end
   end
elseif strcmp(nobirth, 'nobirth') % �޷���������
   if K==0
      m=666; % û�к�����Ҳû�г���: ���ж������뿪��Ұ
   else
      if K==1
         xsicurr =[0 1/5 1/5 0 1/5 1/5 1/5 0];  % �޺ϲ���켣�л��ƶ�
         P = [0 1 2 2 3 4 5 5]./5; % �ֲ� % Ϊ����ٶȣ���ǰ�����ֲ�
         d = rand;
         [~,m] = max(P>d);
      else 
         xsicurr = [0 1/7 1/7 1/7 1/7 1/7 1/7 1/7];
         P = [0 1 2 3 4 5 6 7]./7; % �ֲ� % Ϊ����ٶȣ���ǰ�����ֲ�
         d = rand;
         [~,m] = max(P>d);
      end
   end
end

end
