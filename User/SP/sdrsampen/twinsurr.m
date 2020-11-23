function [y nTw] = twinsurr(varargin)
% TWINSURR   Creates twin surrogates for statistical tests.
%    Y=TWINSURR(X) creates twin surrogates Y based on the vector X
%    using recurrences. The matrix Y contains 100 columns of
%    100 twin surrogates. If X is a PxQ matrix, the resulting
%    surrogate matrix is PxQx100.
%
%    Y=TWINSURR(X,M,T,E,...) creates twin surrogates using
%    embedding dimension M, delay T, recurrence threshold E. The
%    input arguments are similar to those of the command CRP.
%
%    Y=TWINSURR(X,M,T,E,...,N) creates N surrogates (default is 100).
%
%    [Y,NTWINS]=TWINSURR(...) where NTWINS is the total number
%    of twins in the RP.
%
%    Note: Please check before use the recurrence parameters M, T, and
%          E by visual inspection of the recurrence plot! Please also
%          check the number of twins NTWINS whether enough twins have
%          been found.
%
%    Example: x = rand(3,1);
%             a = [.8 .3 -.25 .9]';
%             for i = 4:1000,
%                x(i) = sum(a(1:3) .* x(i-1:-1:i-3)) + a(end) * randn;
%             end
%             xs = twinsurr(x,1,1,.1,'euc',10);
%
%    See also CRP, RECONS.
%
%    References: 
%    Thiel, M., Romano, M. C., Kurths, J., Rolfs, M., Kliegl, R.: 
%    Twin Surrogates to Test for Complex Synchronisation, 
%    Europhys. Lett., 75, 2006.

% Copyright (c) 2008-
% Norbert Marwan, Maik Riedl, Potsdam Institute for Climate Impact Research, Germany
% http://www.pik-potsdam.de
%
% Copyright (c) 2008
% Norbert Marwan, Potsdam University, Germany
% http://www.agnld.uni-potsdam.de
%
% $Date: 2016/03/03 14:57:40 $
% $Revision: 5.7 $
%
% $Log: twinsurr.m,v $
% Revision 5.7  2016/03/03 14:57:40  marwan
% updated input/output check (because Mathworks is removing downwards compatibility)
% bug in crqad_big fixed (calculation of xcf).
%
% Revision 5.6  2016/03/01 16:26:03  marwan
% added support for multi-column phase space vectors
%
% Revision 5.5  2016/03/01 15:56:47  marwan
% complete recoding based on an implementation by Maik Riedl (much faster calculations)
%
% Revision 5.4  2009/03/24 08:33:47  marwan
% copyright address changed
%
% Revision 5.3  2009/03/17 09:18:17  marwan
% serious bug fix, zero columns were also considered as twins!
%
% Revision 5.2  2008/07/02 12:00:48  marwan
% silent ability added, minor bug fixes
%
% Revision 5.1  2008/07/01 13:09:27  marwan
% initial import
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% programme properties

global errcode props

init_properties
nsur_init = 100;
sil = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% check the input

