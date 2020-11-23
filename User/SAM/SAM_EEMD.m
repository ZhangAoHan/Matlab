function [varargout] = SAM_EEMD(varargin)
%% EEMD
%���룺x,Ȩ�أ�������Ӵ���
%% ���������ȡ
if nargin ~=3
    error('�����������ȷ');
else
    x=varargin{1};
    Nstd=varargin{2};
    NR=varargin{3};
    
    desvio_estandar=std(x);
    x=x/desvio_estandar;
    imf=EEMD_ZL(x,Nstd,NR);
end
%% �����������
imf=imf*desvio_estandar;

if nargin>0
    varargout{1}=imf;
end
end


function imf=EEMD_ZL(x,nstd,nr)
x_orign=x;
%% ��������
imf_m=1; %imf�ĸ���
imf=zeros(imf_m,length(x));
for i=1:nr
    x=x_orign+nstd*randn(1,length(x));
    eemd_imf=emd(x);
    eemd_imf=eemd_imf/nr;
    [eemd_imf,m,~]=SPT_ST(eemd_imf);
    %Ϊ��ֹÿ��IMF������һ�������д���
    if m>imf_m          %��һ�����ɵ�imf�������
        zero_num=m-imf_m;
        imf_m=m;  %���յ�IMF����������һ�α���һ��
        imf=[imf;zeros(zero_num,length(x))];
    else     %��һ�����ɵ�imf�����������
         zero_num=imf_m-m;
        eemd_imf=[eemd_imf;zeros(zero_num,length(x))];
    end
    imf=imf+eemd_imf;
end

end
