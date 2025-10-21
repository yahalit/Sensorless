DefMotor = 0 ; 

SetFloatPar('SLPars.FomPars.CyclesForConvergenceApproval', 3); 
SetFloatPar('SLPars.FomPars.ObserverConvergenceToleranceFrac', 0.9); 
SetFloatPar('SLPars.FomPars.MaximumSteadyStateFieldRetard', 0.2); 
SetFloatPar('SLPars.FomPars.MinimumSteadyStateFieldRetard', -0.2); 
SetFloatPar('SLPars.FomPars.FOMTakingStartSpeed', 7); 
SetFloatPar('SLPars.FomPars.OpenLoopAcceleration', 0.5); 
SetFloatPar('SLPars.FomPars.FOMConvergenceTimeout', 10.0); 
SetFloatPar('SLPars.WorkAcceleration', 1); 
SetFloatPar('SLPars.WorkSpeed', 10); 
SetFloatPar('SLPars.FomPars.InitiallStabilizationTime', 3); 
SetFloatPar('SLPars.FomPars.OmegaCommutationLoss', 0.5); 

if DefMotor
    SetFloatPar('SLPars.PhiM', 0.13);  %#ok<UNRCH>
    SetFloatPar('SLPars.Lq0', 2.5e-3 ); 
    SetFloatPar('SLPars.LqCorner2', 0 ); 
    SetFloatPar('SLPars.Ld0', 2.5e-3 ); 
    SetFloatPar('SLPars.LdSlope', 0 ); 
    SetFloatPar('SLPars.R', 0.06 ); 
end

SetFloatPar('SysState.StepperCurrent.StaticCurrent', 14.5); 
SetFloatPar('SysState.StepperCurrent.SpeedCurrent', 0); 
SetFloatPar('SysState.StepperCurrent.AccelerationCurrent', 0); 

SetFloatPar('SLPars.KiFlux', 10); 
SetFloatPar('SLPars.KpFlux', 200); 


SendObj([hex2dec('2225'),54],1,DataType.float,'SpeedKp') ;
SendObj([hex2dec('2225'),55],20,DataType.float,'SpeedKi') ;





 