function [msg,str] = BuildStartManualModeMsg( ) 

str = struct('OpCode',20 ,'Payload',[] ) ; 

msg = BuildHostSciString( str.Payload , str.OpCode  ) ; 

end 