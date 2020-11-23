function [Power,Energy]=SA_SE(y,fs,string)
%求信号的能量和功率
% 输入： 输入信号  采样频率（信号的采样频率，只与t有关，string=t（时域）f(频域)
%输出：  平均功率和总能量

y_num=length(y);%求出采样点数
t=y_num/fs;  %求出采样的时间（为了求功率）
if strcmpi(string,'t')  %求时域的能量
    Energy=sum(y.^2);
    Power=Energy/t;
elseif strcmpi(string,'f') 
    fy=fft(y);%先求快速傅里叶变换
    fy=abs(fy/y_num); %将复信号化为实信号
    fy=fy(1:y_num/2+1); %求单边幅度谱
    fy(2:end-1)=2*fy(2:end-1); %此时得到原信号的傅里叶幅度信号（也就是常说的傅里叶变换后的信号，画傅里叶变换图像的纵轴）
    Energy=sum(fy.^2);
    f=fs*(0:y_num/2)/y_num; %求出傅里叶幅度对应的频率（画傅里叶变换图像的横轴）
    Power=Energy/f(end);
else 
    error("请确定是求时域能量还是频域能量");
end