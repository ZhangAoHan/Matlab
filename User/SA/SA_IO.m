%��֤������IO
%IOԽ�� ˵��ģ̬�������Խ����
function io= SA_IO(x,imf) %����ԭʼ�źţ�һά�����ͷֽ���IMF�����壩
x=x(:)'; %ǿ��������
[m,n]=size(imf);
if m>n   %ǿ���о���
    imf=imf';
end
[m,n]=size(imf);
%����IO
io=0;
for i=1:m
    for j=1:m
        if j~=i
            io=io+abs(sum(imf(i,:).*imf(j,:))/sum(x.^2));
        end
    end
end
