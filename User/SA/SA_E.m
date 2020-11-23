%% 计算香农熵H(x)
function H_x=SA_E(x)
    N=length(x);
%% 计算概率密度函数
    [~,~,x] = unique(x);  %给出x中原始的顺序表（正整数序列，相同的数具有相同的顺序）
    Px = accumarray(x, 1)/N;  %计算x的概率密度函数
    H_x=-dot(Px,log2(Px));   %计算香农熵
    H_x = max(0,H_x); %香农熵为0时，说明：x为一个常函数。  数学上，香农熵不可能为负，但计算机计算存在截断误差
end