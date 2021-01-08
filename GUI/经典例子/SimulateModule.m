function  ArcSimulationData = SimulateModule( ArcSimulationData ) ;
% this module simulate the data .

%  February 2004
%  $Revision: 1.00 $ 




ArcSimulationResult.DataFieldName = { 'CurveData1'; 'CurveData2'; 'CurveData3'; ...
        'CurveData4'; 'CurveData5'; 'CurveData6' } ;

ArcSimulationResult.FFTDataFieldName = { 'FFTCurveData1'; 'FFTCurveData2'; 'FFTCurveData3'; ...
        'FFTCurveData4'; 'FFTCurveData5'; 'FFTCurveData6' } ;

ArcSimulationResult.DataFieldKanaName = { '�������� 1'; '�������� 2'; '�������� 3'; ...
        '�������� 4'; '��ѹ���� 1'; '��ѹ���� 2' } ;

ArcSimulationResult.XLabel = { 'ʱ��'; 'ʱ��'; 'ʱ��'; ...
        'ʱ��'; 'ʱ��'; 'ʱ��' } ;

ArcSimulationResult.YLabel = { '����ֵ'; '����ֵ'; '����ֵ'; ...
        '����ֵ'; '��ѹֵ'; '��ѹֵ' } ;

ArcSimulationResult.LineColor = { 'r'; 'b'; 'r'; ...
        'b'; 'r'; 'b' } ;



[t,x]=ode45('xp',[0,5],[0.0000001;0.0000001;0.0000001;0.0000001;0.0000001;0.0000001]);


% �õ�����Ľ����
ArcSimulationResult.CurveData1 = x(:, 1) ;
ArcSimulationResult.CurveData2 = x(:, 2) ;
ArcSimulationResult.CurveData3 = x(:, 3) ;
ArcSimulationResult.CurveData4 = x(:, 4) ;
ArcSimulationResult.CurveData5 = x(:, 5) ;
ArcSimulationResult.CurveData6 = x(:, 6) ;

% �Խ������fft����
ArcSimulationResult.FFTCurveData1 = fft( x(:, 1) ) ;
ArcSimulationResult.FFTCurveData2 = fft( x(:, 2) ) ;
ArcSimulationResult.FFTCurveData3 = fft( x(:, 3) ) ;
ArcSimulationResult.FFTCurveData4 = fft( x(:, 4) ) ;
ArcSimulationResult.FFTCurveData5 = fft( x(:, 5) ) ;
ArcSimulationResult.FFTCurveData6 = fft( x(:, 6) ) ;

% ��������
ArcSimulationData.ArcSimulationResult = ArcSimulationResult ;


if logical(0)
    xp ;
end
