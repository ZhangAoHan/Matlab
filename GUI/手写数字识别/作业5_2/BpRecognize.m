function [ result ] = BpRecognize( data)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
 load('W2.mat');
  load('W3.mat');
   load('B2.mat');
    load('B3.mat');
%����
P = data;
%P�����
a1 = P;
%�ڶ������
n2 = W2 * a1 + B2;
a2 = Logsig(n2);     
%���������
n3 = W3 * a2 + B3;
a3 = Logsig(n3);  
a3 = floor(a3+0.5);

%��������ת��
result = a3(1,1) * (2^3) + a3(2,1)*(2^2) +a3(3,1)*(2^1) +a3(4,1)*(2^0);
end

