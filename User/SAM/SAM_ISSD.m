function [varargout]=SAM_ISSD(varargin)
if nargin==2
    y=varargin{1};
    Fs=varargin{2};
    Times=inf;
    draws="No";
elseif nargin==3
    y=varargin{1};
    Fs=varargin{2};
    Times=varargin{3};
    draws="No";
elseif nargin==4
    y=varargin{1};
    Fs=varargin{2};
    Times=varargin{3};
    draws=varargin{4};
end
%% 采用镜像延扩法解决端点效应
% N=length(y);
% L=ceil(N/4);
% yy=zeros(1,N+2*L);
% for i=1:L
%     yy(i)=y(L+1-i);
%     yy(L+N+i)=y(N+1-i);
% end
% yy(L+1:L+N)=y;
% y=yy;



%% AAPE-PCC-CAO-SSD
SSC_AAPE=0;
ssc=zeros(1,length(y));
Wc=1;
Res=y;
ZL_SSC=zeros(1,length(y));
ZL_SSC=ZL_SSC+mean(y);
y=y-mean(y);  %去均值后的原始信号

while SSC_AAPE<0.4 && Wc>0.01
   
    Res=Res-mean(Res);
    [SSC,~,Wc,ZL]=SAM_Cao_SSD(Res,Fs,1,draws);
    ZL_SSC=ZL_SSC+ZL;
    ssc=[ssc;SSC];     %存储结果
     Res=y-sum(ssc,1);  %每次都对残余分量进行分解
    SSC_AAPE=SA_AAPE(SSC,7) %最终也需要去掉最后一行
end

ssc=[ssc;Res]; 
ssc=ssc(2:end,:);
%% 提取直流分量
[~,ys_Energy]=SA_SE(y,Fs,'t');
[~,y_Energy]=SA_SE(ZL_SSC,Fs,'t');
if y_Energy/ys_Energy>0.01  %大于th 则认为直流分量为主分量
    ssc=[ZL_SSC;ssc];
end
%% 剔除多余数据
% ssc=ssc(:,L+1:L+N);
if nargout>0
    varargout{1}=ssc;
end  
end

function [varargout]= SAM_Cao_SSD(varargin)
%分解结果不包含残余分量
%输入：信号，采样频率，最大分解次数
warning off; %关闭警告

if nargin==2
    y=varargin{1};
    Fs=varargin{2};
    Times=inf;
    draws="No";
elseif nargin==3
    y=varargin{1};
    Fs=varargin{2};
    Times=varargin{3};
    draws="No";
elseif nargin==4
    y=varargin{1};
    Fs=varargin{2};
    Times=varargin{3};
    draws=varargin{4};
end
%输入： 待分解的时域信号y 信号采样频率  
 %%提取直流分量
