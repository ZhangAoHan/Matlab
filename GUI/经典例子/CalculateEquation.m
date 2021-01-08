function  ArcSimulationData = CalculateEquation( ArcSimulationData ) ;
% 计算状态方程。

%  February 2004
%  $Revision: 1.00 $  



% 计算状态方程系数。
A = [...
        0  0  0  0  0  0  0  0  0  0; ...
        0  0  0  0  0  0  0  0  0  0; ...
        0  0  0  0  0  0  0  0  0  0; ...
        0  0  0  0  0  0  0  0  0  0; ...
        0  0  0  0  0  0  0  0  0  0; ...
        0  0  0  0  0  0  0  0  0  0; ...
        0  0  0  0  0  0  0  0  0  0; ...
        0  0  0  0  0  0  0  0  0  0; ...
        0  0  0  0  0  0  0  0  0  0; ...
        0  0  0  0  0  0  0  0  0  0] ;
B = [...
        0  0  0  0  0  0  0  0  0  0; ...
        0  0  0  0  0  0  0  0  0  0; ...
        0  0  0  0  0  0  0  0  0  0; ...
        0  0  0  0  0  0  0  0  0  0; ...
        0  0  0  0  0  0  0  0  0  0; ...
        0  0  0  0  0  0  0  0  0  0; ...
        0  0  0  0  0  0  0  0  0  0; ...
        0  0  0  0  0  0  0  0  0  0; ...
        0  0  0  0  0  0  0  0  0  0; ...
        0  0  0  0  0  0  0  0  0  0] ;


ElementParameter = ArcSimulationData.ElementParameter ;

if length( ElementParameter ) ~= 21
    
    % 不用计算状态方程的系数矩阵。
    StatusEquation.A = A ;
    StatusEquation.B = B ;
    % ========================================
    
    ArcSimulationData.StatusEquation = StatusEquation ;
    
    return ;
else
    
end

% % 根据这个来计算状态方程系数。
% ArcSimulationData.ElementParameter(1).Type = '电阻' ;   % 元件类型。
% ArcSimulationData.ElementParameter(1).SpurTrackNumber = 1 ;   % 定义支路数。
% ArcSimulationData.ElementParameter(1).BeginNodeIndex = 1 ;   % 始节点序号。
% ArcSimulationData.ElementParameter(1).EndNodeIndex = 2 ;   % 终节点序号。
% ArcSimulationData.ElementParameter(1).Parameter = 0.5 ;   % 定义参数值。


ea = ElementParameter(1).Parameter ;
eb = ElementParameter(2).Parameter ;
ec = ElementParameter(3).Parameter ;

R1 = ElementParameter(4).Parameter ;
R1 = ElementParameter(5).Parameter ;
R1 = ElementParameter(6).Parameter ;

L1 = ElementParameter(7).Parameter ;
L1 = ElementParameter(8).Parameter ;
L1 = ElementParameter(9).Parameter ;

C = ElementParameter(10).Parameter ;
C = ElementParameter(11).Parameter ;
C = ElementParameter(12).Parameter ;

R21 = ElementParameter(13).Parameter ;
R22 = ElementParameter(14).Parameter ;
R21 = ElementParameter(15).Parameter ;

L21 = ElementParameter(16).Parameter ;
L22 = ElementParameter(17).Parameter ;
L21 = ElementParameter(18).Parameter ;

Ra = ElementParameter(19).Parameter ;
Rb = ElementParameter(20).Parameter ;
Rc = ElementParameter(21).Parameter ;


% 计算状态方程系数。
A(1,1)=-((2+L22/L21)*R21+(1+L22/L21)*Ra+Rc)/(2*L21+L22);
A(1,2)=((L22/L21)*R22-R21+(L22/L21)*Rb-Rc)/(2*L21+L22);
A(1,3)=0;
A(1,4)=0;
A(1,5)=(1+L22/L21)/(2*L21+L22);
A(1,6)=1/(2*L21+L22);
A(2,1)=(Ra-Rc)/(2*L21+L22);
A(2,2)=(R21+2*R22+2*Rb+Rc)/(2*L21+L22);
A(2,3)=0;
A(2,4)=0;
A(2,5)=1/(2*L21+L22);
A(2,6)=1/(2*L21+L22);
A(3,1)=0;
A(3,2)=0;
A(3,3)=-R1/L1;
A(3,4)=0;
A(3,5)=-2/(3*L1);
A(3,6)=-1/(3*L1);
A(4,1)=0;
A(4,2)=0;
A(4,3)=0;
A(4,4)=-R1/L1;
A(4,5)=1/(3*L1);
A(4,6)=-1/(3*L1);
A(5,1)=-1/(3*C);
A(5,2)=1/(3*C);
A(5,3)=1/(3*C);
A(5,4)=1/(3*C);
A(5,5)=0;
A(5,6)=0;
A(6,1)=-1/(3*C);
A(6,2)=-2/(3*C);
A(6,3)=1/(3*C);
A(6,4)=2/(3*C);
A(6,5)=0;
A(6,6)=0;

B = [...
        0 0 0 0 0 0 0 0 0 0; ...
        0 0 0 0 0 0 0 0 0 0; ...
        2/(3*L1) -1/(3*L1) -1/(3*L1) 0 0 0 0 0 0 0; ...
        1/(3*L1) -2/(3*L1) -1/(3*L1) 0 0 0 0 0 0 0; ...
        0 0 0 0 0 0 0 0 0 0;...
        0 0 0 0 0 0 0 0 0 0;...
        0 0 0 0 0 0 0 0 0 0;...
        0 0 0 0 0 0 0 0 0 0;...
        0 0 0 0 0 0 0 0 0 0;...
        0 0 0 0 0 0 0 0 0 0];


StatusEquation.A = A ;
StatusEquation.B = B ;

% ========================================


ArcSimulationData.StatusEquation = StatusEquation ;

