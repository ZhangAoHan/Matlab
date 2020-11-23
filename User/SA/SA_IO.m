%验证正交性IO
%IO越大 说明模态混叠现象越严重
function io= SA_IO(x,imf) %输入原始信号（一维），和分解后的IMF（总体）
x=x(:)'; %强制行向量
[m,n]=size(imf);
if m>n   %强制行矩阵
    imf=imf';
end
[m,n]=size(imf);
%计算IO
io=0;
for i=1:m
    for j=1:m
        if j~=i
            io=io+abs(sum(imf(i,:).*imf(j,:))/sum(x.^2));
        end
    end
end
