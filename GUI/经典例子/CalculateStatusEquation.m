function  varargout = CalculateStatusEquation( varargin )
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
    OldFigure = findobj( 'type', 'figure', 'Tag', 'CalculateStatusEquation' ) ;
    if ishandle( OldFigure )
        close( OldFigure ) ;
    end
    

    % generate a new figure .
    FigureHandle = figure( 'Visible', 'off' ) ;
    set( FigureHandle, 'Units' , 'pixels', 'Position', [150 150 500 300], ...
        'Name', '电弧炉对电网影响仿真软件', ...
        'Tag', 'CalculateStatusEquation', ...
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

%     set( findobj( FigureHandle, 'Type', 'uicontrol' ), 'Units', 'normalized' ) ;
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
    ['CalculateStatusEquation( ''LoadData_Callback'', gcbo)']; ...
    ['CalculateStatusEquation( ''SaveData_Callback'', gcbo)']; } ;
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
    'string', '一般系统状态方程的建立', 'fontsize',15 );



% generate the parameters of the MainCircuitParameter .
% -----------------------------------------------------------------------------
% define the first frame .
FrameXPos = TabSpace * 2 ;
FrameWidth = (FigureWidth - TabSpace * 6) * 0.5 ;
FrameHeight = 270 ;
FrameYPos = TitlePosition(2) - FrameHeight - TabSpace * 2 ;
Frame1Position = [FrameXPos  FrameYPos  FrameWidth  FrameHeight] ;
% generate a frame .
TitleHandle = uicontrol(FigureHandle,'style','frame', 'Units','pixels',...
    'position',Frame1Position  );


TextXPos = Frame1Position(1) + 15 ;
TextYPos = Frame1Position(2) + Frame1Position(4) - 12 ;
TextWidth = 90 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% subtitle: 元件参数
SubtitleHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition,'Horizontal','center',...
    'string', '元件参数', 'fontsize',13 );

% get the position of explain text .
TextXPos = Frame1Position(1) + TabSpace ;
TextYPos = Frame1Position(2) + Frame1Position(4) - TextHeight - TabSpace * 1.5 ;
TextWidth = (Frame1Position(3) - TabSpace * 5) * 0.3 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% text: 元件序号
SubtitleHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition, 'Horizontal','center',...
    'string', '序号', 'fontsize',11 );

% get the position of the listbox.
ListboxXPos = Frame1Position(1) + TabSpace ;
ListboxYPos = Frame1Position(2) + TabSpace ;
ListboxWidth = (Frame1Position(3) - TabSpace * 5) * 0.3 ;
ListboxHeight = Frame1Position(4) - TextHeight - TabSpace * 2.5 ;
ListboxPosition = [ListboxXPos  ListboxYPos  ListboxWidth  ListboxHeight] ;
% listbox: 元件序号
ListboxHandle = uicontrol(FigureHandle, 'Style','listbox', 'Units','pixels',...
    'position',ListboxPosition,'Tag','ElementIndex', 'string', '1', ...
    'Max', 1, 'Value', 1, 'fontsize',10, 'BackgroundColor', [1 1 1], ...
    'Callback', ['CalculateStatusEquation(''ElementIndex_Callback'',gcbo)'] );

% get the position of explain text .
TextXPos = ListboxPosition(1) + ListboxPosition(3) + TabSpace ;
TextYPos = Frame1Position(2) + Frame1Position(4) - TextHeight - TabSpace * 3.5 ;
TextWidth = (Frame1Position(3) - TabSpace * 5) * 0.35 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;

% get the position of the popupmenu .
EditXPos = TextXPos + TextWidth + TabSpace ;
EditYPos = TextYPos ;
% EditWidth = 90 ;
EditWidth = (Frame1Position(3) - TabSpace * 5) * 0.35 ;
EditPosition = [EditXPos  EditYPos  EditWidth  TextHeight] ;

