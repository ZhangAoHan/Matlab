function   ArcSimulationData = GetDefaultArcParameter ;
% init all of the parameters .

%  February 2004
%  $Revision: 1.00 $  

% define the string of the MainCircuitParameterText .
ElementType = { '电阻'; '电感'; '电容'; '电压源' } ;

% 定义第一个元件的参数。
ElementParameter(1).Type = '电压源' ;   % 元件类型。
ElementParameter(1).SpurTrackNumber = 1 ;   % 定义支路数。
ElementParameter(1).BeginNodeIndex = 1 ;   % 始节点序号。
ElementParameter(1).EndNodeIndex = 2 ;   % 终节点序号。
ElementParameter(1).Parameter = 10 ;   % 定义参数值。

% 定义第二个元件的参数。
ElementParameter(2).Type = '电压源' ;   % 元件类型。
ElementParameter(2).SpurTrackNumber = 2 ;   % 定义支路数。
ElementParameter(2).BeginNodeIndex = 1 ;   % 始节点序号。
ElementParameter(2).EndNodeIndex = 3 ;   % 终节点序号。
ElementParameter(2).Parameter = 10 ;   % 定义参数值。

% 定义第三个元件的参数。
ElementParameter(3).Type = '电压源' ;   % 元件类型。
ElementParameter(3).SpurTrackNumber = 3 ;   % 定义支路数。
ElementParameter(3).BeginNodeIndex = 1 ;   % 始节点序号。
ElementParameter(3).EndNodeIndex = 4 ;   % 终节点序号。
ElementParameter(3).Parameter = 10 ;   % 定义参数值。


% 定义第四个元件的参数。
ElementParameter(4).Type = '电阻' ;   % 元件类型。
ElementParameter(4).SpurTrackNumber = 4 ;   % 定义支路数。
ElementParameter(4).BeginNodeIndex = 2 ;   % 始节点序号。
ElementParameter(4).EndNodeIndex = 5 ;   % 终节点序号。
ElementParameter(4).Parameter = 10 ;   % 定义参数值。


% 定义第五个元件的参数。
ElementParameter(5).Type = '电阻' ;   % 元件类型。
ElementParameter(5).SpurTrackNumber = 5 ;   % 定义支路数。
ElementParameter(5).BeginNodeIndex = 3 ;   % 始节点序号。
ElementParameter(5).EndNodeIndex = 6 ;   % 终节点序号。
ElementParameter(5).Parameter = 10 ;   % 定义参数值。


% 定义第六个元件的参数。
ElementParameter(6).Type = '电阻' ;   % 元件类型。
ElementParameter(6).SpurTrackNumber = 6 ;   % 定义支路数。
ElementParameter(6).BeginNodeIndex = 4 ;   % 始节点序号。
ElementParameter(6).EndNodeIndex = 7 ;   % 终节点序号。
ElementParameter(6).Parameter = 10 ;   % 定义参数值。


% 定义第七个元件的参数。
ElementParameter(7).Type = '电感' ;   % 元件类型。
ElementParameter(7).SpurTrackNumber = 7 ;   % 定义支路数。
ElementParameter(7).BeginNodeIndex = 5 ;   % 始节点序号。
ElementParameter(7).EndNodeIndex = 8 ;   % 终节点序号。
ElementParameter(7).Parameter = 0.32 ;   % 定义参数值。


% 定义第八个元件的参数。
ElementParameter(8).Type = '电感' ;   % 元件类型。
ElementParameter(8).SpurTrackNumber = 8 ;   % 定义支路数。
ElementParameter(8).BeginNodeIndex = 6 ;   % 始节点序号。
ElementParameter(8).EndNodeIndex = 9 ;   % 终节点序号。
ElementParameter(8).Parameter = 0.32 ;   % 定义参数值。


% 定义第九个元件的参数。
ElementParameter(9).Type = '电感' ;   % 元件类型。
ElementParameter(9).SpurTrackNumber = 9 ;   % 定义支路数。
ElementParameter(9).BeginNodeIndex = 7 ;   % 始节点序号。
ElementParameter(9).EndNodeIndex = 10 ;   % 终节点序号。
ElementParameter(9).Parameter = 0.32 ;   % 定义参数值。


% 定义第十个元件的参数。
ElementParameter(10).Type = '电容' ;   % 元件类型。
ElementParameter(10).SpurTrackNumber = 10 ;   % 定义支路数。
ElementParameter(10).BeginNodeIndex = 8 ;   % 始节点序号。
ElementParameter(10).EndNodeIndex = 9 ;   % 终节点序号。
ElementParameter(10).Parameter = 2 ;   % 定义参数值。


% 定义第十一个元件的参数。
ElementParameter(11).Type = '电容' ;   % 元件类型。
ElementParameter(11).SpurTrackNumber = 11 ;   % 定义支路数。
ElementParameter(11).BeginNodeIndex = 9 ;   % 始节点序号。
ElementParameter(11).EndNodeIndex = 10 ;   % 终节点序号。
ElementParameter(11).Parameter = 2 ;   % 定义参数值。


% 定义第十二个元件的参数。
ElementParameter(12).Type = '电容' ;   % 元件类型。
ElementParameter(12).SpurTrackNumber = 12 ;   % 定义支路数。
ElementParameter(12).BeginNodeIndex = 8 ;   % 始节点序号。
ElementParameter(12).EndNodeIndex = 10 ;   % 终节点序号。
ElementParameter(12).Parameter = 2 ;   % 定义参数值。


