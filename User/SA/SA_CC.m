function sum=SA_CC(y1,y2)  %������Ƚϵ�����ʱ���ź� y1  y2
%�������źŵ����ϵ��  Խ��Խ��(1����ȫһ�������ƣ�  -1����ȫ�����)
% y1��y2���볤����ͬ
XY=0;X=0;Y=0;
for i=1:length(y1)
    XY=XY+y1(i).*y2(i);          %��XY
    X=X+y1(i).^2;               %��X.^2
    Y=Y+y2(i).^2;               %��Y.^2
end
sum=XY/sqrt(X*Y);

