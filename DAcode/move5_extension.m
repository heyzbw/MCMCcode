function Out = move5_extension(W_init, H, T, K, G, v_bar, d_bar)
% ִ�й켣��չ�Ĳ���

global pz

aliveK = zeros(K, 2);
c = 1;
for k = 1:K
    for g = H - T:G % ���ǻ�������
        if tauexist(W_init, g, k) && ~isempty(W_init.track(g).tau(k).islast) % ����켣�����������ʱ�̣��ҹ켣���Ȳ�����1
            aliveK(c, :) = [k, g];
            c = c + 1;
            break;
        end
    end
end

if c == 1 % ���й켣���Ѿ���ʧ
    Out = 666;
    return;
end
a = randi(c - 1);
k2extend = aliveK(a, 1);
tfk2extend = aliveK(a, 2);
N2ext = W_init.track(tfk2extend).tau(k2extend).frame;
% ʹ�������任ʵ�ֹ켣��չ
Out = move1_birth(W_init, H, T, K, d_bar, v_bar, pz, k2extend, tfk2extend, N2ext);

end
