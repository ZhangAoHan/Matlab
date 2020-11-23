function sum=SA_CC(y1,y2)  %输入待比较的两个时序信号 y1  y2
%求两个信号的相关系数  越大越好(1：完全一样（相似）  -1：完全不相关)
% y1和y2必须长度相同
XY=0;X=0;Y=0;
for i=1:length(y1)
    XY=XY+y1(i).*y2(i);          %∑XY
    X=X+y1(i).^2;               %∑X.^2
    Y=Y+y2(i).^2;               %∑Y.^2
end
sum=XY/sqrt(X*Y);

