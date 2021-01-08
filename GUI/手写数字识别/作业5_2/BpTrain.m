function [] = BpTrain()
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

clear all;
clc

ctime = datestr(now, 30);%ȡϵͳʱ��
tseed = str2num(ctime((end - 5) : end)) ;%��ʱ���ַ�ת��Ϊ����
rand('seed', tseed) ;%�������ӣ����������������ȡ��α�����

load Data2;  %������10�����ݣ�ÿ��20��25�У���4���Ǳ�ǩ����200*29 
c = 0;
data = [];
for i = 1:10
    for j = 1:20
        c = c + 1;
        data(c,:) = pattern(i).feature(j,:);
    end
end
 
%=============ѵ������=============
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

%0��ǩ
Data(1:20, 26)   = 0;
Data(1:20, 27)   = 0;
Data(1:20, 28)   = 0;
Data(1:20, 29)   = 0;
%1��ǩ
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

%���������
S1N = 25;

%�ڶ�������
S2N = 50;

%���������
S3N = 4;

%ѧϰ��
sk = 0.5;


%�����ʼ�������W��B
W2 = -1 + 2 .* rand(S2N, S1N);
B2 = -1 + 2 .* rand(S2N, 1);

W3 = -1 + 2 .* rand(S3N, S2N);
B3 = -1 + 2 .* rand(S3N, 1);

%���������±�
di = 1; 


for i=1:50000
    
    P = Data(di, 1:S1N)';
    t = Data(di, 26:29)';
    
    di = di + 1;
    di = 1 + mod(di, DN);
    
    %P�����
    a1 = P;
    
    %�ڶ������
    n2 = W2 * a1 + B2;
    a2 = Logsig(n2);  %�ڶ��㴫�亯��Ϊlogsig
    
    %���������
    n3 = W3 * a2 + B3;
    a3 = Logsig(n3);   %�����㴫�亯��Ϊlogsig
    
    %������������
    e  = t - a3;
    err = (e') * e;
    
    Fd3 = diag((1 - a3) .* a3);
    S3 = -2 * Fd3 * e;
    
    Fd2 = diag((1 - a2) .* a2);
    S2 = Fd2 * (W3') * S3;
    
    W3 = W3 - sk*S3*(a2'); %�ݶ��½�����
    B3 = B3 - sk*S3;
    
    W2 = W2 - sk*S2*(a1');
    B2 = B2 - sk*S2;
end
msgbox(num2str(err),'��������','help');
save('W2.mat','W2');
save('W3.mat','W3');
save('B2.mat','B2');
save('B3.mat','B3');


end

