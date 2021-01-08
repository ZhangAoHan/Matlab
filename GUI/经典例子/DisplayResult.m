function  varargout = DisplayResult( varargin )
% this module display the results .

%  February 2004
%  $Revision: 1.00 $  



if (nargin == 0) | isstruct( varargin{1} )     %  LAUNCH GUI
    
    if nargin == 1
        ArcSimulationData = varargin{1} ;
    else
        ArcSimulationData = [] ;
    end
    
    
    % find if have the same figure, and close it .
    OldFigure = findobj( 'type', 'figure', 'Tag', 'DisplayResult' ) ;
    if ishandle( OldFigure )
        close( OldFigure ) ;
    end
    

    % generate a new figure .
    FigureHandle = figure( 'Visible', 'off' ) ;
    set( FigureHandle, 'Units' , 'pixels', 'Position', [150 150 500 300], ...
        'Name', '电弧炉对电网影响仿真软件', ...
        'Tag', 'DisplayResult', ...
        'FileName' , '' ,...
        'MenuBar' , 'none' ,...
        'NumberTitle' , 'off' ,...
        'Resize', 'on', ...
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
    
%     set( findobj( FigureHandle, 'Type', 'uicontrol' ), 'Units', 'normalized' ) ;

    set( FigureHandle, 'Visible', 'on', ...
        'ResizeFcn', ['DisplayResult( ''ResizeDisplayResult'', gcbf)'] ) ;
    
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
MenuLabel = { '打开(&O)'; '保存(&S)'; '退出(&E)' } ;

% add Polygon at 2003.10.13 .
MenuTag = { 'MenuOpenResult'; 'MenuSaveResult'; 'MenuClose' } ;
MenuCallback = { ['ArcSimulationSoft( ''MenuOpenHistory_Callback'', gcbf)']; ...
        ['DisplayResult( ''SaveResult_Callback'', gcbf)']; ...
        ['close all;'] } ;
SeparatorGroup = { 'off'; 'off'; 'on' } ;

% generate the uimenus of file .
for num = 1: length( MenuTag )
% for num = 3
    UimenuHandle(num) = uimenu( MenuHandle ) ;
    set( UimenuHandle(num), 'Tag' , MenuTag{num} , ...
        'Callback' , MenuCallback{num} , ...
        'Label' , MenuLabel{num} , ...
        'Separator', SeparatorGroup{num} ) ;
end

% generate the parameter menu .
% ------------------------------------------------------------
MenuHandle = uimenu( FigureHandle, 'Label', '参数(&P)' ) ;

% define the parameters of the menus .
MenuLabel = { '查看(&L)'; } ;

% add Polygon at 2003.10.13 .
MenuTag = { 'MenuDisplayParameter';  } ;
MenuCallback = { ...
    ['DisplayResult( ''DisplayParameter_Callback'', gcbo)']; } ;
SeparatorGroup = { 'off'; } ;

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
MenuLabel = { '电路图(&C)'; '状态方程(&L)'; '电弧电阻公式(&E)' } ;

% add Polygon at 2003.10.13 .
MenuTag = { 'MenuCircuitDiagram'; 'MenuMainCircuitFormula'; 'MenuArcResistanceFormula' } ;
MenuCallback = { ...
    ['DisplayResult( ''CircuitDiagram_Callback'', gcbo)']; ...
    ['EditParameter( ''MainCircuitFormula_Callback'', gcbo)']; ...
    ['EditParameter( ''ArcResistanceFormula_Callback'', gcbo)']; } ;
SeparatorGroup = { 'off'; 'on'; 'off' } ;

% generate the uimenus of file .
for num = 1: 3
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
AxesHandle = axes( 'Parent', FigureHandle, 'Units' , 'pixels' ,  ...
    'Position', [0  0  FigureWidth  FigureHeight], 'Visible', 'off', ...
    'Tag', 'BackgroundAxes', ...
    'Xlim', [0  FigureWidth], 'Ylim', [0  FigureHeight] ) ;

% get the color of the figure .
FigureColor = get( FigureHandle, 'Color' ) ;
% reset the default value of the uicontrols .
set(FigureHandle,'defaultuicontrolunits','normalized');
set(FigureHandle,'defaultuicontrolfontname','隶书');
set(FigureHandle,'defaultuicontrolBackgroundColor', FigureColor );



% generate the parameters of the Analyze .
% -----------------------------------------------------------------------------
% define the first frame .
% FrameXPos = Frame1Position(1) + Frame1Position(3) + TabSpace * 1.5 ;
FrameXPos = TabSpace * 1.5 ;
FrameWidth = FigureWidth - TabSpace * 3 ;
FrameHeight = FigureHeight - TabSpace * (8 + 5) ;
FrameYPos = FigureHeight - FrameHeight - TabSpace * 1.5 ;
Frame1Position = [FrameXPos  FrameYPos  FrameWidth  FrameHeight] ;
% generate a frame .
LineXData = [FrameXPos  FrameXPos  (FrameXPos + FrameWidth)  (FrameXPos + FrameWidth)  FrameXPos] ;
LineYData = [FrameYPos  (FrameYPos + FrameHeight)  (FrameYPos + FrameHeight)  FrameYPos  FrameYPos] ;
LineHandle = line ( 'Parent', AxesHandle, 'XData', LineXData, 'YData', LineYData,...
    'Tag', 'FrameLine1', 'LineStyle', '-', 'Color', [0  0  0], 'Marker', 'none'  );


TextXPos = Frame1Position(1) + 15 ;
TextYPos = Frame1Position(2) + Frame1Position(4) - 12 ;
TextWidth = 50 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% subtitle: 分析
SubtitleHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'Position',TextPosition,'horizontal','center',...
    'Tag', 'AnalyzeText', 'String', '结果', 'fontsize',13 );

