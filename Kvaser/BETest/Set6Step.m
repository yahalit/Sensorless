SixStep = 1 ; DisableBldc = 0; 
% SetSpeed: Set acceleration to speed in open loop mode, and activate sensorless estimator 
SendObj([hex2dec('2225'),64],SixStep,DataType.float,'SixStep mode') ;
SendObj([hex2dec('2225'),48],20,DataType.float,'SLPars.FomPars.FOMTakingStartSpeed') ;
SendObj([hex2dec('2225'),53],25,DataType.float,'SLPars.WorkSpeed') ;
SendObj([hex2dec('2223'),12],DisableBldc,DataType.long,'DisableBldc') ;
SendObj([hex2dec('2225'),57],4,DataType.float,'SLPars.FomPars.InitiallStabilizationTime') ;
SetFloatPar('SLPars.Pars6Step.OpenLoopCurDiDtMax',10) ; 
SetFloatPar('SLPars.Pars6Step.JOverKT',0.02) ;  
SetFloatPar('SLPars.FomPars.CyclesForConvergenceApproval',10 ) ; 

SetFloatPar('SysState.StepperCurrent.StaticCurrent',16) ; 
SetFloatPar('SysState.StepperCurrent.SpeedCurrent',0) ; 
SetFloatPar('SysState.StepperCurrent.AccelerationCurrent',0) ; 
