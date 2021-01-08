function  varargout = EditParameter( varargin )
% this module edit the parameters .

%  February 2004
%  $Revision: 1.00 $  




if (nargin == 0) | isstruct( varargin{1} )     %  LAUNCH GUI
    
    if nargin == 1
        ArcSimulationData = varargin{1} ;
    else
        ArcSimulationData = [] ;
    end
    
    % find if have the same figure, and close it .
    OldFigure = findobj( 'type', 'figure', 'Tag', 'EditParameter' ) ;
    if ishandle( OldFigure )
        close( OldFigure ) ;
    end
    

    % generate a new figure .
    FigureHandle = figure( 'Visible', 'off' ) ;
    set( FigureHandle, 'Units' , 'pixels', 'Position', [150 150 500 300], ...
        'Name', '电弧炉对电网影响仿真软件', ...
        'Tag', 'EditParameter', ...
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



% generate the parameter menu .
% ------------------------------------------------------------
MenuHandle = uimenu( FigureHandle, 'Label', '参数(&P)' ) ;

% define the parameters of the menus .
MenuLabel = { '导入(&L)'; '保存(&E)' } ;

% add Polygon at 2003.10.13 .
MenuTag = { 'MenuLoadData'; 'MenuSaveData' } ;
MenuCallback = { ...
    ['EditParameter( ''LoadData_Callback'', gcbo)']; ...
    ['EditParameter( ''SaveData_Callback'', gcbo)']; } ;
SeparatorGroup = { 'off'; 'on' } ;

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
MenuLabel = { '状态方程(&L)'; '电弧电阻公式(&E)' } ;

% add Polygon at 2003.10.13 .
MenuTag = { 'MenuMainCircuitFormula'; 'MenuArcResistanceFormula' } ;
MenuCallback = { ...
    ['EditParameter( ''MainCircuitFormula_Callback'', gcbo)']; ...
    ['EditParameter( ''ArcResistanceFormula_Callback'', gcbo)']; } ;
SeparatorGroup = { 'off'; 'on' } ;

% generate the uimenus of file .
for num = 1: length( MenuTag )
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
    'string', '电弧炉系统参数输入', 'fontsize',15 );



% generate the parameters of the MainCircuitParameter .
% -----------------------------------------------------------------------------
% define the first frame .
FrameXPos = TabSpace * 2 ;
FrameWidth = (FigureWidth - TabSpace * 6) * 2/3 ;
FrameHeight = 220 ;
FrameYPos = TitlePosition(2) - FrameHeight - TabSpace * 1 ;
Frame1Position = [FrameXPos  FrameYPos  FrameWidth  FrameHeight] ;
% generate a frame .
TitleHandle = uicontrol(FigureHandle,'style','frame', 'Units','pixels',...
    'position',Frame1Position  );


TextXPos = Frame1Position(1) + 15 ;
TextYPos = Frame1Position(2) + Frame1Position(4) - 12 ;
TextWidth = 120 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% subtitle: 主电路参数
SubtitleHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition,'Horizontal','center',...
    'string', '主电路参数', 'fontsize',13 );

% get the position of explain text .
TextXPos = Frame1Position(1) + TabSpace ;
TextYPos = Frame1Position(2) + Frame1Position(4) - TextHeight - TabSpace * 2 ;
TextWidth = (Frame1Position(3) - TabSpace * 7) * 0.25 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;

% get the position of the popupmenu .
EditXPos = TextXPos + TextWidth + TabSpace ;
EditYPos = TextYPos ;
% EditWidth = 90 ;
EditWidth = (Frame1Position(3) - TabSpace * 7) * 0.25 ;
EditPosition = [EditXPos  EditYPos  EditWidth  TextHeight] ;

TagIndex = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' ;

