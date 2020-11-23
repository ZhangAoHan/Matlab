%验证相似性指数
%SI越大 说明分解后的IMF与原始信号越相似（通过计算各个IMF与原始信号的相关系数，再平均）
function si= SA_SI(x,imf) %输入原始信号（一维），和分解后的IMF（总体）
x=x(:)'; %强制行向量
[m,n]=size(imf);
if m>n   %强制行矩阵
    imf=imf';
end
[m,n]=size(imf);
%计算SI
si=0;
for i=1:m
    si_init=corrcoef(x,imf(i,:));  %输出为相似矩阵，取（1,2）或者（2，1）
    si=si+si_init(1,2);
end
si=si/m;