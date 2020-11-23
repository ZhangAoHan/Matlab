function [varargout]= SAM_VMD(varargin)
%% 输入 输出
%varargin{1}=y             原始信号
%varargin{2}=fs            原始信号频率
%varargin{3}=alpha         模态的频率范围（该值越大，IMF的频率范围越小）  
%varargin{4}=tau           噪声耐度
%varargin{5}=K             输出的IMF个数  
%varargin{6}=DC            0（），1 （）
%varargin{7}=init          0（），1（），2（）
%varargin{8}=tol           误差  

%varargout{1}=imfs         分解结果           
%varargout{2}=imfs_hat     IMF的范围
%varargout{3}=omega        IMF的估计中心频率
%% 输入数据整理
%默认输入(y,fs,5000,0.3,fix(log2(length(y))),0,1,1e-7)
tol=varargin{8};
init=varargin{7};
DC=varargin{6};
K=varargin{5};
tau=varargin{4};
alpha=varargin{3};
fs=varargin{2};
y=varargin{1};
%% 分解代码
%使用镜像延扩法 对数据进行扩充，防止端点效应
y_num=length(y);
y_left=y(y_num/2:-1:1);
y_right=y(y_num:-1:(y_num/2)+1);
y_hc=[y_left,y,y_right];
y_hc_num=length(y_hc);
%计算合成序列的时序  
t=(1:y_hc_num)/y_hc_num;     
% Spectral Domain discretization
freqs = t-0.5-1/y_hc_num;
%设置循环最大迭代次数
N=500;
% For future generalizations: individual alpha for each mode
Alpha = alpha*ones(1,K);
% Construct and center f_hat
f_hat_plus = fftshift((fft(y_hc)));
f_hat_plus(1:y_hc_num/2) = 0;
%初始化
u_hat_plus = zeros(N, length(freqs), K);
omega_plus = zeros(N, K);
lambda_hat = zeros(N, length(freqs));
switch init
    case 1
        for i = 1:K
            omega_plus(1,i) = (0.5/K)*(i-1);
        end
    case 2
        omega_plus(1,:) = sort(exp(log(fs) + (log(0.5)-log(fs))*rand(1,K)));
    otherwise
        omega_plus(1,:) = 0;
end
if DC
    omega_plus(1,1) = 0;
end
uDiff = tol+eps; % update step
n = 1; % loop counter
sum_uk = 0; % accumulator
%循环
while ( uDiff > tol &&  n < N ) % not converged and below iterations limit
    
    % update first mode accumulator
    k = 1;
    sum_uk = u_hat_plus(n,:,K) + sum_uk - u_hat_plus(n,:,1);
    
    % update spectrum of first mode through Wiener filter of residuals
    u_hat_plus(n+1,:,k) = (f_hat_plus - sum_uk - lambda_hat(n,:)/2)./(1+Alpha(1,k)*(freqs - omega_plus(n,k)).^2);
    
    % update first omega if not held at 0
    if ~DC
        omega_plus(n+1,k) = (freqs(y_hc_num/2+1:y_hc_num)*(abs(u_hat_plus(n+1, y_hc_num/2+1:y_hc_num, k)).^2)')/sum(abs(u_hat_plus(n+1,y_hc_num/2+1:y_hc_num,k)).^2);
    end
    
    % update of any other mode
    for k=2:K
        
        % accumulator
        sum_uk = u_hat_plus(n+1,:,k-1) + sum_uk - u_hat_plus(n,:,k);
        
        % mode spectrum
        u_hat_plus(n+1,:,k) = (f_hat_plus - sum_uk - lambda_hat(n,:)/2)./(1+Alpha(1,k)*(freqs - omega_plus(n,k)).^2);
        
        % center frequencies
        omega_plus(n+1,k) = (freqs(y_hc_num/2+1:y_hc_num)*(abs(u_hat_plus(n+1, y_hc_num/2+1:y_hc_num, k)).^2)')/sum(abs(u_hat_plus(n+1,y_hc_num/2+1:y_hc_num,k)).^2);
        
    end
    
    % Dual ascent
    lambda_hat(n+1,:) = lambda_hat(n,:) + tau*(sum(u_hat_plus(n+1,:,:),3) - f_hat_plus);
    
    % loop counter
    n = n+1;
    
    % converged yet?
    uDiff = eps;
    for i=1:K
        uDiff = uDiff + 1/y_hc_num*(u_hat_plus(n,:,i)-u_hat_plus(n-1,:,i))*conj((u_hat_plus(n,:,i)-u_hat_plus(n-1,:,i)))';
    end
    uDiff = abs(uDiff);
    
end
%后处理
N = min(N,n);
omega = omega_plus(1:N,:);

% Signal reconstruction
u_hat = zeros(y_hc_num, K);
u_hat((y_hc_num/2+1):y_hc_num,:) = squeeze(u_hat_plus(N,(y_hc_num/2+1):y_hc_num,:));
u_hat((y_hc_num/2+1):-1:2,:) = squeeze(conj(u_hat_plus(N,(y_hc_num/2+1):y_hc_num,:)));
u_hat(1,:) = conj(u_hat(end,:));

u = zeros(K,length(t));

for k = 1:K
    u(k,:)=real(ifft(ifftshift(u_hat(:,k))));
end

% remove mirror part
u = u(:,y_hc_num/4+1:3*y_hc_num/4);

% recompute spectrum
clear u_hat;
for k = 1:K
    u_hat(:,k)=fftshift(fft(u(k,:)))';
end
%% 输出数据整理
if nargout > 0
    varargout{1} = u;
end
if nargout > 1
    varargout{2} = u_hat;
end
if nargout > 2
    varargout{3} = omega;
end
