%function [ln_r,ln_C]=G_P(data,N,tau,m)
% the function is used to calculate correlation dimention with G-P algorithm
% data:the time series
% N: the length of the time series
% tau: the time delay
% m:the embedded dimention m

% GP�㷨�����ά

clc
clear
close all

%---------------------------------------------------
% ���� Lorenz ʱ������

sigma = 10;          % Lorenz���̲���
r = 28;               
b = 8/3;          

y = [-1;0;1];        % ��ʼ�� (3x1 ��������)
h = 0.01;            % ����ʱ�䲽��

k1 = 10000;          % ǰ��ĵ�������
k2 = 5000;           % ����ĵ�������

z = LorenzData(y,h,k1+k2,sigma,r,b);
x = z(k1+1:end,1);   % ʱ������(������)
x = normalize_1(x);  % ��һ��
data=x';             % ע�⣺�˴�ӦΪһ��������
%------------------------------------------------------

disp('---------- GP�㷨�����ά ----------');

tau = 14;           % ʱ��
m = 3;              % Ƕ��ά    


logdelt = 0.2;
ln_r = [-7:logdelt:0];
delt = exp(ln_r);
for k=1:length(ln_r)
    r=delt(k); 
    C(k)=correlation_interal(m,data,r,tau);%  �������Ϊ��������
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
% �����������
ln_Cr=ln_C;
ln_r=ln_r;
LinearZone = [10:25];
F = polyfit(ln_r(LinearZone),ln_Cr(LinearZone),1);
CorrelationDimension = F(1)
