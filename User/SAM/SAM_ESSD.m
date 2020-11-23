function ssc = SAM_ESSD(x,fs,Nstd,NR,aapeth)
%�ڷֽ��������Ӹ�˹�����������Ҹ���ssd�ֽ�ֹͣ����   ĩβ����Ϊ�������
%ĩβ�������ǲ����ź�
%���룺�źţ��ź�Ƶ�ʣ�����Ȩ�أ�ÿ���ֽ���� 
%���������ݱ�׼��
x=x(:)';
desvio_x=std(x);
x=x/desvio_x;
oring_x=x;
x_res=zeros(1,length(x));
modes=zeros(size(x));
SSC_AAPE=0;
clear temp;
if nargin==4
    aapeth=0.4;
end
    for i=1:NR/2
    white_noise{i}=randn(size(x));%creates the noise realizations
    white_noise{i+NR/2}=-white_noise{i};
    end
while SSC_AAPE<aapeth
    x_res=zeros(1,length(x));
    aux=zeros(1,length(x));

    for i=1:NR   %�ó�һ��SSC��aux
        temp=x+Nstd*(std(x)/std(white_noise{i}))*white_noise{i};
        temp=SAM_SSD(temp,fs,1);
        x_res=x_res+(x-temp)/NR;
        aux=aux+temp/NR;
    end
%     aux=SAM_SSD(x,fs,1);  %��֤��������
    modes=[modes;aux];  %������Ҫȥ����һ�е�0��
%     x=x_aape-acum;  %�õ�ģ̬֮��Ĳ������
    x=x_res;
    SSC_AAPE=SA_AAPE(aux,7); %����Ҳ��Ҫȥ�����һ��
end
    while SA_PCC(oring_x,x) > 0.5
        ssc_pcc=SAM_SSD(x,fs,1);
        x=x-ssc_pcc;
        modes=[modes;ssc_pcc];
    end
modes=modes(2:end,:);  %�����ź�+���Ĳ����ź�
modes=[modes;x];
ssc=modes*desvio_x;