function [msg,str] = BuildSetQueueExecutionPointerMessage( str ) 

if nargin < 1 
    str = struct('Index',0,'EntryIndex',0,'Mode',1000);
end 

payload = zeros(1,3) ;  
payload(1) = Short2Payload( str.Index) ; 
payload(2) = Short2Payload( str.EntryIndex) ; 
payload(3) = Short2Payload( str.Mode) ; 

str = struct('OpCode',3 ,'Payload',payload ) ; 

msg = BuildHostSciString( str.Payload , str.OpCode  ) ; 

end 