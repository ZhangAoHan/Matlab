
function [varargout] = SAM_GSSD(x,fs,aape_m,aape_th,Nstd,NR,ssc_num)
%% SSD�ĸĽ��㷨
%�Ľ�1���ı������ֹ��������������ģ̬�������߷ֽ⾫�ȣ����ͷֽ�������������������α������
%�Ľ�2���ֽ���룬����Ƶ���ϵ�ë��
global orgin_x;
global ssc_num;

if nargin<7
    ssc_num=0;
end
if nargin<6
    NR=100;
end
if nargin<5
    Nstd=0.2;
end
if nargin<4
    aape_th=0.35;
end
if nargin<3
    aape_m=6;
end
if nargin<2
    error("�����������ȷ����������2��������4��");
end
%varargout=ssc,
%% ����
%���ݱ�׼��
x=x(:)';
desvio_x=std(x);
x=x/desvio_x;
orgin_x=x;
%����AAPE_SSD
aape_ssc=AAPE_SSD(x,fs,aape_m,aape_th);
% ceemdan_AAPE_ssc=CEEMDANG_AAPE_SSD(x,fs,Nstd,NR,aape_th,aape_m);
% ceemdan_ssc=CEEMDAN_AAPE_SSD(x,fs,Nstd,NR,aape_th,aape_m);
%% ���
% ssc=ceemdan_AAPE_ssc*desvio_x;
ssc=aape_ssc*desvio_x;
if nargout > 0
    varargout{1} = ssc;
end
% if nargout > 1
%     varargout{2} = ssc2;
% end

end
%% AAPE_SSD
function aape_ssc=AAPE_SSD(aape_x,aape_fs,aape_m,aape_th) %�Ӳ����ź�
    global orgin_x;
    global ssc_num;
    [~,n]=size(aape_x);
    aape_ssc=zeros(1,n);
    SSC_AAPE=0;
    ssd_remen=1;
    num_ssc=1;
    while 1
        if ssc_num==0
            if SSC_AAPE>aape_th
                break;
            elseif ssd_remen<=0.001
                break;
            end
        else
            if num_ssc >ssc_num
            break;
            end
        end

        temp=zeros(1,n);
        temp=SAM_SSD(aape_x,aape_fs,1);
        aape_x=aape_x-temp;
        aape_ssc=[aape_ssc;temp];
        SSC_AAPE=SA_AAPE(temp,aape_m);%��������źŻ���������������ô���ֽ���ĵ�һ��SSC��Ȼ�ǻ��ҵ�
        ssd_remen = sum(aape_x.^2)/(sum(orgin_x.^2));%�̳�SSD�������ֹ��������ֹ�����źŵķֽ�
        num_ssc=num_ssc+1;
    end
    aape_ssc(end,:)=aape_ssc(end,:)+aape_x;
    aape_ssc=aape_ssc(2:end,:);
end

%% SVD��������׽���(����)
function svds_ssc=SVD_AAPE_SSD(svd_ssc) %�Ӳ����ź�
    [m,~]=size(svd_ssc);
    for i=1:m
        kk=1;
        ssc_this=svd_ssc(i,:);
        [svd_ssc(i,:),~]=SA_SVDS(svd_ssc(i,:));
        %�ж��Ƿ�����©
        res_svd=ssc_this-svd_ssc(i,:);
        while SA_PCC(res_svd,ssc_this)>=0.5 %����©
           [svd_yl,~]=SA_SVDS(res_svd);
           svd_ssc(i,:)=svd_ssc(i,:)+svd_yl;
           res_svd=res_svd-svd_yl;
           kk=kk+1;
        end
        kk
    end
    svds_ssc=svd_ssc;
end
%% �����������CEEMDAN��
function ceemdan_ssc=CEEMDAN_SSD(x,fs,Nstd,NR)
    aux=zeros(size(x));
    res_ssc=zeros(size(x));
%��������
    for i=1:NR/2
    white_noise{i}=randn(size(x));
    white_noise{i+NR/2}=-white_noise{i};
