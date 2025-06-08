function [msg] = BuildTunnelMessage( Payload ) 

OpCode = 4;
msg = BuildHostSciString( Payload , OpCode  ) ; 

end 