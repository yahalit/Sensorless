% Analize the recording of the limit switches 
CalcGeomData;
% Debug - program recording of run shelf vars 
global DataType





RecStruct.Sync2C = 1 ; 
% InitRec set zero , recorder shall start automatically
% RecInitAction = struct( 'InitRec' , 0 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 
RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ,'MaxLen', MaxRecLen ) ; 
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 


RecNames = {'RWheelEncPos','LWheelEncPos','WheelEncoderTarget0','WheelEncoderTarget1','ArcDistance0','ArcDistance1','DinCapture0','DinCapture1','ShelfSubMode'} ; 

L_RecStruct = RecStruct ;
L_RecStruct.BlockUpLoad = 0 ; 
[~,L_RecStruct] = Recorder(RecNames , L_RecStruct , RecInitAction   );

%WAClimbTest2 ; 
return 

% SendObj( [hex2dec('2207'),57] , WAAct.E_TrackWidthExtend , DataType.long , 'Set wheelarm action') ;
% 
% disp(['Wait recording time, Sec:  ',num2str(RecTime) ]) ; 
% pause(RecTime + 2 ) ; 
[~,~,r] = Recorder(RecNames , L_RecStruct , RecBringAction   );
% save('AnaWarmRecordOpenUp12KgFail.mat','r' ) ; 
t = r.t ; 
Ts = r.Ts ;

% 'RWheelEncPos','LWheelEncPos','WheelEncoderTarget0','WheelEncoderTarget1','errPos0','errPos1','ShelfSubMode'
poa = GetFloatPar('Geom.LimitSw2DistPosOnArc') ; 
ar   =GetFloatPar('Geom.ClimbArcRadi') ; 
fh  =GetFloatPar('Geom.ClimbArcOverFloor') ; 

ExtendedWidth= FetchObj( [hex2dec('2224'),3] , DataType.float , 'Width,Extended' ) ; 
RetractedWidth= FetchObj( [hex2dec('2224'),2] , DataType.float , 'Width,Retracted' ) ; 


Ls2Pos = poa + ar * 1.570796326794897 ; 
ArcCorrect = ar * 0.570796326794897;

figure(10) ; 

subplot( 3,1,1) ;
plot( t, r.RWheelEncPos,t, r.LWheelEncPos , t, r.WheelEncoderTarget0,t, r.WheelEncoderTarget1  ); legend('Rpos','Lpos','Rtarget','Ltarget'); grid on 
subplot( 3,1,2) ;
plot( t, r.WheelEncoderTarget0,t, r.WheelEncoderTarget1 ); legend('Rtarget','Ltarget');grid on  
subplot( 3,1,3) ;
plot( t, r.ShelfSubMode ) ; grid on 

figure(11) ; 
plot( t, r.RWheelEncPos,t, r.DinCapture0 , t, r.LWheelEncPos,t, r.DinCapture1,t, r.WheelEncoderTarget0,t, r.WheelEncoderTarget1); grid on 
legend('Rpos','Rcapt','Lpos','Lcapt','Rtarget','Ltarget'); 

figure(12) ; 
plot( t, r.ArcDistance0 ,t, r.ArcDistance1 , t,  r.ArcDistance0 - r.ArcDistance1) ; legend('Arc R','Arc L','Difference') ; set(gca,'ylim',[-1,2]) ; grid on 
title( ['Final: R: ',num2str(r.ArcDistance0(end)),'  L:', num2str(r.ArcDistance1(end))]) ; 

figure(14) 
plot( t, r.WheelEncoderTarget0-r.RWheelEncPos,t, r.WheelEncoderTarget1-r.LWheelEncPos ); legend('DRtarget','DLtarget'); grid on 
