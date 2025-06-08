function [msg,str] = BuildSetQueueEntryMessage( str ) 
%not ready
if nargin < 1 
    str = struct('Queue2Load',1,'EntryInQueue',0,'Opcode',5, 'QueueCommand',0);
end 

payload = zeros(1,15) ;  
payload(1) = Short2Payload( str.Queue2Load) ; 
payload(2) = Short2Payload( str.EntryInQueue) ; 
payload(3) = Short2Payload( str.Opcode) ; 
%payload(4:15) = 0; 

str = struct('OpCode',2 ,'Payload',payload ) ; 

msg = BuildHostSciString( str.Payload , str.OpCode  ) ; 

end 