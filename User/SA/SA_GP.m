function [ln_r,ln_c,MM,D]=SA_GP(x,m,r)
%x:一维行向量
%m=[m_min,m_h,m_max]
%r:
% MM  D:嵌入维数和关联维的关系
    %% 提取参数
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
    %% 计算lnr-lnc
    msg={'正在计算Lnc-Lnr','正在计算嵌入维数'};
    f = waitbar(0,msg{1});
   delt=1/r;  %是r的步长
   for m=m_min:m_h:m_max
        waitbar((m-m_min+1)/(m_max-m_min),f,msg{1});
        [Y,M]=Rec(x,m,1);
        for k=1:r
            rr=k*delt;
            C_r=C_R(Y,M,rr);%计算关联积分函数
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

%% 相空间重构
function [X,M]=Rec(data,m,tau)
%该函数用来重构相空间
% m为嵌入空间维数 决定输出xn的行数,太小的话就是纠集到一条线上
% tau为重构时延，越大，数据越偏离中心线
% data为输入时间序列
    N=length(data);
    M=N-(m-1)*tau;%相空间中点的个数
    for j=1:M           %相空间重构
        for i=1:m
            X(i,j)=data((i-1)*tau+j);
        end
    end  
end

%% 计算关联积分
function C_I=C_R(X,M,r)
%此函数用来计算关联积分
%C_I:关联积分的值
%X:重构的相空间,M是一个 m*M的矩阵
%m:嵌入维数
%M:m维相空间中嵌入点的数量
%r: Heaviside函数中的半径 ,sigma/2<r<2sigma
%sum_H：所有Heaviside函数值的和
    sum_H=0;
    for i=1:M-1
        for j=i+1:M
            d=norm((X(:,i)-X(:,j)),inf); %使用无穷范数计算矩阵M中两点之间的距离
            sita=Hea(r,d);%计算heaviside函数的值
            sum_H=sum_H+sita;
        end                
    end
     C_I=2*sum_H/(M*(M-1));%关联积分的值
end

%% 计算Heaviside函数的数值
function sita=Hea(r,d)
%此函数用于计算Heaviside函数的数值
%sita: Heaviside函数的值
%r: Heaviside函数中的半径 ,sigma/2<r<2sigma
%d: 两点之间的距离
    if (r-d)<=0
        sita=0;
    else
        sita=1;
    end
end

%% 最小二乘法拟合求嵌入维度
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
