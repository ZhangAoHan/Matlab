function  varargout = SimulateFigure( varargin )
% this module simulate the data .

%  February 2004
%  $Revision: 1.00 $ 




if (nargin == 0) | isstruct( varargin{1} )     %  LAUNCH GUI
    
    if nargin == 1
        ArcSimulationData = varargin{1} ;
    else
        ArcSimulationData = [] ;
    end
    
    % find if have the same figure, and close it .
    OldFigure = findobj( 'type', 'figure', 'Tag', 'SimulateFigure' ) ;
    if ishandle( OldFigure )
        close( OldFigure ) ;
    end
    

    % generate a new figure .
    FigureHandle = figure( 'Visible', 'off' ) ;
    set( FigureHandle, 'Units' , 'pixels', 'Position', [150 150 500 300], ...
        'Name', '电弧炉对电网影响仿真软件', ...
        'Tag', 'SimulateFigure', ...
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
    
    % save the ArcSimulationData .
    setappdata( FigureHandle, 'ArcSimulationData', ArcSimulationData ) ;

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
MenuLabel = { '退出(&E)' } ;

% add Polygon at 2003.10.13 .
MenuTag = { 'MenuClose' } ;
MenuCallback = { ...
    ['close all;'] } ;
SeparatorGroup = { 'off' } ;

% generate the uimenus of file .
for num = 1: length( MenuTag )
    UimenuHandle(num) = uimenu( MenuHandle ) ;
    set( UimenuHandle(num), 'Tag' , MenuTag{num} , ...
        'Callback' , MenuCallback{num} , ...
        'Label' , MenuLabel{num} , ...
        'Separator', SeparatorGroup{num} ) ;
end



% generate the formula menu .
% ------------------------------------------------------------
MenuHandle = uimenu( FigureHandle, 'Label', '公式(&m)' ) ;

% define the parameters of the menus .
MenuLabel = { '状态方程(&L)'; } ;

% add Polygon at 2003.10.13 .
MenuTag = { 'MenuMainCircuitFormula'; } ;
MenuCallback = { ...
    ['EditParameter( ''MainCircuitFormula_Callback'', gcbo)'] } ;
SeparatorGroup = { 'off' } ;

% generate the uimenus of file .
for num = 1
    UimenuHandle(num) = uimenu( MenuHandle ) ;
    set( UimenuHandle(num), 'Tag' , MenuTag{num} , ...
        'Callback' , MenuCallback{num} , ...
        'Label' , MenuLabel{num} , ...
        'Separator', SeparatorGroup{num} ) ;
end


% generate the parameter menu .
% ------------------------------------------------------------
MenuHandle = uimenu( FigureHandle, 'Label', '帮助(&H)', 'Enable', 'on' ) ;

% define the parameters of the menus .
MenuLabel = { '帮助(&O)'; '演示(&E)'; '关于' } ;

% add Polygon at 2003.10.13 .
MenuTag = { 'MenuHelp'; 'MenuDemo'; 'MenuAbout' } ;
MenuCallback = { ...
    ['ArcSimulationSoft( ''MenuHelp_Callback'', gcbo)']; ...
    ['ArcSimulationSoft( ''MenuDemo_Callback'', gcbo)']; ...
    ['ArcSimulationSoft( ''MenuAbout_Callback'', gcbo)']; } ;
SeparatorGroup = { 'off'; 'on'; 'on' } ;

% generate the uimenus of file .
for num = 1: length( MenuTag )
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
FigureWidth = 600 ;
FigureHeight = 400 ;
TabSpace = 10 ;
TextHeight = 22 ;
ChangeYPos = 30 ;


% reset the figure's size .
set( FigureHandle, 'Units', 'pixels', ...
    'Position', [150 150  FigureWidth  FigureHeight], ...
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
    'string', '仿真', 'fontsize',15 );


% generate the parameters of the CircuitDiagram .
% -----------------------------------------------------------------------------
% define the first frame .
FrameXPos = TabSpace * 2 ;
FrameWidth = FigureWidth - TabSpace * 4 ;
FrameHeight = 160 ;
FrameYPos = TitlePosition(2) - FrameHeight - TabSpace * 1 ;
Frame1Position = [FrameXPos  FrameYPos  FrameWidth  FrameHeight] ;
% generate a frame .
% TitleHandle=uicontrol(FigureHandle,'style','frame', 'Units','pixels',...
%     'position',Frame1Position  );
LineXData = [FrameXPos  FrameXPos  (FrameXPos + FrameWidth)  (FrameXPos + FrameWidth)  FrameXPos] ;
LineYData = [FrameYPos  (FrameYPos + FrameHeight)  (FrameYPos + FrameHeight)  FrameYPos  FrameYPos] ;
TitleHandle = line ( 'Parent', AxesHandle, 'XData', LineXData, 'YData', LineYData,...
    'LineStyle', '-', 'Color', [0  0  0], 'Marker', 'none'  );


TextXPos = Frame1Position(1) + 15 ;
TextYPos = Frame1Position(2) + Frame1Position(4) - 12 ;
TextWidth = 80 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% subtitle: 电路图
SubtitleHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition,'horizontal','center',...
    'string', '电路图', 'fontsize',13 );



