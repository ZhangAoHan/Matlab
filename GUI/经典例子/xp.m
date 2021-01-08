function xprim=xp(t,x, ArcSimulationData) ;


% find the handle of the current main figure .
FigureHandle = findobj( 'type', 'figure', 'Tag', 'SimulateFigure' ) ;

if ~ishandle( FigureHandle )
    xprim=[25*x(1)+13*x(2)+9*x(5)+20*x(6);...
            59*x(1)-21*x(2)+40*x(5)+28*x(6);...
            20*x(3)-40*x(5)-10*x(6)+80;...
            x(4)+98*x(5)-x(6)+30;...
            x(1)+21*x(2)+34*x(3)-x(4);...
            24*x(1)-19*x(2)+x(3)+31*x(4)];
    return ;
    
else
end


% get the ArcSimulationData .
ArcSimulationData = getappdata( FigureHandle, 'ArcSimulationData' ) ;


% ========================================
% ����״̬����ϵ����
ArcSimulationData = CalculateXPCoefficient( t, ArcSimulationData ) ;
% ========================================


A = ArcSimulationData.StatusEquation.A ;
B = ArcSimulationData.StatusEquation.B ;

XMaitix = kron( ones(1, size(A, 1)), x ) ;

xprim = A.* XMaitix ;

% �����������͡�
xprim = sum( xprim' ) ;
% ���б���С�
xprim = xprim' ;
