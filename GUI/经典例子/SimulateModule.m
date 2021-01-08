function  ArcSimulationData = SimulateModule( ArcSimulationData ) ;
% this module simulate the data .

%  February 2004
%  $Revision: 1.00 $ 




ArcSimulationResult.DataFieldName = { 'CurveData1'; 'CurveData2'; 'CurveData3'; ...
        'CurveData4'; 'CurveData5'; 'CurveData6' } ;

ArcSimulationResult.FFTDataFieldName = { 'FFTCurveData1'; 'FFTCurveData2'; 'FFTCurveData3'; ...
        'FFTCurveData4'; 'FFTCurveData5'; 'FFTCurveData6' } ;

ArcSimulationResult.DataFieldKanaName = { '电流曲线 1'; '电流曲线 2'; '电流曲线 3'; ...
        '电流曲线 4'; '电压曲线 1'; '电压曲线 2' } ;

ArcSimulationResult.XLabel = { '时间'; '时间'; '时间'; ...
        '时间'; '时间'; '时间' } ;

ArcSimulationResult.YLabel = { '电流值'; '电流值'; '电流值'; ...
        '电流值'; '电压值'; '电压值' } ;

ArcSimulationResult.LineColor = { 'r'; 'b'; 'r'; ...
        'b'; 'r'; 'b' } ;



[t,x]=ode45('xp',[0,5],[0.0000001;0.0000001;0.0000001;0.0000001;0.0000001;0.0000001]);


% 得到计算的结果。
ArcSimulationResult.CurveData1 = x(:, 1) ;
ArcSimulationResult.CurveData2 = x(:, 2) ;
ArcSimulationResult.CurveData3 = x(:, 3) ;
ArcSimulationResult.CurveData4 = x(:, 4) ;
ArcSimulationResult.CurveData5 = x(:, 5) ;
ArcSimulationResult.CurveData6 = x(:, 6) ;

% 对结果进行fft处理。
ArcSimulationResult.FFTCurveData1 = fft( x(:, 1) ) ;
ArcSimulationResult.FFTCurveData2 = fft( x(:, 2) ) ;
ArcSimulationResult.FFTCurveData3 = fft( x(:, 3) ) ;
ArcSimulationResult.FFTCurveData4 = fft( x(:, 4) ) ;
ArcSimulationResult.FFTCurveData5 = fft( x(:, 5) ) ;
ArcSimulationResult.FFTCurveData6 = fft( x(:, 6) ) ;

% 保存结果。
ArcSimulationData.ArcSimulationResult = ArcSimulationResult ;


if logical(0)
    xp ;
end
