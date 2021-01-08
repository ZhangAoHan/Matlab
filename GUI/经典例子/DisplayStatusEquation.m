function  DisplayStatusEquation( ArcSimulationData )
% this module display the StatusEquation .

%  February 2004
%  $Revision: 1.00 $  



% generate a new figure .
FigureHandle = figure( 'Visible', 'off' ) ;
set( FigureHandle, 'Units' , 'pixels', 'Position', [150 150 500 300], ...
    'Name', '状态方程', 'Tag', 'MainCircuitFormula', 'FileName' , '' ,...
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
    ImageData = imread( 'MainCircuitFormula.bmp' ) ;
    ImageSize = size( ImageData ) ;
catch
    warndlg( ['Lost File: MainCircuitFormula.bmp'], 'modal' ) ;
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


