function [varargout] = SAM_CESSD(varargin)
%% CEEMD
%���룺x,Ȩ�أ�������Ӵ���
%% ���������ȡ
if nargin ~=4
    error('�����������ȷ');
else
    x=varargin{1};
    fs=varargin{2};
    Nstd=varargin{3};
    NR=varargin{4};
    
    desvio_estandar=std(x);
    x=x/desvio_estandar;
    ssc=CESSD_ZL(x,fs,Nstd,NR);
end

%% �����������
ssc=ssc*desvio_estandar;

if nargin>0
    varargout{1}=ssc;
end
end

function imf=CESSD_ZL(x,fs,nstd,nr)
x_oring=x;
imf_f_m=1; %imf�ĸ���
imf_z_m=1; %imf�ĸ���
imff=zeros(imf_f_m,length(x));
imfz=zeros(imf_z_m,length(x));
    for i=1:nr
        temp=nstd*randn(1,length(x_oring));
        %����
        x_f_noise=x_oring-temp;
        imf_f=SAM_SSD(x_f_noise,fs,5);
        imf_f=imf_f/nr;
        [imf_f,m_f,~]=SPT_ST(imf_f);
            %Ϊ��ֹÿ��IMF������һ�������д���
        if m_f>imf_f_m          %��һ�����ɵ�imf�������
            zero_num=m_f-imf_f_m;
            imf_f_m=m_f;  %���յ�IMF����������һ�α���һ��
            imff=[imff;zeros(zero_num,length(x))];
        else     %��һ�����ɵ�imf�����������
             zero_num=imf_f_m-m_f;
            imf_f=[imf_f;zeros(zero_num,length(x))];
        end
        imff=imff+imf_f;
        %������
        x_z_noise=x_oring+temp;
        imf_z=SAM_SSD(x_z_noise,fs,5);
        imf_z=imf_z/nr;
        [imf_z,m_z,~]=SPT_ST(imf_z);
            %Ϊ��ֹÿ��IMF������һ�������д���
        if m_z>imf_z_m          %��һ�����ɵ�imf�������
            zero_num=m_z-imf_z_m;
            imf_z_m=m_z;  %���յ�IMF����������һ�α���һ��
            imfz=[imfz;zeros(zero_num,length(x))];
        else     %��һ�����ɵ�imf�����������
             zero_num=imf_z_m-m_z;
            imf_z=[imf_z;zeros(zero_num,length(x))];
        end
        imfz=imfz+imf_z;
    end
    %��������ٽ�����IMF���м���
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
