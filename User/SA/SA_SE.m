function [Power,Energy]=SA_SE(y,fs,string)
%���źŵ������͹���
% ���룺 �����ź�  ����Ƶ�ʣ��źŵĲ���Ƶ�ʣ�ֻ��t�йأ�string=t��ʱ��f(Ƶ��)
%�����  ƽ�����ʺ�������

y_num=length(y);%�����������
t=y_num/fs;  %���������ʱ�䣨Ϊ�����ʣ�
if strcmpi(string,'t')  %��ʱ�������
    Energy=sum(y.^2);
    Power=Energy/t;
elseif strcmpi(string,'f') 
    fy=fft(y);%������ٸ���Ҷ�任
    fy=abs(fy/y_num); %�����źŻ�Ϊʵ�ź�
    fy=fy(1:y_num/2+1); %�󵥱߷�����
    fy(2:end-1)=2*fy(2:end-1); %��ʱ�õ�ԭ�źŵĸ���Ҷ�����źţ�Ҳ���ǳ�˵�ĸ���Ҷ�任����źţ�������Ҷ�任ͼ������ᣩ
    Energy=sum(fy.^2);
    f=fs*(0:y_num/2)/y_num; %�������Ҷ���ȶ�Ӧ��Ƶ�ʣ�������Ҷ�任ͼ��ĺ��ᣩ
    Power=Energy/f(end);
else 
    error("��ȷ������ʱ����������Ƶ������");
end