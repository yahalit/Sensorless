%                              & SysState.Profiler.accel, //36
%                              & SysState.Profiler.dec, //37
%                              & SysState.Profiler.vmax , //38
%                              & SysState.StepperCurrent.StaticCurrent, //39
%                              & SysState.StepperCurrent.SpeedCurrent, //40
%                              & SysState.StepperCurrent.AccelerationCurrent //41
% object 0x2225 GetFloatData

% SetSpeed: Set acceleration to speed in open loop mode, and activate sensorless estimator 

Profiler = struct('accel',0.5,'vmax',7,'StaticCurrent',14.5,'SpeedCurrent',0,'AccelerationCurrent',2) ;
Profiler.dec = Profiler.accel ;

% Set to manual mode
SendObj([hex2dec('2220'),12],RecStruct.Enums.SysModes.E_SysMotionModeManual,DataType.long,'Set system mode to manual') ;

% Set the estimator loop closure off(0) or on(1) 
SendObj([hex2dec('2223'),11],1,DataType.long,'Estimator loop closure') ;

% Program profile
SendObj([hex2dec('2225'),36],Profiler.accel,DataType.float,'Acceleration') ;
SendObj([hex2dec('2225'),37],Profiler.dec,DataType.float,'Deceleration') ;
SendObj([hex2dec('2225'),38],Profiler.vmax,DataType.float,'vmax') ;
SendObj([hex2dec('2225'),39],Profiler.StaticCurrent,DataType.float,'StaticCurrent') ;
SendObj([hex2dec('2225'),40],Profiler.SpeedCurrent,DataType.float,'SpeedCurrent') ;
SendObj([hex2dec('2225'),41],Profiler.AccelerationCurrent,DataType.float,'AccelerationCurrent') ;

% Go to speed mode 
SendObj([hex2dec('2220'),14],RecStruct.Enums.ReferenceModes.E_RefModeSpeed,DataType.long,'Set reference mode') ;
SendObj([hex2dec('2225'),43],Profiler.accel,DataType.float,'aTarget') ;
SendObj([hex2dec('2225'),42],Profiler.vmax,DataType.float,'vTarget') ;

