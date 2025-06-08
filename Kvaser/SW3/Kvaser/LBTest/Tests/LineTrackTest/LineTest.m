global RecStruct ; %#ok<*GVMIS> 
global TargetCanId 
global DatType 
CreateStruct =  struct('Interpreter','tex','WindowStyle' , 'modal') ; 

CalcGeomData
RecTime = 20 ; 
RecInitAction = struct( 'InitRec' , 0 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 

RecNames = {'RawDevTStamp','RawDevOffset','RawDevAzimuth','DevMsgCnt','RsteerOuterPos','UsecTimer','EulerYaw','LsteerOuterPos','RightWheelEncoder','LeftWheelEncoder'} ; 
L_RecStruct = RecStruct ;
L_RecStruct.BlockUpLoad = 0 ; 
[~,L_RecStruct] = Recorder(RecNames , L_RecStruct , RecInitAction   );
save AnaLineTest RecNames L_RecStruct RecBringAction Geom 

return 

SendObj( [hex2dec('2000'),100] , 1 , DataType.short  , 'Set the recorder on' ) ;
[RecVec,recstruct,RecStr,errString] = Recorder(RecNames , L_RecStruct , RecBringAction   );