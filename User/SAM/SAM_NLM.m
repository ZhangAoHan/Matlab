%非局部均值降噪NLM
function y_dn = SAM_NLM(x,M,P)
%X:输入信号
%M;搜索领域，越大，效果越好（最好M等于信号的长度），但这样会降低计算效率，通常M=N/2
%P：搜索块的半宽，影响搜索窗口的大小（搜索窗口长度=2*P-1），一般为10
%对信号进行镜像延扩，为了出来边界处的数据，需要在完成后减去
x=SPT_ST(x);
y=[x(1:50),x,x(end-49:end)];
sigma=median(abs(y))/0.6745;
lambda=0.12*sigma; 
[nlm,~]= NLM(y,lambda,M,P);
y_dn=nlm(51:end-50);
end

function [denoisedSig,debug] = NLM(signal,lambda,P,M)
    if length(P)==1  % scalar has been entered; expand into patch sample index vector
        Pvec = -P:P;
    else
       Pvec = P;  % use the vector that has been input  
    end
    debug=[];
    N = length(signal);

    denoisedSig = NaN*ones(size(signal));

    % to simpify, don't bother denoising edges
    iStart=1+M+1;
    iEnd = N-M;
    denoisedSig(iStart:iEnd) = 0;

    debug.iStart = iStart;
    debug.iEnd = iEnd;

    % initialize weight normalization
    Z = zeros(size(signal));
    cnt = zeros(size(signal));    

    % convert lambda value to 'h', denominator, as in original Buades papers
    Npatch = 2*M+1;
    h = 2*Npatch*lambda^2;

    for idx = Pvec  % loop over all possible differences: s-t

        % do summation over p  - Eq. 3 in Darbon
        k=1:N;
        kplus = k+idx;
        igood = find(kplus>0 & kplus<=N);  % ignore OOB data; we could also handle it
        SSD=zeros(size(k));
        SSD(igood) = (signal(k(igood))-signal(kplus(igood))).^2;
        Sdx = cumsum(SSD);


        for ii=iStart:iEnd  % loop over all points 's'
            distance = Sdx(ii+M) - Sdx(ii-M-1); % Eq 4; this is in place of point-by-point MSE
            % but note the -1; we want to icnlude the point ii-iPatchHW

            w = exp(-distance/h);  %Eq 2 in Darbon
            t = ii+idx;  % in the papers, this is not made explicit

            if t>1 && t<=N
                denoisedSig(ii) = denoisedSig(ii) + w*signal(t);
                Z(ii) = Z(ii) + w;
                cnt(ii) = cnt(ii)+1;
            end

        end
    end % loop over shifts

    % now apply normalization
    denoisedSig = denoisedSig./(Z+eps);

end