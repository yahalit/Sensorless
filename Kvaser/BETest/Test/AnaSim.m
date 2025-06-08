% Analize the recording of the limit switches  
% Debug - program recording of run shelf vars 
global RecStruct %#ok<*GVMIS> 
% No need , rescue mission records anyway
% SendObj( [hex2dec('2222'),16] , 1 , DataType.long , 'Debug mode = bRecorder4ShelfRun' ) ;

SendObj( [hex2dec('2220'),240] , 5 , DataType.float , 'VStarta' ) ;
SendObj( [hex2dec('2220'),241] , -2 , DataType.float , 'VStartb' ) ;
SendObj( [hex2dec('2220'),242] ,-2 , DataType.float , 'VStartb' ) ;

RecTime = 0.02 ; 
MaxRecLen = 300  ; 

RecStruct.Sync2C = 1 ; 

% InitRec set zero , recorder shall start automatically
RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ,'MaxLen', MaxRecLen) ; %,'PreTrigPercent',20) ; 

RecNames = {'SimIa','SimIb','SimIc','SimIq','SimId','UsecTimer'} ;
L_RecStruct = RecStruct ;
L_RecStruct.TrigSigName = 'MotorOn' ; 

% recstruct.TrigType:   0 = immediate 
%                       1 = Up trigger 
%                       2 = Dn trigger


L_RecStruct.TrigType = 1 ; 
L_RecStruct.TrigVal  = 1 ; 
[~,L_RecStruct] = Recorder(RecNames , L_RecStruct , RecInitAction   );

return 

RecInitAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'T' , RecTime ,'MaxLen', MaxRecLen) ; %#ok<UNRCH> 
[~,~,r] = Recorder(RecNames , L_RecStruct , RecInitAction   );
% Use RetrieveShelfRescueRecord.m

t = r.t ; 
Ts = r.Ts ;
