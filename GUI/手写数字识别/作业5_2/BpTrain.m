function [] = BpTrain()
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

clear all;
clc

ctime = datestr(now, 30);%取系统时间
tseed = str2num(ctime((end - 5) : end)) ;%将时间字符转换为数字
rand('seed', tseed) ;%设置种子，若不设置种子则可取到伪随机数

load Data2;  %数据有10类数据，每类20行25列，有4列是标签。共200*29 
c = 0;
data = [];
for i = 1:10
    for j = 1:20
        c = c + 1;
        data(c,:) = pattern(i).feature(j,:);
    end
end
 
%=============训练数据=============
Data = data(1:20, 1:25);
Data = [ Data ; data(21:40, 1:25)];
Data = [ Data ; data(41:60, 1:25)];   
Data = [ Data ; data(61:80, 1:25)];
Data = [ Data ; data(81:100, 1:25)];
Data = [ Data ; data(101:120, 1:25)];
Data = [ Data ; data(121:140, 1:25)];
Data = [ Data ; data(141:160, 1:25)];
Data = [ Data ; data(161:180, 1:25)];
Data = [ Data ; data(181:200, 1:25)];

%0标签
Data(1:20, 26)   = 0;
Data(1:20, 27)   = 0;
Data(1:20, 28)   = 0;
Data(1:20, 29)   = 0;
%1标签
Data(21:40, 26)   = 0;
Data(21:40, 27)   = 0;
Data(21:40, 28)   = 0;
Data(21:40, 29)   = 1;

Data(41:60, 26)   = 0;
Data(41:60, 27)   = 0;
Data(41:60, 28)   = 1;
Data(41:60, 29)   = 0;

Data(61:80, 26)   = 0;
Data(61:80, 27)   = 0;
Data(61:80, 28)   = 1;
Data(61:80, 29)   = 1;

Data(81:100, 26)   = 0;
Data(81:100, 27)   = 1;
Data(81:100, 28)   = 0;
Data(81:100, 29)   = 0;

Data(101:120, 26)   = 0;
Data(101:120, 27)   = 1;
Data(101:120, 28)   = 0;
Data(101:120, 29)   = 1;

Data(121:140, 26)   = 0;
Data(121:140, 27)   = 1;
Data(121:140, 28)   = 1;
Data(121:140, 29)   = 0;

Data(141:160, 26)   = 0;
Data(141:160, 27)   = 1;
Data(141:160, 28)   = 1;
Data(141:160, 29)   = 1;

Data(161:180, 26)   = 1;
Data(161:180, 27)   = 0;
Data(161:180, 28)   = 0;
Data(161:180, 29)   = 0;

Data(181:200, 26)   = 1;
Data(181:200, 27)   = 0;
Data(181:200, 28)   = 0;
Data(181:200, 29)   = 1;

DN = size(Data, 1);

%输入层结点数
S1N = 25;

%第二层结点数
S2N = 50;

%输出层结点数
S3N = 4;

%学习率
sk = 0.5;


%随机初始化各层的W和B
W2 = -1 + 2 .* rand(S2N, S1N);
B2 = -1 + 2 .* rand(S2N, 1);

W3 = -1 + 2 .* rand(S3N, S2N);
B3 = -1 + 2 .* rand(S3N, 1);

%数据样本下标
di = 1; 


for i=1:50000
    
    P = Data(di, 1:S1N)';
    t = Data(di, 26:29)';
    
    di = di + 1;
    di = 1 + mod(di, DN);
    
    %P输入层
    a1 = P;
    
    %第二层输出
    n2 = W2 * a1 + B2;
    a2 = Logsig(n2);  %第二层传输函数为logsig
    
    %第三层输出
    n3 = W3 * a2 + B3;
    a3 = Logsig(n3);   %第三层传输函数为logsig
    
    %计算输出层误差
    e  = t - a3;
    err = (e') * e;
    
    Fd3 = diag((1 - a3) .* a3);
    S3 = -2 * Fd3 * e;
    
    Fd2 = diag((1 - a2) .* a2);
    S2 = Fd2 * (W3') * S3;
    
    W3 = W3 - sk*S3*(a2'); %梯度下降步长
    B3 = B3 - sk*S3;
    
    W2 = W2 - sk*S2*(a1');
    B2 = B2 - sk*S2;
end
msgbox(num2str(err),'输出层误差','help');
save('W2.mat','W2');
save('W3.mat','W3');
save('B2.mat','B2');
save('B3.mat','B3');


end

