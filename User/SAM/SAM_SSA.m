function [varargout]=SAM_SSA(varargin)
%������ع����У��������У��������������������
%���룺ʱ�����С�Ƕ��ά��
if nargin>0
    x=varargin{1};
    L=floor(length(x)/3);
else
    error("�������ݰ�");
end
if nargin>1
    L=varargin{2};
end

%% �����������
x=x(:)';
N=length(x);
if L>N/2
    L=N-L;
end
K=N-L+1;  %%K����>1
for i=1:L
    X(i,:)=x(i:i+K-1);
end
%% ����SVD�ֽ�
[U,S,V]=svd(X);

%% ����


