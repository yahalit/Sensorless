function [msg,str] = BuildTunnelPacketMessage( str ) 
%not ready. need to write it.
if nargin < 1 
    str = struct('Content',0);
end 

% payload = zeros(1,7) ;  
% payload(1) = Short2Payload( str.Operation) ; 
% payload(2) = Short2Payload( str.Side) ; 
% payload(3:4) = Long2Payload( str.PackageDepth) ; 
% payload(5:6) = Long2Payload( str.XOffset) ; 
% payload(7) = Short2Payload( str.Incidence) ; 

str = struct('OpCode',4 ,'Payload',payload ) ; 

msg = BuildHostSciString( str.Payload , str.OpCode  ) ; 

end 