function   ArcSimulationData = GetDefaultArcParameter ;
% init all of the parameters .

%  February 2004
%  $Revision: 1.00 $  

% define the string of the MainCircuitParameterText .
ElementType = { '����'; '���'; '����'; '��ѹԴ' } ;

% �����һ��Ԫ���Ĳ�����
ElementParameter(1).Type = '��ѹԴ' ;   % Ԫ�����͡�
ElementParameter(1).SpurTrackNumber = 1 ;   % ����֧·����
ElementParameter(1).BeginNodeIndex = 1 ;   % ʼ�ڵ���š�
ElementParameter(1).EndNodeIndex = 2 ;   % �սڵ���š�
ElementParameter(1).Parameter = 10 ;   % �������ֵ��

% ����ڶ���Ԫ���Ĳ�����
ElementParameter(2).Type = '��ѹԴ' ;   % Ԫ�����͡�
ElementParameter(2).SpurTrackNumber = 2 ;   % ����֧·����
ElementParameter(2).BeginNodeIndex = 1 ;   % ʼ�ڵ���š�
ElementParameter(2).EndNodeIndex = 3 ;   % �սڵ���š�
ElementParameter(2).Parameter = 10 ;   % �������ֵ��

% ���������Ԫ���Ĳ�����
ElementParameter(3).Type = '��ѹԴ' ;   % Ԫ�����͡�
ElementParameter(3).SpurTrackNumber = 3 ;   % ����֧·����
ElementParameter(3).BeginNodeIndex = 1 ;   % ʼ�ڵ���š�
ElementParameter(3).EndNodeIndex = 4 ;   % �սڵ���š�
ElementParameter(3).Parameter = 10 ;   % �������ֵ��


% ������ĸ�Ԫ���Ĳ�����
ElementParameter(4).Type = '����' ;   % Ԫ�����͡�
ElementParameter(4).SpurTrackNumber = 4 ;   % ����֧·����
ElementParameter(4).BeginNodeIndex = 2 ;   % ʼ�ڵ���š�
ElementParameter(4).EndNodeIndex = 5 ;   % �սڵ���š�
ElementParameter(4).Parameter = 10 ;   % �������ֵ��


% ��������Ԫ���Ĳ�����
ElementParameter(5).Type = '����' ;   % Ԫ�����͡�
ElementParameter(5).SpurTrackNumber = 5 ;   % ����֧·����
ElementParameter(5).BeginNodeIndex = 3 ;   % ʼ�ڵ���š�
ElementParameter(5).EndNodeIndex = 6 ;   % �սڵ���š�
ElementParameter(5).Parameter = 10 ;   % �������ֵ��


% ���������Ԫ���Ĳ�����
ElementParameter(6).Type = '����' ;   % Ԫ�����͡�
ElementParameter(6).SpurTrackNumber = 6 ;   % ����֧·����
ElementParameter(6).BeginNodeIndex = 4 ;   % ʼ�ڵ���š�
ElementParameter(6).EndNodeIndex = 7 ;   % �սڵ���š�
ElementParameter(6).Parameter = 10 ;   % �������ֵ��


% ������߸�Ԫ���Ĳ�����
ElementParameter(7).Type = '���' ;   % Ԫ�����͡�
ElementParameter(7).SpurTrackNumber = 7 ;   % ����֧·����
ElementParameter(7).BeginNodeIndex = 5 ;   % ʼ�ڵ���š�
ElementParameter(7).EndNodeIndex = 8 ;   % �սڵ���š�
ElementParameter(7).Parameter = 0.32 ;   % �������ֵ��


% ����ڰ˸�Ԫ���Ĳ�����
ElementParameter(8).Type = '���' ;   % Ԫ�����͡�
ElementParameter(8).SpurTrackNumber = 8 ;   % ����֧·����
ElementParameter(8).BeginNodeIndex = 6 ;   % ʼ�ڵ���š�
ElementParameter(8).EndNodeIndex = 9 ;   % �սڵ���š�
ElementParameter(8).Parameter = 0.32 ;   % �������ֵ��


% ����ھŸ�Ԫ���Ĳ�����
ElementParameter(9).Type = '���' ;   % Ԫ�����͡�
ElementParameter(9).SpurTrackNumber = 9 ;   % ����֧·����
ElementParameter(9).BeginNodeIndex = 7 ;   % ʼ�ڵ���š�
ElementParameter(9).EndNodeIndex = 10 ;   % �սڵ���š�
ElementParameter(9).Parameter = 0.32 ;   % �������ֵ��


% �����ʮ��Ԫ���Ĳ�����
ElementParameter(10).Type = '����' ;   % Ԫ�����͡�
ElementParameter(10).SpurTrackNumber = 10 ;   % ����֧·����
ElementParameter(10).BeginNodeIndex = 8 ;   % ʼ�ڵ���š�
ElementParameter(10).EndNodeIndex = 9 ;   % �սڵ���š�
ElementParameter(10).Parameter = 2 ;   % �������ֵ��


% �����ʮһ��Ԫ���Ĳ�����
ElementParameter(11).Type = '����' ;   % Ԫ�����͡�
ElementParameter(11).SpurTrackNumber = 11 ;   % ����֧·����
ElementParameter(11).BeginNodeIndex = 9 ;   % ʼ�ڵ���š�
ElementParameter(11).EndNodeIndex = 10 ;   % �սڵ���š�
ElementParameter(11).Parameter = 2 ;   % �������ֵ��


