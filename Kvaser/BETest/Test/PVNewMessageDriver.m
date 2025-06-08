function PVNewMessageDriver(  PosRef  )
global c ControlPars SysState %#ok<*GVMIS> 
   % The toutUsec is the end of the (before) previous segment, which is one Ts before now as we accept the new message
    SysState.PVT.ReadyMsgUsec   = SysState.MCanSupport.Usec4ThisMessage ;
    SysState.PVT.ReadyMsgPosRef = PosRef ;
    SysState.PVT.NewMsgReady = 1 ;
end
