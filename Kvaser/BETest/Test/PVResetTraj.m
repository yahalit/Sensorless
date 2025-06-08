function PVResetTraj()
global c ClaControlPars ClaState ClaMailIn ClaSimState SinTable SysState ControlPars %#ok<*GVMIS> 

    SysState.PVT.bFixedSpeed = 1;
    SysState.PVT.vFixed = SysState.Encoder.UserSpeed ;
    SysState.PVT.x0 = 0 ;
    SysState.PVT.a = 0 ;
    SysState.PVT.vout = SysState.Encoder.UserSpeed ;
    SysState.PVT.pout = SysState.Encoder.UserPos ;
    SysState.PVT.dv = 0 ;
    SysState.PVT.dp = SysState.PVT.dv * SysState.Timing.TsTraj ;
    SysState.PVT.Init = 0 ;
    SysState.PVT.NewMsgReady = 0 ;
end
