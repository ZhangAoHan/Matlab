function pe = SA_RPE(data,m,t)
%����RPE�أ����������أ������룺���ݣ�һά����Ƕ��ά��=4��ʱ���ӳ�=1
%��Ӧ���ݸ��Ӷȣ����ݸ��Ӷ�Խ�ߣ�PEֵԽС
N = length(data);
permlist = perms(1:m);
c(1:length(permlist))=0;
 for i=1:N-t*(m-1)
     [~,iv]=sort(data(i:t:i+t*(m-1)));
     for jj=1:length(permlist)
         if (abs(permlist(jj,:)-iv))==0
             c(jj) = c(jj) + 1 ;
         end
     end
 end
 
hist = c; 
c=hist(find(hist~=0));
p = c/sum(c);
pe = sum( p.^2 ) -1/factorial(m) ;
end