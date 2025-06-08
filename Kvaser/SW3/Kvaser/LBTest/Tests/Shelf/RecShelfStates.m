% Analize the recording of the limit switches  
CalcGeomData;
% Debug - program recording of run shelf vars 
global RecStruct 
global DataType %#ok<NUSED>
RecTime = 35; 
SendObj( [hex2dec('2222'),26] ,1 , DataType.long , 'GP debug' ) ;

RecStruct.Sync2C = 1 ; 
% InitRec set zero , recorder shall start automatically
RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 

% EncoderPosTarget0,EncoderPosTarget1
RecNames = {'ShelfMode','Motmode','ShelfSubMode','ChgModeState','ChgModeSubState','Robotxc1','RightWheelEncoder','Ybase','PackageState','RwCurrent','lDebug2','lDebug3'} ; 
    
L_RecStruct = RecStruct ;
L_RecStruct.BlockUpLoad = 1 ; 
[~,L_RecStruct] = Recorder(RecNames , L_RecStruct , RecInitAction   );

return ; 

% disp(['Wait recording time, Sec:  ',num2str(RecTime) ]) ;  %#ok<UNRCH>
% pause(RecTime + 5 ) ; 
[~,~,r] = Recorder(RecNames , L_RecStruct , RecBringAction   ); %#ok<UNRCH>
save('AnaShelfState).mat','r' ) ; 
t = r.t ; 
Ts = r.Ts ;






