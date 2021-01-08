function  ArcSimulationData = CalculateXPCoefficient( t, ArcSimulationData ) ;
% 计算状态方程。

%  February 2004
%  $Revision: 1.00 $  




% 得到主电路的参数。
MainCircuitParameter = ArcSimulationData.MainCircuitParameter ;

L21 = MainCircuitParameter.L21 ;
L22 = MainCircuitParameter.L22 ;
M1 = MainCircuitParameter.M1 ;
M2 = MainCircuitParameter.M2 ;
R21 = MainCircuitParameter.R21 ;
R22 = MainCircuitParameter.R22 ;
R1 = MainCircuitParameter.R1 ;
L1 = MainCircuitParameter.L1 ;
C = MainCircuitParameter.C ;
ea = MainCircuitParameter.ea ;
eb = MainCircuitParameter.eb ;
ec = MainCircuitParameter.ec ;


% 得到电弧电阻的参数。
ArcResistanceParameter = ArcSimulationData.ArcResistanceParameter ;

ParameterA = ArcResistanceParameter.A ;
ParameterB = ArcResistanceParameter.B ;
ParameterC = ArcResistanceParameter.C ;
ParameterD = ArcResistanceParameter.D ;
ParameterL = ArcResistanceParameter.L ;
ParameterAngle1 = ArcResistanceParameter.Angle1 ;
ParameterAngle2 = ArcResistanceParameter.Angle2 ;

% 计算电弧电阻。
RValue = ParameterC * ParameterL * exp(1/(ParameterA + ParameterB ...
    *(1-cos(2 * ParameterAngle1 * t + ParameterAngle2 + ParameterD ) ) ) ) ;
    
Ra = RValue ;
Rb = RValue ;
Rc = RValue ;



% ========================================
% 计算状态方程系数。
L21 = L21 - M2 ;
L22 = L22 - 2 * M1 + M2 ;


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
        0 0 0; ...
        0 0 0; ...
        2/(3*L1) -1/(3*L1) -1/(3*L1); ...
        1/(3*L1) -2/(3*L1) -1/(3*L1); ...
        0 0 0;0 0 0];


StatusEquation.A = A ;
StatusEquation.B = B ;

% ========================================


ArcSimulationData.StatusEquation = StatusEquation ;

