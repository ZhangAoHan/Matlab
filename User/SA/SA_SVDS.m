function [y_out,cf] = SA_SVDS(x)
%% 奇异值差分谱降噪

x=x(:)';
desvio_x=std(x);
x=x/desvio_x;
N=length(x);
%构建hankel矩阵
% c=x(1:N/2);
% r=x(N/2:N);
c=x;
r=x;
A=hankel(c,r);
[U,E,V]=svd(A);

e=diag(E);  %提取奇异值
L=length(e); 

sum_e=0;

for i=1:L
    sum_e=sum_e+e(i)^2;
end
%计算差分
for i=1:L-1 
    cf(i)=(e(i)^2-e(i+1)^2)/sum_e;
end
[~, n]=max(cf);      %n是最大突变点的位置
%重构信号
for j=n+1:N
        E(j,j)=0;
end
AA=U*E*V';
y_out(1:N)=AA(1,1:N);
y_out=y_out*desvio_x;
%% 输出
if nargout>0
    varargin{1}=y_out;
end
if nargout>1  %输出奇异值能量差分谱
    varargin{2}=cf;
end