% 定义第十三个元件的参数。
ElementParameter(13).Type = '电阻' ;   % 元件类型。
ElementParameter(13).SpurTrackNumber = 13 ;   % 定义支路数。
ElementParameter(13).BeginNodeIndex = 8 ;   % 始节点序号。
ElementParameter(13).EndNodeIndex = 11 ;   % 终节点序号。
ElementParameter(13).Parameter = 2 ;   % 定义参数值。


% 定义第十四个元件的参数。
ElementParameter(14).Type = '电阻' ;   % 元件类型。
ElementParameter(14).SpurTrackNumber = 14 ;   % 定义支路数。
ElementParameter(14).BeginNodeIndex = 9 ;   % 始节点序号。
ElementParameter(14).EndNodeIndex = 12 ;   % 终节点序号。
ElementParameter(14).Parameter = 6 ;   % 定义参数值。


% 定义第十五个元件的参数。
ElementParameter(15).Type = '电阻' ;   % 元件类型。
ElementParameter(15).SpurTrackNumber = 15 ;   % 定义支路数。
ElementParameter(15).BeginNodeIndex = 10 ;   % 始节点序号。
ElementParameter(15).EndNodeIndex = 13 ;   % 终节点序号。
ElementParameter(15).Parameter = 2 ;   % 定义参数值。


% 定义第十六个元件的参数。
ElementParameter(16).Type = '电感' ;   % 元件类型。
ElementParameter(16).SpurTrackNumber = 16 ;   % 定义支路数。
ElementParameter(16).BeginNodeIndex = 11 ;   % 始节点序号。
ElementParameter(16).EndNodeIndex = 14 ;   % 终节点序号。
ElementParameter(16).Parameter = 0.1 ;   % 定义参数值。


% 定义第十七个元件的参数。
ElementParameter(17).Type = '电感' ;   % 元件类型。
ElementParameter(17).SpurTrackNumber = 17 ;   % 定义支路数。
ElementParameter(17).BeginNodeIndex = 12 ;   % 始节点序号。
ElementParameter(17).EndNodeIndex = 15 ;   % 终节点序号。
ElementParameter(17).Parameter = 0.22 ;   % 定义参数值。


% 定义第十八个元件的参数。
ElementParameter(18).Type = '电感' ;   % 元件类型。
ElementParameter(18).SpurTrackNumber = 18 ;   % 定义支路数。
ElementParameter(18).BeginNodeIndex = 13 ;   % 始节点序号。
ElementParameter(18).EndNodeIndex = 16 ;   % 终节点序号。
ElementParameter(18).Parameter = 0.1 ;   % 定义参数值。


% 定义第十九个元件的参数。
ElementParameter(19).Type = '电阻' ;   % 元件类型。
ElementParameter(19).SpurTrackNumber = 19 ;   % 定义支路数。
ElementParameter(19).BeginNodeIndex = 14 ;   % 始节点序号。
ElementParameter(19).EndNodeIndex = 17 ;   % 终节点序号。
ElementParameter(19).Parameter = 0.26 ;   % 定义参数值。


% 定义第二十个元件的参数。
ElementParameter(20).Type = '电阻' ;   % 元件类型。
ElementParameter(20).SpurTrackNumber = 20 ;   % 定义支路数。
ElementParameter(20).BeginNodeIndex = 15 ;   % 始节点序号。
ElementParameter(20).EndNodeIndex = 17 ;   % 终节点序号。
ElementParameter(20).Parameter = 0.26 ;   % 定义参数值。


% 定义第二十一个元件的参数。
ElementParameter(21).Type = '电阻' ;   % 元件类型。
ElementParameter(21).SpurTrackNumber = 21 ;   % 定义支路数。
ElementParameter(21).BeginNodeIndex = 16 ;   % 始节点序号。
ElementParameter(21).EndNodeIndex = 17 ;   % 终节点序号。
ElementParameter(21).Parameter = 0.26 ;   % 定义参数值。


% % 初始化主电路的状态方程的元器件参数。
% ArcSimulationData.ElementParameter = ElementParameter ;
ArcSimulationData.ElementParameter = ElementParameter(1) ;


% define the string of the MainCircuitParameterText .
% ==============================================================
Text1String = { 'L21'; 'L22'; 'M1'; 'M2'; 'R21'; 'R22'; ...
        'R1'; 'L1'; 'C'; 'ea'; 'eb'; 'ec' } ;

MainCircuitParameter.L21 = 0.1 ;
MainCircuitParameter.L22 = 0.22 ;
MainCircuitParameter.M1 = 0.3 ;
MainCircuitParameter.M2 = 0.2 ;
MainCircuitParameter.R21 = 2 ;
MainCircuitParameter.R22 = 6 ;
MainCircuitParameter.R1 = 10 ;
MainCircuitParameter.L1 = 0.32 ;
MainCircuitParameter.C = 2 ;
MainCircuitParameter.ea = 10 ;
MainCircuitParameter.eb = 10 ;
MainCircuitParameter.ec = 10 ;

ArcSimulationData.MainCircuitParameter = MainCircuitParameter ;


% define the string of the ArcResistanceParameterText .
% ==============================================================
Text2String = { 'A'; 'B'; 'C'; 'D'; 'L'; 'ω'; 'θ' } ;


ArcResistanceParameter.A = 0.23 ;
ArcResistanceParameter.B = 0.15 ;
ArcResistanceParameter.C = 0.12 ;
ArcResistanceParameter.D = 0 ;
ArcResistanceParameter.L = 0.1 ;
ArcResistanceParameter.Angle1 = 2 ;
ArcResistanceParameter.Angle2 = 0.75 ;

ArcSimulationData.ArcResistanceParameter = ArcResistanceParameter ;

% % 初始化状态方程系数。
% ==============================================================

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

StatusEquation.A = A ;
StatusEquation.B = B ;

ArcSimulationData.StatusEquation = StatusEquation ;

