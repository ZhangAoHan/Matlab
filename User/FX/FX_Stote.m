function [varargout]=FX_Stote(X,Y,b)
%% 方程即方程参数的显著性检验
%输入：
%X：测试样本值(列数和变量个数相等)  Y：测试样本函数值（m*1）
%b:回归方程系数,即y=b0+b1*x1+b2*x2+.....+bn*xn
%输出：
format long;
[m,n]=size(X);
b=b(:); 
Y=Y(:);
x_mean=mean(X);
y_mean=mean(Y);

S=sum((Y-y_mean).^2);%计算 总离差平方和
U=sum(((X*b(2:end))+b(1)-y_mean).^2); %计算回归平方和
Q=S-U;   %计算剩余平方和
RR2=U/S; %计算复可决系数
R=sqrt(RR2);%计算复相关系数,该值越接近1，说明X与Y的相关性越好
U_mean=U/n; %计算回归均方
Q_mean=Q/(m-n-1);%计算剩余均方
ss=sqrt(Q_mean); %计算剩余标准差
F=U_mean/Q_mean; %显著性检验值
A=inv(X'*X-m*x_mean'*x_mean);

%进行方程参数显著性检验
for i=1:n
    FX(i)=b(i+1).^2/(Q_mean*A(i,i));
    TX(i)=b(i+1)/(ss*sqrt(A(i,i)));
end

 %% 首先输出函数表达式(有bug，不要用)
% % % % format short;
% % % % string_f=fliplr(b)  %将矩阵倒序排
% % % % string_ff=poly2sym(string_f) %输出成函数表达式
% % % % 
% % % % string_ff=char(string_ff);  %将sym格式转化为字符串型
% % % % fprintf(['检验方程为：' string_ff]);
%% 输出参数
fprintf('复相关系数为：%f。复相关系数越大（最大为1），说明变量与函数值的相关性越大 \r\n',R);
fprintf('方程显著性值为：%f。只有该值大于F分布表中F(变量个数，样本组数m)的值，才能说明方程具有显著性。\r\n',F);
string_FX=num2str(FX);
fprintf(['方程参数显著性值为：' string_FX '。F检验：只有该值大于F分布表中F(1，样本组数m)的值，才能说明对应参数具有显著性。\r\n']);
string_TX=num2str(TX);
fprintf(['方程参数显著性值为：' string_TX '。T检验：只有该值大于T分布表中T(1，样本组数m)的值，才能说明对应参数具有显著性。\r\n']);
%% 输出变量
if  nargout==4
    varargout{1}=R;%复相关系数
    varargout{2}=F;%方程显著性值
    varargout{3}=FX;%方程参数显著性值,F检验
    varargout{4}=TX;%方程参数显著性值，T检验
elseif nargout==0
    fprintf('无输出参数\r\n');
else
    error('输出参数要么为0，要么为4\r\n');
end

