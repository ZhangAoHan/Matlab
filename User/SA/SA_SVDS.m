function [y_out,cf] = SA_SVDS(x)
%% ����ֵ����׽���

x=x(:)';
desvio_x=std(x);
x=x/desvio_x;
N=length(x);
%����hankel����
% c=x(1:N/2);
% r=x(N/2:N);
c=x;
r=x;
A=hankel(c,r);
[U,E,V]=svd(A);

e=diag(E);  %��ȡ����ֵ
L=length(e); 

sum_e=0;

for i=1:L
    sum_e=sum_e+e(i)^2;
end
%������
for i=1:L-1 
    cf(i)=(e(i)^2-e(i+1)^2)/sum_e;
end
[~, n]=max(cf);      %n�����ͻ����λ��
%�ع��ź�
for j=n+1:N
        E(j,j)=0;
end
AA=U*E*V';
y_out(1:N)=AA(1,1:N);
y_out=y_out*desvio_x;
%% ���
if nargout>0
    varargin{1}=y_out;
end
if nargout>1  %�������ֵ���������
    varargin{2}=cf;
end
