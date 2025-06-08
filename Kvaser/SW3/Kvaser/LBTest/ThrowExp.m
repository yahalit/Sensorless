
global DataType

% Kill the heartbeat response of the wheels
% OsInterp( 12,'CanObj(0x6007,0,0)') ; 
% OsInterp( 22,'CanObj(0x6007,0,0)') ; 

stat = SendObj( [hex2dec('2220'),94] , hex2dec('713d') , DataType.long ,'Throw abort') ;  


