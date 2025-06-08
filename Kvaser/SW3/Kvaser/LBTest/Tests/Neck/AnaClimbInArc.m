% Analize the recording of the limit switches  
CalcGeomData;
% Debug - program recording of run shelf vars 
global RecStruct 
global DataType
RecSw = 0 ; 
% No need , rescue mission records anyway
% SendObj( [hex2dec('2222'),16] , 1 , DataType.long , 'Debug mode = bRecorder4ShelfRun' ) ;
if RecSw == 1 
    SendObj( [hex2dec('2222'),2] , 1 , DataType.long , 'Record limit switches' ) ;
else
    SendObj( [hex2dec('2222'),17] , 1 , DataType.long , 'Record climb gyro' ) ;
end 

RecTime = 12 ; 
MaxRecLen = 1400 ; 

RecStruct.Sync2C = 1 ; 
% InitRec set zero , recorder shall start automatically
RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ,'MaxLen', MaxRecLen) ; 

% EncoderPosTarget0,EncoderPosTarget1


if RecSw == 1 
    RecNames = {'LineSpeed','LeaderScale','FollowerScale','SpeedRatio','RwSpeedCmdAxis','LwSpeedCmdAxis',...
        'RightWheelEncoder','LeftWheelEncoder','EulerRoll','ClimbStatus','RWheelEncSpeed','LWheelEncSpeed','lDebug4'} ;
%     RecNames = {'ArcDistance0','ArcDistance1','SpeedRatio','RwSpeedCmdAxis','LwSpeedCmdAxis',...
%         'RightWheelEncoder','LeftWheelEncoder','EulerRoll','NeckOuterPos','RWheelEncSpeed','LWheelEncSpeed','NeckDiff','lDebug4'} ;
else
    RecNames = {'ArcDistance0','SpeedRatio','RwSpeedCmdAxis','LwSpeedCmdAxis','ShoulderRoll','ArcTilt','HeadRollFilt','dArcTilt',...
        'LeftWheelEncoder','EulerRoll','NeckOuterPos','LWheelEncSpeed','lDebug5','fDebug0','fDebug1'} ;
end

L_RecStruct = RecStruct ;
L_RecStruct.BlockUpLoad = 0 ; 
[~,L_RecStruct] = Recorder(RecNames , L_RecStruct , RecInitAction   );
% Use RetrieveShelfRescueRecord.m

return ; 

% disp(['Wait recording time, Sec:  ',num2str(RecTime) ]) ;  %#ok<UNRCH>
% pause(RecTime + 5 ) ; 
L_RecStruct.BlockUpLoad = 1 ;  %#ok<UNRCH>
CalcGeomData
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 

RecNames = {'LineSpeed','LeaderScale','FollowerScale','SpeedRatio','RwSpeedCmdAxis','LwSpeedCmdAxis',...
    'RightWheelEncoder','LeftWheelEncoder','EulerRoll','ClimbStatus','RWheelEncSpeed','LWheelEncSpeed','lDebug4','ArcDistance0','ArcDistance1'} ;

% RecNames = {'ArcDistance0','ArcDistance1','SpeedRatio','RwSpeedCmdAxis','LwSpeedCmdAxis',...
%     'RightWheelEncoder','LeftWheelEncoder','EulerRoll','NeckOuterPos','RWheelEncSpeed','LWheelEncSpeed','NeckDiff','lDebug4'} ;
L_RecStruct = RecStruct ;
[~,~,r] = Recorder(RecNames , L_RecStruct , RecBringAction   ); 
save('AnaShelfRecord.mat','r' ) ; 
t = r.t ; 
Ts = r.Ts ;
%nspeed = dydt( r.NeckOuterPos , t ) ;

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

% ind = find(r.ArcDistance0 < -1  ); 
% r.ArcDistance0(ind) = -1 ; 
% ind = find(r.ArcDistance1 < -1  ); 
% r.ArcDistance1(ind) = -1 ; 

figure(1) ; clf
ind = find( t > 5) ; 
ti  = t(ind) ; 
er = r.RightWheelEncoder(ind) ; 
el = r.LeftWheelEncoder(ind) ; 

plot( ti , er-er(1), ti , el-el(1)) ; grid on ; legend('R','L') 

figure(2) ; clf
vr = r.RwSpeedCmdAxis(ind) ; 
vl = r.LwSpeedCmdAxis(ind) ; 
avr = r.RWheelEncSpeed(ind) * Geom.Calc.WheelEncoder2MotEncoder ; 
avl = r.LWheelEncSpeed(ind) * Geom.Calc.WheelEncoder2MotEncoder ; 

plot( ti , vr-vr(1), ti , vl-vl(1),ti , avr-avr(1), ti , avl-avl(1)) ; grid on ; legend('R','L','AR','AL') 

% subplot(2,1,1) 
% plot( t , r.ArcDistance0, t , r.ArcDistance1 ) ; grid on 
% 
% figure(3) 
% plot( r.ArcDistance0, r.RwSpeedCmdAxis * Geom.Calc.MotEncoder2MeterShelf , r.ArcDistance0 , r.RWheelEncSpeed * Geom.Calc.WheelEncoder2MeterShelf)
% figure(4) 
% plot( r.ArcDistance0, r.LwSpeedCmdAxis * Geom.Calc.MotEncoder2MeterShelf , r.ArcDistance0 , r.LWheelEncSpeed * Geom.Calc.WheelEncoder2MeterShelf)
% plot( t,dydt(r.RightWheelEncoder,t)) ; 
% subplot(2,1,2) 
% plot( t,r.RWheelEncSpeed,t,dydt(r.RightWheelEncoder,t)) ; legend('spd','Drvc');
% figure(2) ; 
% subplot(3,1,1) 
% plot( t,dydt(r.RightWheelEncoder,t)*Geom.Calc.WheelEncoder2MeterShelf,'+'  , t , r.LineSpeed ) 
% subplot(3,1,2) 
% plot( t,r.ArcTilt) 
% subplot(3,1,3) 
% plot( t ,  dydt(r.ArcTilt,t) , t, r.dArcTilt.*r.RWheelEncSpeed*Geom.Calc.WheelEncoder2MeterShelf) ;  legend('calc','sw');%  .* r.RWheelEncSpeed*Geom.Calc.WheelEncoder2MeterShelf,'+' ) 
% figure(3) ; 
% subplot(2,1,1) 
% plot( t , r.NeckSpeedTarget , t , nspeed ) ; 
% subplot(2,1,2) 
% plot( t , r.EulerRoll ) 
