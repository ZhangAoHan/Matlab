function  PD_YS(imf,fs,name)
%����������άͼģʽ����IMFչ����
%IMF��������Ϊ��Ҫ���ݵľ���
%�������źŲ𿪻�ͼ
if nargin<2
    error("������IMF������Ƶ��");
end
if nargin==2
    name="û�ж���ͼƬ����";
end
[m,n]=size(imf);
if m>n  %����������ǿ��ת��Ϊ��������Ϊ��Ч�����ľ���
   imf=imf';
end
figure('Name',name,'NumberTitle','off','Color',[1 1 0]);
[m,n]=size(imf);
y_size=ones(m,n);
for i=1:m
    plot3((1:n)/fs,i*y_size(i,:),imf(i,:));
    hold on
    y_name{i}=['IMF' num2str(i)];
    text(1,i,y_name{i});
end
xlabel('t')
ylabel('IMF')
zlabel('Amp')
set(gca,'Yticklabel',y_name);
title('IMFs');
box on
% legend(y_name);