ZL_SSC=zeros(1,length(y));



    k1=0;
    th=0.01;
    y=y(:)'; %强制变为行向量
    L=length(y);
     ZL_SSC=ZL_SSC+mean(y);
    y = y-mean(y); %将输入信号变为均值为0的向量，因为SSD针对的就是均值为0的向量

    if Fs/L <= 0.5
        lf = L;
    else
        lf = 2*Fs;
    end
    RR1=zeros(size(y)); %初始化输出
    orig = y;
    remen = 1;  %迭代停止标准
    testcond = 0;
    time=0;
    %% 首先提取直流分量
    
    while (remen > th && time<Times)
        time=time+1;
        k1 = k1+1;
        y = y-mean(y);  %输入信号均值向0逼近
         ZL_SSC=ZL_SSC+mean(y);
        v2=y;
        clear nmmt;
        [nmmt,ff] = pwelch(v2,[],[],4096,Fs);%求功率谱估计密度
        [~,in3] = max(nmmt);
        nmmt = nmmt';

        if ((k1 == 1) && (ff(in3)/Fs < 1e-3)) % 在第一次迭代中，如果最大PDS值/采样频率<阈值（10^-3），则认为残余量具有单调趋势，将嵌入维度M设置为N/3  否则 M=1.2*FS/最大PDS值
           %% 改进 针对低频分量
            l = floor(L/3);     %l就是嵌入维数    
            %下面开始重构SSC分量
            %先是重构轨迹矩阵
            M = zeros(L-(l-1), l);
            for k=1:L-(l-1)
                M(k,:) = v2(k:k+(l-1));
            end
            [U,S,V] = svd(M); %对M进行奇异值分解 M=U*S*V   U左奇异向量 S奇异值 V右奇异向量
            U(:,l+1:end) = [];
            S(l+1:end,:) = [];
            V(:,l+1:end) = [];

            rM = rot90(U(:,1)*S(1,:)*V');  %将数组旋转90°
            r = zeros(1,L);
            [~,m] = size(rM);
            for k=-(l-1):L-(l)
                r(k+l) = sum(diag(rM,k))/m;  
            end
                  
        else % 以后的运行中

            for cont = 1:2 %运行2次
                v2 = v2-mean(v2);
                [deltaf] = gaussfit_Cao_SSD(ff,nmmt'); % 高斯拟合
                % 带宽估计
                [~,iiii1] = min(abs(ff-(ff(in3)-deltaf)));
                [~,iiii2] = min(abs(ff-(ff(in3)+deltaf)));
              
%                  l = floor(Fs/ff(in3)*1.2);   %设定嵌入维度，可更改的地方
%%                     改进     
                    if Fs/ff(in3)<=20   %处理高频分量  要提高嵌入维数(选值必须大于33)
                        if ceil(5*Fs/ff(in3))- ceil(Fs/(ff(in3)*5))<20                    %防止处理低频分量时 数据点不够
                            a_m=ceil(0.5*Fs/ff(in3));
                            b_m=1;
                            c_m=a_m+19;
                        else
                            a_m=ceil(Fs/(ff(in3)*5));
                            b_m=ceil((ceil(5*Fs/ff(in3))-ceil(Fs/(ff(in3)*5)))/20);
                            c_m=ceil(5*Fs/ff(in3));
                        end
                    
                        

                    else              %处理低频分量  要降低嵌入维数
%                         a_m=ceil(Fs/ff(in3)*0.1);
%                         c_m=ceil(Fs/ff(in3)*1.1);
                        a_m=ceil(Fs/ff(in3)*0.1);
                        c_m=ceil(Fs/ff(in3)*1.1);
                        b_m=ceil((c_m-a_m)/20);
                    end
                     [l,DD1,dd1]=SA_Caos(v2,[a_m,b_m,c_m]);
                M=zeros(L, l);
                
                % M built with wrap-around
                for k=1:l
                    M(:,k)=[v2(end-k+2:end)'; v2(1:end-k+1)'];
                end

                [U,S,V] = svd(M,0);

                %选择主成分
                 if size(U,2)>l
                    yy = abs(fft(U(:,1:l),lf));
                else
                    yy = abs(fft(U,lf));
                end
                yy_n = size(yy,1);
                ff2 = (0:yy_n-1)*Fs/yy_n;
                yy(floor(yy_n/2)+1:end,:) = [];
                ff2(floor(length(ff2)/2)+1:end) = [];
                % %
                if size(U,2)>l
                    [~,ind1] = max(yy(:,1:l));
                else
                    [~,ind1] = max(yy);
                end

                ii2 = find(ff2(ind1)>ff(iiii1) & ff2(ind1)<ff(iiii2)); %0.31
                [~,indom] = min(abs(ff2-ff(in3)));
                [~, maxindom] = max(yy(indom,:));

                if isempty(ii2)
                    rM=U(:,1)*S(1,:)*V';
                else
                    if ii2(ii2==maxindom)
                        rM = U(:,ii2)*S(ii2,:)*V';
                    else
                        ii2 = [maxindom,ii2];
                        rM = U(:,ii2)*S(ii2,:)*V';
                    end
                end
                if cont == 2
                    vr = r;
                end

                [~,m] = size(rM);

                for k=-(L-1):0
                    kl = k+L;
                    if kl >= m
                        r(kl) = sum(diag(rM,k))/m;    
                    else
                        r(kl) = (sum(diag(rM,k))+sum(diag(rM,kl)))/m;
                    end
                end
                r = fliplr(r);

                if cont == 2 && r*(y-r)'<0 % check condition for convergence
                    r = vr;
                end
                v2 = r;
            end
            if strcmpi("Yes",draws)
                 figure
                 plot(DD1,dd1);
                 hold on
                set(gca, 'FontName', 'Times New Roman');
                xlabel('m');
                ylabel('E(m)');  
                for jk=1:length(DD1)-1
                    if DD1(jk)<=l && DD1(jk+1)>=l
                        knn=jk;
                    end
                end
                plot(DD1(knn),dd1(knn),'r*');
%                 text(DD1(knn),dd1(knn)*0.9,['BestPoint:','(',num2str(l),',',num2str(dd1(knn)),')']);
            end
        
        end
        
        RR1(k1,:) = (y*r'/(r*r'))*r;
        y=y-RR1(k1,:);  %残余信号
        remenold = remen;  
        if testcond  %如果达到停止条件？
            remen = sum((sum(RR1(stept:end,:),1)-orig2).^2)/(sum(orig2.^2));
            if k1 == stept+3
                break
            end
        else
            remen = sum((sum(RR1(1:end,:),1)-orig).^2)/(sum(orig.^2)); %残余信号与原信号之间的标准均方误差
        end
        % in rare cases, convergence becomes very slow; the algorithm is then
        % stopped if no real improvement in decomposition is detected (this is 
        % something to fix in future versions of SSD)
        if abs(remenold - remen)< 1e-3   %判断残余信号与原信号直接的标准均方误差，如果该值<自定义阈值th的0.01时，认为分解完成  否则将该残余信号当原信号继续分解
            testcond = 1;
            stept = k1+1;
            orig2 = y;
        end
     

    end
  
    if testcond
    fprintf('分解完成，残余信号与原始信号的均方误差能量为： %3.1f\n %',(1-sum((sum(RR1(1:end,:),1)-orig).^2)/(sum(orig.^2)))*100);
    end
%
    ftemp = (0:size(RR1,2)-1)*Fs/size(RR1,2);
    sprr = abs(fft(RR1'));
    [~,isprr] = max(sprr);
    fsprr = ftemp(isprr);
    [~,iord] = sort(fsprr,'descend');
    RR1 = RR1(iord,:);

    SSD_Output = RR1;

if nargout>0
    varargout{1}=SSD_Output;
end  
if nargout>1
    varargout{2}=y;
end
if nargout>2
    varargout{3}=remen;   %输出
end
if nargout>3
    varargout{4}=ZL_SSC;   %输出
end

end


function [deltaf, deltaf2] = gaussfit_Cao_SSD(ff,nmmt)
    [pks,lcs] = findpeaks(nmmt);
    [~,inpks] = sort(pks,'descend');
    in1 = lcs(inpks(1));
    in2 = lcs(inpks(2));

    is1 = find(nmmt(in1+1:end)<2/3*nmmt(in1),1,'first');
    is2 = find(nmmt(in2+1:end)<2/3*nmmt(in2),1,'first');

    estsig1 = abs(ff(in1)-ff(in1+is1));

    if isempty(is2) %isempty 确定数组是否为空
        estsig2 = 4*abs(ff(in1)-ff(in2));
    else
        estsig2 = abs(ff(in2)-ff(in2+is2));
    end

    ff_in1 = -((ff-ff(in1)).^2);
    ff_in2 = -((ff-ff(in2)).^2);
    ff_m_in1_in2 = -((ff-0.5*(ff(in1)+ff(in2))).^2);

    Phi = @(x)(nmmt-(x(1)*exp(ff_in1/(2*(x(4))^2))+x(2)*exp(ff_in2/(2*(x(5))^2))+x(3)*exp(ff_m_in1_in2/(2*(x(6))^2))));
    x0 = [nmmt(in1)/2 nmmt(in2)/2 nmmt(round(mean([in1,in2])))/4 estsig1 estsig2 4*abs(ff(in1)-ff(in2))];
    x=SAM_LMF(Phi,x0);

    deltaf = abs(x(4))*2.5;
    deltaf2 = abs(x(6));
end

