function InitControlParams()
global c ClaControlPars ClaState ClaMailIn ClaSimState SinTable SysState ControlPars HallDecode Commutation %#ok<*GVMIS> 
SetEnums ;

%    InitOverCurrentTholds();
    ControlPars.SpeedAWU = ControlPars.SpeedKi * SysState.Timing.Ts /  ...
            ( ControlPars.SpeedKp + ControlPars.SpeedKi * SysState.Timing.Ts ) ;  

    ClaControlPars.OneOverPP = 1.0 / max( ClaControlPars.nPolePairs, 1.0) ;
    ClaControlPars.Bit2Amp = ControlPars.FullAdcRangeCurrent * (1.0/2048.0) ;
    ClaControlPars.Amp2Bit = 1.0 /max( ClaControlPars.Bit2Amp, 1.e-7) ;
    ControlPars.Pos2Rev = 1.0 / max( ControlPars.Rev2Pos , 1e-8) ;

    ClaMailIn.SimdT = SysState.Timing.Ts ;

    ControlPars.I2tPoleS = 1.0 - iexp2( SysState.Timing.Ts * 256 * Log2OfE / max( 0.0001 , ControlPars.I2tCurTime ) );
    ControlPars.SpeedFilterCst = 1.0 - iexp2( SysState.Timing.Ts * Log2OfE * 6.283185307179586 * ControlPars.SpeedFilterBWHz  );

    fTemp = min( ControlPars.I2tCurLevel , ControlPars.FullAdcRangeCurrent * 0.95) ;
    ControlPars.I2tCurThold = fTemp * fTemp  ;

    Commutation.EncoderCountsFullRev = ControlPars.EncoderCountsFullRev ;
    ControlPars.InvEncoderCountsFullRev = 1.0 / max( ControlPars.EncoderCountsFullRev, 1) ;
    Commutation.Encoder2CommAngle = ClaControlPars.nPolePairs * ControlPars.InvEncoderCountsFullRev  ;

    SysState.Timing.OneOverTsTraj = 1.0 / SysState.Timing.TsTraj ; 
    
    SysState.MCanSupport.OneOverNomMessageTime = 1 / SysState.MCanSupport.NomInterMessageTime ;
    SysState.MCanSupport.OneOverActMessageTime = SysState.MCanSupport.OneOverNomMessageTime ;
    SysState.MCanSupport.InterMessageTime = SysState.MCanSupport.NomInterMessageTime ;

end 