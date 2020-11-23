function [Y] = SA_SSE(X,m,tau,r,k)
%计算空间相关递归样本熵 signal_SDR_SE=sdr_sampen(signal,2,1,0.12,1)
%{ 
"Spatial-Dependence Recurrence Sample Entropy (sdr-SampEn)",
based on the concepts of SampEn, recurrence plots, and GLCM.

Reference: T.D. Pham, H. Yan, 
Spatial-dependence recurrence sample entropy, 
Physica A: Statistical Mechanics and its Applications, 
accepted (DOA: 6 December 2016).

INPUT:
X: time series
m: embedding dimension
tau: time delay
r: tolerance factor (eg. 0.15) to be multiplied with standard deviation
k = GLCM-offset in horizontal direction (eg. k=1, giving [0 1])

OUTPUT:
Y: Spatial-dependence recurrence sample entropy (sdr-SampEn) 

Functions used: 
crp.m (CRP Toolbox by Norbert Marwan), which can be downloaded at
"http://tocsy.pik-potsdam.de/CRPtoolbox/".

graycomatrix.m (Image Processing Toolbox of MathWorks)

* Note: This code is written for GLCM-offset in the horizontal direction.
It can be extended to include other geometrical orientations.

Author: Tuan Pham
%}

N = length(X);

% Set toterance based on SampEn
e = r*std(X); 

% Compute recurrence plots using maximum norm (Tchebychev distance or
% L_inf metric)
% 1 (white) indicates recurrence, otherwise 0 (black)
R1 = crp(X,m,tau,e,'nonormalize','maxnorm'); 
R2 = crp(X,m+1,tau,e,'nonormalize','maxnorm');

% Plotting
% spy(R1);
% spy(R2);

% Changing white to black pixels
R1=1-R1;
R2=1-R2;

% Create binary-level co-occurrence matrices
offsets = [0 k]; % k pixel(s) to the right (0 degree)
G1 = graycomatrix(double(R1),'NumLevels',2,'Offset',offsets);
G2 = graycomatrix(double(R2),'NumLevels',2,'Offset',offsets);

% Spatial-dependence recurrence SampEn
L1=length(R1); % square matrix
L2=length(R2); % square matrix
NumOffset1= (L1-k)*L1; % for horizontal offset 
NumOffset2= (L2-k)*L2; % for horizontal offset 
B1 = G1(1,1)/NumOffset1; % prob of co-occurrence of recurrence (black) in G1
B2 = G2(1,1)/NumOffset2; % prob of co-occurrence of recurrence (black) in G2
Y= -log(B2/B1); % sdr-SampEn
%-----------end-------------



