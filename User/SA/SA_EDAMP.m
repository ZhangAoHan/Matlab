%% 计算能量密度和平均周期的关系（CEEMD里的：蒙特卡洛验证）
%用于验证盲信号是否为噪声
function [varargout]=SA_EDAMP(varargin)
    %varargin{1}=IMF（全部的IMF分量），以行向量为主信号
    %varargin{2}=fs

    %varargout{1}=ln(t)
    %varargout{2}=ln(E)
    
    y=varargin{1};
    fs=varargin{2};
%     Nstd=varargin{3};
    [y,m,~]=SPT_ST(y);
    

    Energy=zeros(1,m);
    Tt=zeros(1,m);
    %% 进行缩放，为了保证能量小于0
    for i=1:m
      %% 计算能量密度
       Energy(i)=sum(y(i,:).^2);
       Energy(i)=Energy(i)/length(y(1,:)); 
       %% 计算平均周期
       
        [y_f,y_y]=SA_FFT(y(i,:),fs);
        y_f=y_f(2:end);
        y_y=y_y(2:end);
        f=y_f.*y_y;
        T=1./f;
        Lt=log(T);
        St=abs(fft(Lt));
        Tt(i)=sum(St)/sum(St./T);
    end
    %% 输出
    varargout{1}=log(Tt);
    varargout{2}=log(Energy);

end