%掩蔽EMD程序
function memd_imf=SAM_MEMD(y)

maxiter = 100;
L = length(y);
dd=1:1:L;
t = 1:L;
am = max(y);
fm = 125;
sm = am*sin(2*pi*fm*t)'; %辅助噪声

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
        
        y = y - imf1; %残余信号
        
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
    %输入： 待筛选的时间序列，其实输入的是原数据和其标准差的比值+随机数（Nstd表示随机数的权重）
%输出： spmax 极大值的位置及其对应的值  spmax极小值的位置及其对应的值
%flag：好像某种标志量，正常设置为1  当有突然情况是设置为-1
flag=1;  
dsize=length(in_data);  %本程序中=1024

spmax(1,1) = 1;
spmax(1,2) = in_data(1); %spmax=[1，in_data]
jj=2;
kk=2;
while jj<dsize  %循环1024-2次
    if ( in_data(jj-1)<=in_data(jj) && in_data(jj)>=in_data(jj+1) )  %寻找极大值，并记录极大值的位置
        spmax(kk,1) = jj;  %记录极大值的位置
        spmax(kk,2) = in_data (jj);%记录极大值（数值）
        kk = kk+1;
    end
    jj=jj+1;
end
%spmax 最后会变成一个N*2的矩阵   N=in_data极大值的个数     其中spmax第一列表示极大值的位置，第二列表示极大值数值
spmax(kk,1)=dsize;  %spmax再扩展一行，改行第一列为1024  第二列为in_data最后一个数值
spmax(kk,2)=in_data(dsize);%到这来 已经完成了寻找极大值及极大值位置的工作

if kk>=4  %如果有超过2个极大值(极大值数量大于等于2)  此时极大值数量太大 需要进一步分解
    %强行将spmax的第二列的第一个数和最后一个数进行改变（原来应是输入数据的第一个和最后一个）
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
    flag=-1;  %如果极大值数量小于2个
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