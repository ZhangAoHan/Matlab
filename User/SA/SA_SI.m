%��֤������ָ��
%SIԽ�� ˵���ֽ���IMF��ԭʼ�ź�Խ���ƣ�ͨ���������IMF��ԭʼ�źŵ����ϵ������ƽ����
function si= SA_SI(x,imf) %����ԭʼ�źţ�һά�����ͷֽ���IMF�����壩
x=x(:)'; %ǿ��������
[m,n]=size(imf);
if m>n   %ǿ���о���
    imf=imf';
end
[m,n]=size(imf);
%����SI
si=0;
for i=1:m
    si_init=corrcoef(x,imf(i,:));  %���Ϊ���ƾ���ȡ��1,2�����ߣ�2��1��
    si=si+si_init(1,2);
end
si=si/m;