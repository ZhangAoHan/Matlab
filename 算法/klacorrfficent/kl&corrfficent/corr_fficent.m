% x和y必须长度相同
%求相关系数
% r=∑XY/sqrt(∑X.^2*∑Y.^2)
function [r]=corr_fficent(x,y)
XY=0;X=0;Y=0;
for i=1:length(x)
    XY=XY+x(i).*y(i);          %∑XY
    X=X+x(i).^2;               %∑X.^2
    Y=Y+y(i).^2;               %∑Y.^2
end
r=XY/sqrt(X*Y);
end