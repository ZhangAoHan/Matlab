function [varargout]=SA_Caos(y,m)
    %m=[min,h,max]
    if length(m)==2
        m_min=m(1);
        m_max=m(2);
        m_h=1;
    elseif length(m)==3
        m_min=m(1);
        m_max=m(3);
        m_h=m(2);
    else
        error("m�����ʽ����ȷ");
    end
    D=m_min:m_h:m_max;
    d=Cao_M(y,[m_min,m_h,m_max]);
    Dd=Cao_d(D,d);
    %% ���
    if nargout==1
        varargout{1}=Dd;
    elseif nargout==3  %�����������������ֱ�ӻ�M-E(M)
        varargout{1}=Dd;
        varargout{2}=D(1:end-1);
        varargout{3}=d;
    end
end

%% Cao����Ƕ��ά��
function dd=Cao_M(x,m)
    %% ��ȡ����
    x=x(:)';
    x=x-mean(x);
    x=x/(max(x)-min(x));
    N=length(x);
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
    msg={'���ڼ���Ƕ��ά��'};
    f = waitbar(0,msg);
    for m=MM               %ȡ��ͬ��Ƕ��ά��
        waitbar((m-m_min+1)/(m_max-m_min),f,msg{1});
        [Y,~]=Rec_Cao(x,m,1);  %�̶�ʱ��Ϊ1
        for i=1:N-m %m�� i��������������mȷ��ʱ������X(:,i)���������X(:,j)
            %% �����X(:,i)���������X(:,j)
            for j=1:N-m
                d(j)=norm(Y(:,i)-Y(:,j),inf);
            end
            temp=sort(d);
            D(i,1)=i;         %D�ĵ�һ��Ϊ�������
            temp1=find(temp>0);
            temp2=find(d==temp(temp1(1)));
            D(i,2)=temp2(1);  %�ڶ���Ϊ��֮��Ӧ����̾������������
            D(i,3)=temp(temp1(1));%������Ϊ��֮��Ӧ����̾���
        
          %% -----------����a(i,m)-----------------------
            Y1=[Y(:,i);x(m+i)];
            Y2=[Y(:,D(i,2));x(D(i,2)+m)];
            ad(i)=norm(Y1-Y2,inf)/D(i,3);
            clear d Y1 Y2 temp temp1 temp2
        end
        E(m)=sum(ad)/(N-m);
    end
    E=E(MM);
    for ij=1:length(E)-1
        dd(ij)=E(ij+1)/E(ij);
    end
   close(f);   
end

%% ��ռ��ع�
function [X,M]=Rec_Cao(data,m,tau)
%�ú��������ع���ռ�
% mΪǶ��ռ�ά�� �������xn������,̫С�Ļ����Ǿ�����һ������
% tauΪ�ع�ʱ�ӣ�Խ������Խƫ��������
% dataΪ����ʱ������
%X=m*M=m*(N-m+1)
    N=length(data);
    M=N-(m-1)*tau;%��ռ��е�ĸ���
    for j=1:M           %��ռ��ع�
        for i=1:m
            X(i,j)=data((i-1)*tau+j);
        end
    end  
end

%% ��ȡǶ��ά��
function D=Cao_d(m,d)
%����m,d
    N=length(d);
    for i=1:N-1
        dd(i)=d(i+1)-d(i);
    end
    e=mean(dd);
    clear kk;
    for i=1:N-2
        if dd(i)<e
            kk=i;
            break;
        end
    end
    e=mean(dd(kk:end));
    k=0;
    for j=2:N-2
        if dd(j)>dd(j-1) && dd(j)>dd(j+1) && dd(j)<e*2
            k=j;
            break;
        end
    end
    if k==0
        k=floor(N/2);
        warning("û���ҵ�����������j�������߼�");
    end
    D=m(k);
end