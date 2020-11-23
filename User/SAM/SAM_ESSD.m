function ssc = SAM_ESSD(x,fs,Nstd,NR,aapeth)
%在分解过程中添加高斯白噪声，并且根据ssd分解停止条件   末尾分量为残余分量
%末尾分量就是残余信号
%输入：信号，信号频率，噪声权重，每级分解次数 
%将输入数据标准化
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

    for i=1:NR   %得出一个SSC，aux
        temp=x+Nstd*(std(x)/std(white_noise{i}))*white_noise{i};
        temp=SAM_SSD(temp,fs,1);
        x_res=x_res+(x-temp)/NR;
        aux=aux+temp/NR;
    end
%     aux=SAM_SSD(x,fs,1);  %验证不加噪声
    modes=[modes;aux];  %最终需要去掉第一行的0行
%     x=x_aape-acum;  %得到模态之后的残余误差
    x=x_res;
    SSC_AAPE=SA_AAPE(aux,7); %最终也需要去掉最后一行
end
    while SA_PCC(oring_x,x) > 0.5
        ssc_pcc=SAM_SSD(x,fs,1);
        x=x-ssc_pcc;
        modes=[modes;ssc_pcc];
    end
modes=modes(2:end,:);  %有用信号+最后的残余信号
modes=[modes;x];
ssc=modes*desvio_x;