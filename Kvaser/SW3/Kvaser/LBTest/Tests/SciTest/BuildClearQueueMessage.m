function [msg,str] = BuildClearQueueMessage( Qindex  ) 

payload = Qindex ;  
str = struct('OpCode',1 ,'Payload',payload ) ; 

msg = BuildHostSciString( str.Payload , str.OpCode  ) ; 

end 