% get the position of the axeses .
AxesXPos = Frame1Position(1) + TabSpace * 5.5 ;
AxesWidth = (Frame1Position(3) - TabSpace * 17) / 3 ;
AxesHeight = (Frame1Position(4) - TabSpace * 15) / 2 ;
AxesYPos = Frame1Position(2) + Frame1Position(4) - AxesHeight - TabSpace * 3 ;
AxesPosition = [AxesXPos  AxesYPos  AxesWidth  AxesHeight] ;

TagIndex = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' ;

for num = 1: 6
    TempAxesPosition = AxesPosition ;
    if num <= 3
        TempAxesPosition(1) = TempAxesPosition(1) + (num - 1) * (AxesWidth + TabSpace * 5) ;
    else
        TempAxesPosition(1) = TempAxesPosition(1) + (num - 4) * (AxesWidth + TabSpace * 5) ;
        TempAxesPosition(2) = TempAxesPosition(2) - (AxesHeight + TabSpace * 8) ;
    end
    % generate the axes to plot lines .
    AxesHandle = axes( 'Parent', FigureHandle, 'Units' , 'Pixels' ,  ...
        'Position', TempAxesPosition, 'Visible', 'on', ...
        'Tag', ['AnalyzeAxes', TagIndex(num)] ) ;
    
end


% display the formula .
% -----------------------------------------------------------------------------
% define the second frame .
FrameXPos = TabSpace * 1.5 ;
FrameWidth = FigureWidth - TabSpace * 3 ;
FrameHeight = 42 ;
FrameYPos = TabSpace * 6 ;
Frame2Position = [FrameXPos  FrameYPos  FrameWidth  FrameHeight] ;
% generate a frame .
TitleHandle = uicontrol(FigureHandle,'style','frame', 'Units','pixels',...
    'Position',Frame2Position, 'Tag', 'FrameLine2'  );


% get the position of buttons .
ButtonXPos = Frame2Position(1) + TabSpace ;
ButtonYPos = Frame2Position(2) + Frame2Position(4) - TextHeight - TabSpace * 1 ;
ButtonWidth = (Frame2Position(3) - TabSpace * 5) * 0.25 ;
ButtonPosition = [ButtonXPos  ButtonYPos  ButtonWidth  TextHeight] ;