for num = 1: 12
    TempTextPosition = TextPosition ;
    if num <= 6
        TempTextPosition(2) = TempTextPosition(2) - (num - 1) * (TextHeight + TabSpace) ;
    else
        TempTextPosition(2) = TempTextPosition(2) - (num - 7) * (TextHeight + TabSpace) ;
        TempTextPosition(1) = TempTextPosition(1) + TextWidth * 2 + TabSpace * 3 ;
    end
    % generate the text .
    TextHandle = uicontrol(FigureHandle, 'style', 'text', 'Units','pixels',...
        'position', TempTextPosition, 'Horizontal','center',...
        'Tag', ['MainCircuitParameterText', TagIndex(num)], 'FontSize',10 );
    
    TempEditPosition = EditPosition ;
    if num <= 6
        TempEditPosition(2) = TempEditPosition(2) - (num - 1) * (TextHeight + TabSpace) ;
    else
        TempEditPosition(2) = TempEditPosition(2) - (num - 7) * (TextHeight + TabSpace) ;
        TempEditPosition(1) = TempEditPosition(1) + TextWidth * 2 + TabSpace * 3 ;
    end
    % generate the text .
    TextHandle = uicontrol(FigureHandle, 'Style', 'edit', 'Units','pixels',...
        'position', TempEditPosition, 'Horizontal','center', 'BackgroundColor', [1 1 1], ...
        'Tag', ['MainCircuitParameterEdit', TagIndex(num)], ...
        'String', '0', 'FontSize',10, ...
        'Callback', ['EditParameter(''MainCircuitParameter_Callback'',gcbo)'] ) ;
            
end




% generate the parameters of the ArcResistanceParameter .
% -----------------------------------------------------------------------------
% define the second frame .
FrameXPos = Frame1Position(1) + Frame1Position(3) + TabSpace * 2 ;
FrameWidth = (FigureWidth - TabSpace * 6) * 1/3 ;
FrameHeight = 277 ;
FrameYPos = TitlePosition(2) - FrameHeight - TabSpace * 1 ;
Frame2Position = [FrameXPos  FrameYPos  FrameWidth  FrameHeight] ;
% generate a frame .
TitleHandle = uicontrol(FigureHandle,'style','frame', 'Units','pixels',...
    'position',Frame2Position  );


TextXPos = Frame2Position(1) + 15 ;
TextYPos = Frame2Position(2) + Frame2Position(4) - 12 ;
TextWidth = 130 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% subtitle: 电弧电阻参数
SubtitleHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition,'Horizontal','center',...
    'string', '电弧电阻参数', 'fontsize',13 );



% get the position of explain text .
TextXPos = Frame2Position(1) + TabSpace ;
TextYPos = Frame2Position(2) + Frame2Position(4) - TextHeight - TabSpace * 2 ;
TextWidth = (Frame2Position(3) - TabSpace * 4) * 0.5 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;

% get the position of the popupmenu .
EditXPos = TextXPos + TextWidth + TabSpace ;
EditYPos = TextYPos ;
% EditWidth = 90 ;
EditWidth = (Frame2Position(3) - TabSpace * 4) * 0.5 ;
EditPosition = [EditXPos  EditYPos  EditWidth  TextHeight] ;

for num = 1: 7
    TempTextPosition = TextPosition ;
    TempTextPosition(2) = TempTextPosition(2) - (num - 1) * (TextHeight + TabSpace * 1.4) ;
    % generate the text .
    TextHandle = uicontrol(FigureHandle, 'style', 'text', 'Units','pixels',...
        'position', TempTextPosition, 'Horizontal','center', 'FontSize', 10,...
        'Tag', ['ArcResistanceParameterText', TagIndex(num)] );
    
    TempEditPosition = EditPosition ;
    TempEditPosition(2) = TempEditPosition(2) - (num - 1) * (TextHeight + TabSpace * 1.4) ;
    % generate the text .
    TextHandle = uicontrol(FigureHandle, 'Style', 'edit', 'Units','pixels',...
        'position', TempEditPosition, 'Horizontal','center', 'BackgroundColor', [1 1 1], ...
        'Tag', ['ArcResistanceParameterEdit', TagIndex(num)], ...
        'String', '0', 'FontSize',10, ...
        'Callback', ['EditParameter(''ArcResistanceParameter_Callback'',gcbo)'] ) ;
    
end


% display the formula .
% -----------------------------------------------------------------------------
% define the second frame .
FrameXPos = Frame1Position(1) ;
FrameWidth = (FigureWidth - TabSpace * 6) * 2/3 ;
FrameHeight = 42 ;
FrameYPos = Frame1Position(2) - FrameHeight - TabSpace * 1.5 ;
Frame3Position = [FrameXPos  FrameYPos  FrameWidth  FrameHeight] ;
% generate a frame .
TitleHandle = uicontrol(FigureHandle,'style','frame', 'Units','pixels',...
    'position',Frame3Position  );


