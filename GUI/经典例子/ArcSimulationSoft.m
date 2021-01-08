function  varargout = ArcSimulationSoft( varargin )
% this module open the soft .

%  February 2004
%  $Revision: 1.00 $  


if (nargin == 0) | isstruct( varargin{1} )     %  LAUNCH GUI
    
    if nargin == 1
        ArcSimulationData = varargin{1} ;
    else
        ArcSimulationData = [] ;
    end
    
    
    % find if have the same figure, and close it .
    OldFigure = findobj( 'type', 'figure', 'Tag', 'ArcSimulationSoft' ) ;
    if ishandle( OldFigure )
        close( OldFigure ) ;
    end
    

    % generate a new figure .
    FigureHandle = figure( 'Visible', 'off' ) ;
    set( FigureHandle, 'Units' , 'pixels', 'Position', [150 150 500 300], ...
        'Name', '电弧炉对电网影响仿真软件', ...
        'Tag', 'ArcSimulationSoft', ...
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
MenuLabel = { '打开(&O)'; '退出(&E)' } ;

% add Polygon at 2003.10.13 .
MenuTag = { 'MenuOpenHistory'; 'MenuClose' } ;
MenuCallback = { ...
    ['ArcSimulationSoft( ''MenuOpenHistory_Callback'', gcbf)']; ...
    ['close all;'] } ;
SeparatorGroup = { 'off'; 'on' } ;

% generate the uimenus of file .
for num = 1: length( MenuTag )
% for num = 2
    UimenuHandle(num) = uimenu( MenuHandle ) ;
    set( UimenuHandle(num), 'Tag' , MenuTag{num} , ...
        'Callback' , MenuCallback{num} , ...
        'Label' , MenuLabel{num} , ...
        'Separator', SeparatorGroup{num} ) ;
end



% % generate the parameter menu .
% % ------------------------------------------------------------
% MenuHandle = uimenu( FigureHandle, 'Label', '参数(&P)' ) ;
% 
% % define the parameters of the menus .
% MenuLabel = { '导入(&L)'; '编辑(&E)' } ;
% 
% % add Polygon at 2003.10.13 .
% MenuTag = { 'MenuLoadData'; 'MenuEditParameter' } ;
% MenuCallback = { ...
%     ['ArcSimulationSoft( ''MenuLoadData_Callback'', gcbo)']; ...
%     ['ArcSimulationSoft( ''BeginButton_Callback'', gcbo)']; } ;
% SeparatorGroup = { 'off'; 'on' } ;
% 
% % generate the uimenus of file .
% for num = 1: length( MenuTag )
%     UimenuHandle(num) = uimenu( MenuHandle ) ;
%     set( UimenuHandle(num), 'Tag' , MenuTag{num} , ...
%         'Callback' , MenuCallback{num} , ...
%         'Label' , MenuLabel{num} , ...
%         'Separator', SeparatorGroup{num} ) ;
% end


% generate the parameter menu .
% ------------------------------------------------------------
MenuHandle = uimenu( FigureHandle, 'Label', '帮助(&H)', 'Enable', 'on' ) ;

% define the parameters of the menus .
MenuLabel = { '帮助(&P)'; '演示(&D)'; '关于(&A)' } ;

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
TextHeight = 20 ;
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
FrameXPos = TabSpace ;
FrameWidth = FigureWidth - TabSpace * 2 ;
FrameHeight = 120 ;
FrameYPos = FigureHeight - FrameHeight - TabSpace * 2 ;
Frame1Position = [FrameXPos  FrameYPos  FrameWidth  FrameHeight] ;
% generate the second frame .
% com_BackgroundFrame(AxesHandle, Frame1Position ) ;
h_text=uicontrol(FigureHandle,'style','text', 'unit','pixels',...
    'position',Frame1Position,'Horizontal','center',...
    'string',{'电弧炉对电网影响'; ''; '仿真软件'},'fontsize',30);


% load the picture data .
ImageCData = imread( 'UndeePicture.BMP', 'BMP' ) ;
for num1 = 1:3
    ImageCData(:,:,num1) = flipud( ImageCData(:,:,num1) ) ;
end

ImageXPos = TabSpace * 2 ;
ImageYPos = TabSpace * 2 ;
ImageWidth = 350 ;
ImageHeight = 200 ;
ImageXData = ImageXPos + [0  ImageWidth] ;
ImageYData = ImageYPos + [0  ImageHeight] ;
% generate a image to display picture .
MovieImageHandle = image( 'Parent', AxesHandle, ...
    'XData', ImageXData, 'YData', ImageYData, ...
    'Cdata', ImageCData ) ;



% define the parameters of the buttons .
ButtonString = { '开始'; '演示实例'; '使用说明' } ; 
ButtonTag = { 'BeginButton'; 'DemoButton'; 'HelpButton' } ;
ButtonCallback = { ['ArcSimulationSoft(''BeginButton_Callback'',gcbo)']; ...
        ['ArcSimulationSoft(''MenuDemo_Callback'',gcbo)']; ...
        ['ArcSimulationSoft(''MenuHelp_Callback'',gcbo)'] } ;
ButtonEnable = { 'on'; 'on'; 'on' } ;

ButtonWidth = 120 ;
ButtonHeight = 32 ;
ButtonXPos = FigureWidth - ButtonWidth - TabSpace * 3 ;
ButtonYPos = TabSpace * 1 + ButtonHeight * 3 + TabSpace * 2 ;;
ButtonPosition = [ButtonXPos  ButtonYPos  ButtonWidth  ButtonHeight] ;
for num = 1: 3
    TempButtonPosition = ButtonPosition ;
    TempButtonPosition(2) = TempButtonPosition(2) - (num - 1) * (ButtonHeight + TabSpace * 0.5) ;
    % generate the pushbutton: OK .
    ButtonHandle = uicontrol( 'Parent', FigureHandle, 'Units', 'Pixels', 'Position', TempButtonPosition, ...
        'Style', 'pushbutton', 'Tag',ButtonTag{num}, 'string', ButtonString{num}, 'Fontsize',15, ...
        'Callback', ButtonCallback{num}, 'Enable', ButtonEnable{num} ) ;
    
end


handles = guihandles( FigureHandle ) ;
guidata( FigureHandle, handles ) ;




% --------------------------------------------------------------------------
function  init_FigureContent( h )
       
handles = guidata( h ) ;

% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.ArcSimulationSoft, 'ArcSimulationData' ) ;
if isempty( ArcSimulationData )
    ArcSimulationData = ArcSimulationSoft( 'Get_DefaultArcSimulationData' ) ;    
    % save the data .
    setappdata( handles.ArcSimulationSoft, 'ArcSimulationData', ArcSimulationData ) ;