% define the parameters of the buttons .
ButtonString = { '显示参数'; '电路图'; '状态方程'; '电弧电阻公式' } ; 
ButtonTag = { 'DisplayParameter'; 'CircuitDiagram'; 'MainCircuitFormula'; 'ArcResistanceFormula' } ;
ButtonCallback = { ['DisplayResult(''DisplayParameter_Callback'',gcbo)']; ...
        ['DisplayResult(''CircuitDiagram_Callback'',gcbo)']; ...
        ['EditParameter(''MainCircuitFormula_Callback'',gcbo)']; ...
        ['EditParameter(''ArcResistanceFormula_Callback'',gcbo)'] } ;

for num = 1: 4
    TempButtonPosition = ButtonPosition ;
    TempButtonPosition(1) = TempButtonPosition(1) + (num - 1) * (ButtonWidth + TabSpace * 1) ;
    % generate the pushbutton: OK .
    ButtonHandle = uicontrol( 'Parent', FigureHandle, 'Units', 'Pixels', 'Position', TempButtonPosition, ...
        'Style', 'pushbutton', 'Tag',ButtonTag{num}, 'string', ButtonString{num}, 'Fontsize',12, ...
        'Callback', ButtonCallback{num} ) ;
    
end



% define the parameters of the buttons .
ButtonString = { '上一步'; ...
        '打开'; ...
        '保存'; ...
        '下一步' } ; 
ButtonTag = { 'PreviousButton'; ...
        'LoadResultButton'; ...
        'SaveResultButton'; ...
        'NextButton' } ;
ButtonCallback = { ['DisplayResult(''PreviousButton_Callback'',gcbo)']; ...
        ['ArcSimulationSoft( ''MenuOpenHistory_Callback'', gcbf)']; ...
        ['DisplayResult(''SaveResult_Callback'',gcbo)']; ...
        ['DisplayResult(''NextButton_Callback'',gcbo)'] } ;

ButtonWidth = 80 ;
ButtonHeight = 25 ;
ButtonXPos = FigureWidth - ButtonWidth * 4 - TabSpace * 5 ;
ButtonYPos = TabSpace * 2 ;;
ButtonPosition = [ButtonXPos  ButtonYPos  ButtonWidth  ButtonHeight] ;
for num = 1: 4
    TempButtonPosition = ButtonPosition ;
    TempButtonPosition(1) = TempButtonPosition(1) + (num - 1) * (ButtonWidth + TabSpace) ;
    % generate the pushbutton: OK .
    ButtonHandle = uicontrol( 'Parent', FigureHandle, 'Units', 'Pixels', 'Position', TempButtonPosition, ...
        'Style', 'pushbutton', 'Tag',ButtonTag{num}, 'string', ButtonString{num}, 'Fontsize',12, ...
        'Callback', ButtonCallback{num} ) ;
    
end


handles = guihandles( FigureHandle ) ;
guidata( FigureHandle, handles ) ;




% --------------------------------------------------------------------------
function  ResizeDisplayResult( h )
% update the position of the uicontrols .


handles = guidata( h ) ;
if isempty( handles ) ;
    return ;
end

% get the new size of the figure .
FigureSize = get( handles.DisplayResult, 'Position' ) ;

FigureWidth = FigureSize(3) ;
FigureHeight = FigureSize(4) ;

if FigureWidth < 600 ;
    FigureWidth = 600 ;
end

if FigureHeight < 400 ;
    FigureHeight = 400 ;
end

% init the variables .
TabSpace = 10 ;
TextHeight = 22 ;


% generate the axes to plot lines .
set( handles.BackgroundAxes, 'Units' , 'pixels' ,  ...
    'Position', [0  0  FigureWidth  FigureHeight], ...
    'Xlim', [0  FigureWidth], 'Ylim', [0  FigureHeight] ) ;



% generate the parameters of the Analyze .
% -----------------------------------------------------------------------------
% define the first frame .
% FrameXPos = Frame1Position(1) + Frame1Position(3) + TabSpace * 1.5 ;
FrameXPos = TabSpace * 1.5 ;
FrameWidth = FigureWidth - TabSpace * 3 ;
FrameHeight = FigureHeight - TabSpace * (8 + 5) ;
FrameYPos = FigureHeight - FrameHeight - TabSpace * 1.5 ;
Frame1Position = [FrameXPos  FrameYPos  FrameWidth  FrameHeight] ;
% generate a frame .
LineXData = [FrameXPos  FrameXPos  (FrameXPos + FrameWidth)  (FrameXPos + FrameWidth)  FrameXPos] ;
LineYData = [FrameYPos  (FrameYPos + FrameHeight)  (FrameYPos + FrameHeight)  FrameYPos  FrameYPos] ;
set( handles.FrameLine1, 'XData', LineXData, 'YData', LineYData );