% define the string of the text .
TextString = { '类型'; '支路数'; '始节点'; '终节点'; '参数值'; } ;
UicontrolStyle = { 'popupmenu'; 'edit'; 'edit'; 'edit'; 'edit' } ;
UicontrolString = { { '电阻'; '电感'; '电容'; '电压源';'电流源';'压控压源' }; '1'; '1'; '1'; '0.5' } ;

TagIndex = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' ;

for num = 1: 5
    TempTextPosition = TextPosition ;
    TempTextPosition(2) = TempTextPosition(2) - (num - 1) * (TextHeight + TabSpace) ;
    % generate the text .
    TextHandle = uicontrol(FigureHandle, 'style', 'text', 'Units','pixels',...
        'position', TempTextPosition, 'Horizontal','center', 'String', TextString{num}, ...
        'Tag', ['ElementParameterText', TagIndex(num)], 'FontSize',11 );
    
    TempEditPosition = EditPosition ;
    TempEditPosition(2) = TempEditPosition(2) - (num - 1) * (TextHeight + TabSpace) ;
    % generate the text .
    EditHandle = uicontrol(FigureHandle, 'Style', UicontrolStyle{num}, 'Units','pixels',...
        'position', TempEditPosition, 'Horizontal','center', 'BackgroundColor', [1 1 1], ...
        'Tag', ['ElementParameterEdit', TagIndex(num)], ...
        'String', UicontrolString{num}, 'FontSize',10, ...
        'Callback', ['CalculateStatusEquation(''ElementParameter_Callback'',gcbo)'] ) ;
    
%     if num == 1
%         % 这里是一般状态方程和任意状态方程的切换开关。％％％％ 
%         set( EditHandle, 'Enable', 'inactive' ) ;              
%     end
    
end


% get the position of buttons .
ButtonXPos = TextPosition(1) + TabSpace ;
ButtonYPos = TempTextPosition(2) - TextHeight - TabSpace * 2 ;
ButtonWidth = 100 ;
ButtonPosition = [ButtonXPos  ButtonYPos  ButtonWidth  TextHeight] ;


% define the string of the button .
ButtonString = { '增加元件'; '删除元件' } ;
ButtonTag = { 'AddElement'; 'DeleteElement' } ;
ButtonCallback = { ['CalculateStatusEquation(''AddElement_Callback'',gcbo)']; ...
        ['CalculateStatusEquation(''DeleteElement_Callback'',gcbo)'] } ;


for num = 1: 2
    TempButtonPosition = ButtonPosition ;
    TempButtonPosition(2) = TempButtonPosition(2) - (num - 1) * (TextHeight + TabSpace) ;
    % generate the button .
    ButtonHandle = uicontrol(FigureHandle, 'style', 'pushbutton', 'Units','pixels',...
        'position', TempButtonPosition, 'String', ButtonString{num}, ...
        'Tag', ButtonTag{num}, 'FontSize',11, 'Callback', ButtonCallback{num} );
    
    
%     if logical(1)
%         % 这里是一般状态方程和任意状态方程的切换开关。％％％％ 
%         set( ButtonHandle, 'Enable', 'inactive' ) ;              
%     end       
end



% generate the parameters of the 状态方程 .
% -----------------------------------------------------------------------------
% define the second frame .
FrameXPos = Frame1Position(1) + Frame1Position(3) + TabSpace * 2 ;
FrameWidth = (FigureWidth - TabSpace * 6) * 0.5 ;
FrameHeight = 250 ;
FrameYPos = TitlePosition(2) - FrameHeight - TabSpace * 2 ;
Frame2Position = [FrameXPos  FrameYPos  FrameWidth  FrameHeight] ;
% generate a frame .
TitleHandle = uicontrol(FigureHandle,'style','frame', 'Units','pixels',...
    'position',Frame2Position  );


TextXPos = Frame2Position(1) + 15 ;
TextYPos = Frame2Position(2) + Frame2Position(4) - 12 ;
TextWidth = 90 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% subtitle: 状态方程
SubtitleHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition,'Horizontal','center',...
    'string', '状态方程', 'fontsize',13 );

