%function [ln_r,ln_C]=G_P(data,N,tau,m)
% the function is used to calculate correlation dimention with G-P algorithm
% data:the time series
% N: the length of the time series
% tau: the time delay
% m:the embedded dimention m

% GP算法求关联维

clc
clear
close all

%---------------------------------------------------
% 产生 Lorenz 时间序列

sigma = 10;          % Lorenz方程参数
r = 28;               
b = 8/3;          

y = [-1;0;1];        % 起始点 (3x1 的列向量)
h = 0.01;            % 积分时间步长

k1 = 10000;          % 前面的迭代点数
k2 = 5000;           % 后面的迭代点数

z = LorenzData(y,h,k1+k2,sigma,r,b);
x = z(k1+1:end,1);   % 时间序列(列向量)
x = normalize_1(x);  % 归一化
data=x';             % 注意：此处应为一个行向量
%------------------------------------------------------

disp('---------- GP算法求关联维 ----------');

tau = 14;           % 时延
m = 3;              % 嵌入维    


logdelt = 0.2;
ln_r = [-7:logdelt:0];
delt = exp(ln_r);
for k=1:length(ln_r)
    r=delt(k); 
    C(k)=correlation_interal(m,data,r,tau);%  输出变量为关联积分
    k
    if (C(k)<0.0001)
        C(k)=0.0001;
    end
    ln_C(k)=log(C(k));%lnC(r)
end
C
subplot(211)
plot(ln_r,ln_C,'+:');grid;
xlabel('ln r'); ylabel('ln C(r)');
hold on;

subplot(212)
Y = diff(ln_C)./logdelt;
plot(Y,'+:'); grid;
xlabel('n'); ylabel('slope'); 
hold on;

%------------------------------------------------------
% 拟合线性区域
ln_Cr=ln_C;
ln_r=ln_r;
LinearZone = [10:25];
F = polyfit(ln_r(LinearZone),ln_Cr(LinearZone),1);
CorrelationDimension = F(1)