end



% --------------------------------------------------------------------------
function   ArcSimulationData = Get_DefaultArcSimulationData ;
% init all of the parameters .

ArcSimulationData = GetDefaultArcParameter ;




% --------------------------------------------------------------------------
function  MenuOpenHistory_Callback( h )
       
handles = guidata( h ) ;


PromptString = '选择结果文件' ;                                 
WarningString1 = '文件格式出错。 ' ;
WarningString2 = '选择的文件不是正确的结果文件。 ' ;

% get file from view .
[ FileName, PathName ]  = uigetfile( {'*.fig', '结果文件(*.fig)'}, PromptString ) ;


% analyze the user select file type .
if FileName == 0
    return ;
else
    [TempPathName, FileName, FileTypeName, Version] = fileparts( FileName ) ;

    if ~strcmp( FileTypeName, '.fig' ) ;
        warndlg( WarningString1, '警告', 'modal' ) ;
        return ;
    end
    SaveFile = fullfile(PathName, [FileName, FileTypeName, Version]) ;
end



if strcmp( lower( FileName ), 'figuremenubar' )
    warndlg( '这是系统文件：FigureMenuBar.fig。', '警告', 'modal' ) ;
    return ;    
    
elseif strcmp( lower( FileName ), 'figuretoolbar' ) ;
    warndlg( '这是系统文件：FigureToolBar.fig。', '警告', 'modal' ) ;
    return ;    
else
end


% open the history figure .
NewFigureHandle = hgload( SaveFile ) ;

% get the marker of project file .
FigureTag = get( NewFigureHandle, 'Tag' ) ;
if  ~( find( strcmp( FigureTag, {'DisplayResult'; 'DisplayFFTResult' } ) ) ) ;
    % close error figure .
    close( NewFigureHandle ) ;
    
    warndlg( WarningString2, '警告', 'modal' ) ;
    return ;
end


% close current figure .
if ishandle( h )
    CurrentFigure = h ;
    
    pause(0.01) ;    
    close( CurrentFigure ) ;
else
end




% --------------------------------------------------------------------------
function  MenuLoadData_Callback( h )
       
handles = guidata( h ) ;


PromptString = '选择数据文件.' ;
WarningString1 = '文件格式出错。 ' ;
WarningString2 = '选择的文件不是正确的数据文件。 ' ;


[ FileName , PathName ] = uigetfile( {'*.mat','数据文件(*.mat)'}, PromptString ) ;


if FileName == 0
    return ;    
else
    
    [TempPathName, FileName, FileTypeName, Version] = fileparts( FileName ) ;

    if ~strcmp( FileTypeName, '.mat' ) ;
        warndlg( WarningString1, '警告', 'modal' ) ;
        return ;
    end
    SaveFile = fullfile( PathName, [FileName, FileTypeName, Version] ) ;