narginchk(1,7);
nargoutchk(0,2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% read the input

% transform any int to double
intclasses = {'uint8';'uint16';'uint32';'uint64';'int8';'int16';'int32';'int64'};
flagClass = [];
for i = 1:length(intclasses)
    i_int=find(cellfun('isclass',varargin,intclasses{i}));
    if ~isempty(i_int)
        for j = 1:length(i_int)
            varargin{i_int(j)} = double(varargin{i_int(j)});
        end
        flagClass = [flagClass; i_int(:)];
    end
end
if ~isempty(flagClass)
    disp(['Warning: Input arguments at position [',num2str(flagClass'),'] contain integer values']);
    disp(['(now converted to double).'])
end


varargin{8}=[];
i_double=find(cellfun('isclass',varargin,'double'));
i_char=find(cellfun('isclass',varargin,'char'));
check_meth={'ma','eu','mi'}; 	% maxnorm, euclidean, nrmnorm,  fan, distance
check_norm={'non','nor'};                        % nonormalize, normalize
check_sil={'ve','si'};                         % verbose, silent
nonorm = 0;
if isnumeric(varargin{1}) 		% read commandline input
   % check the text input parameters for method, gui 
    temp_meth=0;
    temp_norm=0;
    temp_sil=0;
    if ~isempty(i_char)
         for i=1:length(i_char), 
            varargin{i_char(i)}(4)='0';
            temp_norm=temp_norm+strcmpi(varargin{i_char(i)}(1:3),check_norm'); 
            temp_meth=temp_meth+strcmpi(varargin{i_char(i)}(1:2),check_meth'); 
            temp_sil=temp_sil+strcmpi(varargin{i_char(i)}(1:2),check_sil'); 
         end
         method_n=min(find(temp_meth));
         nonorm=min(find(temp_norm))-1;
         sil=min(find(temp_sil))-1;
         for i=1:length(i_char); temp2(i,:)=varargin{i_char(i)}(1:3); end

         if isempty(sil), sil=0; end
         if isempty(nonorm), nonorm=0; end
         if nonorm>1, nonorm=1; end
         if isempty(method_n), method_n=1; end
         if method_n>length(check_meth), method0=length(check_meth); end
         method=check_meth{method_n};
         norm_str = check_norm{nonorm+1};
    else
         method = 'max'; norm_str = 'non';
    end

    % get the parameters for creating RP
    if max(size(varargin{1}))<=3
        disp('Error using ==> twinsurr')
        disp('To less values in data X.')
        return
    end
    x=double(varargin{1});

    if ~isempty(varargin{i_double(2)}), m=varargin{i_double(2)}(1); else m=1; end
    if ~isempty(varargin{i_double(3)}), t=varargin{i_double(3)}(1); else t=1; end
    if ~isempty(varargin{i_double(4)}), e=varargin{i_double(4)}(1); else e=.1; end
    if ~isempty(varargin{i_double(5)}), nsur=varargin{i_double(5)}(1); else nsur=nsur_init; end
else
    disp('Error using ==> twinsurr')
    disp('No valid arguments.')
    return
end


if size(x,1) < size(x,2), x = x'; end
if size(x,2) > 1 & m > 1
    warning('Embedding for multi-column phase space vectors is not supported. Continue without embedding.')
    m = 1;
end

N = length(x); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% main part: create surrogates

if size(x,2) > 1
   surr = zeros(N,size(x,2),nsur);
else
   surr = zeros(N,nsur);
end

%% find twins
h = [];
if ~sil & N > 3000, h = waitbar(0,'Find recurrences'); end
twinList = findTwins(x,m,t,e,method,nonorm,sil,h);
nTwins = length(twinList); % number of twins 

if nTwins < 1
    if ~sil & exist('h') & ishandle(h), close(h), end
    error(['No twins found!',10,'The derived surrogates would identical with the original data.']')
end

%% marker list for number of twins
markerTwin = zeros(N,1);
for i = 1:nTwins
    markerTwin(twinList{i}) = i;
end

%% remove the last twin from twinList                  
temp_ind = find(markerTwin);
temp_ind2 = find(twinList{markerTwin(temp_ind(end))} == temp_ind(end));
twinList{markerTwin(temp_ind(end))}(temp_ind2) = [];

%% create twin surrogate
cnt = 0;
while cnt < nsur
    idxSurr = ceil(rand(1)*N); % random starting point
    r_ind = rand(N,1);
    i = 2;
    while (idxSurr(i-1)+1) <= N % just go through the time series (the next point after the last found point)
        if markerTwin(idxSurr(i-1)+1) ~= 0 % we have twins: let's jump!
            nr_sel = ceil(r_ind(i) * length(twinList{markerTwin(idxSurr(i-1)+1)})); % select randomly a new point
            idxSurr(i)=twinList{markerTwin(idxSurr(i-1)+1)}(nr_sel); % jump to this new point
        else
           idxSurr(i) = idxSurr(i-1)+1; % just use the next point from the time series
        end
        i = i + 1; % just go through the time series
        if i > N
            break
        end
    end
    if length(idxSurr)==N
        cnt = cnt + 1;
        if size(x,2) > 1
           surr(:,:,cnt)=x(idxSurr,:);
        else
           surr(:,cnt)=x(idxSurr,:);
        end
        if ~sil & ~isempty(h) & mod(cnt,100)==0
            waitbar((2*N+N*cnt/nsur)/(3*N),h,'Create surrogates')
        end
    end
end

if ~sil & exist('h') & ishandle(h), close(h), end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% output
if nargout > 0;
   y = surr;
else
   surr
end


if nargout == 2;
    nTw = nTwins;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% helper function (findTwins)


function twinList=findTwins(x,m,t,thr,method,nonorm,sil,h)
% FINDTWINS   Find twins in recurrence plot.
%
%    twinList=TWIN_MAIK(X,M,TAU,THR)
%
%The function look for the twins in a time series X.
%Therefore the phase space is reconstructed by time delay embedding
%approach where M is the dimension of the phase space and TAU is
%the time delay.
%Neighbouring points are two points with a distance smaller than the
%threshold THR.
%Twins are points with the same neighbourhood.

if nonorm
    if ~sil, disp('Normalize data.'), end
    x = zscore(x);
end

updateTime = 100;
N = length(x);

%% Reconstruct phase space if m is set
if m > 1
    Nx = N - (m-1)*t;
    xEmb = zeros(Nx,m);                
    for i = 1:m
        xEmb(:,i) = x(((i-1)*t+1):(end-t*(m-i)));
    end
else
    xEmb = x;
    Nx = N;
end
    
%% Find recurrence points (= neighbours) for each state
% this is a list of neighbours for each time point/state
idxNeighbours = [];
nNeighbours=[];
for i = 1:Nx, if ~sil & ~isempty(h) & mod(i,updateTime)==0, waitbar(i/(3*N)), end
    % distance between current state and all other states
    switch method
        case 'eu'
           d = sqrt(sum((xEmb-repmat(xEmb(i,:),Nx,1)).^2,2));
        case 'mi'
           d = sum(abs(xEmb-repmat(xEmb(i,:),Nx,1)),2);
        otherwise
           d = max(abs(xEmb-repmat(xEmb(i,:),Nx,1)),[],2);
    end
    % indices of the Neighbours
    idxNeighbours{i} = find(d<thr);
    % number of Neighbours found (useful for acceleration of the algorithm)
    nNeighbours(i) = length(idxNeighbours{i});
end

%% Find twins
ind_p = 1:Nx; % set of states
twinList = []; % list of twins 
cnt = 1;
while length(ind_p) > 1,if ~sil & ~isempty(h) & mod(i,updateTime)==0, waitbar((2*N - length(ind_p))/(3*N),h,'Find twins'), end
    currentTwins = 1; % start with the first entry in the (remaining) set 
    % find only those columns in the RP that have the same number of neighbours
    potentialTwins = find(nNeighbours == nNeighbours(1)); % this will speed up the code
    for i = 2:length(potentialTwins)
        if sum(abs(idxNeighbours{1}-idxNeighbours{potentialTwins(i)})) == 0 & any(idxNeighbours{1})
            currentTwins = [currentTwins, potentialTwins(i)];
        end
    end
    if length(currentTwins) > 1
        twinList{cnt} = ind_p(currentTwins);
        cnt = cnt + 1;
    end
    % remove all states that are already found
    ind_p(currentTwins) = [];
    idxNeighbours(currentTwins) = [];
    nNeighbours(currentTwins) = [];
end

if ~sil & ~isempty(h), waitbar(2/3,h), end
