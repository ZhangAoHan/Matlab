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
        'Name', '�绡¯�Ե���Ӱ��������', ...
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
MenuHandle = uimenu( 'Parent', FigureHandle, 'Label', '�ļ�(&F)' ) ;

% define the parameters of the menus .
MenuLabel = { '�˳�(&E)' } ;

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
MenuHandle = uimenu( FigureHandle, 'Label', '����(&P)' ) ;

% define the parameters of the menus .
MenuLabel = { '����(&L)'; '����(&E)' } ;

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
MenuHandle = uimenu( FigureHandle, 'Label', '����(&H)', 'Enable', 'on' ) ;

% define the parameters of the menus .
MenuLabel = { '����(&O)'; '��ʾ(&E)'; '����' } ;

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
set(FigureHandle,'defaultuicontrolfontname','����');
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
    'string', 'һ��ϵͳ״̬���̵Ľ���', 'fontsize',15 );



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
% subtitle: Ԫ������
SubtitleHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition,'Horizontal','center',...
    'string', 'Ԫ������', 'fontsize',13 );

% get the position of explain text .
TextXPos = Frame1Position(1) + TabSpace ;
TextYPos = Frame1Position(2) + Frame1Position(4) - TextHeight - TabSpace * 1.5 ;
TextWidth = (Frame1Position(3) - TabSpace * 5) * 0.3 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% text: Ԫ�����
SubtitleHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition, 'Horizontal','center',...
    'string', '���', 'fontsize',11 );

% get the position of the listbox.
ListboxXPos = Frame1Position(1) + TabSpace ;
ListboxYPos = Frame1Position(2) + TabSpace ;
ListboxWidth = (Frame1Position(3) - TabSpace * 5) * 0.3 ;
ListboxHeight = Frame1Position(4) - TextHeight - TabSpace * 2.5 ;
ListboxPosition = [ListboxXPos  ListboxYPos  ListboxWidth  ListboxHeight] ;
% listbox: Ԫ�����
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
TextString = { '����'; '֧·��'; 'ʼ�ڵ�'; '�սڵ�'; '����ֵ'; } ;
UicontrolStyle = { 'popupmenu'; 'edit'; 'edit'; 'edit'; 'edit' } ;
UicontrolString = { { '����'; '���'; '����'; '��ѹԴ';'����Դ';'ѹ��ѹԴ' }; '1'; '1'; '1'; '0.5' } ;

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
%         % ������һ��״̬���̺�����״̬���̵��л����ء��������� 
%         set( EditHandle, 'Enable', 'inactive' ) ;              
%     end
    
end


% get the position of buttons .
ButtonXPos = TextPosition(1) + TabSpace ;
ButtonYPos = TempTextPosition(2) - TextHeight - TabSpace * 2 ;
ButtonWidth = 100 ;
ButtonPosition = [ButtonXPos  ButtonYPos  ButtonWidth  TextHeight] ;


% define the string of the button .
ButtonString = { '����Ԫ��'; 'ɾ��Ԫ��' } ;
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
%         % ������һ��״̬���̺�����״̬���̵��л����ء��������� 
%         set( ButtonHandle, 'Enable', 'inactive' ) ;              
%     end       
end



% generate the parameters of the ״̬���� .
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
% subtitle: ״̬����
SubtitleHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition,'Horizontal','center',...
    'string', '״̬����', 'fontsize',13 );

% define the string of the button .
TextString = { 'ͳһ��ʽ�� X.=AX+BU';  } ;
ButtonString = { '����';  } ;
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
TextString = {' A����:'; ' B����' } ;


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
TextString = { '��ʾ״̬����:';  } ;
ButtonString = { '��ʾ'; } ;
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
ButtonString = { '��һ��'; '����'; '����'; '��һ��' } ; 
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

% ��ʾ��һ��Ԫ���ĵĲ�����
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


% ��ʾ��ǰԪ�������� .
ParameterValue = getfield( ArcSimulationData.ElementParameter, {ElementIndex}, ParameterName{1} ) ;
PopupmenuIndex = find( strcmp( ParameterValue, { '����'; '���'; '����'; '��ѹԴ' } ) ) ;
set( handles.ElementParameterEditA, 'Value', PopupmenuIndex ) ;    


TagIndex = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' ;

% ��ʾ��ǰԪ���Ĳ��� .
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
    
    warndlg( '���ֻ������30��Ԫ����', '����', 'modal' ) ;
    return ;
