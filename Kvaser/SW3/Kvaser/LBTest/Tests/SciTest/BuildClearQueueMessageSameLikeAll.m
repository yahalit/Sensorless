function [msg,str] = BuildClearQueueMessageSameLikeAll( str ) 

if nargin < 1 
    str = struct('Index',1);
end 

payload = zeros(1,1) ;  
payload(1) = Short2Payload( str.Index) ; 

str = struct('OpCode',1 ,'Payload',payload ) ; 

msg = BuildHostSciString( str.Payload , str.OpCode  ) ; 

end 