TextXPos = Frame1Position(1) + 15 ;
TextYPos = Frame1Position(2) + Frame1Position(4) - 12 ;
TextWidth = 50 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% subtitle: 分析
set( handles.AnalyzeText, 'Position', TextPosition ) ;

% get the position of the axeses .
AxesXPos = Frame1Position(1) + TabSpace * 5.5 ;
AxesWidth = (Frame1Position(3) - TabSpace * 17) / 3 ;
AxesHeight = (Frame1Position(4) - TabSpace * 15) / 2 ;
AxesYPos = Frame1Position(2) + Frame1Position(4) - AxesHeight - TabSpace * 3 ;
AxesPosition = [AxesXPos  AxesYPos  AxesWidth  AxesHeight] ;

TagIndex = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' ;

for num = 1: 6
    TempAxesPosition = AxesPosition ;
    if num <= 3
        TempAxesPosition(1) = TempAxesPosition(1) + (num - 1) * (AxesWidth + TabSpace * 5) ;
    else
        TempAxesPosition(1) = TempAxesPosition(1) + (num - 4) * (AxesWidth + TabSpace * 5) ;
        TempAxesPosition(2) = TempAxesPosition(2) - (AxesHeight + TabSpace * 8) ;
    end
    % generate the axes to plot lines .
    AxesHandle = getfield( handles, ['AnalyzeAxes', TagIndex(num)] ) ;
    set( AxesHandle, 'Units' , 'Pixels' , 'Position', TempAxesPosition ) ;    
end


% display the formula .
% -----------------------------------------------------------------------------
% define the second frame .
FrameXPos = TabSpace * 1.5 ;
FrameWidth = FigureWidth - TabSpace * 3 ;
FrameHeight = 42 ;
FrameYPos = TabSpace * 6 ;
Frame2Position = [FrameXPos  FrameYPos  FrameWidth  FrameHeight] ;
% generate a frame .
set( handles.FrameLine2, 'Position', Frame2Position ) ;


% get the position of buttons .
ButtonXPos = Frame2Position(1) + TabSpace ;
ButtonYPos = Frame2Position(2) + Frame2Position(4) - TextHeight - TabSpace * 1 ;
ButtonWidth = (Frame2Position(3) - TabSpace * 5) * 0.25 ;
ButtonPosition = [ButtonXPos  ButtonYPos  ButtonWidth  TextHeight] ;
 
% define the parameters of the buttons .
ButtonTag = { 'DisplayParameter'; 'CircuitDiagram'; 'MainCircuitFormula'; 'ArcResistanceFormula' } ;
 
for num = 1: 4
    TempButtonPosition = ButtonPosition ;
    TempButtonPosition(1) = TempButtonPosition(1) + (num - 1) * (ButtonWidth + TabSpace * 1) ;
    % generate the pushbutton: OK .
    ButtonHandle = getfield( handles, ButtonTag{num} ) ;
    set( ButtonHandle, 'Position', TempButtonPosition ) ;
end


% define the bottom buttons .
ButtonTag = { 'PreviousButton'; ...
        'LoadResultButton'; ...
        'SaveResultButton'; ...
        'NextButton' } ;

ButtonWidth = 80 ;
ButtonHeight = 25 ;
ButtonXPos = FigureWidth - ButtonWidth * 4 - TabSpace * 5 ;
ButtonYPos = TabSpace * 2 ;;
ButtonPosition = [ButtonXPos  ButtonYPos  ButtonWidth  ButtonHeight] ;
for num = 1: 4
    TempButtonPosition = ButtonPosition ;
    TempButtonPosition(1) = TempButtonPosition(1) + (num - 1) * (ButtonWidth + TabSpace) ;
    % generate the pushbutton: OK .
    ButtonHandle = getfield( handles, ButtonTag{num} ) ;
    set( ButtonHandle, 'Position', TempButtonPosition ) ;
