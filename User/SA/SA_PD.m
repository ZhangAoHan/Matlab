function [xn,dn] = SA_PD(s,tau,m,T,String)
%����ͼ�����жϽ��������
%��
% [zn0,dn0]=PSR(s1,1,4);
% figure(2);
% plot(zn0(1,:),dn0);
% �������е���ռ��ع� (phase space reconstruction)
% [xn, dn, xn_cols] = PhaSpaRecon(s, tau, m)
% ���������    s          ��������(������)
%               tau        �ع�ʱ�ӣ�Խ������Խƫ��������
%               m          �ع�ά��,�������xn������,̫С�Ļ����Ǿ�����һ������
%               T          ֱ��Ԥ�ⲽ��,Խ������Խƫ��������
% ���������    xn         ��ռ��еĵ�����(ÿһ��Ϊһ����)
%               dn         һ��Ԥ���Ŀ��(������)

if nargin==1
    tau=1;
    m=4;
    T = 1;
    String='method_1';
elseif nargin==2
    m=4;
    T = 1;
    String='method_1';
elseif nargin==3
    T = 1;
    String='method_1';
elseif nargin==4
    String='method_1';
end

if strcmpi(String,'method_1')
    [s,~,cols]=SPT_ST(s);
    len = cols;
    if (nargout==1) %����������е��ع����У�һά��ͼ��
        if (len-(m-1)*tau < 1)
            disp('err: delay time or the embedding dimension is too large!')
            xn = [];
        else
            xn = zeros(m,len-(m-1)*tau);
            for i = 1:m
                xn(i,:) = s(1+(i-1)*tau : len-(m-i)*tau);   % ��ռ��ع���ÿһ��Ϊһ���� 
            end
        end

    elseif (nargout==2)%����������е��ع����У���ά��ͼ��

        if (len-T-(m-1)*tau < 1)
            disp('err: delay time or the embedding dimension is too large!')
            xn = [];
            dn = [];
        else
            xn = zeros(m,len-T-(m-1)*tau);
            for i = 1:m
                xn(i,:) = s(1+(i-1)*tau : len-T-(m-i)*tau);   % ��ռ��ع���ÿһ��Ϊһ���� 
            end
            dn = s(1+T+(m-1)*tau : end);    % Ԥ���Ŀ��
        end
    
    end
elseif strcmpi(String,'method_2')
    N=length(s);
    n=N-(m-1)*tau;
    V=zeros(n,m);
    for i=1:n
    V(i,:)=s(i:tau:i+(m-1)*tau);
    end
    V=V';   %v=m*n����ok
    xn=V; %ȡǰ���У���Ϊ�Ѿ�ת���ˣ�
    dn=V(2,:);
else
    error('����ȷ���ʹ�õķ���')
end