% �����ʮ����Ԫ���Ĳ�����
ElementParameter(12).Type = '����' ;   % Ԫ�����͡�
ElementParameter(12).SpurTrackNumber = 12 ;   % ����֧·����
ElementParameter(12).BeginNodeIndex = 8 ;   % ʼ�ڵ���š�
ElementParameter(12).EndNodeIndex = 10 ;   % �սڵ���š�
ElementParameter(12).Parameter = 2 ;   % �������ֵ��


% �����ʮ����Ԫ���Ĳ�����
ElementParameter(13).Type = '����' ;   % Ԫ�����͡�
ElementParameter(13).SpurTrackNumber = 13 ;   % ����֧·����
ElementParameter(13).BeginNodeIndex = 8 ;   % ʼ�ڵ���š�
ElementParameter(13).EndNodeIndex = 11 ;   % �սڵ���š�
ElementParameter(13).Parameter = 2 ;   % �������ֵ��


% �����ʮ�ĸ�Ԫ���Ĳ�����
ElementParameter(14).Type = '����' ;   % Ԫ�����͡�
ElementParameter(14).SpurTrackNumber = 14 ;   % ����֧·����
ElementParameter(14).BeginNodeIndex = 9 ;   % ʼ�ڵ���š�
ElementParameter(14).EndNodeIndex = 12 ;   % �սڵ���š�
ElementParameter(14).Parameter = 6 ;   % �������ֵ��


% �����ʮ���Ԫ���Ĳ�����
ElementParameter(15).Type = '����' ;   % Ԫ�����͡�
ElementParameter(15).SpurTrackNumber = 15 ;   % ����֧·����
ElementParameter(15).BeginNodeIndex = 10 ;   % ʼ�ڵ���š�
ElementParameter(15).EndNodeIndex = 13 ;   % �սڵ���š�
ElementParameter(15).Parameter = 2 ;   % �������ֵ��


% �����ʮ����Ԫ���Ĳ�����
ElementParameter(16).Type = '���' ;   % Ԫ�����͡�
ElementParameter(16).SpurTrackNumber = 16 ;   % ����֧·����
ElementParameter(16).BeginNodeIndex = 11 ;   % ʼ�ڵ���š�
ElementParameter(16).EndNodeIndex = 14 ;   % �սڵ���š�
ElementParameter(16).Parameter = 0.1 ;   % �������ֵ��


% �����ʮ�߸�Ԫ���Ĳ�����
ElementParameter(17).Type = '���' ;   % Ԫ�����͡�
ElementParameter(17).SpurTrackNumber = 17 ;   % ����֧·����
ElementParameter(17).BeginNodeIndex = 12 ;   % ʼ�ڵ���š�
ElementParameter(17).EndNodeIndex = 15 ;   % �սڵ���š�
ElementParameter(17).Parameter = 0.22 ;   % �������ֵ��


% �����ʮ�˸�Ԫ���Ĳ�����
ElementParameter(18).Type = '���' ;   % Ԫ�����͡�
ElementParameter(18).SpurTrackNumber = 18 ;   % ����֧·����
ElementParameter(18).BeginNodeIndex = 13 ;   % ʼ�ڵ���š�
ElementParameter(18).EndNodeIndex = 16 ;   % �սڵ���š�
ElementParameter(18).Parameter = 0.1 ;   % �������ֵ��


% �����ʮ�Ÿ�Ԫ���Ĳ�����
ElementParameter(19).Type = '����' ;   % Ԫ�����͡�
ElementParameter(19).SpurTrackNumber = 19 ;   % ����֧·����
ElementParameter(19).BeginNodeIndex = 14 ;   % ʼ�ڵ���š�
ElementParameter(19).EndNodeIndex = 17 ;   % �սڵ���š�
ElementParameter(19).Parameter = 0.26 ;   % �������ֵ��


% ����ڶ�ʮ��Ԫ���Ĳ�����
ElementParameter(20).Type = '����' ;   % Ԫ�����͡�
ElementParameter(20).SpurTrackNumber = 20 ;   % ����֧·����
ElementParameter(20).BeginNodeIndex = 15 ;   % ʼ�ڵ���š�
ElementParameter(20).EndNodeIndex = 17 ;   % �սڵ���š�
ElementParameter(20).Parameter = 0.26 ;   % �������ֵ��


% ����ڶ�ʮһ��Ԫ���Ĳ�����
ElementParameter(21).Type = '����' ;   % Ԫ�����͡�
ElementParameter(21).SpurTrackNumber = 21 ;   % ����֧·����
ElementParameter(21).BeginNodeIndex = 16 ;   % ʼ�ڵ���š�
ElementParameter(21).EndNodeIndex = 17 ;   % �սڵ���š�
ElementParameter(21).Parameter = 0.26 ;   % �������ֵ��


% % ��ʼ������·��״̬���̵�Ԫ����������
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
Text2String = { 'A'; 'B'; 'C'; 'D'; 'L'; '��'; '��' } ;


ArcResistanceParameter.A = 0.23 ;
ArcResistanceParameter.B = 0.15 ;
ArcResistanceParameter.C = 0.12 ;
ArcResistanceParameter.D = 0 ;
ArcResistanceParameter.L = 0.1 ;
ArcResistanceParameter.Angle1 = 2 ;
ArcResistanceParameter.Angle2 = 0.75 ;

ArcSimulationData.ArcResistanceParameter = ArcResistanceParameter ;

% % ��ʼ��״̬����ϵ����
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