end

% ����µ�Ԫ����
ArcSimulationData.ElementParameter(ElementNumber + 1).Type = '����' ;   % Ԫ�����͡�
ArcSimulationData.ElementParameter(ElementNumber + 1).SpurTrackNumber = 1 ;   % ����֧·����
ArcSimulationData.ElementParameter(ElementNumber + 1).BeginNodeIndex = 1 ;   % ʼ�ڵ���š�
ArcSimulationData.ElementParameter(ElementNumber + 1).EndNodeIndex = 2 ;   % �սڵ���š�
ArcSimulationData.ElementParameter(ElementNumber + 1).Parameter = 0.5 ;   % �������ֵ��

% save the data .
setappdata( handles.CalculateStatusEquation, 'ArcSimulationData', ArcSimulationData ) ;

% get the string of the element .
ListboxString = num2str( [1: (ElementNumber + 1)]' ) ;
set( handles.ElementIndex, 'Value', 1, 'String', ListboxString ) ;

% ��ʾ����һ��Ԫ���ĵĲ�����
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
    
    warndlg( '����Ҫ��һ��Ԫ����', '����', 'modal' ) ;
    return ;
end

% ɾ�����һ��Ԫ����
ArcSimulationData.ElementParameter = ArcSimulationData.ElementParameter( [1: (ElementNumber - 1)] ) ;

% save the data .
setappdata( handles.CalculateStatusEquation, 'ArcSimulationData', ArcSimulationData ) ;

% get the string of the element .
ListboxString = num2str( [1: (ElementNumber - 1)]' ) ;
set( handles.ElementIndex, 'Value', 1, 'String', ListboxString ) ;

% ��ʾ����һ��Ԫ���ĵĲ�����
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

ElementType = { '����'; '���'; '����'; '��ѹԴ' } ;
if EditIndex == 1
    % ѡ��Ԫ�����͡�
    PopupmenuIndex = get( handles.ElementParameterEditA, 'Value' ) ;
    
    % ����Ԫ�����͡�
    ArcSimulationData.ElementParameter = setfield( ...
        ArcSimulationData.ElementParameter, {ElementIndex}, ParameterName{EditIndex}, ElementType{PopupmenuIndex} ) ;
    
    % save the data .
    setappdata( handles.CalculateStatusEquation, 'ArcSimulationData', ArcSimulationData ) ;
    
    return ;
end


EditValue = get( h, 'String' ) ;
EditValue = str2num( EditValue ) ;
if isempty( EditValue )
    warndlg( '������һ�����֡�', '����' ) ;
    return ;
end

% ����Ǳ༭����ֵ��
if EditIndex == 5
        
    % ��Ϊ��һЩԪ�����Ĳ�����һ���ģ����޸�����һ���Ĳ���������Ԫ�����Ĳ���ҲҪ��Ӧ�ĸı䡣
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
% ����״̬���̡�


handles = guidata( h ) ;


% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.CalculateStatusEquation, 'ArcSimulationData' ) ;

% ========================================
% ����״̬����ϵ����

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

% ���¼���һ�£���ʾ���µ�A,B����
CalculateEquation_Callback( h ) ;

% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.CalculateStatusEquation, 'ArcSimulationData' ) ;

DisplayEquationABMatrix( ArcSimulationData ) ;



% --------------------------------------------------------------------------
function  LoadData_Callback( h )
       
handles = guidata( h ) ;


PromptString = 'ѡ�������ļ�.' ;
WarningString1 = '�ļ���ʽ���� ' ;
WarningString2 = 'ѡ����ļ�������ȷ�������ļ��� ' ;


[ FileName , PathName ] = uigetfile( {'*.mat','�����ļ�(*.mat)'}, PromptString ) ;


if FileName == 0
    return ;    
else
    
    [TempPathName, FileName, FileTypeName, Version] = fileparts( FileName ) ;

    if ~strcmp( FileTypeName, '.mat' ) ;
        warndlg( WarningString1, '����', 'modal' ) ;
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
    
    warndlg( WarningString1, '����', 'modal' ) ;
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


PromptString = '���������ļ�.' ;
MessageString = '���������ļ��ɹ��� ' ;

[ FileName , PathName ] = uiputfile( {'*.mat','�����ļ�(*.mat)'}, PromptString ) ;


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
    warndlg( '���ܸ���ϵͳ�ļ���ImageData.mat��', '����', 'modal' ) ;
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
