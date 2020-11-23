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
        error("m输入格式不正确");
    end
    D=m_min:m_h:m_max;
    d=Cao_M(y,[m_min,m_h,m_max]);
    Dd=Cao_d(D,d);
    %% 输出
    if nargout==1
        varargout{1}=Dd;
    elseif nargout==3  %输出三个参数，可以直接画M-E(M)
        varargout{1}=Dd;
        varargout{2}=D(1:end-1);
        varargout{3}=d;
    end
end

%% Cao法求嵌入维数
function dd=Cao_M(x,m)
    %% 提取参数
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
    msg={'正在计算嵌入维数'};
    f = waitbar(0,msg);
    for m=MM               %取不同的嵌入维数
        waitbar((m-m_min+1)/(m_max-m_min),f,msg{1});
        [Y,~]=Rec_Cao(x,m,1);  %固定时延为1
        for i=1:N-m %m定 i定，则可以求出在m确定时，距离X(:,i)最近的向量X(:,j)
            %% 求距离X(:,i)最近的向量X(:,j)
            for j=1:N-m
                d(j)=norm(Y(:,i)-Y(:,j),inf);
            end
            temp=sort(d);
            D(i,1)=i;         %D的第一列为向量序号
            temp1=find(temp>0);
            temp2=find(d==temp(temp1(1)));
            D(i,2)=temp2(1);  %第二列为与之对应的最短距离向量的序号
            D(i,3)=temp(temp1(1));%第三列为与之对应的最短距离
        
          %% -----------计算a(i,m)-----------------------
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

%% 相空间重构
function [X,M]=Rec_Cao(data,m,tau)
%该函数用来重构相空间
% m为嵌入空间维数 决定输出xn的行数,太小的话就是纠集到一条线上
% tau为重构时延，越大，数据越偏离中心线
% data为输入时间序列
%X=m*M=m*(N-m+1)
    N=length(data);
    M=N-(m-1)*tau;%相空间中点的个数
    for j=1:M           %相空间重构
        for i=1:m
            X(i,j)=data((i-1)*tau+j);
        end
    end  
end

%% 提取嵌入维数
function D=Cao_d(m,d)
%输入m,d
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
        warning("没有找到符号条件的j，请检查逻辑");
    end
    D=m(k);
end