function y=FX_Random(m,n,string)
%���������������[0-1]ֱ�ӵ���
%m*n�������  ��������  ��ʼ�㣨��Щ�����������Щ������Ҫѡ�
%     if nargin==3
%         
%     end
    y = Middle_Square(m,n,string);
end

%% ƽ��ȡ�з�
%�ص㣺
%���룺kΪ
% function r = Middle_Square(k,x0,n)
function r = Middle_Square(m,n,x0)
    r = zeros(m,n);
    x = zeros(m,n);
    k=floor(log10(x0(1)))+1;
    k=k/2;
    x(1,:) = x0;
    r(1,:) = x(1,:)/(100^k);
    for j=2:m
        for i=1:n
            x(j,i) = mod(x(j-1,i)^2 /(10^k),100^k);
            r(j,i) = x(j,i)/(100^k);
        end
    end

end

%% 