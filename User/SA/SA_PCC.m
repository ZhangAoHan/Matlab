function r=SA_PCC(A,B)
%��2���źŵ�Ƥ��ѷ���ϵ��
%�����  0-0.1
%�����  0.1-0.3
%���  0.3-0.5
%ǿ���  0.5-1
% <0  �����
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