end



% --------------------------------------------------------------------------
function  init_FigureContent( h )
       
handles = guidata( h ) ;

% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.DisplayResult, 'ArcSimulationData' ) ;
if isempty( ArcSimulationData )
    ArcSimulationData = ArcSimulationSoft( 'Get_DefaultArcSimulationData' ) ;    
    % save the data .
    setappdata( handles.DisplayResult, 'ArcSimulationData', ArcSimulationData ) ;
end



if ~isfield( ArcSimulationData, 'ArcSimulationResult' )
    % none data .
    return ;
end

% get the ArcSimulationData .
ArcSimulationResult = ArcSimulationData.ArcSimulationResult ;
if isempty( ArcSimulationResult )
    % save the data .
    setappdata( handles.DisplayResult, 'ArcSimulationResult', ArcSimulationResult ) ;
end

% get the data .
DataFieldName = ArcSimulationResult.DataFieldName ;
DataFieldKanaName = ArcSimulationResult.DataFieldKanaName ;
XLabel = ArcSimulationResult.XLabel ;
YLabel = ArcSimulationResult.YLabel ;
LineColor = ArcSimulationResult.LineColor ;

TagIndex = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' ;


for num = 1: 6
    
    CurveData = getfield( ArcSimulationResult, DataFieldName{num} ) ;    
    DataLength = length( CurveData ) ;
    
    % generate the axes to plot lines .
    AxesHandle = getfield( handles, ['AnalyzeAxes', TagIndex(num)] ) ;
    % plot line .
    LineHandle = line( 'Parent', AxesHandle, 'XData', [1: DataLength], ...
        'YData', CurveData, 'Color', LineColor{num} ) ;
    
    set( get(AxesHandle,'Title'), 'String', DataFieldKanaName{num} )
    set( get(AxesHandle,'XLabel'), 'String', XLabel{num} )
    set( get(AxesHandle,'YLabel'), 'String', YLabel{num} )
    
end








% --------------------------------------------------------------------------
function  DisplayParameter_Callback( h )
       
handles = guidata( h ) ;


% get the string of the parameters .
[MainCircuitString, ArcResistanceString] = Get_DisplayParamterString( h ) ;

% find if have the same figure, and close it .
OldFigure = findobj( 'type', 'figure', 'Tag', 'DisplayParameter' ) ;
if ishandle( OldFigure )
    close( OldFigure ) ;
end

% init the variables .
FigureWidth = 500 ;
FigureHeight = 400 ;
TabSpace = 10 ;
TextHeight = 20 ;

% generate a new figure .
FigureHandle = figure( 'Visible', 'off' ) ;
set( FigureHandle, 'Units' , 'pixels', 'Position', [150  150  FigureWidth  FigureHeight], ...
    'Name', '显示输入参数', 'Tag', 'DisplayParameter', 'FileName' , '' ,...
    'MenuBar' , 'none', 'NumberTitle' , 'off' ,...
    'Resize', 'off', 'windowstyle', 'normal', 'Visible', 'off' ) ;
movegui( FigureHandle, 'center' )

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


TextXPos = Frame1Position(1) + TabSpace * 1.5 ;
TextYPos = Frame1Position(2) + Frame1Position(4) - TextHeight - TabSpace ;
TextWidth = (Frame1Position(3) - TabSpace * 4.5) / 2 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% subtitle: 主电路参数
TextHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition, 'Horizontal','center',...
    'string', '  主电路参数', 'fontsize',12 );

ListboxXPos = Frame1Position(1) + TabSpace * 1.5 ;
ListboxYPos = Frame1Position(2) + TabSpace * 1.5;
ListboxWidth = (Frame1Position(3) - TabSpace * 4.5) / 2 ;
ListboxHeight = Frame1Position(4) - TextHeight - TabSpace * 2.5 ;
ListboxPosition = [ListboxXPos  ListboxYPos  ListboxWidth  ListboxHeight] ;
% subtitle: 显示参数
ListboxHandle = uicontrol(FigureHandle, 'Style', 'listbox', 'Units','pixels',...
    'Position', ListboxPosition, 'Max', 2, 'BackgroundColor', [1  1  1], ...
    'string', MainCircuitString, 'fontsize',11 );


