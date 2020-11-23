function [f,y1]= SA_FFT(sy,fs,draw,titles)
%对信号进行快速傅里叶变换，输入时域信号和采样频率
if nargin==2
    draw='No draw';
    titles=' ';
elseif nargin==3
    titles=' ';
end
[m,n]=size(sy);
h_num=min(m,n);
y_num=max(m,n);  %采样点个数
if m>n  %将输入数据强制转换为以行向量为有效向量的矩阵
    y=sy';
    sy=sy';
else
    y=sy;
end
t=(1:y_num)/fs;
y1=zeros(h_num,y_num/2+1);
for i=1:h_num
    y(i,:)=fft(y(i,:));
    y(i,:)=abs(y(i,:)/y_num);
    y1(i,:)=y(i,1:y_num/2+1);
    y1(i,2:end-1)=2*y1(i,2:end-1);  
end
    f=fs*(0:(y_num/2))/y_num;
if strcmpi(draw,'draw')
    figure('Name','输入信号y的FFT变换','NumberTitle','off')
    for i=1:h_num
        subplot(h_num,2,2*i-1);
        plot(t,sy(i,:));
        subplot(h_num,2,2*i);
        plot(f,y1(i,:));
    end
end
if ~strcmpi(titles,' ')
    title(titles);
end