%     modes_white_noise{i}=SAM_SSD(white_noise{i},fs);
    modes_white_noise{i}=emd(white_noise{i})';
    modes_white_noise{i+NR/2}=-modes_white_noise{i};
    end
    ssc_num=11; %�涨SSC����������������Ҫ���������������滻��
%��һ�μ���
    for i=1:NR %calculates the first mode
    temp=x+Nstd*white_noise{i};
    [temp,ssd_res]=SAM_SSD(temp,fs,1);
%     temp=temp(1,:);
    aux=aux+temp/NR;
    res_ssc=res_ssc+ssd_res/NR;
    end
    res=res_ssc;
    modes=aux; %saves the first mode
    k=1;
    aux=zeros(size(x));
    acum=sum(modes,1);

    for j=1:ssc_num
        aux=zeros(size(x));
        res_ssc=zeros(size(x));
        for i=1:NR
        tamanio=size(modes_white_noise{i});
            if tamanio(1)>=k+1
                noise=modes_white_noise{i}(k,:);
                noise=noise/std(noise);
                noise=Nstd*noise;
                try
                    [temp,ssd_res]=SAM_SSD(res+std(res)*noise,fs,1);
                catch
                    temp=res-acum;
                    ssd_res=res-temp;
                    
                end
            else
                [temp,ssd_res]=SAM_SSD(res,fs,1);
            end
        aux=aux+temp/NR; 
        res_ssc=res_ssc+ssd_res/NR;
        end
        modes=[modes;aux];
        res=res_ssc;
        acum=sum(modes,1);
        k=k+1
    end
%     ceemdan_ssc=[modes;res];
ceemdan_ssc=modes;
end

%% ����������Ľ�CEEMDAN��
% function ceemdan_ssc=CEEMDANG_SSD(x,fs,Nstd,NR,aape_th,aape_m)
%     aux=zeros(size(x));
%     res_ssc=zeros(size(x));
%     modes=zeros(size(x));
% %��������
%     for i=1:NR/2
%     white_noise{i}=randn(size(x));
%     white_noise{i+NR/2}=-white_noise{i};
%     modes_white_noise{i}=SAM_SSD(white_noise{i},fs,10);
% %     modes_white_noise{i}=emd(white_noise{i})';
%     modes_white_noise{i+NR/2}=SAM_SSD(white_noise{i+NR/2},fs,10);
%     end
%     ssc_num=3; %�涨SSC����������������Ҫ���������������滻��
%     k=1;
%     res=x;
%     ssc_aape=0;
%     while ssc_aape < aape_th
%         aux=zeros(size(x));
%         res_ssc=zeros(size(x));
%          for i=1:NR
%             tamanio=size(modes_white_noise{i});
%             if tamanio(1)>=k+1
%                 noise=modes_white_noise{i}(k,:);
%                 noise=noise/std(noise);
%                 noise=Nstd*noise;
%                 [~,ssd_res]=SAM_SSD(res+std(res)*noise,fs,1);
%             else
%                 [~,ssd_res]=SAM_SSD(res,fs,1);
%             end
%             res_ssc=res_ssc+ssd_res/NR;
%         end
%         modes=[modes;res-res_ssc];
%         k=k+1
%         ssc_aape=SA_AAPE(res-res_ssc,aape_m)
%         res=res_ssc;
%     end
%     modes=modes(2:end,:);
%     modes(end,:)=modes(end,:)+res;
%     ceemdan_ssc=modes;
% end
%% CEEMDAN��AAPE-SSD
function ceemdan_AAPE_ssc=CEEMDAN_AAPE_SSD(x,fs,Nstd,NR,aape_th,aape_m)
    aux=zeros(size(x));
    res_ssc=zeros(size(x));
    ssc_aape=0;
%��������
    for i=1:NR
    white_noise{i}=randn(size(x));
%     white_noise{i+NR/2}=-white_noise{i};
%     modes_white_noise{i}=SAM_SSD(white_noise{i},fs,s_num);
    modes_white_noise{i}=SAM_EMD(white_noise{i});
