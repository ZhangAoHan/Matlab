%function allmode=memd(Y)
%
% This is an EMD/EEMD program
%
% INPUT:
%       Y: Inputted data;1-d data only
%       Nstd: ratio of the standard deviation of the added noise and that of Y;
%       NE: Ensemble number for the EEMD
% OUTPUT:
%       A matrix of N*(m+1) matrix, where N is the length of the input
%       data Y, and m=fix(log2(N))-1. Column 1 is the original data, columns 2, 3, ...
%       m are the IMFs from high to low frequency, and comlumn (m+1) is the
%       residual (over all trend).
%
% NOTE:
%       It should be noted that when Nstd is set to zero and NE is set to 1, the
%       program degenerates to a EMD program.(for EMD Nstd=0,NE=1)
%       This code limited sift number=10 ,the stoppage criteria can't change. 
%
% References:   
%  Wu, Z., and N. E Huang (2008), 
%  Ensemble Empirical Mode Decomposition: a noise-assisted data analysis method. 
%   Advances in Adaptive Data Analysis. Vol.1, No.1. 1-41.  
%
% code writer: Zhaohua Wu. 
% footnote:S.C.Su 2009/03/04
%
% There are three loops in this code coupled together.
%  1.read data, find out standard deviation ,devide all data by std
%  2.evaluate TNM as total IMF number--eq1. 
%    TNM2=TNM+2,original data and residual included in TNM2
%    assign 0 to TNM2 matrix
%  3.Do EEMD NE times-------------------------------------------------------------loop EEMD start
%     4.add noise
%     5.give initial values before sift 
%     6.start to find an IMF------------------------------------------------IMF loop start
%     7.sift 10 times to get IMF--------------------------sift loop  start  and end
%     8.after 10 times sift --we got IMF
%     9.subtract IMF from data ,and let the residual to find next IMF by loop
%     6.after having all the IMFs---------------------------------------------IMF loop end
%     9.after TNM IMFs ,the residual xend is over all trend
%  3.Sum up NE decomposition result-------------------------------------------------loop EEMD end
% 10.Devide EEMD summation by NE,std be multiply back to data
%
% Association: no
% this function ususally used for doing 1-D EEMD with fixed 
% stoppage criteria independently.
%
% Concerned function: extrema.m 
%                     above mentioned m file must be put together
%函数allmode = memd (Y)
% %
% 这是一个EMD/EEMD程序
% %
% %的输入:
% % Y:输入数据，仅1-d数据
% % Nstd:添加噪声与Y的标准差之比;
% % NE: EEMD的合奏曲目
% %输出:
% 一个N*(m+1)矩阵的矩阵，其中N是输入的长度
% 和m=fix(log2(N))-1。列1是原始数据，列2、3、…
% % m是由高到低的imf, comlumn (m+1)是
% 剩余百分比(总体趋势)。
% %
% %注意:
% 应该注意，当Nstd设置为0,NE设置为1时
% 程序退化为EMD程序。(EMD Nstd = 0, NE = 1)
% 此代码限制sift数量=10，停止条件不能改变。
% %
% %的引用:
% %,Z。和黄乃娥(2008)，
% %集成经验模式分解:一种噪声辅助数据分析方法。
% %自适应数据分析的进展。第1卷,第一。1-41。
% %
% 代码编写者:吴兆华。
% %的脚注:南卡罗莱纳州苏2009/03/04
% %
% 这段代码中有三个循环是耦合在一起的。
% % 1。读取数据，找出标准偏差，用std分解所有数据
% % 2。计算TNM为IMF总编号——eq1。
% % TNM2=TNM+2，原始数据和残差包含在TNM2中
% 将0赋值给TNM2矩阵
% % 3。做EEMD NE次- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -循环EEMD开始
% % 4。添加噪声
% % 5。在筛选之前给出初始值
% % 6。开始找到一个国际货币基金组织(IMF) - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -国际货币基金组织(IMF)循环开始
% % 7。筛选得到国际货币基金组织(IMF)的10倍- - - - - - - - - - - - - - - - - - - - - - - - - - - -过滤循环的开始和结束
% % 8。经过10次筛选，我们得到了IMF
% % 9。从数据中减去IMF，让余项通过循环得到下一个IMF
% % 6。后,所有的货币- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -国际货币基金组织(imf)循环结束
% % 9。经过TNM IMFs后，残差xend总体呈上升趋势
% % 3。总结不分解的结果- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -循环EEMD结束
% % 10。除NE的总和外，std再乘回数据
% %
% %协会:不
% 这个函数通常用于做一维EEMD与固定
% %停机条件独立。
% %
% 有关功能:极值
% 上述m文件必须放在一起
function allmode=memd(Y)
maxiter = 100;
L = length(Y);
dd=1:1:L;
t = 1:L;
am = max(Y);
fm = 125;
sm = am*sin(2*pi*fm*t)'; %辅助噪声

    x_add = Y + sm;
    x_minus = Y - sm;
    iter = 1;
        while iter<=maxiter,
            [spmax, spmin, flag]=extrema(x_add);  %call function extrema 
            %the usage of  spline ,please see part11.  
            upper= spline(spmax(:,1),spmax(:,2),dd); %upper spline bound of this sift 
            lower= spline(spmin(:,1),spmin(:,2),dd); %lower spline bound of this sift 
            mean_ul_add = (upper + lower)/2;%spline mean of upper and lower  
            x_add = x_add - mean_ul_add';%extract spline mean from Xstart
            iter = iter +1;
        end
        iter = 1;
        while iter<=maxiter,
            [spmax, spmin, flag]=extrema(x_minus);  %call function extrema 
            %the usage of  spline ,please see part11.  
            upper= spline(spmax(:,1),spmax(:,2),dd); %upper spline bound of this sift 
            lower= spline(spmin(:,1),spmin(:,2),dd); %lower spline bound of this sift 
            mean_ul_minus = (upper + lower)/2;%spline mean of upper and lower          
            x_minus = x_minus - mean_ul_minus';%extract spline mean from Xstart
            iter = iter +1;
        end
        mean_ul = (x_add + x_minus) / 2;
        imf1 = mean_ul;
        
        Y = Y - imf1; %残余信号
        
        am = max(Y);
        fm = 75;
        sm = am*sin(2*pi*fm*t)';

    x_add = Y + sm;
    x_minus = Y - sm;
    iter = 1;
        while iter<=maxiter,
            [spmax, spmin, flag]=extrema(x_add);  %call function extrema 
            %the usage of  spline ,please see part11.  
            upper= spline(spmax(:,1),spmax(:,2),dd); %upper spline bound of this sift 
            lower= spline(spmin(:,1),spmin(:,2),dd); %lower spline bound of this sift 
            mean_ul_add = (upper + lower)/2;%spline mean of upper and lower  
            x_add = x_add - mean_ul_add';%extract spline mean from Xstart
            iter = iter +1;
        end
        iter = 1;
        while iter<=maxiter,
            [spmax, spmin, flag]=extrema(x_minus);  %call function extrema 
            %the usage of  spline ,please see part11.  
            upper= spline(spmax(:,1),spmax(:,2),dd); %upper spline bound of this sift 
            lower= spline(spmin(:,1),spmin(:,2),dd); %lower spline bound of this sift 
            mean_ul_minus = (upper + lower)/2;%spline mean of upper and lower          
            x_minus = x_minus - mean_ul_minus';%extract spline mean from Xstart
            iter = iter +1;
        end
        mean_ul = (x_add + x_minus) / 2;
        imf2 = mean_ul;
        
        Y = Y - imf2;
        am = max(Y);
        fm = 50;
        sm = am*sin(2*pi*fm*t)';

    x_add = Y + sm;
    x_minus = Y - sm;
    iter = 1;
        while iter<=maxiter,
            [spmax, spmin, flag]=extrema(x_add);  %call function extrema 
            %the usage of  spline ,please see part11.  
            upper= spline(spmax(:,1),spmax(:,2),dd); %upper spline bound of this sift 
            lower= spline(spmin(:,1),spmin(:,2),dd); %lower spline bound of this sift 
            mean_ul_add = (upper + lower)/2;%spline mean of upper and lower  
            x_add = x_add - mean_ul_add';%extract spline mean from Xstart
            iter = iter +1;
        end
        iter = 1;
        while iter<=maxiter,
            [spmax, spmin, flag]=extrema(x_minus);  %call function extrema 
            %the usage of  spline ,please see part11.  
            upper= spline(spmax(:,1),spmax(:,2),dd); %upper spline bound of this sift 
            lower= spline(spmin(:,1),spmin(:,2),dd); %lower spline bound of this sift 
            mean_ul_minus = (upper + lower)/2;%spline mean of upper and lower          
            x_minus = x_minus - mean_ul_minus';%extract spline mean from Xstart
            iter = iter +1;
        end
        mean_ul = (x_add + x_minus) / 2;
        imf3 = mean_ul;
        
        
        allmode = [imf1,imf2,imf3];
        
       
