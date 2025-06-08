% Analize the recording of the limit switches  
global RecStruct 
global DataType

RecTime = 20; 


RecStruct.Sync2C = 1 ; 
% InitRec set zero , recorder shall start automatically
RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 


% EncoderPosTarget0,EncoderPosTarget1
RecNames = {'C2_LeftLockPosTgt','C2_RightLockPosTgt','C2_LeftDoorPosAct','C2_RightDoorPosAct','C2_DynStat12_0Statistic1','C2_DynStat12_1Statistic1',...
    'C2_DStatistic1','C2_DStatistic2','C2_CtrlWord','C2_ShoulderPos'} ; 

L_RecStruct = RecStruct ;
L_RecStruct.BlockUpLoad = 0 ; 
[~,L_RecStruct] = Recorder(RecNames , L_RecStruct , RecInitAction   );
save ProgManipRec RecNames  L_RecStruct   RecInitAction RecBringAction