% load the picture data .
ImageCData = imread( 'CircuitDiagram.BMP', 'BMP' ) ;
for num1 = 1:3
    ImageCData(:,:,num1) = flipud( ImageCData(:,:,num1) ) ;
end

ImageXPos = Frame1Position(1) + TabSpace * 1.5 ;
ImageYPos = Frame1Position(2) + TabSpace * 1.5 ;
ImageWidth = 530 ;
ImageHeight = 130 ;
ImageXData = ImageXPos + [0  ImageWidth] ;
ImageYData = ImageYPos + [0  ImageHeight] ;
% generate a image to display picture .
MovieImageHandle = image( 'Parent', AxesHandle, ...
    'XData', ImageXData, 'YData', ImageYData, ...
    'Cdata', ImageCData ) ;


% display the formula .
% -----------------------------------------------------------------------------
% define the second frame .
FrameXPos = Frame1Position(1) ;
FrameWidth = FigureWidth - TabSpace * 4 + 1 ;
FrameHeight = 90 ;
FrameYPos = Frame1Position(2) - FrameHeight - TabSpace * 2 ;
Frame2Position = [FrameXPos  FrameYPos  FrameWidth  FrameHeight] ;
% generate a frame .
TitleHandle = uicontrol(FigureHandle,'style','frame', 'Units','pixels',...
    'position',Frame2Position  );


TextXPos = Frame2Position(1) + 15 ;
TextYPos = Frame2Position(2) + Frame2Position(4) - 12 ;
TextWidth = 80 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% subtitle: 公式
SubtitleHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition,'Horizontal','center',...
    'string', '公式', 'fontsize',13 );


% get the position of explain text .
TextXPos = Frame2Position(1) + TabSpace ;
TextYPos = Frame2Position(2) + Frame2Position(4) - TextHeight - TabSpace * 2 ;
TextWidth = 100 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% generate the text: 状态方程
TextHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition,'Horizontal','center',...
    'string', '状态方程', 'fontsize',11 );


% get the position of buttons .
ButtonXPos = TextPosition(1) + TextPosition(3) + TabSpace ;
ButtonYPos = TextPosition(2) ;
ButtonWidth = 70 ;
ButtonPosition = [ButtonXPos  ButtonYPos  ButtonWidth  TextHeight] ;
ButtonHandle = uicontrol( 'Parent', FigureHandle, 'Units', 'Pixels', 'Position', ButtonPosition, ...
    'Style', 'pushbutton', 'Tag', 'MainCircuitFormula', 'string', '显示',  'Fontsize',11, ...
    'Callback', ['EditParameter(''MainCircuitFormula_Callback'',gcbo)'] ) ;