% define the string of the button .
TextString = { '统一公式： X.=AX+BU';  } ;
ButtonString = { '计算';  } ;
ButtonTag = { 'CalculateEquation'; 'DisplayABMatrix'; 'DisplayBMatrix' } ;
ButtonCallback = { ['CalculateStatusEquation(''CalculateEquation_Callback'',gcbo)'] } ;


% get the position of explain text .
TextXPos = Frame2Position(1) + TabSpace * 2 ;
TextYPos = Frame2Position(2) + Frame2Position(4) - TextHeight - TabSpace * 2 ;
TextWidth = 150 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% generate the text .
TextHandle = uicontrol(FigureHandle, 'style', 'text', 'Units','pixels',...
    'position', TextPosition, 'Horizontal','left', 'FontSize', 10,...
    'String', TextString{1} );

% get the position of buttons .
ButtonXPos = TextPosition(1) + TextPosition(3) + TabSpace ;
ButtonYPos = TextPosition(2) + 5 ;
ButtonWidth = 70 ;
ButtonPosition = [ButtonXPos  ButtonYPos  ButtonWidth  TextHeight] ;

% generate the button .
ButtonHandle = uicontrol(FigureHandle, 'style', 'pushbutton', 'Units','pixels',...
    'position', ButtonPosition, 'String', ButtonString{1}, ...
    'Tag', ButtonTag{1}, 'FontSize',11, 'Callback', ButtonCallback{1} );




% define the string of the button .
TextString = {' A矩阵:'; ' B矩阵：' } ;


TextXPos = Frame2Position(1) + TabSpace * 1.5 ;
TextYPos = Frame2Position(2) + Frame2Position(4) - TextHeight * 2 - TabSpace * 2 ;
TextWidth = (Frame2Position(3) - TabSpace * 4.5) / 2 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% text
TextHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition, 'Horizontal','left',...
    'string', TextString{1}, 'fontsize',11 );

ListboxXPos = Frame2Position(1) + TabSpace * 1.5 ;
ListboxYPos = Frame2Position(2) + TabSpace * 1.5 + TextHeight + TabSpace;
ListboxWidth = (Frame2Position(3) - TabSpace * 4.5) / 2 ;
ListboxHeight = Frame2Position(4) - TextHeight * 2 - TabSpace * 6.5 ;
ListboxPosition = [ListboxXPos  ListboxYPos  ListboxWidth  ListboxHeight] ;
% listbox
ListboxHandle = uicontrol(FigureHandle, 'Style', 'listbox', 'Units','pixels',...
    'Position', ListboxPosition, 'Max', 2, 'BackgroundColor', [1  1  1], ...
    'Tag', 'DisplayAMatrix', 'fontsize',11 );


TextXPos = TextPosition(1) + TextPosition(3) + TabSpace * 1.5 ;
TextWidth = (Frame2Position(3) - TabSpace * 4.5) / 2 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% text
TextHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition, 'Horizontal','left',...
    'string', TextString{2}, 'fontsize',11 );

ListboxXPos = ListboxPosition(1) + ListboxPosition(3) + TabSpace * 1.5 ;
ListboxPosition = [ListboxXPos  ListboxYPos  ListboxWidth  ListboxHeight] ;
% listbox
ListboxHandle = uicontrol(FigureHandle, 'Style', 'listbox', 'Units','pixels',...
    'Position', ListboxPosition, 'Max', 2, 'BackgroundColor', [1  1  1], ...
    'Tag', 'DisplayBMatrix', 'fontsize',11 );



% define the string of the button .
TextString = { '显示状态方程:';  } ;
ButtonString = { '显示'; } ;
ButtonTag = {  'DisplayEquation';  } ;
ButtonCallback = { ['CalculateStatusEquation(''DisplayEquation_Callback'',gcbo)'] } ;



