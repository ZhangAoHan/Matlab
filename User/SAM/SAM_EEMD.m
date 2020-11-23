function [varargout] = SAM_EEMD(varargin)
%% EEMD
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
    imf=EEMD_ZL(x,Nstd,NR);
end
%% 输出参数整理
imf=imf*desvio_estandar;

if nargin>0
    varargout{1}=imf;
end
end


function imf=EEMD_ZL(x,nstd,nr)
x_orign=x;
%% 生成噪声
imf_m=1; %imf的个数
imf=zeros(imf_m,length(x));
for i=1:nr
    x=x_orign+nstd*randn(1,length(x));
    eemd_imf=emd(x);
    eemd_imf=eemd_imf/nr;
    [eemd_imf,m,~]=SPT_ST(eemd_imf);
    %为防止每次IMF数量不一样，进行处理
    if m>imf_m          %这一次生成的imf数量最多
        zero_num=m-imf_m;
        imf_m=m;  %最终的IMF数量与最多的一次保存一致
        imf=[imf;zeros(zero_num,length(x))];
    else     %这一次生成的imf数量不是最多
         zero_num=imf_m-m;
        eemd_imf=[eemd_imf;zeros(zero_num,length(x))];
    end
    imf=imf+eemd_imf;
end

end
