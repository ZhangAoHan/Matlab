function [ln_r,ln_c,MM,D]=SA_GP(x,m,r)
%x:һά������
%m=[m_min,m_h,m_max]
%r:
% MM  D:Ƕ��ά���͹���ά�Ĺ�ϵ
    %% ��ȡ����
    x=x(:)';
    x=x-mean(x);
    x=x/(max(x)-min(x));
    if length(m)==2
       m_min=m(1);
       m_max=m(2);
       m_h=1;
    else
        m_min=m(1);
        m_max=m(3);
        m_h=m(2);
    end
    MM=m_min:m_h:m_max;
    %% ����lnr-lnc
    msg={'���ڼ���Lnc-Lnr','���ڼ���Ƕ��ά��'};
    f = waitbar(0,msg{1});
   delt=1/r;  %��r�Ĳ���
   for m=m_min:m_h:m_max
        waitbar((m-m_min+1)/(m_max-m_min),f,msg{1});
        [Y,M]=Rec(x,m,1);
        for k=1:r
            rr=k*delt;
            C_r=C_R(Y,M,rr);%����������ֺ���
            ln_c(m,k)=log(C_r);%lnC(r)
            ln_r(m,k)=log(rr);%lnr
        end
   end
   ln_c=ln_c(MM,:);
   ln_r=ln_r(MM,:);
   for jj=1:length(ln_r(:,1))
       D(jj)=SA_GP_LS(ln_r(jj,:),ln_c(jj,:));
   end
 close(f);  
end

%% ��ռ��ع�
function [X,M]=Rec(data,m,tau)
%�ú��������ع���ռ�
% mΪǶ��ռ�ά�� �������xn������,̫С�Ļ����Ǿ�����һ������
% tauΪ�ع�ʱ�ӣ�Խ������Խƫ��������
% dataΪ����ʱ������
    N=length(data);
    M=N-(m-1)*tau;%��ռ��е�ĸ���
    for j=1:M           %��ռ��ع�
        for i=1:m
            X(i,j)=data((i-1)*tau+j);
        end
    end  
end

%% �����������
function C_I=C_R(X,M,r)
%�˺������������������
%C_I:�������ֵ�ֵ
%X:�ع�����ռ�,M��һ�� m*M�ľ���
%m:Ƕ��ά��
%M:mά��ռ���Ƕ��������
%r: Heaviside�����еİ뾶 ,sigma/2<r<2sigma
%sum_H������Heaviside����ֵ�ĺ�
    sum_H=0;
    for i=1:M-1
        for j=i+1:M
            d=norm((X(:,i)-X(:,j)),inf); %ʹ��������������M������֮��ľ���
            sita=Hea(r,d);%����heaviside������ֵ
            sum_H=sum_H+sita;
        end                
    end
     C_I=2*sum_H/(M*(M-1));%�������ֵ�ֵ
end

%% ����Heaviside��������ֵ
function sita=Hea(r,d)
%�˺������ڼ���Heaviside��������ֵ
%sita: Heaviside������ֵ
%r: Heaviside�����еİ뾶 ,sigma/2<r<2sigma
%d: ����֮��ľ���
    if (r-d)<=0
        sita=0;
    else
        sita=1;
    end
end

%% ��С���˷������Ƕ��ά��
function dd=SA_GP_LS(xx,yy)
    numm=0;
    num=length(xx);
    for i=1:num
        if yy(i)~=inf && yy(i)~=-inf
            numm=numm+1;
        end
    end
    p=polyfit(xx(num-numm+1:end),yy(num-numm+1:end),1);
    dd=p(1);
end     
