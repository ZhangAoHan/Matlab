%�ڱ�EMD����
function memd_imf=SAM_MEMD(y)

maxiter = 100;
L = length(y);
dd=1:1:L;
t = 1:L;
am = max(y);
fm = 125;
sm = am*sin(2*pi*fm*t)'; %��������

    x_add = y + sm;                                                                                                                                                           
    x_minus = y - sm;
    iter = 1;
        while iter<=maxiter
            [spmax, spmin, flag]=eemd_extrema(x_add);  %call function extrema 
            %the usage of  spline ,please see part11.  
            upper= spline(spmax(:,1),spmax(:,2),dd); %upper spline bound of this sift 
            lower= spline(spmin(:,1),spmin(:,2),dd); %lower spline bound of this sift 
            mean_ul_add = (upper + lower)/2;%spline mean of upper and lower  
            x_add = x_add - mean_ul_add';%extract spline mean from Xstart
            iter = iter +1;
        end
        iter = 1;
        while iter<=maxiter
            [spmax, spmin, flag]=eemd_extrema(x_minus);  %call function extrema 
            %the usage of  spline ,please see part11.  
            upper= spline(spmax(:,1),spmax(:,2),dd); %upper spline bound of this sift 
            lower= spline(spmin(:,1),spmin(:,2),dd); %lower spline bound of this sift 
            mean_ul_minus = (upper + lower)/2;%spline mean of upper and lower          
            x_minus = x_minus - mean_ul_minus';%extract spline mean from Xstart
            iter = iter +1;
        end
        mean_ul = (x_add + x_minus) / 2;
        imf1 = mean_ul;
        
        y = y - imf1; %�����ź�
        
        am = max(y);
        fm = 75;
        sm = am*sin(2*pi*fm*t)';

    x_add = y + sm;
    x_minus = y - sm;
    iter = 1;
        while iter<=maxiter
            [spmax, spmin, flag]=eemd_extrema(x_add);  %call function extrema 
            %the usage of  spline ,please see part11.  
            upper= spline(spmax(:,1),spmax(:,2),dd); %upper spline bound of this sift 
            lower= spline(spmin(:,1),spmin(:,2),dd); %lower spline bound of this sift 
            mean_ul_add = (upper + lower)/2;%spline mean of upper and lower  
            x_add = x_add - mean_ul_add';%extract spline mean from Xstart
            iter = iter +1;
        end
        iter = 1;
        while iter<=maxiter
            [spmax, spmin, flag]=eemd_extrema(x_minus);  %call function extrema 
            %the usage of  spline ,please see part11.  
            upper= spline(spmax(:,1),spmax(:,2),dd); %upper spline bound of this sift 
            lower= spline(spmin(:,1),spmin(:,2),dd); %lower spline bound of this sift 
            mean_ul_minus = (upper + lower)/2;%spline mean of upper and lower          
            x_minus = x_minus - mean_ul_minus';%extract spline mean from Xstart
            iter = iter +1;
        end
        mean_ul = (x_add + x_minus) / 2;
        imf2 = mean_ul;
        
        y = y - imf2;
        am = max(y);
        fm = 50;
        sm = am*sin(2*pi*fm*t)';

    x_add = y + sm;
    x_minus = y - sm;
    iter = 1;
        while iter<=maxiter
            [spmax, spmin, flag]=eemd_extrema(x_add);  %call function extrema 
            %the usage of  spline ,please see part11.  
            upper= spline(spmax(:,1),spmax(:,2),dd); %upper spline bound of this sift 
            lower= spline(spmin(:,1),spmin(:,2),dd); %lower spline bound of this sift 
            mean_ul_add = (upper + lower)/2;%spline mean of upper and lower  
            x_add = x_add - mean_ul_add';%extract spline mean from Xstart
            iter = iter +1;
        end
        iter = 1;
        while iter<=maxiter
            [spmax, spmin, flag]=eemd_extrema(x_minus);  %call function extrema 
            %the usage of  spline ,please see part11.  
            upper= spline(spmax(:,1),spmax(:,2),dd); %upper spline bound of this sift 
            lower= spline(spmin(:,1),spmin(:,2),dd); %lower spline bound of this sift 
            mean_ul_minus = (upper + lower)/2;%spline mean of upper and lower          
            x_minus = x_minus - mean_ul_minus';%extract spline mean from Xstart
            iter = iter +1;
        end
        mean_ul = (x_add + x_minus) / 2;
        imf3 = mean_ul;
        
        
        memd_imf = [imf1,imf2,imf3];
