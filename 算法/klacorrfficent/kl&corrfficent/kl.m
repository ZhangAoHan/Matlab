% x和y必须长度相同
function [sum]=kl(x,y)
% 核密度估计
[f1,x1]=ksdensity(x);
[f2,x2]=ksdensity(y);

%
sum1=0;
for i=1:100
    t(i)=f1(i)/f2(i);
    t1(i)=log(t(i));
    p(i)=f1(i).*t1(i);
    sum1=sum1+p(i);
end
sum2=0;
for i=1:100
    k(i)=f2(i)/f1(i);
    k1(i)=log(k(i));
    q(i)=f2(i).*k1(i);
    sum2=sum2+q(i);
end
sum=sum1+sum2;