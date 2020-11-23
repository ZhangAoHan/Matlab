function PD_CP(x,y,name)
%经典画矩阵 画出多行一列的图像
if nargin==2
    name='未定义图像';
end
[y,m,n]=SPT_ST(y);
figure('Name',name);
for i=1:m
    subplot(m,1,i);
    plot(x,y(i,:));
end

