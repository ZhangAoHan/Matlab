function [varargout] = SAM_EMD(x,IMF_num,varargin)
%较原版emd，只增加了输出IMF数量的控制
%如果不使用varargin，可以不用输入IMF_num，否则，必须输入IMF_num，当不理睬时，输入0
%检测输入参数数量（1-无穷），输出参数数量（1-3）
ssc=SAM_SSD(x,1024);
narginchk(1,inf);
nargoutchk(0,3);
if nargin==1
    IMF_num=0;
end
%验证和读取输入参数
[x,t,td,isTT,opt] = parseAndValidateInputs(x, varargin{:});
%输出  IMF  残差  信息
[IMF, residual, info] = localEMD(x,t,opt,IMF_num);

if(isTT)
    t = td;
end

if (nargout == 0 && coder.target('MATLAB'))
    signalwavelet.internal.guis.plot.emdPlot(x, IMF, residual, t);
end

if(isTT && coder.target('MATLAB'))
    IMF = array2timetable(IMF,'RowTimes',t);
    residual = array2timetable(residual,'RowTimes',t);
end
IMF=SPT_ST(IMF);
if nargout > 0
    varargout{1} = IMF;
end

if nargout > 1
    varargout{2} = residual;
end

% if nargout > 2
%     varargout{3} = info;
% end

if nargout > 2
    varargout{3} = ssc;
end

end





%输入参数处理，
function [x,t,td,isTT,opt] = parseAndValidateInputs(x,  varargin)
% 输入参数类型检查
isTT = isa(x,'timetable');
if ~isTT
    validateattributes(x, {'single','double','timetable'},{'vector'},'emd','X');
end

% handle timetable and single
if(isTT)
    signalwavelet.internal.util.utilValidateattributesTimetable(x, {'sorted','singlechannel'},'emd','X');
    [x, t, td] = signalwavelet.internal.util.utilParseTimetable(x);
else
    isSingle = isa(x,'single');
    td = [];
    if(isSingle)
        t = single(1:length(x))';
    else
        t = (1:length(x))';
    end
end

% data integrity checking
validateattributes(x, {'single','double'},{'nonnan','finite','real','nonsparse'},'emd','X');
validateattributes(t, {'single','double'},{'nonnan','finite','real'},'emd','T');

% turn x into column vector
if isrow(x)
    x = x(:);
end

% parse and validate name-value pairs
if(isempty(varargin))
    opt = signalwavelet.internal.emd.emdOptions();
else
    opt = signalwavelet.internal.emd.emdOptions(varargin{:});
end

validatestring(opt.Interpolation,{'spline', 'pchip'}, 'emd', 'Interpolation');
validateattributes(opt.SiftStopCriterion.SiftMaxIterations,...
    {'numeric'},{'nonnan','finite','scalar','>',0,'integer'}, 'emd', 'SiftMaxIterations');
validateattributes(opt.SiftStopCriterion.SiftRelativeTolerance,...
    {'numeric'},{'nonnan','finite','scalar','>=',0,'<',1},'emd', 'SiftRelativeTolerance');
validateattributes(opt.DecompStopCriterion.MaxEnergyRatio,...
    {'numeric'},{'nonnan','finite','scalar'}, 'emd', 'MaxEnergyRatio');
validateattributes(opt.DecompStopCriterion.MaxNumExtrema,...
    {'numeric'},{'nonnan','finite','scalar','>=',0,'integer'},'emd','MaxNumExtrema');
validateattributes(opt.DecompStopCriterion.MaxNumIMF,...
    {'numeric'},{'nonnan','finite','scalar','>',0,'integer'},'emd', 'MaxNumIMF');
end









%%%%EMD分解函数  增加IMF_num：控制分解次数
function [IMFs, rsig, info] = localEMD(x, t, opt,IMF_num)
isInMATLAB = coder.target('MATLAB');
isSingle = isa(x,'single');

% get name-value pairs
Interpolation = opt.Interpolation;
MaxEnergyRatio = opt.DecompStopCriterion.MaxEnergyRatio;
MaxNumExtrema = opt.DecompStopCriterion.MaxNumExtrema;
MaxNumIMF = opt.DecompStopCriterion.MaxNumIMF;
SiftMaxIterations = opt.SiftStopCriterion.SiftMaxIterations;
SiftRelativeTolerance = opt.SiftStopCriterion.SiftRelativeTolerance;
Display = opt.Display;

% initialization
rsig = x;
N = length(x);

if(isSingle)
    ArrayType = 'single';
else
    ArrayType = 'double';
end

IMFs = zeros(N, MaxNumIMF, ArrayType);
info.NumIMF = zeros(MaxNumIMF, 1, ArrayType);
info.NumExtrema = zeros(MaxNumIMF, 1, ArrayType);
info.NumZerocrossing = zeros(MaxNumIMF, 1, ArrayType);
info.NumSifting = zeros(MaxNumIMF, 1, ArrayType);
info.MeanEnvelopeEnergy = zeros(MaxNumIMF, 1, ArrayType);
info.RelativeTolerance = zeros(MaxNumIMF, 1, ArrayType);

% preallocate memory
rsigPrev = zeros(N, 1, ArrayType);
mVal = zeros(N, 1, ArrayType);
upperEnvelope = zeros(N, 1, ArrayType);
lowerEnvelope = zeros(N, 1, ArrayType);

% % Define intermediate print formats
% if(isInMATLAB && opt.Display)
%     fprintf('Current IMF  |  #Sift Iter  |  Relative Tol  |  Stop Criterion Hit  \n');
%     formatstr = '  %5.0f      |    %5.0f     | %12.5g   |  %s\n';
% end

