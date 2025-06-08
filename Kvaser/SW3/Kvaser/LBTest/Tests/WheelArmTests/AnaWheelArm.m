% Analize the recording of the limit switches 
CalcGeomData;
% Debug - program recording of run shelf vars 
global DataType

WAAct = struct('E_TrackWidthNothing',0,'E_TrackWidthRetract',1,'E_TrackWidthExtend',2)  ; 
SendObj( [hex2dec('2222'),18] , 1 , DataType.long , 'Debug mode = wheelarm' ) ;
SendObj( [hex2dec('2222'),19] , 2 , DataType.long , 'Auto record trigger -  wheelarm' ) ;

RecTime = 12; 


RecStruct.Sync2C = 1 ; 
% InitRec set zero , recorder shall start automatically
% RecInitAction = struct( 'InitRec' , 0 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 
RecInitAction = struct( 'InitRec' , 0 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 


RecNames = {'lDebug0','fDebug0','fDebug1','fDebug2','fDebug3','fDebug3','fDebug4','NeckDiff','RwCurrent','LwCurrent',...
    'lDebug0','lDebug1','lDebug2','lDebug3','lDebug4'} ; 
L_RecStruct = RecStruct ;
L_RecStruct.BlockUpLoad = 0 ; 
[~,L_RecStruct] = Recorder(RecNames , L_RecStruct , RecInitAction   );
save AnaWheelArmVars RecNames L_RecStruct RecBringAction

return 

% SendObj( [hex2dec('2207'),57] , WAAct.E_TrackWidthExtend , DataType.long , 'Set wheelarm action') ;
% 
% disp(['Wait recording time, Sec:  ',num2str(RecTime) ]) ; 
% pause(RecTime + 2 ) ; 