TextXPos = TextPosition(1) + TextPosition(3) + TabSpace * 1.5 ;
TextYPos = Frame1Position(2) + Frame1Position(4) - TextHeight - TabSpace ;
TextWidth = (Frame1Position(3) - TabSpace * 4.5) / 2 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% subtitle: 电弧电阻参数
TextHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition, 'Horizontal','center',...
    'string', '  电弧电阻参数', 'fontsize',12 );

ListboxXPos = ListboxPosition(1) + ListboxPosition(3) + TabSpace * 1.5 ;
ListboxYPos = Frame1Position(2) + TabSpace * 1.5;
ListboxWidth = (Frame1Position(3) - TabSpace * 4.5) / 2 ;
ListboxHeight = Frame1Position(4) - TextHeight - TabSpace * 2.5 ;
ListboxPosition = [ListboxXPos  ListboxYPos  ListboxWidth  ListboxHeight] ;
% subtitle: 显示参数
ListboxHandle = uicontrol(FigureHandle, 'Style', 'listbox', 'Units','pixels',...
    'Position', ListboxPosition, 'Max', 2, 'BackgroundColor', [1  1  1], ...
    'string', ArcResistanceString, 'fontsize',11 );



ButtonWidth = 80 ;
ButtonHeight = 25 ;
ButtonXPos = FigureWidth - ButtonWidth - TabSpace * 2 ;
ButtonYPos = TabSpace * 2 ;;
ButtonPosition = [ButtonXPos  ButtonYPos  ButtonWidth  ButtonHeight] ;
% generate the pushbutton: Close .
ButtonHandle = uicontrol( 'Parent', FigureHandle, 'Units', 'Pixels', 'Position', ButtonPosition, ...
    'Style', 'pushbutton', 'string', '关闭', 'Fontsize',12, 'Callback', ['close(gcbf) ;'] ) ;

% display the figure .
set( FigureHandle, 'Visible', 'on' ) ;




% -------------------------------------------------------
function [MainCircuitString, ArcResistanceString] = Get_DisplayParamterString( h ) ;

handles = guidata( h ) ;

% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.DisplayResult, 'ArcSimulationData' ) ;


% define the string of the MainCircuitParameterText .
Text1String = { 'L21'; 'L22'; 'M1'; 'M2'; 'R21'; 'R22'; ...
        'R1'; 'L1'; 'C'; 'ea'; 'eb'; 'ec' } ;
ParameterName = { 'L21'; 'L22'; 'M1'; 'M2'; 'R21'; 'R22'; ...
        'R1'; 'L1'; 'C'; 'ea'; 'eb'; 'ec' } ;

MainCircuitString{1} = '主电路参数：' ;
for num = 1: 12
    ParameterValue = getfield( ArcSimulationData.MainCircuitParameter, ParameterName{num} ) ;
    MainCircuitString{num + 1} = ['    ', Text1String{num}, ' :  ', num2str(ParameterValue)] ;    
end

% define the string of the ArcResistanceParameterText .
Text2String = { 'A'; 'B'; 'C'; 'D'; 'L'; 'ω'; 'θ' } ;
ParameterName = { 'A'; 'B'; 'C'; 'D'; 'L'; 'Angle1'; 'Angle2' } ; ;

ArcResistanceString{1} = '电弧电阻参数：' ;
for num = 1: 7
    ParameterValue = getfield( ArcSimulationData.ArcResistanceParameter, ParameterName{num} ) ;
    ArcResistanceString{num + 1} = ['    ', Text2String{num}, ' :  ', num2str(ParameterValue)] ;    
end





% --------------------------------------------------------------------------
function  CircuitDiagram_Callback( h )
       
handles = guidata( h ) ;


% find if have the same figure, and close it .
OldFigure = findobj( 'type', 'figure', 'Tag', 'CircuitDiagram' ) ;
if ishandle( OldFigure )
    close( OldFigure ) ;
end


