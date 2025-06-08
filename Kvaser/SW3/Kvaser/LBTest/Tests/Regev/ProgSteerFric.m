% Analize the recording of the limit switches 
CalcGeomData;
% Debug - program recording of run shelf vars 
global DataType

SendObj( [hex2dec('2222'),2] , 1 , DataType.long , 'Record switch data') ; 
RecTime = 25 ; 
MaxRecLen = 2500 ; 


RecStruct.Sync2C = 1 ; 
% InitRec set zero , recorder shall start automatically
% RecInitAction = struct( 'InitRec' , 0 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 
RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ,'MaxLen', MaxRecLen ) ; 
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 

RecNames = {'RWheelEncPos','LWheelEncPos','RsteerOuterPos','LsteerOuterPos','ArcDistance0','ArcDistance1','DinCapture0','DinCapture1',...
'RWheelDriveEnc',...
'LWheelDriveEnc',...
'RwCurrent',...
'LwCurrent',...
'lDebug4',...
'fDebug0',...
'fDebug1'...
    } ; 

L_RecStruct = RecStruct ;
L_RecStruct.BlockUpLoad = 0 ; 
[~,L_RecStruct] = Recorder(RecNames , L_RecStruct , RecInitAction   );
save AnaSteerFric RecNames L_RecStruct RecBringAction

return 



[~,~,r] = Recorder(RecNames , L_RecStruct , RecBringAction   );
save Regev1 r 

return 

% SendObj( [hex2dec('2207'),57] , WAAct.E_TrackWidthExtend , DataType.long , 'Set wheelarm action') ;
% 
% disp(['Wait recording time, Sec:  ',num2str(RecTime) ]) ; 
% pause(RecTime + 2 ) ; 