% get the position of explain text .
TextXPos = Frame1Position(1) + TabSpace ;
TextYPos = TextPosition(2) - TextHeight - TabSpace * 1 ;
TextWidth = 100 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% generate the text: 电弧电阻公式
TextHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition,'Horizontal','center',...
    'string', '电弧电阻公式', 'fontsize',11 );


% get the position of explain text .
TextXPos = TextPosition(1) + TextPosition(3) + TabSpace ;
TextYPos = TextPosition(2)  ;
TextWidth = 425 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% generate the text: 电弧电阻公式
TextHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition,'Horizontal','left', 'BackgroundColor', [1  1  1], ...
    'string', '   R(t)=C*L*exp{1/[A+B(1-cos(2ωt+θ+D))]}', 'fontsize',11 );




% define the parameters of the buttons .
% ButtonString = { '上一步';'下一步' } ; 
ButtonString = { '上一步';'仿真' } ; 
ButtonTag = { 'PreviousButton'; 'NextButton' } ;
ButtonCallback = { ['SimulateFigure(''PreviousButton_Callback'',gcbo)']; ...
        ['SimulateFigure(''NextButton_Callback'',gcbo)'] } ;

ButtonWidth = 80 ;
ButtonHeight = 25 ;
ButtonXPos = FigureWidth - ButtonWidth * 2 - TabSpace * 4 ;
ButtonYPos = TabSpace * 2 ;;
ButtonPosition = [ButtonXPos  ButtonYPos  ButtonWidth  ButtonHeight] ;
for num = 1: 2
    TempButtonPosition = ButtonPosition ;
    TempButtonPosition(1) = TempButtonPosition(1) + (num - 1) * (ButtonWidth + TabSpace) ;
    % generate the pushbutton: Simulate .
    ButtonHandle = uicontrol( 'Parent', FigureHandle, 'Units', 'Pixels', 'Position', TempButtonPosition, ...
        'Style', 'pushbutton', 'Tag',ButtonTag{num}, 'string', ButtonString{num}, 'Fontsize',12, ...
        'Callback', ButtonCallback{num} ) ;
    
end


handles = guihandles( FigureHandle ) ;
guidata( FigureHandle, handles ) ;




% --------------------------------------------------------------------------
function  init_FigureContent( h )
       
handles = guidata( h ) ;

% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.SimulateFigure, 'ArcSimulationData' ) ;
if isempty( ArcSimulationData )
    ArcSimulationData = ArcSimulationSoft( 'Get_DefaultArcSimulationData' ) ;
    % save the data .
    setappdata( handles.SimulateFigure, 'ArcSimulationData', ArcSimulationData ) ;
end





% --------------------------------------------------------------------------
function  PreviousButton_Callback( h )
       
handles = guidata( h ) ;

% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.SimulateFigure, 'ArcSimulationData' ) ;

% return the parameter figure .
EditParameter( ArcSimulationData ) ;


% close the current figure .
pause(0) ;
close( handles.SimulateFigure ) ;



% --------------------------------------------------------------------------
function  NextButton_Callback( h )
       
handles = guidata( h ) ;

% 将鼠标设为等待。
set( handles.SimulateFigure, 'Pointer', 'watch' ) ;


% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.SimulateFigure, 'ArcSimulationData' ) ;
if isempty( ArcSimulationData )
    ArcSimulationData = ArcSimulationSoft( 'Get_DefaultArcSimulationData' ) ;
    % save the data .
    setappdata( handles.SimulateFigure, 'ArcSimulationData', ArcSimulationData ) ;
end



% ================================================
%  在这里加上的仿真模块，并且输出结果。
 ArcSimulationData = SimulateModule( ArcSimulationData ) ;
 
% ================================================


% open the next figure ,
DisplayResult( ArcSimulationData ) ;


% close the current figure .
pause(0) ;
close( handles.SimulateFigure ) ;
