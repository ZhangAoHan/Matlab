function ssc = SAM_SSDAN_2(x,fs)%对比程序

%在分解过程中添加高斯白噪声，并且根据AAPE值作为分解停止条件   末尾分量为残余分量
%末尾分量就是残余信号
%输入：信号，信号频率，噪声权重，每级分解次数 
%将输入数据标准化
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
%     for i=1:NR   %得出一个SSC，aux
%         temp=x+Nstd*white_noise{i};
%         temp=SAM_SSD(temp,fs,1);
%         aux=aux+temp/NR;
%     end
     aux=SAM_SSD(x,fs,1);  %验证不加噪声
    modes=[modes;aux];  %最终需要去掉第一行的0行
    acum=sum(modes,1);
    x=x_aape-acum;  %得到模态之后的残余误差
    SSC_AAPE=SA_AAPE(aux,5) %最终也需要去掉最后一行
end
modes=modes(2:end,:);  %有用信号+最后的残余信号
ssc=modes*desvio_x;