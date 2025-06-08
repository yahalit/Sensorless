% fname = 'AboveFiveM' ; 
% fname = 'Regev15' ; 
% fname = 'Regev1_11.5kg_no2' ; 
%fname = 'Regev1_11.5kg' ; 
fname = 'Regev1' ; 

x = load([fname,'.mat']) ;

r = x.r;
t = r.t ; 
CalcGeomData; 
r.RSwAnalog = r.fDebug0 ; 
r.LSwAnalog = r.fDebug1 ;

statf = fix( r.lDebug4 + 2^32 ) ;
%         usl.us[0] =  (RLimitSwRegs.PresentValue > 0 ? 1 :0 ) +  ( RLimitSwRegs.RiseMarker > 0 ? 2 :0  ) + ( RLimitSwRegs.FallMarker > 0 ? 4 : 0 ) +
%             (( (short)ClaState.RLimit.SwitchRequestDir & 3) <<3 )  + ( (ClaState.LLimit.SwitchDetectMarker ? 1 :0 ) << 5 )  +
%             ( (SysState.CBit.bit.QueueAborted ? 1 :0 ) << 7 ) + ( (ManRouteCmd.ShelfSubMode & 0xf ) << 8 ) +  (( ClaState.RLimit.SwitchDetectValid & 0xf ) << 12 );
%         usl.us[1] =  (LLimitSwRegs.PresentValue > 0 ? 1 :0 ) +  ( LLimitSwRegs.RiseMarker > 0 ? 2 :0 ) + ( LLimitSwRegs.FallMarker > 0 ? 4 : 0 ) +
%             (( (short)ClaState.LLimit.SwitchRequestDir & 3) <<3 )  + ( (ClaState.LLimit.SwitchDetectMarker ? 1 :0 ) << 5 )  +
%             (( SysState.PoleRun.TargetArmDone & 0x7 ) << 7 ) + ((SysState.ManRouteState.GoDirection & 3 ) << 10) + (( ClaState.LLimit.SwitchDetectValid & 0xf ) << 12 );

st = bitand ( statf ,65535 ) ;  
d = bitget( st , 4) + bitget( st , 5) * 2  ; 
v = bitextract(st , 15, 12 );
d( d== 3) = -1 ; 
r.rstat = struct('Value',bitget(st,1),'Rise', bitget(st,2),'Fall', bitget(st,3),'Dir',d,'Rqst',bitget(st,6),'Valid',v) ; 
r.mstat = struct('Abort',bitget(st,8),'ShelfSubMode',bitget(st,9)+2*bitget(st,10)+4*bitget(st,11)+8*bitget(st,12)) ; 

r.Aborted = bitget(st,8);
% r.ShelfSubMode = bitand(st,2^8*31) /2^8  ;   
st = bitand ( (statf - st)/2^16,65535 ) ;  
v = bitextract(st , 15, 12 );
r.lstat = struct('Value',bitget(st,1),'Rise', bitget(st,2),'Fall', bitget(st,3),'Dir',d,'Rqst',bitget(st,6),'Valid',v) ; 
r.mstat.TargetArmDone = bitget(st,8)+2*bitget(st,9)+4*bitget(st,10);
r.mstat.GoDirection  = bitget(st,11)+2*bitget(st,12);


% figure(30) ; clf 
% plot( r.t, r.rstat.Value , r.t , r.rstat.Rise ,'+'  , r.t ,  r.rstat.Fall ,'-') ; legend('Sw value','Rise','Fall') ;
% xlabel('Right switch') ; 
% set( gca , 'ylim' , [-0.2, 1.2 ]) 

whm = Geom.Calc.WheelEncoder2MeterShelf * r.RWheelEncPos ; 
rwm = whm ;
figure(31) ; clf 
plot( whm, r.rstat.Value , whm , r.rstat.Rise ,'+'  , whm ,  r.rstat.Fall ,'-',... 
    whm , 0.5 * r.RSwAnalog / mean(r.RSwAnalog)) ; 
legend('Sw value','Rise','Fall','Analog') ;
xlabel('Right wheel Pole travel, meters') ; 
% xlabel('Left switch') ; 

set( gca , 'ylim' , [-0.2, 1.2 ]) 

whm = Geom.Calc.WheelEncoder2MeterShelf * r.LWheelEncPos ; 
lwm = whm ;
figure(32) ; clf 
plot( whm, r.lstat.Value , whm , r.lstat.Rise ,'+'  , whm ,  r.lstat.Fall ,'-',...
    whm , 0.5 * r.LSwAnalog / mean(r.LSwAnalog) ) ; 
legend('Sw value','Rise','Fall','Analog') ;
xlabel('Left wheel Pole travel, meters') ; 
set( gca , 'ylim' , [-0.2, 1.2 ]) 

try
fac = Geom.Calc.WheelEncoder2MeterShelf ; 
figure(40) ; clf 
subplot( 2,1,1) ; 
plot( t , (r.WheelEncoderTarget0 - r.WheelEncoderTarget0(1)  ) * fac , t, ( r.RWheelEncPos -  r.WheelEncoderTarget0(1) )  * fac  ) ; legend('right target','pos')
subplot( 2,1,2) ; 
plot( t , (r.WheelEncoderTarget1 - r.WheelEncoderTarget1(1)) * fac , t, (r.LWheelEncPos -  r.WheelEncoderTarget1(1) ) * fac ) ; legend('left target','pos')
xlabel('Time,sec') 
catch 
figure(40) ; clf 
subplot( 2,1,1) ; 
plot( t, r.RWheelEncPos ) ; legend('right pos')
subplot( 2,1,2) ; 
plot( t, r.LWheelEncPos ) ; legend('left pos')
end

lm = Geom.Calc.MotEncoder2MeterShelf * unwrap( r.LWheelDriveEnc * 2 * pi / 262144 ) * 262144 / 2 / pi ; 
lm = lm - lm(1) ; 
figure(41) ; 
subplot( 2,1,1) ; 
plot( t , lm , t ,  (r.LWheelEncPos -  r.LWheelEncPos(1) ) * fac); legend('Mot','Encoder') ; 
subplot( 2,1,2) ; 
plot( t , lm -   (r.LWheelEncPos -  r.LWheelEncPos(1) ) * fac);

figure(100) ; clf 
subplot(2,1,1);
plot( t , r.RwCurrent , t , r.LwCurrent) ; legend( 'r','L')

subplot(2,1,2);
plot( t , r.RwCurrent +  r.LwCurrent) ; legend( 'sum')