% get the position of buttons .
ButtonXPos = Frame3Position(1) + TabSpace ;
ButtonYPos = Frame3Position(2) + Frame3Position(4) - TextHeight - TabSpace * 1 ;
ButtonWidth = (Frame3Position(3) - TabSpace * 3) * 0.5 ;
ButtonPosition = [ButtonXPos  ButtonYPos  ButtonWidth  TextHeight] ;


% define the parameters of the buttons .
ButtonString = { '状态方程'; '电弧电阻公式' } ; 
ButtonTag = { 'MainCircuitFormula'; 'ArcResistanceFormula' } ;
ButtonCallback = { ['EditParameter(''MainCircuitFormula_Callback'',gcbo)']; ...
        ['EditParameter(''ArcResistanceFormula_Callback'',gcbo)'] } ;

for num = 1: 2
    TempButtonPosition = ButtonPosition ;
    TempButtonPosition(1) = TempButtonPosition(1) + (num - 1) * (ButtonWidth + TabSpace * 1) ;
    % generate the pushbutton: OK .
    ButtonHandle = uicontrol( 'Parent', FigureHandle, 'Units', 'Pixels', 'Position', TempButtonPosition, ...
        'Style', 'pushbutton', 'Tag',ButtonTag{num}, 'string', ButtonString{num}, 'Fontsize',12, ...
        'Callback', ButtonCallback{num} ) ;
    
end




% define the parameters of the buttons .
ButtonString = { '上一步'; '导入'; '保存'; '下一步' } ; 
ButtonTag = { 'PreviousButton'; 'LoadButton'; 'SaveButton'; 'NextButton' } ;
ButtonCallback = { ['EditParameter(''PreviousButton_Callback'',gcbo)']; ...
        ['EditParameter(''LoadData_Callback'',gcbo)']; ...
        ['EditParameter(''SaveData_Callback'',gcbo)']; ...
        ['EditParameter(''NextButton_Callback'',gcbo)'] } ;

ButtonWidth = 80 ;
ButtonHeight = 25 ;
ButtonXPos = FigureWidth - ButtonWidth * 4 - TabSpace * 6 ;
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
function  init_FigureContent( h )
       
handles = guidata( h ) ;


% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.EditParameter, 'ArcSimulationData' ) ;
if isempty( ArcSimulationData )
    ArcSimulationData = ArcSimulationSoft( 'Get_DefaultArcSimulationData' ) ;    
    % save the data .
    setappdata( handles.EditParameter, 'ArcSimulationData', ArcSimulationData ) ;
end


TagIndex = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' ;

% define the string of the MainCircuitParameterText .
Text1String = { 'L21'; 'L22'; 'M1'; 'M2'; 'R21'; 'R22'; ...
        'R1'; 'L1'; 'C'; 'ea'; 'eb'; 'ec' } ;
ParameterName = { 'L21'; 'L22'; 'M1'; 'M2'; 'R21'; 'R22'; ...
        'R1'; 'L1'; 'C'; 'ea'; 'eb'; 'ec' } ;
for num = 1: 12
    % get the handle of the text .
    TextHandle = getfield( handles, ['MainCircuitParameterText', TagIndex(num)] ) ;
    EditHandle = getfield( handles, ['MainCircuitParameterEdit', TagIndex(num)] ) ;
    
    set( TextHandle, 'String', Text1String{num} ) ;    
    
    % get the handle of the edit .
    ParameterValue = getfield( ArcSimulationData.MainCircuitParameter, ParameterName{num} ) ;
    set( EditHandle, 'String', num2str( ParameterValue ) ) ;    
    
    
end


