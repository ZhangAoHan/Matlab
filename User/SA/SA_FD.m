function B=SA_FD(y,fs)
%求信号在频域上的能量散度
y=y(:)'; %将y强制变成行向量 为了标准化
[~,e]=SA_SE(y,fs,'t'); %先计算时域的能量
y_num=length(y);
fy=fft(y);  
fy=abs(fy/y_num); %将复信号化为实信号
fy=fy(1:y_num/2+1); %求单边幅度谱
fy(2:end-1)=2*fy(2:end-1); %此时得到原信号的傅里叶幅度信号（也就是常说的傅里叶变换后的信号，画傅里叶变换图像的纵轴）
f=fs*(0:y_num/2)/y_num; %求出傅里叶幅度对应的频率（画傅里叶变换图像的横轴）

f_m=sum(f.*fy)/e; %得到信号频率均值

B=(4*pi*sum((f-f_m).*fy.^2)/e)^0.5;
