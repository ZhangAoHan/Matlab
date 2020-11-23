function imf=SAM_UPEMD(sig, startMode, numImf, numSift, maxPhase0, ampSin0)
%  Copyright National Central University; July, 2018 
% function version 1.1 (upemd Uniform Phase EMD); 2018-0724; % this function calls emd() function
% Reference: 
%Yung-Hung Wang, Kun Hu, and Men-Tzung Lo, "Uniform Phase Empirical Mode Decomposition: An Optimal Hybridization of Masking Signal and Ensemble Approaches",IEEE ACCESS July 2018

% Input Parameters:
% (1) % sig: signal
% (2) startMode: first IMF to be extracted: default = 1
% (3) numImf: number of IMF: default = round(log2(length(x)))
% (4) numSift: number of sifting iteration: (use fixed sifting number); default = 10
% (5) maxPhase0: maximum number of phases allowed in each IMF (level); default = 8
% (6) ampSin0: un-normalized amplitude of the assisted sinusoids; suggested value 0.1~1.0 It will be normalized later by the standard deviation of the signal or residual
% typeSpline: default=2; 1: clamped spline; 2: not a knot spline; 3: natural cubic spline; default 2
% toModifyBC: default=1; 0: None ; 1: modified linear extrapolation; default 1
% Output: IMF (Intrinsic Mode Function) matrix; imf(1,:) == 1st IMF, imf(2,:) = 2nd IMF, ..

% Àý£º
%%
typeSpline = 3; %suggest use 2 (Not-a-Knot) or 3 (natural cubic spline);
toModifyBC = 1;
startShift = 1;
ndata = size(sig,2);
defaultMaxImf = floor(log2(ndata));    


if numImf > defaultMaxImf
    numImf = defaultMaxImf;
end

lastMode = startMode + numImf - 1;

countMode = 1;
res = sig;
for mode=startMode:lastMode-1
    ampSin = ampSin0*std(res);
    numShift = 2^(mode);
        
    numPhase =  floor(log2(maxPhase0));
    numPhase = 2^numPhase;
    if numPhase > numShift
        numPhase = min(numPhase,numShift);
    end
    
    ds = numShift/numPhase;
    assert(rem(numShift,numPhase)==0);   
    [mediaArray]=sinusoidalWave(2*ndata,ampSin,numShift/2); % oversized media pool; will speedup by this phase  rotation
       
    sumWrk = zeros(1,ndata);

    countShift = 0;
    for shift=startShift:ds:numShift + startShift-1 % phase rotating
        media =  mediaArray(shift:shift+ndata-1);
        countShift = countShift + 1;
        y = res + media;
              
        [subImf] = emd_yanglan(y, toModifyBC, typeSpline, 2, numSift); subImf=subImf';
        subImf(1,:) = subImf(1,:) - media;
        sumWrk = sumWrk +subImf(1,:);
    end % shift
   
    imf(countMode,:) = sumWrk/countShift;
    res = res - imf(countMode,:);
    countMode = countMode + 1;
end % mode

imf(countMode,:) = res;
err = abs(sig - sum(imf,1));
assert(max(err) < 1.0e-8); % check the reconstruction error is on the order of machine error

end
%% ¸¨ÖúÔëÉù²úÉú³ÌÐò
function [y]=sinusoidalWave(ndata,a,hp)
% hp == half period
t=0:2*hp-1;
f = 0.5/hp;
yt = cos(2*pi*f*t);
yt = a*yt;

nyt = size(yt,2);
no = ceil(ndata/nyt);

y = repmat(yt,1,no);
y = y(1:ndata);
return;
end