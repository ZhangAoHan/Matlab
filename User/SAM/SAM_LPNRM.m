function result_x  = SAM_LPNRM(x,tau,m,T,String,r)
%�ֲ�ͶӰ����
[zn,~]=SA_PD(x,tau,m,T,String);
Vnum=length(zn);
neigh_num=zeros(1,Vnum);
for i=1:Vnum
    current_point=zn(:,i);%ȡÿ����㣬��i�����
    neigh_num(i)=0;    %ÿ�������������
    %���i����������
    for j=1:Vnum
        comparing_point=zn(:,j);
        if j~=i
            distance=sum((current_point-comparing_point).^2)^0.5;%ŷʽ�����Ⱥͺ󿪷�
            if distance<r
                neigh_num(i)= neigh_num(i)+1;
                neighbour(:,neigh_num(i))=comparing_point;%��Ӧ��i����������������
            end
        end
    end
     %���i����������
    center_vec=zeros(m,1);
    for k=1:neigh_num(i)
        center_vec=center_vec+neighbour(:,k);
    end
    center_vec=center_vec/neigh_num(i); %����
    %��i����������ĵĲ�
    s=current_point-center_vec;
    %����ÿ������Э�������C
    R=eye(m);R(1,1)=1000;R(m,m)=1000;
    Z=R*s;C=Z*Z';
    %ѡ���ӿռ�������ռ�
    [E,D]=eig(C);%E��������D����ֵ
    t=diag(D);
    [t,p]=sort(t,'ascend');%����ֵ��������,t�µ��������У�p��t��Ԫ����ԭ�����е�λ������
    for k=1:length(t)  %�����������Ӧ����
         e(:,k)=E(:,p(k));
    end
    rate=t/sum(t);%������
    %Qֵѡȡ������С��25%
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
