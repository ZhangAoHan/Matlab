function [varargout]=SAM_SSA(varargin)
%输出：重构序列（降噪序列）、各个分量、残余分量
%输入：时间序列、嵌入维度
if nargin>0
    x=varargin{1};
    L=floor(length(x)/3);
else
    error("输入数据啊");
end
if nargin>1
    L=varargin{2};
end

%% 构建奇异矩阵
x=x(:)';
N=length(x);
if L>N/2
    L=N-L;
end
K=N-L+1;  %%K必须>1
for i=1:L
    X(i,:)=x(i:i+K-1);
end
%% 进行SVD分解
[U,S,V]=svd(X);

%% 分组


