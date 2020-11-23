function [Out_AAPE,hist] = SA_AAPE(y,m,varargin)
%振幅感知排列熵
% y: univariate signal
% m: order of AAPE  顺序  该值越大 结果越可靠，但是计算时间也越长，一般令该值为5
% t: delay time of AAPE (the defulat value of t is 1) 延时
% A: adjusting coefficient related to the mean value and difference between
% consecutive samples (the defulat value of A is 0.5)



if length(varargin) == 2
    t = varargin{1};
    A = varargin{2};
elseif length(varargin) == 1
    t = varargin{1};
    A = 0.5;
else
    t = 1;
    A = 0.5;
end


ly = length(y);
permlist = perms(1:m);
c(1:length(permlist))=0;


for j=1:ly-t*(m-1)
    [a,iv]=sort(y(j:t:j+t*(m-1)));
    
    
    
    if 0~=min(abs(diff(a)))         % in case the embedding vectors do not have any equal values
        
        
        for jj=1:length(permlist)
            if (abs(permlist(jj,:)-iv))==0
                c(jj) = c(jj) + (A/(m))*sum(abs(y(j:t:j+(m-1)*t)))+ (1-A/(m-1))*sum(abs(diff(y(j:t:j+(m-1)*t)))); %
            end
        end
        
    else % in case the embedding vectors have equal values (addressing the second above mentioned problem of PE)
        
        
        [u1,~,u3]=unique(y(j:t:j+t*(m-1)));
        TF=1;
        for ip=1:length(u1)
            f1=find(u3==ip);
            TF=factorial(length(f1))*TF;
        end
        
        yy=NaN*ones(TF,m);
        
        for ip=1:length(u1)
            a=find(u3==ip);
            pa=perms(a);
            yy(:,a)=repmat(pa,TF/(factorial(length(a))),1);
        end
        
        for jjj=1:TF
            iv=yy(jjj,:);
            for jj=1:length(permlist)
                if (abs(permlist(jj,:)-iv))==0
                    c(jj) = c(jj) + (1/TF)*((A/(m))*sum(abs(y(j:t:j+(m-1)*t)))+ (1-A/(m-1))*sum(abs(diff(y(j:t:j+(m-1)*t)))));
                end
            end
        end
        
    end
    
end
% hist = c;

c=c(find(c~=0));
p = c/sum(c);
hist = p;
Out_AAPE = -sum(p .* log(p));
Out_AAPE=Out_AAPE/log(factorial(m)); %归一化AAPE