% get the position of explain text .
TextXPos = Frame2Position(1) + TabSpace * 1.5 ;
TextYPos = Frame2Position(2) + 5 ;
TextWidth = 100 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% generate the text .
TextHandle = uicontrol(FigureHandle, 'style', 'text', 'Units','pixels',...
    'position', TextPosition, 'Horizontal','left', 'FontSize', 10,...
    'String', TextString{1} );


% get the position of buttons .
ButtonXPos = TextPosition(1) + TextPosition(3) + TabSpace ;
ButtonYPos = TextPosition(2) + 5 ;
ButtonWidth = 70 ;
ButtonPosition = [ButtonXPos  ButtonYPos  ButtonWidth  TextHeight] ;

% generate the button .
ButtonHandle = uicontrol(FigureHandle, 'style', 'pushbutton', 'Units','pixels',...
    'position', ButtonPosition, 'String', ButtonString{1}, ...
    'Tag', ButtonTag{1}, 'FontSize',11, 'Callback', ButtonCallback{1} );





% define the parameters of the buttons .
ButtonString = { '上一步'; '导入'; '保存'; '下一步' } ; 
ButtonTag = { 'PreviousButton'; 'LoadButton'; 'SaveButton'; 'NextButton' } ;
ButtonCallback = { ['CalculateStatusEquation(''PreviousButton_Callback'',gcbo)']; ...
        ['CalculateStatusEquation(''LoadData_Callback'',gcbo)']; ...
        ['CalculateStatusEquation(''SaveData_Callback'',gcbo)']; ...
        ['CalculateStatusEquation(''NextButton_Callback'',gcbo)'] } ;

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
ArcSimulationData = getappdata( handles.CalculateStatusEquation, 'ArcSimulationData' ) ;
if isempty( ArcSimulationData )
    ArcSimulationData = ArcSimulationSoft( 'Get_DefaultArcSimulationData' ) ;    
    % save the data .
    setappdata( handles.CalculateStatusEquation, 'ArcSimulationData', ArcSimulationData ) ;
end

% get the index of the element .
ElementNumber = length( ArcSimulationData.ElementParameter ) ;

% get the string of the element .
ListboxString = num2str( [1: ElementNumber]' ) ;
set( handles.ElementIndex, 'Value', 1, 'String', ListboxString ) ;

% 显示第一个元件的的参数。
ElementIndex_Callback( h ) ;

% CalculateEquation_Callback( h ) ;


% --------------------------------------------------------------------------
function  ElementIndex_Callback( h )
       
handles = guidata( h ) ;


% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.CalculateStatusEquation, 'ArcSimulationData' ) ;

% get the index of the element .
ElementIndex = get( handles.ElementIndex, 'Value' ) ;


% define the string of the MainCircuitParameterText .
ParameterName = { 'Type'; 'SpurTrackNumber'; 'BeginNodeIndex'; 'EndNodeIndex'; 'Parameter' } ;


% 显示当前元件的类型 .
ParameterValue = getfield( ArcSimulationData.ElementParameter, {ElementIndex}, ParameterName{1} ) ;
PopupmenuIndex = find( strcmp( ParameterValue, { '电阻'; '电感'; '电容'; '电压源' } ) ) ;
set( handles.ElementParameterEditA, 'Value', PopupmenuIndex ) ;    


TagIndex = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' ;

% 显示当前元件的参数 .
for num = 2: 5
    % get the handle of the edit .
    EditHandle = getfield( handles, ['ElementParameterEdit', TagIndex(num)] ) ;
    % reset the value of the edit .
    ParameterValue = getfield( ArcSimulationData.ElementParameter, {ElementIndex}, ParameterName{num} ) ;
    set( EditHandle, 'String', num2str( ParameterValue ) ) ;    
    
end




% --------------------------------------------------------------------------
function  AddElement_Callback( h )
       
handles = guidata( h ) ;

% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.CalculateStatusEquation, 'ArcSimulationData' ) ;

% get the index of the element .
ElementNumber = length( ArcSimulationData.ElementParameter ) ;

if ElementNumber == 30
    
    warndlg( '最多只能输入30个元件。', '警告', 'modal' ) ;
    return ;
end

% 添加新的元件。
ArcSimulationData.ElementParameter(ElementNumber + 1).Type = '电阻' ;   % 元件类型。
ArcSimulationData.ElementParameter(ElementNumber + 1).SpurTrackNumber = 1 ;   % 定义支路数。
ArcSimulationData.ElementParameter(ElementNumber + 1).BeginNodeIndex = 1 ;   % 始节点序号。
ArcSimulationData.ElementParameter(ElementNumber + 1).EndNodeIndex = 2 ;   % 终节点序号。
ArcSimulationData.ElementParameter(ElementNumber + 1).Parameter = 0.5 ;   % 定义参数值。

% save the data .
setappdata( handles.CalculateStatusEquation, 'ArcSimulationData', ArcSimulationData ) ;

% get the string of the element .
ListboxString = num2str( [1: (ElementNumber + 1)]' ) ;
set( handles.ElementIndex, 'Value', 1, 'String', ListboxString ) ;

% 显示最新一个元件的的参数。
set( handles.ElementIndex, 'Value', (ElementNumber + 1) ) ;

ElementIndex_Callback( h ) ;



% --------------------------------------------------------------------------
function  DeleteElement_Callback( h )
       
handles = guidata( h ) ;

% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.CalculateStatusEquation, 'ArcSimulationData' ) ;

% get the index of the element .
ElementNumber = length( ArcSimulationData.ElementParameter ) ;

if ElementNumber == 1
    
    warndlg( '至少要有一个元件。', '警告', 'modal' ) ;
    return ;
end

% 删除最后一个元件。
ArcSimulationData.ElementParameter = ArcSimulationData.ElementParameter( [1: (ElementNumber - 1)] ) ;

% save the data .
setappdata( handles.CalculateStatusEquation, 'ArcSimulationData', ArcSimulationData ) ;

% get the string of the element .
ListboxString = num2str( [1: (ElementNumber - 1)]' ) ;
set( handles.ElementIndex, 'Value', 1, 'String', ListboxString ) ;

% 显示最新一个元件的的参数。
set( handles.ElementIndex, 'Value', (ElementNumber - 1) ) ;

ElementIndex_Callback( h ) ;




% --------------------------------------------------------------------------
function  ElementParameter_Callback( h )
       
handles = guidata( h ) ;


% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.CalculateStatusEquation, 'ArcSimulationData' ) ;

% get the index of the element .
ElementIndex = get( handles.ElementIndex, 'Value' ) ;

% define the string of the ElementParameterText .
ParameterName = { 'Type'; 'SpurTrackNumber'; 'BeginNodeIndex'; 'EndNodeIndex'; 'Parameter' } ;


TagIndex = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' ;

% get the tag and the string of the edit .
EditTag = get( h, 'Tag' ) ;
EditIndex = findstr( TagIndex, EditTag(end) ) ;

ElementType = { '电阻'; '电感'; '电容'; '电压源' } ;
if EditIndex == 1
    % 选择元件类型。
    PopupmenuIndex = get( handles.ElementParameterEditA, 'Value' ) ;
    
    % 保存元件类型。
    ArcSimulationData.ElementParameter = setfield( ...
        ArcSimulationData.ElementParameter, {ElementIndex}, ParameterName{EditIndex}, ElementType{PopupmenuIndex} ) ;
    
    % save the data .
    setappdata( handles.CalculateStatusEquation, 'ArcSimulationData', ArcSimulationData ) ;
    
    return ;
end


EditValue = get( h, 'String' ) ;
EditValue = str2num( EditValue ) ;
if isempty( EditValue )
    warndlg( '请输入一个数字。', '警告' ) ;
    return ;
