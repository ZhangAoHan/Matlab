function y=SAM_XB(x)
%用db1小波对信号进行3层分解并提取系数
[c,l]=wavedec(x,3,'db1');
a3=appcoef(c,l,'db1',3);
d3=detcoef(c,l,3);
d2=detcoef(c,l,2);
d1=detcoef(c,l,1);
%强制消噪处理
dd3=zeros(1,length(d3));
dd2=zeros(1,length(d2));
dd1=zeros(1,length(d1));
c1=[a3 dd3 dd2 dd1];
y=waverec(c1,l,'db1');


