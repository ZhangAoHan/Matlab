function [f,bl] =SA_Hilbert(x,fs,title)
%Hilbert�任
if strcmpi(title,'bl')   %���������
    [f,bl] = Hilbert_bl(x,fs);
end

end

function [bl_f,bl_bl] = Hilbert_bl(bl_x,bl_fs)
%���������
%plot(f,abs(Xk));
N=length(bl_x);
baoluo=hilbert(bl_x);
Xk=fft(abs(baoluo));
Xk(1)=0;
bl_f=(0:N-1)/N*bl_fs;
bl_f=bl_f(1:N/2);
bl_bl=abs(Xk);
bl_bl=bl_bl(1:N/2);
end
