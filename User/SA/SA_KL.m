function sum=SA_KL(y1,y2)  %输入待比较的两个时序信号 y1  y2
%sum为KL散度值  该值越大 说明差异性越大（可以设定阈值为0.1，即SUM大于0.1 就认为差异过大，为无效分量）
%该值为0：说明二个输入信号没有差异
%定义核密度函数  生成100个数据（f x 都是100个数据）
[f1,x1]=ksdensity(y1);
[f2,x2]=ksdensity(y2);

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

sum=sum1+sum2;  %得到KL散度值