end

ArcSimulationData = [] ;
try
    load( SaveFile, 'ArcSimulationData' ) ;
catch
end

if isempty( ArcSimulationData ) | ~isstruct( ArcSimulationData ) ...
        | ~isfield( ArcSimulationData, 'MainCircuitParameter' ) ...
        | ~isfield( ArcSimulationData, 'ArcResistanceParameter' ) 
    
    warndlg( WarningString1, '警告', 'modal' ) ;
    return ;
end


% open the parameter figure .
% EditParameter( ArcSimulationData ) ;
CalculateStatusEquation( ArcSimulationData ) ;


% close the current figure .
pause(0) ;
close( handles.ArcSimulationSoft ) ;



% --------------------------------------------------------------------------
function  BeginButton_Callback( h )
       
handles = guidata( h ) ;

% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.ArcSimulationSoft, 'ArcSimulationData' ) ;

% open the parameter figure .
% EditParameter( ArcSimulationData ) ;
CalculateStatusEquation( ArcSimulationData ) ;


% close the current figure .
pause(0) ;
close( handles.ArcSimulationSoft ) ;



% --------------------------------------------------------------------------
function  MenuHelp_Callback( h )
       
handles = guidata( h ) ;


try
    % get the current path .
    CurrentPath = cd ;
    HelpFileName = fullfile( CurrentPath, 'ArcSimulationHelp.pdf' ) ;
    
    % open the help file .
    mexrun( HelpFileName ) ;
    
catch
    % get the current path .
    CurrentPath = cd ;
    HelpFileName = fullfile( CurrentPath, 'ArcSimulationHelp.doc' ) ;
    
    % open the help file .
    mexrun( HelpFileName ) ;
    
end



% --------------------------------------------------------------------------
function  MenuDemo_Callback( h )
       
handles = guidata( h ) ;

% open the demo .
ArcSoftDemo ;



% --------------------------------------------------------------------------
function  MenuAbout_Callback( h )
       
handles = guidata( h ) ;


% find if have the same figure, and close it .
OldFigure = findobj( 'type', 'figure', 'Tag', 'AboutArcSimulation' ) ;
if ishandle( OldFigure )
    close( OldFigure ) ;
end

% init the variables .
FigureWidth = 250 ;
FigureHeight = 220 ;
TabSpace = 10 ;
TextHeight = 20 ;

% generate a new figure .
FigureHandle = figure( 'Visible', 'off' ) ;
set( FigureHandle, 'Units' , 'pixels', 'Position', [150  150  FigureWidth  FigureHeight], ...
    'Name', '关于', 'Tag', 'AboutArcSimulation', 'FileName' , '' ,...
    'MenuBar' , 'none', 'NumberTitle' , 'off' ,...
    'Resize', 'off', 'windowstyle', 'normal', 'Visible', 'off' ) ;
movegui( FigureHandle, 'center' )


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


% generate the parameters of the MainCircuitParameter .
% -----------------------------------------------------------------------------
% define the first frame .
FrameXPos = TabSpace * 2 ;
FrameWidth = FigureWidth - TabSpace * 4  ;
FrameHeight = FigureHeight - TabSpace * 8 ;
FrameYPos = FigureHeight - FrameHeight - TabSpace * 2 ;
Frame1Position = [FrameXPos  FrameYPos  FrameWidth  FrameHeight] ;
% generate a frame .
TitleHandle = uicontrol(FigureHandle,'style','frame', 'Units','pixels',...
    'position',Frame1Position  );


TextXPos = Frame1Position(1) + TabSpace  ;
TextYPos = Frame1Position(2) + TabSpace ;
TextWidth = Frame1Position(3) - TabSpace * 2 ;
TextHeight = Frame1Position(4) - TabSpace * 2 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% subtitle: 电弧电阻公式
TextHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition, 'Horizontal','left',...
    'string', {['  《电弧炉对电网影响仿真软件》是一个完全由matlab实现的软件。']}, 'fontsize',13 );


ButtonWidth = 80 ;
ButtonHeight = 25 ;
ButtonXPos = FigureWidth - ButtonWidth - TabSpace * 3 ;
ButtonYPos = TabSpace * 2 ;;
ButtonPosition = [ButtonXPos  ButtonYPos  ButtonWidth  ButtonHeight] ;
% generate the pushbutton: Close .
ButtonHandle = uicontrol( 'Parent', FigureHandle, 'Units', 'Pixels', 'Position', ButtonPosition, ...
    'Style', 'pushbutton', 'string', '关闭', 'Fontsize',12, 'Callback', ['close(gcbf) ;'] ) ;


% display the figure .
set( FigureHandle, 'Visible', 'on' ) ;

