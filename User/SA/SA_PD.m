function [xn,dn] = SA_PD(s,tau,m,T,String)
%画相图，来判断降噪的优劣
%例
% [zn0,dn0]=PSR(s1,1,4);
% figure(2);
% plot(zn0(1,:),dn0);
% 混沌序列的相空间重构 (phase space reconstruction)
% [xn, dn, xn_cols] = PhaSpaRecon(s, tau, m)
% 输入参数：    s          混沌序列(列向量)
%               tau        重构时延，越大，数据越偏离中心线
%               m          重构维数,决定输出xn的行数,太小的话就是纠集到一条线上
%               T          直接预测步数,越大，数据越偏离中心线
% 输出参数：    xn         相空间中的点序列(每一列为一个点)
%               dn         一步预测的目标(行向量)

if nargin==1
    tau=1;
    m=4;
    T = 1;
    String='method_1';
elseif nargin==2
    m=4;
    T = 1;
    String='method_1';
elseif nargin==3
    T = 1;
    String='method_1';
elseif nargin==4
    String='method_1';
end

if strcmpi(String,'method_1')
    [s,~,cols]=SPT_ST(s);
    len = cols;
    if (nargout==1) %输出混沌序列的重构序列（一维点图）
        if (len-(m-1)*tau < 1)
            disp('err: delay time or the embedding dimension is too large!')
            xn = [];
        else
            xn = zeros(m,len-(m-1)*tau);
            for i = 1:m
                xn(i,:) = s(1+(i-1)*tau : len-(m-i)*tau);   % 相空间重构，每一行为一个点 
            end
        end

    elseif (nargout==2)%输出混沌序列的重构序列（二维相图）

        if (len-T-(m-1)*tau < 1)
            disp('err: delay time or the embedding dimension is too large!')
            xn = [];
            dn = [];
        else
            xn = zeros(m,len-T-(m-1)*tau);
            for i = 1:m
                xn(i,:) = s(1+(i-1)*tau : len-T-(m-i)*tau);   % 相空间重构，每一行为一个点 
            end
            dn = s(1+T+(m-1)*tau : end);    % 预测的目标
        end
    
    end
elseif strcmpi(String,'method_2')
    N=length(s);
    n=N-(m-1)*tau;
    V=zeros(n,m);
    for i=1:n
    V(i,:)=s(i:tau:i+(m-1)*tau);
    end
    V=V';   %v=m*n以上ok
    xn=V; %取前两行（因为已经转置了）
    dn=V(2,:);
else
    error('请正确输出使用的方法')
end




