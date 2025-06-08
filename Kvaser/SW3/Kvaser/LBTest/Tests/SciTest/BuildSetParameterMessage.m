function [msg,str] = BuildSetParameterMessage( str ) 

if nargin < 1 
    str = struct('CommandIndex',0,'CommandSubindex',1,'nData',1,'Value',10) ;
end 

payload = zeros(1,6) ;  
payload(1) = Short2Payload( str.CommandIndex) ; 
payload(2) = Short2Payload( str.CommandSubindex) ; 
payload(3) = Short2Payload( str.nData) ; 
payload(5:6) = Long2Payload( str.Value) ; 

str = struct('OpCode',12 ,'Payload',payload ) ; 

msg = BuildHostSciString( str.Payload , str.OpCode  ) ; 

end 