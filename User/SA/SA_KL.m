function sum=SA_KL(y1,y2)  %������Ƚϵ�����ʱ���ź� y1  y2
%sumΪKLɢ��ֵ  ��ֵԽ�� ˵��������Խ�󣨿����趨��ֵΪ0.1����SUM����0.1 ����Ϊ�������Ϊ��Ч������
%��ֵΪ0��˵�����������ź�û�в���
%������ܶȺ���  ����100�����ݣ�f x ����100�����ݣ�
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

sum=sum1+sum2;  %�õ�KLɢ��ֵ
