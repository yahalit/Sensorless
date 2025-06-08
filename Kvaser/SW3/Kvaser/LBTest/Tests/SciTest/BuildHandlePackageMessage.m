function [msg,str] = BuildHandlePackageMessage( str ) 

if nargin < 1 
    str = struct('Operation',0,'Side',1,'PackageDepth',1000,'XOffset',2000,...
        'Incidence',1500) ;
end 

payload = zeros(1,7) ;  
payload(1) = Short2Payload( str.Operation) ; 
payload(2) = Short2Payload( str.Side) ; 
payload(3:4) = Long2Payload( str.PackageDepth) ; 
payload(5:6) = Long2Payload( str.XOffset) ; 
payload(7) = Short2Payload( str.Incidence) ; 

str = struct('OpCode',8 ,'Payload',payload ) ; 

msg = BuildHostSciString( str.Payload , str.OpCode  ) ; 

end 