function [varargout]=SAM_CEEMDAN(x,Nstd,NR)
%输入：信号，噪声权重，每级分解次数 
x=x(:)';
desvio_x=std(x);
x=x/desvio_x;
aux=zeros(size(x));
for i=1:NR
    white_noise{i}=randn(size(x));
    modes_white_noise{i}=SAM_EMD(white_noise{i});
end

%% 第一次运算
for i=1:NR %calculates the first mode
    temp=x+Nstd*white_noise{i};
    temp=SAM_EMD(temp);
    temp=temp(1,:);
    aux=aux+temp/NR;
end
modes=aux; %saves the first mode
k=1;
aux=zeros(size(x));
acum=sum(modes,1);
while  nnz(diff(sign(diff(x-acum))))>2 %calculates the rest of the modes
    
    for i=1:NR
        tamanio=size(modes_white_noise{i});
        if tamanio(1)>=k+1
            noise=modes_white_noise{i}(k,:);
            noise=noise/std(noise);
            noise=Nstd*noise;
            try
                temp=SAM_EMD(x-acum+std(x-acum)*noise);
                temp=temp(1,:);
            catch
                temp=x-acum;
            end
        else
            temp=SAM_EMD(x-acum);
            temp=temp(1,:);
        end
        aux=aux+temp/NR; 
    end
    modes=[modes;aux];
    aux=zeros(size(x));
    acum=sum(modes,1);
    k=k+1;
end
modes=[modes;(x-acum)];
modes=modes*desvio_x;
if nargout < 2
    varargout{1} = modes;
end
