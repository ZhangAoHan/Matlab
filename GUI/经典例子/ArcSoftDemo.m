function  varargout = ArcSoftDemo( varargin )
% open the demo .

%  February 2004
%  $Revision: 1.00 $  



if (nargin == 0) 
    
    % find if have the same figure, and close it .
    OldFigure = findobj( 'type', 'figure', 'Tag', 'ArcSoftDemo' ) ;
    if ishandle( OldFigure )
        close( OldFigure ) ;
    end
    

    % generate a new figure .
    FigureHandle = figure( 'Visible', 'off' ) ;
    set( FigureHandle, 'Units' , 'pixels', 'Position', [150 150 500 300], ...
        'Name', '电弧炉对电网影响仿真软件', ...
        'Tag', 'ArcSoftDemo', ...
        'FileName' , '' ,...
        'MenuBar' , 'none' ,...
        'NumberTitle' , 'off' ,...
        'Resize', 'off', ...
        'windowstyle', 'normal', ...
        'Visible', 'off' ) ;
    
    % generate the menu .
    generate_MenuContent( FigureHandle ) ;
    
    % generate the uicontrols .
    generate_FigureContent( FigureHandle ) ;
     
   
    % display the figure .
    movegui( FigureHandle, 'center' ) ;
    set( FigureHandle, 'Visible', 'on' ) ;

    % init the data .
    init_FigureContent( FigureHandle ) ;
    
    
    if nargout > 0
        varargout{1} = FigureHandle;
    end
    
elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK
    
    global  SET_DEBUG_VALUE_IN_SIMULATOR ;
    if isempty( SET_DEBUG_VALUE_IN_SIMULATOR ) | ~isnumeric( SET_DEBUG_VALUE_IN_SIMULATOR )
        SET_DEBUG_VALUE_IN_SIMULATOR = 0 ;
    else
    end
    
    if  SET_DEBUG_VALUE_IN_SIMULATOR == 1 ; 
        
        if (nargout)
            [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
        else
            feval(varargin{:}); % FEVAL switchyard
        end             
        
    else        
        
        try
            if (nargout)
                [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
            else
                feval(varargin{:}); % FEVAL switchyard
            end
        catch            
            disp(lasterr);
        end
        
    end

    
end

% ------------------------------------------------------------
function  generate_MenuContent( FigureHandle ) ;


% generate the file menu .
% ------------------------------------------------------------
MenuHandle = uimenu( 'Parent', FigureHandle, 'Label', '文件(&F)' ) ;

% define the parameters of the menus .
MenuLabel = { '打开(&O)'; '退出(&E)' } ;

% add Polygon at 2003.10.13 .
MenuTag = { 'MenuOpenHistory'; 'MenuClose' } ;
MenuCallback = { ...
    ['ArcSoftDemo( ''MenuOpenHistory_Callback'', gcbf)']; ...
    ['close(gcbf);'] } ;
SeparatorGroup = { 'off'; 'off' } ;

% generate the uimenus of file .
% for num = 1: length( MenuTag )
for num = 2
    UimenuHandle(num) = uimenu( MenuHandle ) ;
    set( UimenuHandle(num), 'Tag' , MenuTag{num} , ...
        'Callback' , MenuCallback{num} , ...
        'Label' , MenuLabel{num} , ...
        'Separator', SeparatorGroup{num} ) ;
end






% ------------------------------------------------------------
function  generate_FigureContent( FigureHandle )
% generate the uicontrols .



% init the variables .
FigureWidth = 700 ;
FigureHeight = 520 ;
TabSpace = 10 ;
TextHeight = 22 ;
ChangeYPos = 30 ;


% reset the figure's size .
set( FigureHandle, 'Units', 'pixels', ...
    'Position', [150 150  FigureWidth  FigureHeight], ...
    'Color', [0.8824    0.8824    0.8824], ... 
    'DoubleBuffer', 'on' ) ;

% generate the axes to plot lines .
AxesHandle = axes( 'Parent', FigureHandle, 'Units' , 'normalized' ,  ...
    'Position', [0 0 1 1], 'Visible', 'off', ...
    'Xlim', [0  FigureWidth], 'Ylim', [0  FigureHeight] ) ;

% get the color of the figure .
FigureColor = get( FigureHandle, 'Color' ) ;
% reset the default value of the uicontrols .
set(FigureHandle,'defaultuicontrolunits','normalized');
set(FigureHandle,'defaultuicontrolfontname','隶书');
set(FigureHandle,'defaultuicontrolBackgroundColor', FigureColor );


% define the first frame .
TitleXPos = TabSpace ;
TitleWidth = FigureWidth - TabSpace * 1.5 ;
TitleHeight = 25 ;
TitleYPos = FigureHeight - TitleHeight - TabSpace * 1 ;
TitlePosition = [TitleXPos  TitleYPos  TitleWidth  TitleHeight] ;
% generate the second frame .
% com_BackgroundFrame(AxesHandle, Frame1Position ) ;
Titlehandle = uicontrol(FigureHandle,'style','text', 'unit','pixels',...
    'position',TitlePosition,'horizontal','center',...
    'string', '实例演示', 'fontsize',15 );


handles = guihandles( FigureHandle ) ;
guidata( FigureHandle, handles ) ;




% --------------------------------------------------------------------------
function  init_FigureContent( FigureHandle )
  

% init the variables .
FigureWidth = 700 ;
FigureHeight = 500 ;
TabSpace = 10 ;
TextHeight = 22 ;
ChangeYPos = 30 ;


% AxesWidth = 600 ;
% AxesHeight = 400 ;
AxesWidth = 620 ;
AxesHeight = 460 ;
AxesXPos = (FigureWidth - AxesWidth) / 2 ;
AxesYPos = (FigureHeight - AxesHeight) / 2 ;
% get the axes' position .
AxesPosition = [AxesXPos  AxesYPos  AxesWidth  AxesHeight] ;

% generate the axes to display mthe movie .
AxesHandle = axes( 'Parent', FigureHandle, 'Units', 'pixels', ...
    'position', AxesPosition, 'visible', 'off' );


try
    load( 'ImageData.mat', 'ImageData') ;
catch
    
    % load the picture data .
    ImageCData = imread( 'UndeePicture.BMP', 'BMP' ) ;
    for num1 = 1:3
        ImageCData(:,:,num1) = flipud( ImageCData(:,:,num1) ) ;
    end
    
    ImageXPos = TabSpace * 5 ;
    ImageYPos = TabSpace * 5 ;
    ImageWidth = (FigureWidth - ImageXPos * 2) ;
    ImageHeight = (FigureHeight - ImageYPos * 2.5) ;
    ImageXData = ImageXPos + [0  ImageWidth] ;
    ImageYData = ImageYPos + [0  ImageHeight] ;
    % generate a image to display picture .
    MovieImageHandle = image( 'Parent', AxesHandle, ...
        'XData', ImageXData, 'YData', ImageYData, ...
        'Cdata', ImageCData ) ;
    return ;
end



while ishandle( AxesHandle )
    % 显示demo图片。
    com_Movie( AxesHandle, ImageData, 1, 0.5 );
    
    return ;    
end



% --------------------------------------------------------------------------
function  varargout = com_Movie( varargin ) ;
% movie  the image in sepicial axes .

AxesHandle = varargin{1} ;
ImageData = varargin{2} ;

if nargin <3 ;
    PlayTimes = 1 ;
else
    PlayTimes = varargin{3} ;
end

if nargin < 4
    Frequency = 1 ;
else
    Frequency = varargin{4} ;
end

OldMovieImageHandle = findobj( AxesHandle, 'Type', 'image', 'Tag', 'OnlyMovieImage' ) ;
if isempty( OldMovieImageHandle ) | ~ishandle( OldMovieImageHandle ) 
    MovieImageHandle = image( 'Parent', AxesHandle, 'Cdata', [] ) ;
else
    MovieImageHandle = OldMovieImageHandle ;
end


for index = 1: PlayTimes
    for num = 1: length( ImageData )
        
        if ~ishandle( AxesHandle )
            return ;
        end
        % reset the limit of current axes .
        CDataSize = size( ImageData(num).cdata ) ;
        set( AxesHandle, 'XLim', [0  CDataSize(2)], 'YLim', [0  CDataSize(1)] ) ;
        % update the image .
        set( MovieImageHandle, 'CData', ImageData(num).cdata ) ;
        
        ColormapData = ImageData(num).colormap ; 
        if ~isempty( ColormapData )
            colormap(ColormapData)
        end
        drawnow ; 
        pause( 1/Frequency ) ;
    end
    
end

