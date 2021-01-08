function  varargout = DisplayEquationABMatrix( varargin )
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
    OldFigure = findobj( 'type', 'figure', 'Tag', 'DisplayEquationABMatrix' ) ;
    if ishandle( OldFigure )
        close( OldFigure ) ;
    end
    

    % generate a new figure .
    FigureHandle = figure( 'Visible', 'off' ) ;
    set( FigureHandle, 'Units' , 'pixels', 'Position', [150 150 500 300], ...
        'Name', '电弧炉对电网影响仿真软件', ...
        'Tag', 'DisplayEquationABMatrix', ...
        'FileName' , '' ,...
        'MenuBar' , 'none' ,...
        'NumberTitle' , 'off' ,...
        'Resize', 'on', ...
        'windowstyle', 'normal', ...
        'Visible', 'off' ) ;
    
    
    % generate the uicontrols .
    generate_FigureContent( FigureHandle ) ;
 
    % save the ArcSimulationData .
    setappdata( FigureHandle, 'ArcSimulationData', ArcSimulationData ) ;
    
    
    % display the figure .
    movegui( FigureHandle, 'center' ) ;
    
    set( get( FigureHandle, 'Children' ), 'Units', 'normalized' ) ;
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
function  generate_FigureContent( FigureHandle )
% generate the uicontrols .


% init the variables .
FigureWidth = 560 ;
FigureHeight = 360 ;
TabSpace = 10 ;
TextHeight = 22 ;
ChangeYPos = 30 ;


% reset the figure's size .
set( FigureHandle, 'Units', 'pixels', ...
    'Position', [160 170  FigureWidth  FigureHeight], ...
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


% generate the parameters of the 状态方程 .
% -----------------------------------------------------------------------------
% define the second frame .
FrameXPos = TabSpace * 2 ;
FrameWidth = (FigureWidth - TabSpace * 4) ;
FrameYPos = TabSpace * 6 ;
FrameHeight = FigureHeight - FrameYPos - TabSpace * 2 ;
Frame1Position = [FrameXPos  FrameYPos  FrameWidth  FrameHeight] ;
% generate a frame .
TitleHandle = uicontrol(FigureHandle,'style','frame', 'Units','pixels',...
    'position',Frame1Position  );


TextXPos = Frame1Position(1) + 15 ;
TextYPos = Frame1Position(2) + Frame1Position(4) - 12 ;
TextWidth = 90 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% subtitle: 状态方程
SubtitleHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition,'Horizontal','center',...
    'string', '状态方程', 'fontsize',13 );

% define the string of the button .
TextString = { '统一公式： X.=AX+BU';  } ;

% get the position of explain text .
TextXPos = Frame1Position(1) + TabSpace * 2 ;
TextYPos = Frame1Position(2) + Frame1Position(4) - TextHeight - TabSpace * 2 ;
TextWidth = 150 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% generate the text .
TextHandle = uicontrol(FigureHandle, 'style', 'text', 'Units','pixels',...
    'position', TextPosition, 'Horizontal','left', 'FontSize', 10,...
    'String', TextString{1} );




% define the string of the button .
TextString = {' A矩阵:'; ' B矩阵：' } ;


TextXPos = Frame1Position(1) + TabSpace * 1.5 ;
TextYPos = Frame1Position(2) + Frame1Position(4) - TextHeight * 2 - TabSpace * 2 ;
TextWidth = (Frame1Position(3) - TabSpace * 4.5) * 0.6 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% text
TextHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition, 'Horizontal','left',...
    'string', TextString{1}, 'fontsize',11 );

ListboxXPos = Frame1Position(1) + TabSpace * 1.5 ;
ListboxYPos = Frame1Position(2) + TabSpace * 1.5 ;
ListboxWidth = TextWidth ;
ListboxHeight = Frame1Position(4) - TextHeight * 1 - TabSpace * 5.5 ;
ListboxPosition = [ListboxXPos  ListboxYPos  ListboxWidth  ListboxHeight] ;
% listbox
ListboxHandle = uicontrol(FigureHandle, 'Style', 'listbox', 'Units','pixels',...
    'Position', ListboxPosition, 'Max', 2, 'BackgroundColor', [1  1  1], ...
    'Tag', 'DisplayAMatrix', 'fontsize',11 );


TextXPos = TextPosition(1) + TextPosition(3) + TabSpace * 1.5 ;
TextWidth = (Frame1Position(3) - TabSpace * 4.5) * 0.4 ;
TextPosition = [TextXPos  TextYPos  TextWidth  TextHeight] ;
% text
TextHandle = uicontrol(FigureHandle, 'Style','text', 'Units','pixels',...
    'position',TextPosition, 'Horizontal','left',...
    'string', TextString{2}, 'fontsize',11 );

ListboxXPos = ListboxPosition(1) + ListboxPosition(3) + TabSpace * 1.5 ;
ListboxWidth = TextWidth ;
ListboxPosition = [ListboxXPos  ListboxYPos  ListboxWidth  ListboxHeight] ;
% listbox
ListboxHandle = uicontrol(FigureHandle, 'Style', 'listbox', 'Units','pixels',...
    'Position', ListboxPosition, 'Max', 2, 'BackgroundColor', [1  1  1], ...
    'Tag', 'DisplayBMatrix', 'fontsize',11 );





ButtonWidth = 80 ;
ButtonHeight = 25 ;
ButtonXPos = FigureWidth - ButtonWidth - TabSpace * 3 ;
ButtonYPos = TabSpace * 2 ;;
ButtonPosition = [ButtonXPos  ButtonYPos  ButtonWidth  ButtonHeight] ;
% generate the pushbutton: Close .
ButtonHandle = uicontrol( 'Parent', FigureHandle, 'Units', 'Pixels', 'Position', ButtonPosition, ...
    'Style', 'pushbutton', 'string', '关闭', 'Fontsize',12, 'Callback', ['close(gcbf) ;'] ) ;


handles = guihandles( FigureHandle ) ;
guidata( FigureHandle, handles ) ;




% --------------------------------------------------------------------------
function  init_FigureContent( h )
       
handles = guidata( h ) ;


% get the ArcSimulationData .
ArcSimulationData = getappdata( handles.DisplayEquationABMatrix, 'ArcSimulationData' ) ;
if isempty( ArcSimulationData )
    ArcSimulationData = ArcSimulationSoft( 'Get_DefaultArcSimulationData' ) ;    
    % save the data .
    setappdata( handles.DisplayEquationABMatrix, 'ArcSimulationData', ArcSimulationData ) ;
end


AMatrixString = num2str( ArcSimulationData.StatusEquation.A ) ;
BMatrixString = num2str( ArcSimulationData.StatusEquation.B ) ;

% reset the string of the listboxes.
set( handles.DisplayAMatrix, 'Value', [], 'String', AMatrixString ) ;
set( handles.DisplayBMatrix, 'Value', [], 'String', BMatrixString ) ;

