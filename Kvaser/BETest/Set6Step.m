SixStep = 1 ; DisableBldc = 1; 
% SetSpeed: Set acceleration to speed in open loop mode, and activate sensorless estimator 
SendObj([hex2dec('2225'),64],SixStep,DataType.float,'SixStep mode') ;
SendObj([hex2dec('2223'),12],DisableBldc,DataType.long,'DisableBldc') ;


SetFloatPar('SysState.StepperCurrent.StaticCurrent',14) ; 
SetFloatPar('SysState.StepperCurrent.SpeedCurrent',0) ; 
SetFloatPar('SysState.StepperCurrent.AccelerationCurrent',0) ; 