% define the string of the ArcResistanceParameterText .
Text2String = { 'A'; 'B'; 'C'; 'D'; 'L'; 'ω'; 'θ' } ;
ParameterName = { 'A'; 'B'; 'C'; 'D'; 'L'; 'Angle1'; 'Angle2' } ; ;
for num = 1: 7
    % get the handle of the text .
    TextHandle = getfield( handles, ['ArcResistanceParameterText', TagIndex(num)] ) ;
    EditHandle = getfield( handles, ['ArcResistanceParameterEdit', TagIndex(num)] ) ;
    
    set( TextHandle, 'String', Text2String{num} ) ;    
    
    % get the handle of the edit .
    ParameterValue = getfield( ArcSimulationData.ArcResistanceParameter, ParameterName{num} ) ;
    set( EditHandle, 'String', num2str( ParameterValue ) ) ;    
    
end





% --------------------------------------------------------------------------
function  MainCircuitParameter_Callback( h )
       
handles = guidata( h ) ;


% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.EditParameter, 'ArcSimulationData' ) ;

% define the string of the MainCircuitParameterText .
Text1String = { 'L21'; 'L22'; 'M1'; 'M2'; 'R21'; 'R22'; ...
        'R1'; 'L1'; 'C'; 'ea'; 'eb'; 'ec' } ;
ParameterName = { 'L21'; 'L22'; 'M1'; 'M2'; 'R21'; 'R22'; ...
        'R1'; 'L1'; 'C'; 'ea'; 'eb'; 'ec' } ;

TagIndex = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' ;

% get the tag and the string of the edit .
EditTag = get( h, 'Tag' ) ;
EditIndex = findstr( TagIndex, EditTag(end) ) ;

EditValue = get( h, 'String' ) ;
EditValue = str2num( EditValue ) ;
if isempty( EditValue )
    warndlg( '请输入一个数字。', '警告' ) ;
    return ;
end

% 保存结果。
% ---------------------------------------------------
ArcSimulationData.MainCircuitParameter = setfield( ...
    ArcSimulationData.MainCircuitParameter, ParameterName{EditIndex}, EditValue ) ;


% 检查输入参数，保证不能被0除。
% ----------------------------------------------------
L21 = ArcSimulationData.MainCircuitParameter.L21 ;
L22 = ArcSimulationData.MainCircuitParameter.L22 ;
M1 = ArcSimulationData.MainCircuitParameter.M1 ;
M2 = ArcSimulationData.MainCircuitParameter.M2 ;

if L21 == M2
    warndlg( { 'L21 不能等于 M2，'; '因为(L21 - M2)将作为除数。' } , '警告' ) ;
    return ;
    
elseif (2 * (L21 - M2) + L22  - 2 * M1 + M2 ) == 0
    warndlg( { '(2 * (L21 - M2) + L22  - 2 * M1 + M2 ) 不能等于 0，'; ...
            '因为(2 * (L21 - M2) + L22  - 2 * M1 + M2 )将作为除数。' } , '警告' ) ;
    return ;
    
elseif ArcSimulationData.MainCircuitParameter.C == 0
    warndlg( 'C 不能等于 0 。', '警告' ) ;
    return ;
    
else
end


% save the data .
setappdata( handles.EditParameter, 'ArcSimulationData', ArcSimulationData ) ;






% --------------------------------------------------------------------------
function  ArcResistanceParameter_Callback( h )
       
handles = guidata( h ) ;


% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.EditParameter, 'ArcSimulationData' ) ;

% define the string of the ArcResistanceParameterText .
Text2String = { 'A'; 'B'; 'C'; 'D'; 'L'; 'ω'; 'θ' } ;
ParameterName = { 'A'; 'B'; 'C'; 'D'; 'L'; 'Angle1'; 'Angle2' } ; ;

TagIndex = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' ;


% get the tag and the string of the edit .
EditTag = get( h, 'Tag' ) ;
EditIndex = findstr( TagIndex, EditTag(end) ) ;

EditValue = get( h, 'String' ) ;
EditValue = str2num( EditValue ) ;
if isempty( EditValue )
    warndlg( '请输入一个数字。', '警告' ) ;
    return ;
end

ArcSimulationData.ArcResistanceParameter = setfield( ...
    ArcSimulationData.ArcResistanceParameter, ParameterName{EditIndex}, EditValue ) ;

% save the data .
setappdata( handles.EditParameter, 'ArcSimulationData', ArcSimulationData ) ;





% --------------------------------------------------------------------------
function  MainCircuitFormula_Callback( h )
       
handles = guidata( h ) ;


