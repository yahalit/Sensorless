yy = load('uuu.mat') ; 
r = yy.r ; 
t = r.t ; 
Ts = r.Ts ;


r.RCaptEncoderH = r.lDebug0 ;
r.RCaptEncoderL = r.lDebug1 ;
r.LCaptEncoderH = r.lDebug2 ;
r.LCaptEncoderL = r.lDebug3 ;
r.RSwAnalog = r.fDebug0 ; 
r.LSwAnalog = r.fDebug1 ;
r.RSWidthN = r.fDebug2 ; 
r.LSWidthN = r.fDebug3 ;

statf = fix( r.lDebug4 + 2^32 ) ;
%         usl.us[0] =  RLimitSwRegs.PresentValue +  ( RLimitSwRegs.RiseMarker << 1 ) + ( RLimitSwRegs.FallMarker << 2 ) +
%             (( RLimitSwRegs.ExpectedDir & 3) <<3 )  + ( (ClaState.RLimit.SwitchRequest ? 1 :0 ) << 5 )  + ( (ClaState.RLimit.SwitchDetectValid ? 1 :0 ) << 6 ) +
%             ( (SysState.CBit.bit.QueueAborted ? 1 :0 ) << 7 ) + ( ManRouteCmd.ShelfSubMode  << 8 ) ;
%         usl.us[1] =  LLimitSwRegs.PresentValue +  ( LLimitSwRegs.RiseMarker << 1 ) + ( LLimitSwRegs.FallMarker << 2 ) +
%             (( LLimitSwRegs.ExpectedDir & 3) <<3 )  + ( (ClaState.LLimit.SwitchRequest ? 1 :0 ) << 5 )  + ( (ClaState.LLimit.SwitchDetectValid ? 1 :0 ) << 6 ) ;

st = bitand ( statf ,65535 ) ;  
d = bitget( st , 4) + bitget( st , 5) * 2  ; 
d( d== 3) = -1 ; 
r.rstat = struct('Value',bitget(st,1),'Rise', bitget(st,2),'Fall', bitget(st,3),'Dir',d,'Rqst',bitget(st,6),'Valid',bitget(st,7)) ; 
r.mstat = struct('Abort',bitget(st,8),'ShelfSubMode',bitget(st,9)+2*bitget(st,10)+4*bitget(st,11)+8*bitget(st,12)) ; 

r.Aborted = bitget(st,8);
% r.ShelfSubMode = bitand(st,2^8*31) /2^8  ;   
st = bitand ( (statf - st)/2^16,65535 ) ;  
r.lstat = struct('Value',bitget(st,1),'Rise', bitget(st,2),'Fall', bitget(st,3),'Dir',d,'Rqst',bitget(st,6),'Valid',bitget(st,7)) ; 
r.mstat.TargetArmDone = bitget(st,8)+2*bitget(st,9)+4*bitget(st,10);
r.mstat.GoDirection  = bitget(st,11)+2*bitget(st,12);
figure(20) ; clf 
plot( t , r.RightWheelEncoder,t , r.LeftWheelEncoder) ; 
figure(2) ; clf 
plot( t , r.rstat.Value ,t , r.lstat.Value ) ; 
figure(3) ; clf 
plot( t , r.mstat.GoDirection  ) ; 

