global DataType
load AnaWheelArmVars  

[~,~,ra] = Recorder(RecNames , L_RecStruct , RecBringAction   );
save('AnaWarmRecord.mat','ra' ) ; 
load AnaWarmRecord  
r = ra ; 
r = SetTimeRange(ra , [0.1,8] ,'t' ) ; 

t = r.t ; 
Ts = r.Ts ;


r.LeaderTarget = r.lDebug1 ;
r.errPos = r.lDebug2 ;
r.WheelEncoderLeader = r.lDebug3 ;
r.PinPos = r.lDebug4 ;
r.RodAngle0 = r.fDebug0 ; 
r.RodAngle1 = r.fDebug1 ;
r.TrackWidth = r.fDebug2 ;
r.SpeedCmd = r.fDebug3 ;
r.TrackTilt = r.fDebug4 ;

%if isfield(r,'lDebug0') 
    st = r.lDebug0 ;
    r.stat = GetWheelArmStat(st) ; 
%end
% struct('RPinState',bitextract(st , 3, 0 ),'LPinState', bitextract(st , 3, 2 ),'WheelArmState', bitextract(st , 15, 4 ),...
%     'Axis', bitextract(st , 3, 8 ) ,'OtherAxis',bitextract(st , 3, 10 ),'ShelfSubSubMode',bitextract(st , 15, 12 ),...
%     'tOutCnt',bitextract(st , 2047 , 16 ),'TargetArmDone',bitextract(st , 7 , 28 ),'tOutCnt',bitextract(st , 1 , 31 )) ; 

figure(10) ; 

subplot( 3,1,1) ;
plot( t, r.WheelEncoderLeader ); legend('WheelEncoderLeader') ; grid on 
subplot( 3,1,2) ;
plot( t, r.stat.ShelfSubSubMode ) ; legend('ShelfSubSubMode') ; grid on 
subplot( 3,1,3) ;
plot( t, r.PinPos ) ; legend('PinPos') ; grid on 

figure(11) ;
subplot( 3,1,1) ;
plot( t, r.stat.RPinState ) ; legend('RPinState') ; grid on 
subplot( 3,1,2) ;
plot( t, r.stat.tOutCnt ) ; legend('tOutCnt') ; grid on 
subplot( 3,1,3) ;
plot( t, r.errPos ) ; legend('errPos') ; grid on 

figure(12) ;
subplot( 3,1,1) ;
plot( t, r.RwCurrent ) ; legend('RwCurrent') ; grid on 
subplot( 3,1,2) ;
plot( t, r.LwCurrent ) ; legend('LwCurrent') ; grid on 
subplot( 3,1,3) ;
plot( t, r.NeckDiff ) ; legend('NeckDiff') ; grid on 