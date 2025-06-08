function Done = StayInPlaceDriver()

global c ClaControlPars ClaState ClaMailIn ClaSimState SinTable SysState ControlPars %#ok<*NUSED,*GVMIS> 

    v = SysState.SpeedControl.SpeedReference ;
    SysState.SpeedControl.SpeedReference = SysState.SpeedControl.SpeedReference - sign(SysState.SpeedControl.SpeedReference) * ControlPars.MaxAcc * SysState.Timing.TsTraj ; 
    SysState.PosControl.PosReference = SysState.PosControl.PosReference + (v+SysState.SpeedControl.SpeedReference) * 0.5 * SysState.Timing.TsTraj ;
    Done = 1 ;
end

