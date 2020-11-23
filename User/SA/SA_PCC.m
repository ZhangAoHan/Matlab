function r=SA_PCC(A,B)
%求2个信号的皮尔逊相关系数
%不相关  0-0.1
%弱相关  0.1-0.3
%相关  0.3-0.5
%强相关  0.5-1
% <0  负相关
N=length(A);

ab=sum(A.*B);
s_a=sum(A);
s_a2=sum(A.^2);
s_b=sum(B);
s_b2=sum(B.^2);

if (s_a2-s_a^2/N)*(s_b2-s_b^2/N)==0%Modified on 06.09.15
    r=0;
else
    r=(ab-s_a*s_b/N)/sqrt((s_a2-s_a^2/N)*(s_b2-s_b^2/N));
end
