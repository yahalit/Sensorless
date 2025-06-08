% Analize the recording of the limit switches  
CalcGeomData;
% Debug - program recording of run shelf vars 
global RecStruct 
global DataType
% No need , rescue mission records anyway
% SendObj( [hex2dec('2222'),16] , 1 , DataType.long , 'Debug mode = bRecorder4ShelfRun' ) ;

RecTime = 25 ; 
MaxRecLen = 1400 ; 

RecStruct.Sync2C = 1 ; 
% InitRec set zero , recorder shall start automatically
RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ,'MaxLen', MaxRecLen) ; 

% EncoderPosTarget0,EncoderPosTarget1


RecNames = {'ArcDistance0','LineSpeed','dArcTilt','HeadRollFilt','ArcTilt','NeckPosTarget',...
    'RightWheelEncoder','LeftWheelEncoder','EulerRoll','NeckSpeedTarget ','NeckOuterPos','RWheelEncSpeed'} ;
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


RecNames = {'ArcDistance0','LineSpeed','dArcTilt','HeadRollFilt','ArcTilt','NeckPosTarget',...
    'RightWheelEncoder','LeftWheelEncoder','EulerRoll','NeckSpeedTarget ','NeckOuterPos','RWheelEncSpeed'} ;
L_RecStruct = RecStruct ;
[~,~,r] = Recorder(RecNames , L_RecStruct , RecBringAction   ); 
save('AnaShelfRecord.mat','r' ) ; 
t = r.t ; 
Ts = r.Ts ;
nspeed = dydt( r.NeckOuterPos , t ) ;


figure(1) 
subplot(2,1,1) 
plot( t,dydt(r.RightWheelEncoder,t)) ; 
subplot(2,1,2) 
plot( t,r.RWheelEncSpeed,t,dydt(r.RightWheelEncoder,t)) ; legend('spd','Drvc');
figure(2) ; 
subplot(3,1,1) 
plot( t,dydt(r.RightWheelEncoder,t)*Geom.Calc.WheelEncoder2MeterShelf,'+'  , t , r.LineSpeed ) 
subplot(3,1,2) 
plot( t,r.ArcTilt) 
subplot(3,1,3) 
plot( t ,  dydt(r.ArcTilt,t) , t, r.dArcTilt.*r.RWheelEncSpeed*Geom.Calc.WheelEncoder2MeterShelf) ;  legend('calc','sw');%  .* r.RWheelEncSpeed*Geom.Calc.WheelEncoder2MeterShelf,'+' ) 
figure(3) ; 
subplot(2,1,1) 
plot( t , r.NeckSpeedTarget , t , nspeed ) ; 
subplot(2,1,2) 
plot( t , r.EulerRoll ) 
