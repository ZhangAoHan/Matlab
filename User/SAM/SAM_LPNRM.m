function result_x  = SAM_LPNRM(x,tau,m,T,String,r)
%局部投影降噪
[zn,~]=SA_PD(x,tau,m,T,String);
Vnum=length(zn);
neigh_num=zeros(1,Vnum);
for i=1:Vnum
    current_point=zn(:,i);%取每个相点，第i个相点
    neigh_num(i)=0;    %每个相点的邻域点数
    %求第i个相点的邻域
    for j=1:Vnum
        comparing_point=zn(:,j);
        if j~=i
            distance=sum((current_point-comparing_point).^2)^0.5;%欧式距离先和后开方
            if distance<r
                neigh_num(i)= neigh_num(i)+1;
                neighbour(:,neigh_num(i))=comparing_point;%对应第i个相点的邻域相点矩阵
            end
        end
    end
     %求第i个相点的质心
    center_vec=zeros(m,1);
    for k=1:neigh_num(i)
        center_vec=center_vec+neighbour(:,k);
    end
    center_vec=center_vec/neigh_num(i); %质心
    %第i个相点与质心的差
    s=current_point-center_vec;
    %构造每个相点的协方差矩阵C
    R=eye(m);R(1,1)=1000;R(m,m)=1000;
    Z=R*s;C=Z*Z';
    %选出子空间和噪声空间
    [E,D]=eig(C);%E特征向量D特征值
    t=diag(D);
    [t,p]=sort(t,'ascend');%特征值升幂排列,t新的升幂序列，p是t中元素在原序列中的位置序列
    for k=1:length(t)  %特征向量相对应排列
         e(:,k)=E(:,p(k));
    end
    rate=t/sum(t);%贡献率
    %Q值选取贡献率小于25%
    sumrate=0;
    for k=1:length(t)
        sumrate=sumrate+rate(k);
        newi=k;
        if sumrate>0.25 
            break;
        end
    end
%     q=length(t)-newi+1;
    S=zeros(m,1);
    for j=1:newi
        S=S+e(:,j)*dot(e(:,j),Z);
    end   
    result_x(:,i)=current_point-R\S;
end