% generate a new figure .
FigureHandle = figure( 'Visible', 'off' ) ;
set( FigureHandle, 'Units' , 'pixels', 'Position', [150 150 500 300], ...
    'Name', '电路图', 'Tag', 'CircuitDiagram', 'FileName' , '' ,...
    'MenuBar' , 'none', 'NumberTitle' , 'off' ,...
    'Resize', 'off', 'windowstyle', 'normal', 'Visible', 'off' ) ;

% get the color of the figure .
FigureColor = get( FigureHandle, 'Color' ) ;
% reset the default value of the uicontrols .
set(FigureHandle,'defaultuicontrolunits','normalized');
set(FigureHandle,'defaultuicontrolfontname','隶书');
set(FigureHandle,'defaultuicontrolBackgroundColor', FigureColor );


% init the variables .
FigureWidth = 520 ;
FigureHeight = 420 ;
TabSpace = 10 ;
TextHeight = 20 ;


try
    % read the image data .
    ImageData = imread( 'CircuitDiagram.bmp' ) ;
    ImageSize = size( ImageData ) ;
catch
    warndlg( ['Lost File: CircuitDiagram.bmp'], 'modal' ) ;
    close( FigureHandle ) ;
    return ;
end


% define the position of the Axes .
AxesXPos = TabSpace * 2 ;
AxesYPos = TabSpace * 6 ;
AxesWidth = ImageSize(2) ;
AxesHeight = ImageSize(1) ;
AxesPosition = [AxesXPos  AxesYPos  AxesWidth  AxesHeight] ;

FigureWidth = AxesWidth + TabSpace * 4 ;
FigureHeight = AxesHeight + TabSpace * (2 + 6) ;

% reset the figure's size . 
set( FigureHandle, 'Units', 'pixels', 'Position', [100  250  FigureWidth  FigureHeight] ) ;
movegui( FigureHandle, 'center' )


% generate the axes to plot lines .
AxesHandle = axes( 'Parent', FigureHandle, 'Units' , 'pixels' ,  ...
    'Position', AxesPosition, 'Visible', 'off', 'YDir', 'reverse', ...
    'Xlim', [0  AxesWidth], 'Ylim', [0  AxesHeight] ) ;

% draw the image .
ImageHandle = image( 'Parent', AxesHandle, 'CData', ImageData ) ;


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





% --------------------------------------------------------------------------
function  PreviousButton_Callback( h )
       
handles = guidata( h ) ;

% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.DisplayResult, 'ArcSimulationData' ) ;

% return the simulate figure .
SimulateFigure( ArcSimulationData ) ;


% close the current figure .
pause(0) ;
close( handles.DisplayResult ) ;



% --------------------------------------------------------------------------
function  SaveResult_Callback( h )
       
handles = guidata( h ) ;


PromptString = '保存结果文件.' ;
MessageString = '保存结果文件成功。 ' ;

[ FileName , PathName ] = uiputfile( {'*.fig','结果文件(*.fig)'}, PromptString ) ;


if FileName == 0
    return ;    
else
    
    [TempPathName, FileName, FileTypeName, Version] = fileparts( FileName ) ;

    if ~strcmp( FileTypeName, '.fig' ) ;
        FileTypeName = '.fig' ;
    else
    end
    SaveFile = fullfile( PathName, [FileName, FileTypeName, Version] ) ;
end


if strcmp( lower( FileName ), 'figuremenubar' )
    warndlg( '不能覆盖系统文件：FigureMenuBar.fig。', '警告', 'modal' ) ;
    return ;    
    
elseif strcmp( lower( FileName ), 'figuretoolbar' ) ;
    warndlg( '不能覆盖系统文件：FigureToolBar.fig。', '警告', 'modal' ) ;
    return ;    
else
end


% save the result  file .
hgsave( handles.DisplayResult, SaveFile ) ;


msgbox( MessageString ) ;



% --------------------------------------------------------------------------
function  NextButton_Callback( h )
       
handles = guidata( h ) ;

% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.DisplayResult, 'ArcSimulationData' ) ;

% open the next figure ,
DisplayFFTResult( ArcSimulationData ) ;


% close the current figure .
pause(0) ;
close( handles.DisplayResult ) ;
