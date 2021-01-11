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
%����allmode = memd (Y)
% %
% ����һ��EMD/EEMD����
% %
% %������:
% % Y:�������ݣ���1-d����
% % Nstd:���������Y�ı�׼��֮��;
% % NE: EEMD�ĺ�����Ŀ
% %���:
% һ��N*(m+1)����ľ�������N������ĳ���
% ��m=fix(log2(N))-1����1��ԭʼ���ݣ���2��3����
% % m���ɸߵ��͵�imf, comlumn (m+1)��
% ʣ��ٷֱ�(��������)��
% %
% %ע��:
% Ӧ��ע�⣬��Nstd����Ϊ0,NE����Ϊ1ʱ
% �����˻�ΪEMD����(EMD Nstd = 0, NE = 1)
% �˴�������sift����=10��ֹͣ�������ܸı䡣
% %
% %������:
% %,Z���ͻ��˶�(2008)��
% %���ɾ���ģʽ�ֽ�:һ�������������ݷ���������
% %����Ӧ���ݷ����Ľ�չ����1��,��һ��1-41��
% %
% �����д��:���׻���
% %�Ľ�ע:�Ͽ�����������2009/03/04
% %
% ��δ�����������ѭ���������һ��ġ�
% % 1����ȡ���ݣ��ҳ���׼ƫ���std�ֽ���������
% % 2������TNMΪIMF�ܱ�š���eq1��
% % TNM2=TNM+2��ԭʼ���ݺͲв������TNM2��
% ��0��ֵ��TNM2����
% % 3����EEMD NE��- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -ѭ��EEMD��ʼ
% % 4���������
% % 5����ɸѡ֮ǰ������ʼֵ
% % 6����ʼ�ҵ�һ�����ʻ��һ�����֯(IMF) - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -���ʻ��һ�����֯(IMF)ѭ����ʼ
% % 7��ɸѡ�õ����ʻ��һ�����֯(IMF)��10��- - - - - - - - - - - - - - - - - - - - - - - - - - - -����ѭ���Ŀ�ʼ�ͽ���
% % 8������10��ɸѡ�����ǵõ���IMF
% % 9���������м�ȥIMF��������ͨ��ѭ���õ���һ��IMF
% % 6����,���еĻ���- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -���ʻ��һ�����֯(imf)ѭ������
% % 9������TNM IMFs�󣬲в�xend�������������
% % 3���ܽ᲻�ֽ�Ľ��- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -ѭ��EEMD����
% % 10����NE���ܺ��⣬std�ٳ˻�����
% %
% %Э��:��
% �������ͨ��������һάEEMD��̶�
% %ͣ������������
% %
% �йع���:��ֵ
% ����m�ļ��������һ��
function allmode=memd(Y)
maxiter = 100;
L = length(Y);
dd=1:1:L;
t = 1:L;
am = max(Y);
fm = 125;
sm = am*sin(2*pi*fm*t)'; %��������

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
        
        Y = Y - imf1; %�����ź�
        
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
        
       
