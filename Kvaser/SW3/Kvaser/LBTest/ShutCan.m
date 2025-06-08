% Shut the CAN communications of the entire robot
DataType = GetDataType(); 

% Kill the heartbeat response of the wheels
% OsInterp( 12,'CanObj(0x6007,0,0)') ; 
% OsInterp( 22,'CanObj(0x6007,0,0)') ; 

stat = SendObj( [hex2dec('2220'),3,124] , hex2dec('1234') , DataType.short ,'Shut CAN activity') ;  

if stat == 0 , error ('CAN communication still exists?') ; end 
try
success = KvaserCom(2) ; 
catch
end
