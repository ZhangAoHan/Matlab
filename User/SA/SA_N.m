function K= SA_N(x)
%����һά���е�����ǿ��
x=x(:)';
x_mean=mean(x);
K=sqrt(mean((x-x_mean).^2));