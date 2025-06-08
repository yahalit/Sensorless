function [msg,str] = BuildEmergencyStopMessage( str ) 
if nargin < 1
    str = struct('Code',2) ; 
end 

payload = zeros(1,1) ;  
payload(1) = Short2Payload(str.Code) ; 

str = struct('OpCode',7 ,'Payload',payload ) ; 

msg = BuildHostSciString( str.Payload , str.OpCode  ) ; 

end 