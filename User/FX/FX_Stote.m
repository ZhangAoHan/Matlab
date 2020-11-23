function [varargout]=FX_Stote(X,Y,b)
%% ���̼����̲����������Լ���
%���룺
%X����������ֵ(�����ͱ����������)  Y��������������ֵ��m*1��
%b:�ع鷽��ϵ��,��y=b0+b1*x1+b2*x2+.....+bn*xn
%�����
format long;
[m,n]=size(X);
b=b(:); 
Y=Y(:);
x_mean=mean(X);
y_mean=mean(Y);

S=sum((Y-y_mean).^2);%���� �����ƽ����
U=sum(((X*b(2:end))+b(1)-y_mean).^2); %����ع�ƽ����
Q=S-U;   %����ʣ��ƽ����
RR2=U/S; %���㸴�ɾ�ϵ��
R=sqrt(RR2);%���㸴���ϵ��,��ֵԽ�ӽ�1��˵��X��Y�������Խ��
U_mean=U/n; %����ع����
Q_mean=Q/(m-n-1);%����ʣ�����
ss=sqrt(Q_mean); %����ʣ���׼��
F=U_mean/Q_mean; %�����Լ���ֵ
A=inv(X'*X-m*x_mean'*x_mean);

%���з��̲��������Լ���
for i=1:n
    FX(i)=b(i+1).^2/(Q_mean*A(i,i));
    TX(i)=b(i+1)/(ss*sqrt(A(i,i)));
end

 %% ��������������ʽ(��bug����Ҫ��)
% % % % format short;
% % % % string_f=fliplr(b)  %����������
% % % % string_ff=poly2sym(string_f) %����ɺ������ʽ
% % % % 
% % % % string_ff=char(string_ff);  %��sym��ʽת��Ϊ�ַ�����
% % % % fprintf(['���鷽��Ϊ��' string_ff]);
%% �������
fprintf('�����ϵ��Ϊ��%f�������ϵ��Խ�����Ϊ1����˵�������뺯��ֵ�������Խ�� \r\n',R);
fprintf('����������ֵΪ��%f��ֻ�и�ֵ����F�ֲ�����F(������������������m)��ֵ������˵�����̾��������ԡ�\r\n',F);
string_FX=num2str(FX);
fprintf(['���̲���������ֵΪ��' string_FX '��F���飺ֻ�и�ֵ����F�ֲ�����F(1����������m)��ֵ������˵����Ӧ�������������ԡ�\r\n']);
string_TX=num2str(TX);
fprintf(['���̲���������ֵΪ��' string_TX '��T���飺ֻ�и�ֵ����T�ֲ�����T(1����������m)��ֵ������˵����Ӧ�������������ԡ�\r\n']);
%% �������
if  nargout==4
    varargout{1}=R;%�����ϵ��
    varargout{2}=F;%����������ֵ
    varargout{3}=FX;%���̲���������ֵ,F����
    varargout{4}=TX;%���̲���������ֵ��T����
elseif nargout==0
    fprintf('���������\r\n');
else
    error('�������ҪôΪ0��ҪôΪ4\r\n');
end

