% Analize the recording of the limit switches 
CalcGeomData;
% Debug - program recording of run shelf vars 
global DataType

RecTime = 10 ;



RecStruct.Sync2C = 1 ; 
% InitRec set zero , recorder shall start automatically
% RecInitAction = struct( 'InitRec' , 0 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 
RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ,'MaxLen', MaxRecLen ) ; 
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 


%RecNames = {'RWheelEncPos','LWheelEncPos','lDebug6','lDebug7','ArcDistance0','ArcDistance1','DinCapture0','DinCapture1','WheelEncoderTarget0','WheelEncoderTarget1','LeaderError'} ; 
RecNames = {'RWheelEncPos','LWheelEncPos','lDebug6','lDebug7','fDebug0','fDebug1','lDebug5','LwCurrent','RwCurrent','WheelEncoderTarget0','WheelEncoderTarget1','LwSpeedCmdAxis'} ; 

L_RecStruct = RecStruct ;
L_RecStruct.BlockUpLoad = 0 ; 
[~,L_RecStruct] = Recorder(RecNames , L_RecStruct , RecInitAction   );


%WAClimbTest2 ; 
return 

% SendObj( [hex2dec('2207'),57] , WAAct.E_TrackWidthExtend , DataType.long , 'Set wheelarm action') ;
% 
% disp(['Wait recording time, Sec:  ',num2str(RecTime) ]) ; 
% pause(RecTime + 2 ) ; 
[~,~,r1] = Recorder(RecNames , L_RecStruct , RecBringAction   );
r = r1 ; 
save('Anakuku.mat','r' ) ; 
t = r.t ; 
Ts = r.Ts ;

% 'RWheelEncPos','LWheelEncPos','WheelEncoderTarget0','WheelEncoderTarget1','errPos0','errPos1','ShelfSubMode'
try 
poa = GetFloatPar('Geom.LimitSw2DistPosOnArc') ; 
ar   =GetFloatPar('Geom.ClimbArcRadi') ; 
fh  =GetFloatPar('Geom.ClimbArcOverFloor') ; 

ExtendedWidth= FetchObj( [hex2dec('2224'),3] , DataType.float , 'Width,Extended' ) ; 
RetractedWidth= FetchObj( [hex2dec('2224'),2] , DataType.float , 'Width,Retracted' ) ; 
catch
    poa = 0.0810 ; 
    ar = 0.2202 ; 
    fh = 0.0450 ; 
    ExtendedWidth = 0.6084 ; 
    RetractedWidth = 0.5012 ;
end

Ls2Pos = poa + ar * 1.570796326794897 ; 
ArcCorrect = ar * 0.570796326794897;

figure(10) ; 

m = struct () ;
m.rsw = bitgetvalue(r.lDebug6,8) ; 
m.rswcnt = bitgetvalue(r.lDebug6,[11:12]) ; 
m.lswcnt = bitgetvalue(r.lDebug6,[13:14]) ; 
m.lsw = bitgetvalue(r.lDebug6,10) ; 
m.rind =  bitgetvalue(r.lDebug6,26) ; 
m.rdir =  bitgetvalue(r.lDebug6,[15:16]) ; 
m.ldir =  bitgetvalue(r.lDebug6,17:18) ; 
m.rdetmark = bitgetvalue(r.lDebug6,19) ; 
m.ldetmark = bitgetvalue(r.lDebug6,20) ; 
m.rrisemark = bitgetvalue(r.lDebug6,7) ; 
m.submode = bitgetvalue(r.lDebug6,21:25) ; 
m.targetarmdone = bitgetvalue(r.lDebug6,1:3) ; 
m.targetarmrq = bitgetvalue(r.lDebug6,4:6) ; 
m.rbrcmd = bitgetvalue(r.lDebug6,28) ; 
m.lbrcmd = bitgetvalue(r.lDebug6,29) ; 
m.steerrelease = bitgetvalue(r.lDebug6,31) ; 
m.wheelrelease = bitgetvalue(r.lDebug6,30) ; 
% rswAnalog = r.fDebug0 ; 
rpos = r.RWheelEncPos * Geom.Calc.WheelEncoder2MeterShelf ;
lpos = r.LWheelEncPos * Geom.Calc.WheelEncoder2MeterShelf ;

m.pin0 = bitgetvalue(r.lDebug7,1:2) ;
m.pin1 = bitgetvalue(r.lDebug7,3:4) ;
m.ssmode = bitgetvalue(r.lDebug7,13:16) ;
m.toutcnt = bitgetvalue(r.lDebug7,17:28) ;


% subplot( 3,1,1) ;
% plot( t, r.RWheelEncPos,t, r.LWheelEncPos , t, r.WheelEncoderTarget0,t, r.WheelEncoderTarget1  ); legend('Rpos','Lpos','Rtarget','Ltarget'); grid on 
% subplot( 3,1,2) ;
% plot( t, r.WheelEncoderTarget0,t, r.WheelEncoderTarget1 ); legend('Rtarget','Ltarget');grid on  
% subplot( 3,1,3) ;
% plot( t, r.ShelfSubMode ) ; grid on 
% 
% figure(11) ; 
% plot( t, r.RWheelEncPos,t, r.DinCapture0 , t, r.LWheelEncPos,t, r.DinCapture1,t, r.WheelEncoderTarget0,t, r.WheelEncoderTarget1); grid on 
% legend('Rpos','Rcapt','Lpos','Lcapt','Rtarget','Ltarget'); 
% 
% figure(12) ; 
% plot( t, r.ArcDistance0 ,t, r.ArcDistance1 , t,  r.ArcDistance0 - r.ArcDistance1) ; legend('Arc R','Arc L','Difference') ; set(gca,'ylim',[-1,2]) ; grid on 
% title( ['Final: R: ',num2str(r.ArcDistance0(end)),'  L:', num2str(r.ArcDistance1(end))]) ; 
% 
% figure(14) 
% plot( t, r.WheelEncoderTarget0-r.RWheelEncPos,t, r.WheelEncoderTarget1-r.LWheelEncPos ); legend('DRtarget','DLtarget'); grid on 
