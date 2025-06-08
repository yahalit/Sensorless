global DataType
% SendObj( [hex2dec('2207'),63] , 1 , DataType.long , 'Yotb' ) ;


% disp(['Wait recording time, Sec:  ',num2str(RecTime) ]) ;  %#ok<UNRCH>
% pause(RecTime + 5 ) ; 
CalcGeomData
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 


RecNames = {'ArcDistance0','SpeedRatio','RwSpeedCmdAxis','LwSpeedCmdAxis','ShoulderRoll','ArcTilt','HeadRollFilt','dArcTilt',...
    'LeftWheelEncoder','EulerRoll','NeckOuterPos','LWheelEncSpeed','lDebug5','fDebug0','fDebug1'} ;
L_RecStruct = RecStruct ;
[~,~,r] = Recorder(RecNames , L_RecStruct , RecBringAction   ); 
save('AnaGyroRecord.mat','r' ) ; 
t = r.t ; 
Ts = r.Ts ;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                nspeed = dydt( r.NeckOuterPos , t ) ;
totalRoll = r.fDebug0 ; 
thtEst = r.fDebug1 ;  
GyroSwCapture =  r.lDebug5 ; 

ind = find(r.ArcDistance0 < -1  ); 
r.ArcDistance0(ind) = -1 ; 
ind = find( t < 10 ) ; 
ti = t(ind) ; 
figure(1) ; clf
subplot( 2,1,1) ; 
plot( ti , r.EulerRoll(ind) , ti , r.HeadRollFilt(ind) , ti , r.ShoulderRoll(ind),...
    ti , totalRoll(ind),ti,r.ArcTilt(ind) ) ; grid on ; legend('r','filt r','s','totroll','tilt') ; 
subplot( 2,1,2) ;
plot( ti , thtEst(ind) ) ;


% subplot(2,1,1) 
plot( t , r.ArcDistance0, t , r.ArcDistance1 ) ; grid on 

figure(3) 
plot( r.ArcDistance0, r.RwSpeedCmdAxis * Geom.Calc.MotEncoder2MeterShelf , r.ArcDistance0 , r.RWheelEncSpeed * Geom.Calc.WheelEncoder2MeterShelf)
figure(4) 
plot( r.ArcDistance0, r.LwSpeedCmdAxis * Geom.Calc.MotEncoder2MeterShelf , r.ArcDistance0 , r.LWheelEncSpeed * Geom.Calc.WheelEncoder2MeterShelf)
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
