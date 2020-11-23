function [x,y]=FX_Rukt4(ufunc,y0,h,a,b,coe)%������˳��������΢�ַ�����ĺ������ƣ���ʼֵ������������ʱ����㣬ʱ���յ�,coe:Ϊ1*3�����飬[o r b]��������ʽ�ο���ode45������ 
if size(coe,2)~=3 || nargin<6
    aa=10;
    bb=28;
    cc=8/3;
    coe=[aa bb cc];
end
n=floor((b-a)/h);%���� 
x(1)=a;%ʱ����� 
y(:,1)=y0;%����ֵ������������������Ҫע��ά�� 
for ii=1:n  
    x(ii+1)=x(ii)+h;  
    k1=ufunc(x(ii),y(:,ii),coe);  
    k2=ufunc(x(ii)+h/2,y(:,ii)+h*k1/2,coe);  
    k3=ufunc(x(ii)+h/2,y(:,ii)+h*k2/2,coe);  
    k4=ufunc(x(ii)+h,y(:,ii)+h*k3,coe);  
    y(:,ii+1)=y(:,ii)+h*(k1+2*k2+2*k3+k4)/6; %���������������������ֵ���
end