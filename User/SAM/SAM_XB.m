function y=SAM_XB(x)
%��db1С�����źŽ���3��ֽⲢ��ȡϵ��
[c,l]=wavedec(x,3,'db1');
a3=appcoef(c,l,'db1',3);
d3=detcoef(c,l,3);
d2=detcoef(c,l,2);
d1=detcoef(c,l,1);
%ǿ�����봦��
dd3=zeros(1,length(d3));
dd2=zeros(1,length(d2));
dd1=zeros(1,length(d1));
c1=[a3 dd3 dd2 dd1];
y=waverec(c1,l,'db1');


