function y=SPT_CG(x)
%对IMFS进行重构
%输出，一个行向量
[x,m,n]=SPT_ST(x);
y=sum(x,1);