end

function [spmax, spmin, flag]= eemd_extrema(in_data)
    %���룺 ��ɸѡ��ʱ�����У���ʵ�������ԭ���ݺ����׼��ı�ֵ+�������Nstd��ʾ�������Ȩ�أ�
%����� spmax ����ֵ��λ�ü����Ӧ��ֵ  spmax��Сֵ��λ�ü����Ӧ��ֵ
%flag������ĳ�ֱ�־������������Ϊ1  ����ͻȻ���������Ϊ-1
flag=1;  
dsize=length(in_data);  %��������=1024

spmax(1,1) = 1;
spmax(1,2) = in_data(1); %spmax=[1��in_data]
jj=2;
kk=2;
while jj<dsize  %ѭ��1024-2��
    if ( in_data(jj-1)<=in_data(jj) && in_data(jj)>=in_data(jj+1) )  %Ѱ�Ҽ���ֵ������¼����ֵ��λ��
        spmax(kk,1) = jj;  %��¼����ֵ��λ��
        spmax(kk,2) = in_data (jj);%��¼����ֵ����ֵ��
        kk = kk+1;
    end
    jj=jj+1;
end
%spmax ������һ��N*2�ľ���   N=in_data����ֵ�ĸ���     ����spmax��һ�б�ʾ����ֵ��λ�ã��ڶ��б�ʾ����ֵ��ֵ
spmax(kk,1)=dsize;  %spmax����չһ�У����е�һ��Ϊ1024  �ڶ���Ϊin_data���һ����ֵ
spmax(kk,2)=in_data(dsize);%������ �Ѿ������Ѱ�Ҽ���ֵ������ֵλ�õĹ���

if kk>=4  %����г���2������ֵ(����ֵ�������ڵ���2)  ��ʱ����ֵ����̫�� ��Ҫ��һ���ֽ�
    %ǿ�н�spmax�ĵڶ��еĵ�һ���������һ�������иı䣨ԭ��Ӧ���������ݵĵ�һ�������һ����
    slope1=(spmax(2,2)-spmax(3,2))/(spmax(2,1)-spmax(3,1));
    tmp1=slope1*(spmax(1,1)-spmax(2,1))+spmax(2,2);
    if tmp1>spmax(1,2)
        spmax(1,2)=tmp1;
    end

    slope2=(spmax(kk-1,2)-spmax(kk-2,2))/(spmax(kk-1,1)-spmax(kk-2,1));
    tmp2=slope2*(spmax(kk,1)-spmax(kk-1,1))+spmax(kk-1,2);
    if tmp2>spmax(kk,2)
        spmax(kk,2)=tmp2;
    end
else
    flag=-1;  %�������ֵ����С��2��
end


msize=size(in_data);
dsize=max(msize);
xsize=dsize/3;
xsize2=2*xsize;

spmin(1,1) = 1;
spmin(1,2) = in_data(1);
jj=2;
kk=2;
while jj<dsize
    if ( in_data(jj-1)>=in_data(jj) && in_data(jj)<=in_data(jj+1))
        spmin(kk,1) = jj;
        spmin(kk,2) = in_data (jj);
        kk = kk+1;
    end
    jj=jj+1;
end
spmin(kk,1)=dsize;
spmin(kk,2)=in_data(dsize);

if kk>=4
    slope1=(spmin(2,2)-spmin(3,2))/(spmin(2,1)-spmin(3,1));
    tmp1=slope1*(spmin(1,1)-spmin(2,1))+spmin(2,2);
    if tmp1<spmin(1,2)
        spmin(1,2)=tmp1;
    end

    slope2=(spmin(kk-1,2)-spmin(kk-2,2))/(spmin(kk-1,1)-spmin(kk-2,1));
    tmp2=slope2*(spmin(kk,1)-spmin(kk-1,1))+spmin(kk-1,2);
    if tmp2<spmin(kk,2)
        spmin(kk,2)=tmp2;
    end
else
    flag=-1;
end

flag=1;
end