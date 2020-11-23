function  PD_YS(imf,fs,name)
%画分量的三维图模式（按IMF展开）
%IMF是行向量为主要数据的矩阵
%将复合信号拆开画图
if nargin<2
    error("请输入IMF即采样频率");
end
if nargin==2
    name="没有定义图片名称";
end
[m,n]=size(imf);
if m>n  %将输入数据强制转换为以行向量为有效向量的矩阵
   imf=imf';
end
figure('Name',name,'NumberTitle','off','Color',[1 1 0]);
[m,n]=size(imf);
y_size=ones(m,n);
for i=1:m
    plot3((1:n)/fs,i*y_size(i,:),imf(i,:));
    hold on
    y_name{i}=['IMF' num2str(i)];
    text(1,i,y_name{i});
end
xlabel('t')
ylabel('IMF')
zlabel('Amp')
set(gca,'Yticklabel',y_name);
title('IMFs');
box on
% legend(y_name);
