%% ���������ܶȺ�ƽ�����ڵĹ�ϵ��CEEMD��ģ����ؿ�����֤��
%������֤ä�ź��Ƿ�Ϊ����
function [varargout]=SA_EDAMP(varargin)
    %varargin{1}=IMF��ȫ����IMF����������������Ϊ���ź�
    %varargin{2}=fs

    %varargout{1}=ln(t)
    %varargout{2}=ln(E)
    
    y=varargin{1};
    fs=varargin{2};
%     Nstd=varargin{3};
    [y,m,~]=SPT_ST(y);
    

    Energy=zeros(1,m);
    Tt=zeros(1,m);
    %% �������ţ�Ϊ�˱�֤����С��0
    for i=1:m
      %% ���������ܶ�
       Energy(i)=sum(y(i,:).^2);
       Energy(i)=Energy(i)/length(y(1,:)); 
       %% ����ƽ������
       
        [y_f,y_y]=SA_FFT(y(i,:),fs);
        y_f=y_f(2:end);
        y_y=y_y(2:end);
        f=y_f.*y_y;
        T=1./f;
        Lt=log(T);
        St=abs(fft(Lt));
        Tt(i)=sum(St)/sum(St./T);
    end
    %% ���
    varargout{1}=log(Tt);
    varargout{2}=log(Energy);

end