% use different functions under different environment
if(isInMATLAB)
    if(~isSingle)
        localFindExtramaIdx = @(x) signalwavelet.internal.emd.cg_utilFindExtremaIdxmex_double(x);
    else
        localFindExtramaIdx = @(x) signalwavelet.internal.emd.cg_utilFindExtremaIdxmex_single(x);
    end
else
    localFindExtramaIdx = @(x) signalwavelet.internal.emd.utilFindExtremaIdx(x);
end

% extract IMFs
i = 0;
outerLoopExitFlag = 0;
if IMF_num~=0
    MaxNumIMF=IMF_num;
end
while(i<MaxNumIMF)
    % convergence checking
    [peaksIdx, bottomsIdx] = localFindExtramaIdx(rsig);
    numResidExtrema = length(peaksIdx) + length(bottomsIdx);
    energyRatio = 10*log10(norm(x,2)/norm(rsig,2));
    
    if energyRatio > MaxEnergyRatio
        outerLoopExitFlag = 1;
        break
    end
    
    if numResidExtrema < MaxNumExtrema
        outerLoopExitFlag = 2;
        break
    end
    
    % SIFTING process initialization
    rsigL = rsig;
    rtol = ones(1, ArrayType);
    k = 0;
    SiftStopCriterionHit = 'SiftMaxIteration';
    
    % Sifting process
    while (k<SiftMaxIterations)
        % check convergence
        if(rtol<SiftRelativeTolerance)
            SiftStopCriterionHit = 'SiftMaxRelativeTolerance';
            break;
        end
        
        % store previous residual
        rsigPrev(1:N) = rsigL;
        
        % finding peaks
        [peaksIdx, bottomsIdx] = localFindExtramaIdx(rsigL);
        
        if((length(peaksIdx) + length(bottomsIdx))>0)
            % compute upper and lower envelope using extremas
            [uLoc, uVal, bLoc, bVal] = computeSupport(t, rsigL, peaksIdx, bottomsIdx);
            upperEnvelope(:) = interp1(uLoc, uVal, t, Interpolation);
            lowerEnvelope(:) = interp1(bLoc, bVal, t, Interpolation);
            
            % subtract mean envelope from residual
            mVal(1:N) = (upperEnvelope + lowerEnvelope)/2;
        else
            mVal(1:N) = 0;
        end
        
        rsigL = rsigL - mVal;
        
        % residual tolerance
        rtol = (norm(rsigPrev-rsigL,2)/norm(rsigPrev,2))^2;
        k = k + 1;
    end
    
%     if(isInMATLAB && Display)
%         fprintf(formatstr, i+1, k, rtol, SiftStopCriterionHit);
%     end
    
    % record information
    [peaksIdx, bottomsIdx] = localFindExtramaIdx(rsigL);
    numZerocrossing = sum(diff(sign(rsigL))~=0);
    info.NumIMF(i+1) = i+1;
    info.NumExtrema(i+1) = length(peaksIdx) + length(bottomsIdx);
    info.NumZerocrossing(i+1) = numZerocrossing;
    info.MeanEnvelopeEnergy(i+1) = mean(mVal.^2);
    info.NumSifting(i+1) = k;
    info.RelativeTolerance(i+1) = rtol;
    
    % extract new IMF and subtract the IMF from residual signal
    IMFs(:,i+1) = rsigL;
    rsig = rsig - IMFs(:,i+1);
    i = i + 1;
end


% if(isInMATLAB && Display)
%     switch outerLoopExitFlag
%         case 0
%             disp(getString(message('shared_signalwavelet:emd:general:MaxNumIMFHit', 'MaxNumIMF')));
%         case 1
%             disp(getString(message('shared_signalwavelet:emd:general:MaxEnergyRatioHit', 'MaxEnergyRatio')));
%         case 2
%             disp(getString(message('shared_signalwavelet:emd:general:MaxNumExtremaHit', 'MaxNumExtrema')));
%     end
% end

% remove extra portion
IMFs = IMFs(:,1:i);
info.NumIMF = info.NumIMF(1:i);
info.NumExtrema = info.NumExtrema(1:i);
info.NumZerocrossing = info.NumZerocrossing(1:i);
info.NumSifting = info.NumSifting(1:i);
info.MeanEnvelopeEnergy = info.MeanEnvelopeEnergy(1:i);
info.RelativeTolerance = info.RelativeTolerance(1:i);
end


%--------------------------------------------------------------------------
function [uLoc, uVal, bLoc, bVal] = computeSupport(t, rsigL, pksIdx, btmsIdx)
% compute support for upper and lower envelope given input signal rsigL
N = length(t);
if(isempty(pksIdx))
    pksIdx = [1; N];
end

if(isempty(btmsIdx))
    btmsIdx = [1; N];
end

pksLoc = t(pksIdx);
btmsLoc = t(btmsIdx);

% compute envelop for wave method
% extended waves on the left
[lpksLoc, lpksVal, lbtmLoc, lbtmVal] = signalwavelet.internal.emd.emdWaveExtension(t(1), rsigL(1),...
    pksLoc(1), rsigL(pksIdx(1)),...
    btmsLoc(1), rsigL(btmsIdx(1)),...
    -1);

% extended waves on the right
[rpksLoc, rpksVal, rbtmLoc, rbtmVal] = signalwavelet.internal.emd.emdWaveExtension(t(end), rsigL(end),...
    pksLoc(end), rsigL(pksIdx(end)),...
    btmsLoc(end), rsigL(btmsIdx(end)),...
    1);

% append extended wave to extrema
uLoc = [lpksLoc;pksLoc;rpksLoc];
uVal = [lpksVal;rsigL(pksIdx);rpksVal];
bLoc = [lbtmLoc;btmsLoc;rbtmLoc];
bVal = [lbtmVal;rsigL(btmsIdx);rbtmVal];
end

