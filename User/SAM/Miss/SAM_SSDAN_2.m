function ssc = SAM_SSDAN_2(x,fs)%�Աȳ���

%�ڷֽ��������Ӹ�˹�����������Ҹ���AAPEֵ��Ϊ�ֽ�ֹͣ����   ĩβ����Ϊ�������
%ĩβ�������ǲ����ź�
%���룺�źţ��ź�Ƶ�ʣ�����Ȩ�أ�ÿ���ֽ���� 
%���������ݱ�׼��
x=x(:)';
desvio_x=std(x);
x=x/desvio_x;
x_aape=x;
modes=zeros(size(x));
SSC_AAPE=0;
clear temp;
while SSC_AAPE<0.4 
%     aux=zeros(size(x));
%     for i=1:NR
%     white_noise{i}=randn(size(x));%creates the noise realizations
%     end
%     for i=1:NR   %�ó�һ��SSC��aux
%         temp=x+Nstd*white_noise{i};
%         temp=SAM_SSD(temp,fs,1);
%         aux=aux+temp/NR;
%     end
     aux=SAM_SSD(x,fs,1);  %��֤��������
    modes=[modes;aux];  %������Ҫȥ����һ�е�0��
    acum=sum(modes,1);
    x=x_aape-acum;  %�õ�ģ̬֮��Ĳ������
    SSC_AAPE=SA_AAPE(aux,5) %����Ҳ��Ҫȥ�����һ��
end
modes=modes(2:end,:);  %�����ź�+���Ĳ����ź�
ssc=modes*desvio_x;