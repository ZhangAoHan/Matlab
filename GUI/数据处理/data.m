%生成原始数据  要求结果变量为y
clear all
t=(2*pi)/1000:(2*pi)/1000:2*pi;
y=cos(t);
fs=1000;
class(fs)
        ssc=SAM_SSD(y,fs);
        [~,~]= SA_FFT(ssc,fs,'draw','SSD');
% save('F:\工程文件\Matlab\GUI\数据处理\Data.mat','y');