% get the ArcSimulationData .
% ArcSimulationData = getappdata( handles.StatusEquation, 'ArcSimulationData' ) ;
ArcSimulationData = getappdata( gcbf, 'ArcSimulationData' ) ;

DisplayStatusEquation( ArcSimulationData ) ;




% --------------------------------------------------------------------------
function  ArcResistanceFormula_Callback( h )
       
handles = guidata( h ) ;


% find if have the same figure, and close it .
OldFigure = findobj( 'type', 'figure', 'Tag', 'ArcResistanceFormula' ) ;
if ishandle( OldFigure )
    close( OldFigure ) ;
end

% init the variables .
FigureWidth = 500 ;
FigureHeight = 150 ;
TabSpace = 10 ;
TextHeight = 20 ;

% generate a new figure .
FigureHandle = figure( 'Visible', 'off' ) ;
set( FigureHandle, 'Units' , 'pixels', 'Position', [150  150  FigureWidth  FigureHeight], ...
    'Name', '电弧电阻公式', 'Tag', 'ArcResistanceFormula', 'FileName' , '' ,...
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
FrameHeight = 70 ;
FrameYPos = FigureHeight - FrameHeight - TabSpace * 2 ;
Frame1Position = [FrameXPos  FrameYPos  FrameWidth  FrameHeight] ;
% generate a frame .
TitleHandle = uicontrol(FigureHandle,'style','frame', 'Units','pixels',...
    'position',Frame1Position  );


TextXPos = Frame1Position(1) + TabSpace * 1.5 ;
TextYPos = Frame1Position(2) + Frame1Position(4) - TextHeight - TabSpace ;
TextWidth = Frame1Position(3) - TabSpace * 3 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% subtitle: 电弧电阻公式
TextHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition,'Horizontal','left',...
    'string', '电弧电阻公式:', 'fontsize',13 );

TextXPos = Frame1Position(1) + TabSpace * 1.5 ;
TextYPos = TextPosition(2) - TextHeight - TabSpace ;
TextWidth = Frame1Position(3) - TabSpace * 3 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% subtitle: 电弧电阻公式
TextHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition,'Horizontal','center',...
    'string', 'R(t)=C*L*exp{1/[A+B(1-cos(2ωt+θ+D))]}', 'fontsize',13 );



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






% --------------------------------------------------------------------------
function  LoadData_Callback( h )
       
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


% save the data .
setappdata( handles.EditParameter, 'ArcSimulationData', ArcSimulationData ) ;

% display the new data .
init_FigureContent( h ) ;


% --------------------------------------------------------------------------
function  SaveData_Callback( h )
       
handles = guidata( h ) ;

% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.EditParameter, 'ArcSimulationData' ) ;


PromptString = '保存数据文件.' ;
MessageString = '保存数据文件成功。 ' ;

[ FileName , PathName ] = uiputfile( {'*.mat','数据文件(*.mat)'}, PromptString ) ;


if FileName == 0
    return ;    
else
    
    [TempPathName, FileName, FileTypeName, Version] = fileparts( FileName ) ;

    if ~strcmp( FileTypeName, '.mat' ) ;
        FileTypeName = '.mat' ;
    else
    end
    SaveFile = fullfile( PathName, [FileName, FileTypeName, Version] ) ;
end


if strcmp( lower( FileName ), 'imagedata' ) ;
    warndlg( '不能覆盖系统文件：ImageData.mat。', '警告', 'modal' ) ;
    return ;    
end


% save the result  file .
save( SaveFile, 'ArcSimulationData' ) ;


msgbox( MessageString ) ;




% --------------------------------------------------------------------------
function  PreviousButton_Callback( h )
       
handles = guidata( h ) ;

% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.EditParameter, 'ArcSimulationData' ) ;

% return the wizard figure .
% ArcSimulationSoft( ArcSimulationData ) ;
CalculateStatusEquation( ArcSimulationData ) ;


% close the current figure .
pause(0) ;
close( handles.EditParameter ) ;


% --------------------------------------------------------------------------
function  NextButton_Callback( h )
       
handles = guidata( h ) ;

% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.EditParameter, 'ArcSimulationData' ) ;


SimulateFigure( ArcSimulationData ) ;


% close the current figure .
pause(0) ;
close( handles.EditParameter ) ;
