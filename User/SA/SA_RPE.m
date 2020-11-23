function pe = SA_RPE(data,m,t)
%计算RPE熵（反向排列熵），输入：数据（一维），嵌入维数=4，时间延迟=1
%反应数据复杂度，数据复杂度越高，PE值越小
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