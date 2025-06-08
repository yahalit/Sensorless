% Analize the recording of the limit switches  
CalcGeomData;
% Debug - program recording of run shelf vars 
global RecStruct 
global DataType
% No need , rescue mission records anyway
SendObj( [hex2dec('2222'),16] , 1 , DataType.long , 'Debug mode = bRecorder4ShelfRun' ) ;

RecTime = 12; 


RecStruct.Sync2C = 1 ; 
% InitRec set zero , recorder shall start automatically
RecInitAction = struct( 'InitRec' , 0 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 

% EncoderPosTarget0,EncoderPosTarget1
RecNames = {'lDebug0','lDebug1','EncoderPosTarget0','EncoderPosTarget1','LineSpeed',...
    'RightWheelEncoder','LeftWheelEncoder','RwSpeedCmdAxis','LwSpeedCmdAxis','WheelProfile0Speed','WheelProfile0Pos','WheelProfile1Pos'} ;
% RecNames = {'lDebug0','lDebug1','lDebug2','lDebug3','lDebug4','fDebug0','fDebug1',...
%     'RightWheelEncoder','LeftWheelEncoder','ShelfMode','WheelProfile0Speed','WheelProfile0Pos','WheelProfile1Pos'} ;

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
RecNames = {'lDebug0','lDebug1','EncoderPosTarget0','EncoderPosTarget1','LineSpeed',...
    'RightWheelEncoder','LeftWheelEncoder','RwSpeedCmdAxis','LwSpeedCmdAxis','WheelProfile0Speed','WheelProfile0Pos','WheelProfile1Pos'} ;
L_RecStruct = RecStruct ;
[~,~,r] = Recorder(RecNames , L_RecStruct , RecBringAction   ); 
save('AnaShelfRecord.mat','r' ) ; 
t = r.t ; 
Ts = r.Ts ;


st = r.lDebug0 ;
r.PosTarget0 = r.fDebug4 ;
r.PosTarget1 = r.fDebug5 ;
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


