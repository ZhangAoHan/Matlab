function PD_CP(x,y,name)
%���仭���� ��������һ�е�ͼ��
if nargin==2
    name='δ����ͼ��';
end
[y,m,n]=SPT_ST(y);
figure('Name',name);
for i=1:m
    subplot(m,1,i);
    plot(x,y(i,:));
end

