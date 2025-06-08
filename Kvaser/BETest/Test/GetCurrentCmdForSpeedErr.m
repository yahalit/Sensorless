function CurCmd = GetCurrentCmdForSpeedErr(   CurrentFF   )
global c ControlPars ClaState ClaMailIn ClaSimState SinTable SysState %#ok<*GVMIS> 

    SysState.SpeedControl.SpeedError =  SysState.SpeedControl.SpeedCommand - SysState.Encoder.UserSpeed ;
    
    SysState.SpeedControl.PIState = SysState.SpeedControl.PIState  + ...
            ControlPars.SpeedKi * ( SysState.Timing.Ts * SysState.SpeedControl.SpeedCommand - ...
                SysState.Encoder.UserPosDelta ) ; 
            
    Cand  = ControlPars.SpeedKp * SysState.SpeedControl.SpeedError + SysState.SpeedControl.PIState + CurrentFF ;
    CandR = fSat( Cand, ControlPars.MaxCurCmd * SysState.Mot.CurrentLimitFactor ) ;

    if (Cand == CandR)
        SysState.CurrentControl.bInCurrentRefLimit = 0; 
    else
        SysState.CurrentControl.bInCurrentRefLimit = 1 ; 
    end

    SysState.SpeedControl.PIState = SysState.SpeedControl.PIState + (CandR - Cand ) * ControlPars.SpeedAWU ;
    CurCmd = CandR ;
end
