L_RecStruct.BlockUpLoad = 1 ;  %#ok<UNRCH>
CalcGeomData
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 
RecNames = {'lDebug0','lDebug1','EncoderPosTarget0','EncoderPosTarget1','LineSpeed',...
    'RightWheelEncoder','LeftWheelEncoder','RwSpeedCmdAxis','LwSpeedCmdAxis','WheelProfile0Speed','WheelProfile0Pos','WheelProfile1Pos'} ;
L_RecStruct = RecStruct ;
[~,~,r] = Recorder(RecNames , L_RecStruct , RecBringAction   ); 
save('AnaShelfRecord.mat','r' ) ; 
t = r.t ; 
Ts = r.Ts ;

statf = fix( r.lDebug1 + 2^32 ) ;
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

st = r.lDebug0 ;
% r.PosTarget0 = r.fDebug4 ;
% r.PosTarget1 = r.fDebug5 ;
r.stat = struct('bEndGame',bitextract(st , 1, 1 ),'Prof0Done', bitextract(st , 1, 2 ),'Prof1Done', bitextract(st , 1, 3 ),...
    'TargetArmDone', bitextract(st , 7, 4 ) ,'RunDirection',bitextract(st , 3, 10 ),'bProfileStart',bitextract(st , 3, 12 ),...
    'ShelfMode',bitextract(st , 15, 16 ),'NextStationIsPole',bitextract(st , 1, 20 ),'ChgModeState',bitextract(st , 127, 21 )) ; 

figure(30) ; clf 
subplot(3,1,1) ; 
plot( t , r.stat.bEndGame , t , r.stat.TargetArmDone ,'+-') ; legend('bEndGame','TargetArmDone') ; 
subplot( 3,1,2) ; 
plot( t , r.EncoderPosTarget0 , t , r.RightWheelEncoder , t , r.EncoderPosTarget1 , t , r.LeftWheelEncoder) ; 
legend('Targ0','Enc0','Targ1','Enc1') ; 
subplot( 3,1,3) ;
ind = find( r.stat.bEndGame) ; 
fac = Geom.Calc.WheelEncoder2MeterShelf ; 
if isempty(ind) 
    title('End game is absent') ;
else
    plot( t(ind) , (r.EncoderPosTarget0(ind) - r.RightWheelEncoder(ind))*fac * 1000 ,'+' , t(ind) , (r.EncoderPosTarget1(ind)-r.LeftWheelEncoder(ind))*fac * 1000,'linewidth',2 ) ; 
    ylabel('mm') ;
    legend('Err0','Err1') ; 
end

figure(31 )
fac1 = Geom.Calc.WheelEncoder2MeterShelf  ; 
fac2 = Geom.Calc.MotEncoder2MeterShelf  ; 
spd1 = dydt( r.RightWheelEncoder , t ) * fac1 ;  
spd2 = dydt( r.LeftWheelEncoder , t ) * fac1 ;  
plot( t , r.RwSpeedCmdAxis * fac2 , t , spd1 , t , r.LwSpeedCmdAxis *fac2 , t , spd2) ; 
legend( 'Cmd0','Spd0','Cmd1','Spd1') ; 

figure(32) 
plot( t, r.rstat.Value , t, r.lstat.Value ) 