%     modes_white_noise{i+NR/2}=-modes_white_noise{i};
    end
    
%��һ�μ���
    for i=1:NR %calculates the first mode
    temp=x+Nstd*white_noise{i};
    [temp,ssd_res]=SAM_SSD(temp,fs,1);
    aux=aux+temp/NR;
    res_ssc=res_ssc+ssd_res/NR;
    end
    res=res_ssc;
    modes=aux; %saves the first mode
    k=1;
    aux=zeros(size(x));
    acum=sum(modes,1);
    
    ssc_aape=SA_AAPE(modes,aape_m);
    while ssc_aape < aape_th
        aux=zeros(size(x));
        res_ssc=zeros(size(x));
        for i=1:NR
        tamanio=size(modes_white_noise{i});
            if tamanio(1)>=k+1
                noise=modes_white_noise{i}(k,:);
                noise=noise/std(noise);
                noise=Nstd*noise;
                try
                    [temp,ssd_res]=SAM_SSD(res+std(res)*noise,fs,1);
                catch
                    temp=res-acum;
                    ssd_res=res-temp;
                    
                end
            else
                [temp,ssd_res]=SAM_SSD(res,fs,1);
            end
        aux=aux+temp/NR; 
        res_ssc=res_ssc+ssd_res/NR;
        end
        modes=[modes;aux];
        res=res_ssc;
        acum=sum(modes,1);
        ssc_aape=SA_AAPE(aux,aape_m)
        k=k+1;
    end
    while SA_PCC(res,x) > 0.33
        ssc_pcc=SAM_SSD(res,fs,1);
        res=res-ssc_pcc;
        modes=[modes;ssc_pcc];
    end
    ceemdan_ssc=[modes;res];
    modes(end,:)=modes(end,:)+res;
    ceemdan_AAPE_ssc=modes;
end

%% CEEMDAN��AAPE-SSD
function ceemdan_AAPE_ssc=CEEMDANG_AAPE_SSD(x,fs,Nstd,NR,aape_th,aape_m)
    aux=zeros(size(x));
    res_ssc=zeros(size(x));
    ssc_aape=0;
%��������
    for i=1:NR
    white_noise{i}=randn(size(x));
%     white_noise{i+NR/2}=-white_noise{i};
%     modes_white_noise{i}=SAM_SSD(white_noise{i},fs,s_num);
%     modes_white_noise{i}=emd(white_noise{i})';
%     modes_white_noise{i+NR/2}=-modes_white_noise{i};
    end
    
%��һ�μ���
    for i=1:NR %calculates the first mode
    temp=x+Nstd*white_noise{i};
    [temp,ssd_res]=SAM_SSD(temp,fs,1);
    aux=aux+temp/NR;
    res_ssc=res_ssc+ssd_res/NR;
    end
    res=res_ssc;
    modes=aux; %saves the first mode
    k=2;
    aux=zeros(size(x));
    ssc_aape=SA_AAPE(modes,aape_m)
    while ssc_aape < aape_th
        aux=zeros(size(x));
        res_ssc=zeros(size(x));
        for i=1:NR
        noise=SAM_SSD(white_noise{i},fs,k);
        noise=noise(1,:);
        noise=noise/std(noise);
        noise=Nstd*noise;

        [temp,ssd_res]=SAM_SSD(res+std(res)*noise,fs,1);
        aux=aux+temp/NR; 
        res_ssc=res_ssc+ssd_res/NR;
        end
        modes=[modes;aux];
        res=res_ssc;
        acum=sum(modes,1);
        ssc_aape=SA_AAPE(aux,aape_m)
        k=k+1;
    end
    while SA_PCC(res,x) > 0.33
        ssc_pcc=SAM_SSD(res,fs,1);
        res=res-ssc_pcc;
        modes=[modes;ssc_pcc];
    end
    ceemdan_ssc=[modes;res];
    modes(end,:)=modes(end,:)+res;
    ceemdan_AAPE_ssc=modes;
end