function [varargout] = SAM_CEEMD(varargin)
%% CEEMD
%输入：x,权重，噪声添加次数
%% 输入参数提取
if nargin ~=3
    error('输入参数不正确');
else
    x=varargin{1};
    Nstd=varargin{2};
    NR=varargin{3};
    
    desvio_estandar=std(x);
    x=x/desvio_estandar;
    imf=CEEMD_ZL(x,Nstd,NR);
end

%% 输出参数整理
imf=imf*desvio_estandar;

if nargin>0
    varargout{1}=imf;
end
end

function imf=CEEMD_ZL(x,nstd,nr)
x_oring=x;
imf_f_m=1; %imf的个数
imf_z_m=1; %imf的个数
imff=zeros(imf_f_m,length(x));
imfz=zeros(imf_z_m,length(x));
    for i=1:nr
        temp=nstd*randn(1,length(x_oring));
        %处理负
        x_f_noise=x_oring-temp;
        imf_f=emd(x_f_noise);
        imf_f=imf_f/nr;
        [imf_f,m_f,~]=SPT_ST(imf_f);
            %为防止每次IMF数量不一样，进行处理
        if m_f>imf_f_m          %这一次生成的imf数量最多
            zero_num=m_f-imf_f_m;
            imf_f_m=m_f;  %最终的IMF数量与最多的一次保存一致
            imff=[imff;zeros(zero_num,length(x))];
        else     %这一次生成的imf数量不是最多
             zero_num=imf_f_m-m_f;
            imf_f=[imf_f;zeros(zero_num,length(x))];
        end
        imff=imff+imf_f;
        %处理正
        x_z_noise=x_oring+temp;
        imf_z=emd(x_z_noise);
        imf_z=imf_z/nr;
        [imf_z,m_z,~]=SPT_ST(imf_z);
            %为防止每次IMF数量不一样，进行处理
        if m_z>imf_z_m          %这一次生成的imf数量最多
            zero_num=m_z-imf_z_m;
            imf_z_m=m_z;  %最终的IMF数量与最多的一次保存一致
            imfz=[imfz;zeros(zero_num,length(x))];
        else     %这一次生成的imf数量不是最多
             zero_num=imf_z_m-m_z;
            imf_z=[imf_z;zeros(zero_num,length(x))];
        end
        imfz=imfz+imf_z;
    end
    %处理完后，再将二组IMF进行集成
    [ceemd_f,~]=size(imff);
    [ceemd_z,~]=size(imfz);
    if ceemd_f>ceemd_z
        zero_num=ceemd_f-ceemd_z;
        imfz=[imfz;zeros(zero_num,length(x));];
    else
        zero_num=ceemd_z-ceemd_f;
        imff=[imff;zeros(zero_num,length(x));];
    end
    imf=(imff+imfz)/2;
end
