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
%% ���þ�������������˵�ЧӦ
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
y=y-mean(y);  %ȥ��ֵ���ԭʼ�ź�

while SSC_AAPE<0.4 && Wc>0.01
   
    Res=Res-mean(Res);
    [SSC,~,Wc,ZL]=SAM_Cao_SSD(Res,Fs,1,draws);
    ZL_SSC=ZL_SSC+ZL;
    ssc=[ssc;SSC];     %�洢���
     Res=y-sum(ssc,1);  %ÿ�ζ��Բ���������зֽ�
    SSC_AAPE=SA_AAPE(SSC,7) %����Ҳ��Ҫȥ�����һ��
end

ssc=[ssc;Res]; 
ssc=ssc(2:end,:);
%% ��ȡֱ������
[~,ys_Energy]=SA_SE(y,Fs,'t');
[~,y_Energy]=SA_SE(ZL_SSC,Fs,'t');
if y_Energy/ys_Energy>0.01  %����th ����Ϊֱ������Ϊ������
    ssc=[ZL_SSC;ssc];
end
%% �޳���������
% ssc=ssc(:,L+1:L+N);
if nargout>0
    varargout{1}=ssc;
end  
end

function [varargout]= SAM_Cao_SSD(varargin)
%�ֽ����������������
%���룺�źţ�����Ƶ�ʣ����ֽ����
warning off; %�رվ���

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
%���룺 ���ֽ��ʱ���ź�y �źŲ���Ƶ��  
 %%��ȡֱ������
ZL_SSC=zeros(1,length(y));



    k1=0;
    th=0.01;
    y=y(:)'; %ǿ�Ʊ�Ϊ������
    L=length(y);
     ZL_SSC=ZL_SSC+mean(y);
    y = y-mean(y); %�������źű�Ϊ��ֵΪ0����������ΪSSD��Եľ��Ǿ�ֵΪ0������

    if Fs/L <= 0.5
        lf = L;
    else
        lf = 2*Fs;
    end
    RR1=zeros(size(y)); %��ʼ�����
    orig = y;
    remen = 1;  %����ֹͣ��׼
    testcond = 0;
    time=0;
    %% ������ȡֱ������
    
    while (remen > th && time<Times)
        time=time+1;
        k1 = k1+1;
        y = y-mean(y);  %�����źž�ֵ��0�ƽ�
         ZL_SSC=ZL_SSC+mean(y);
        v2=y;
        clear nmmt;
        [nmmt,ff] = pwelch(v2,[],[],4096,Fs);%�����׹����ܶ�
        [~,in3] = max(nmmt);
        nmmt = nmmt';

        if ((k1 == 1) && (ff(in3)/Fs < 1e-3)) % �ڵ�һ�ε����У�������PDSֵ/����Ƶ��<��ֵ��10^-3��������Ϊ���������е������ƣ���Ƕ��ά��M����ΪN/3  ���� M=1.2*FS/���PDSֵ
           %% �Ľ� ��Ե�Ƶ����
            l = floor(L/3);     %l����Ƕ��ά��    
            %���濪ʼ�ع�SSC����
            %�����ع��켣����
            M = zeros(L-(l-1), l);
            for k=1:L-(l-1)
                M(k,:) = v2(k:k+(l-1));
            end
            [U,S,V] = svd(M); %��M��������ֵ�ֽ� M=U*S*V   U���������� S����ֵ V����������
            U(:,l+1:end) = [];
            S(l+1:end,:) = [];
            V(:,l+1:end) = [];

            rM = rot90(U(:,1)*S(1,:)*V');  %��������ת90��
            r = zeros(1,L);
            [~,m] = size(rM);
            for k=-(l-1):L-(l)
                r(k+l) = sum(diag(rM,k))/m;  
            end
                  
        else % �Ժ��������

            for cont = 1:2 %����2��
                v2 = v2-mean(v2);
                [deltaf] = gaussfit_Cao_SSD(ff,nmmt'); % ��˹���
                % �������
                [~,iiii1] = min(abs(ff-(ff(in3)-deltaf)));
                [~,iiii2] = min(abs(ff-(ff(in3)+deltaf)));
              
%                  l = floor(Fs/ff(in3)*1.2);   %�趨Ƕ��ά�ȣ��ɸ��ĵĵط�
%%                     �Ľ�     
                    if Fs/ff(in3)<=20   %�����Ƶ����  Ҫ���Ƕ��ά��(ѡֵ�������33)
                        if ceil(5*Fs/ff(in3))- ceil(Fs/(ff(in3)*5))<20                    %��ֹ�����Ƶ����ʱ ���ݵ㲻��
                            a_m=ceil(0.5*Fs/ff(in3));
                            b_m=1;
                            c_m=a_m+19;
                        else
                            a_m=ceil(Fs/(ff(in3)*5));
                            b_m=ceil((ceil(5*Fs/ff(in3))-ceil(Fs/(ff(in3)*5)))/20);
                            c_m=ceil(5*Fs/ff(in3));
                        end
                    
                        

                    else              %�����Ƶ����  Ҫ����Ƕ��ά��
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

                %ѡ�����ɷ�
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
        y=y-RR1(k1,:);  %�����ź�
        remenold = remen;  
        if testcond  %����ﵽֹͣ������
            remen = sum((sum(RR1(stept:end,:),1)-orig2).^2)/(sum(orig2.^2));
            if k1 == stept+3
                break
            end
        else
            remen = sum((sum(RR1(1:end,:),1)-orig).^2)/(sum(orig.^2)); %�����ź���ԭ�ź�֮��ı�׼�������
        end
        % in rare cases, convergence becomes very slow; the algorithm is then
        % stopped if no real improvement in decomposition is detected (this is 
        % something to fix in future versions of SSD)
        if abs(remenold - remen)< 1e-3   %�жϲ����ź���ԭ�ź�ֱ�ӵı�׼�����������ֵ<�Զ�����ֵth��0.01ʱ����Ϊ�ֽ����  ���򽫸ò����źŵ�ԭ�źż����ֽ�
            testcond = 1;
            stept = k1+1;
            orig2 = y;
        end
     

    end
  
    if testcond
    fprintf('�ֽ���ɣ������ź���ԭʼ�źŵľ����������Ϊ�� %3.1f\n %',(1-sum((sum(RR1(1:end,:),1)-orig).^2)/(sum(orig.^2)))*100);
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
    varargout{3}=remen;   %���
end
if nargout>3
    varargout{4}=ZL_SSC;   %���
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

    if isempty(is2) %isempty ȷ�������Ƿ�Ϊ��
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

