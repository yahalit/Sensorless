% Analize the recording of the limit switches  
CalcGeomData;
% Debug - program recording of run shelf vars 
global RecStruct 
global DataType %#ok<NUSED>
RecTime = 25; 
SendObj( [hex2dec('2222'),26] ,1 , DataType.long , 'GP debug' ) ;

RecStruct.Sync2C = 1 ; 
RecStruct.TrigType = 4 ; 
% InitRec set zero , recorder shall start automatically
RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime , 'PreTrigPercent', 60 ) ; 
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 

% EncoderPosTarget0,EncoderPosTarget1
RecNames = {'ShelfMode','Motmode','ShelfSubMode','ChgModeState','ChgModeSubState','RightWheelEncoder','PackageState','MotLog','MotLog2'} ; 
    
L_RecStruct = RecStruct ;
L_RecStruct.BlockUpLoad = 1 ; 
[~,L_RecStruct] = Recorder(RecNames , L_RecStruct , RecInitAction   );
save ProgTest2Manual RecNames L_RecStruct RecBringAction







