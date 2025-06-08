% Analize the recording of the limit switches 
CalcGeomData;
% Debug - program recording of LSW vars 
global DataType
SendObj( [hex2dec('2222'),2] , 1 , DataType.long , 'Debug mode = lsw' ) ;

RecTime = 12; 


RecStruct.Sync2C = 1 ; 
RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 


RecNames = {'lDebug0','lDebug1','lDebug2','lDebug3','lDebug4','fDebug0','fDebug1','fDebug2','fDebug3',...
    'RightWheelEncoder','LeftWheelEncoder','ShelfMode','WheelProfile0Speed','WheelProfile0Pos','WheelProfile1Pos'} ;
% RecNames = {'lDebug0','lDebug1','lDebug2','lDebug3','lDebug4','fDebug0','fDebug1',...
%     'RightWheelEncoder','LeftWheelEncoder','ShelfMode','WheelProfile0Speed','WheelProfile0Pos','WheelProfile1Pos'} ;

L_RecStruct = RecStruct ;
L_RecStruct.BlockUpLoad = 0 ; 
[~,L_RecStruct] = Recorder(RecNames , L_RecStruct , RecInitAction   );

disp(['Wait recording time, Sec:  ',num2str(RecTime) ]) ; 
pause(RecTime) ; 
[~,~,r] = Recorder(RecNames , L_RecStruct , RecBringAction   );
save('AnaSwitchRecord.mat','r' ) ; 
t = r.t ; 
Ts = r.Ts ;


r.RCaptEncoderH = r.lDebug0 ;
r.RCaptEncoderL = r.lDebug1 ;
r.LCaptEncoderH = r.lDebug2 ;
r.LCaptEncoderL = r.lDebug3 ;
r.RSwAnalog = r.fDebug0 ; 
r.LSwAnalog = r.fDebug1 ;
% r.RSWidthN = r.fDebug2 ; 
% r.LSWidthN = r.fDebug3 ;

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


figure(30) ; clf 
plot( r.t, r.rstat.Value , r.t , r.rstat.Rise ,'+'  , r.t ,  r.rstat.Fall ,'-') ; legend('Sw value','Rise','Fall') ;
set( gca , 'ylim' , [-0.2, 1.2 ]) 

whm = Geom.Calc.WheelEncoder2MeterShelf * r.RightWheelEncoder ; 
rwm = whm ;
figure(31) ; clf 
plot( whm, r.rstat.Value , whm , r.rstat.Rise ,'+'  , whm ,  r.rstat.Fall ,'-') ; legend('Sw value','Rise','Fall') ;
xlabel('Right wheel Pole travel, meters') ; 
set( gca , 'ylim' , [-0.2, 1.2 ]) 

whm = Geom.Calc.WheelEncoder2MeterShelf * r.LeftWheelEncoder ; 
lwm = whm ;
figure(32) ; clf 
plot( whm, r.lstat.Value , whm , r.lstat.Rise ,'+'  , whm ,  r.lstat.Fall ,'-') ; legend('Sw value','Rise','Fall') ;
xlabel('Left wheel Pole travel, meters') ; 
set( gca , 'ylim' , [-0.2, 1.2 ]) 






