function PD_PL(varargin)
% ������ͼ  Ҫ��x����������
    if nargin==1
        x=varargin{1};
        t=1:length(x);  %��Žϴ���Ϊ�˱����ͻ
    elseif nargin==2
        x=varargin{1};
        t=varargin{2};
        if length(x)~=length(t)
            error('���������������ݸ�����һ��');
        end
    end
    x=x(:)';
    n=length(x);
    x_zes=[t;t];  %x��
    y_zes=[zeros(1,n);x]; %y��
    for i=1:n
        plot(x_zes(:,i),y_zes(:,i),'b'); %����
        hold on
        plot(x_zes(1,i),y_zes(2,i),'r*')  %����
    end
end