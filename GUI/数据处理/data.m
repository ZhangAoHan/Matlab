%����ԭʼ����  Ҫ��������Ϊy
clear all
t=(2*pi)/1000:(2*pi)/1000:2*pi;
y=cos(t);
fs=1000;
class(fs)
        ssc=SAM_SSD(y,fs);
        [~,~]= SA_FFT(ssc,fs,'draw','SSD');
% save('F:\�����ļ�\Matlab\GUI\���ݴ���\Data.mat','y');