function PD_PL(varargin)
% 画点线图  要求x必须是向量
    if nargin==1
        x=varargin{1};
        t=1:length(x);  %标号较大是为了避免冲突
    elseif nargin==2
        x=varargin{1};
        t=varargin{2};
        if length(x)~=length(t)
            error('横坐标数量和数据个数不一致');
        end
    end
    x=x(:)';
    n=length(x);
    x_zes=[t;t];  %x轴
    y_zes=[zeros(1,n);x]; %y轴
    for i=1:n
        plot(x_zes(:,i),y_zes(:,i),'b'); %画线
        hold on
        plot(x_zes(1,i),y_zes(2,i),'r*')  %画点
    end
end