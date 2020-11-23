function K= SA_N(x)
%计算一维序列的噪声强度
x=x(:)';
x_mean=mean(x);
K=sqrt(mean((x-x_mean).^2));