end

% 如果是编辑参数值。
if EditIndex == 5
        
    % 因为有一些元器件的参数是一样的，故修改其中一个的参数，其它元器件的参数也要相应的改变。
    if find( ElementIndex == [4  5  6] ) 
        ElementIndex = [4  5  6] ;
        
    elseif find( ElementIndex == [7  8  9] ) 
        ElementIndex = [7  8  9] ;
        
    elseif find( ElementIndex == [10  11  12] ) 
        ElementIndex = [10  11  12] ;
        
    elseif find( ElementIndex == [13  15] ) 
        ElementIndex = [13  15] ;
        
    elseif find( ElementIndex == [16  18] ) 
        ElementIndex = [16  18] ;
        
    end 
    
end


for num = 1: length( ElementIndex )    
    ArcSimulationData.ElementParameter = setfield( ...
        ArcSimulationData.ElementParameter, {ElementIndex(num)}, ParameterName{EditIndex}, EditValue ) ;
end

% save the data .
setappdata( handles.CalculateStatusEquation, 'ArcSimulationData', ArcSimulationData ) ;








% --------------------------------------------------------------------------
function  CalculateEquation_Callback( h )
% 计算状态方程。


handles = guidata( h ) ;


% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.CalculateStatusEquation, 'ArcSimulationData' ) ;

% ========================================
% 计算状态方程系数。

ArcSimulationData = CalculateEquation( ArcSimulationData ) ;

% ========================================

% save the data .
setappdata( handles.CalculateStatusEquation, 'ArcSimulationData', ArcSimulationData ) ;


AMatrixString = num2str( ArcSimulationData.StatusEquation.A ) ;
BMatrixString = num2str( ArcSimulationData.StatusEquation.B ) ;

% reset the string of the listboxes.
set( handles.DisplayAMatrix, 'Value', [], 'String', AMatrixString ) ;
set( handles.DisplayBMatrix, 'Value', [], 'String', BMatrixString ) ;




% --------------------------------------------------------------------------
function  DisplayEquation_Callback( h )
       
handles = guidata( h ) ;

% 重新计算一下，显示最新的A,B矩阵。
CalculateEquation_Callback( h ) ;

% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.CalculateStatusEquation, 'ArcSimulationData' ) ;

DisplayEquationABMatrix( ArcSimulationData ) ;



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
        | ~isfield( ArcSimulationData, 'ElementParameter' ) ...
        | ~isfield( ArcSimulationData, 'MainCircuitParameter' ) ...
        | ~isfield( ArcSimulationData, 'ArcResistanceParameter' ) 
    
    warndlg( WarningString1, '警告', 'modal' ) ;
    return ;
end


% save the data .
setappdata( handles.CalculateStatusEquation, 'ArcSimulationData', ArcSimulationData ) ;

% display the new data .
init_FigureContent( h ) ;

% reset the string of the listboxes.
set( handles.DisplayAMatrix, 'Value', [], 'String', ' ' ) ;
set( handles.DisplayBMatrix, 'Value', [], 'String', ' ' ) ;





% --------------------------------------------------------------------------
function  SaveData_Callback( h )
       
handles = guidata( h ) ;

% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.CalculateStatusEquation, 'ArcSimulationData' ) ;


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
ArcSimulationData = getappdata( handles.CalculateStatusEquation, 'ArcSimulationData' ) ;

% return the wizard figure .
ArcSimulationSoft( ArcSimulationData ) ;


% close the current figure .
pause(0) ;
close( handles.CalculateStatusEquation ) ;


% --------------------------------------------------------------------------
function  NextButton_Callback( h )
       
handles = guidata( h ) ;

% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.CalculateStatusEquation, 'ArcSimulationData' ) ;

% open the next figure .
% SimulateFigure( ArcSimulationData ) ;
EditParameter( ArcSimulationData ) ;


% close the current figure .
pause(0) ;
close( handles.CalculateStatusEquation ) ;
