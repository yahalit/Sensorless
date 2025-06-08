function InitPVT()
global c ClaControlPars ClaState ClaMailIn ClaSimState SinTable SysState ControlPars %#ok<*GVMIS> 

    SysState.PVT.TsCont = SysState.Timing.Ts;
    SysState.PVT.VrFac = 1 ;
    SysState.PVT.dT =  SysState.Timing.Ts;  
    SysState.PVT.x0 = 0.5 ;
    SysState.PVT.vFixed = 1 ;
    SysState.PVT.CycleFac = 1;
    SysState.PVT.bFixedSpeed = 1;
end