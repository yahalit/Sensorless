function [msg,str] = BuildConfigurationMessage( BitPeriod , StatusPeriod, TravelInfoPeriod, RCVersion, Permission ) 

if nargin < 5 
    Permission = 0 ; 
end 
if nargin < 4 
    RCVersion = 0 ; 
    Permission = 0;
end 
if nargin < 3
    TravelInfoPeriod = 0 ;
end
    
payload = zeros(1,6) ;  
payload(1:2) = Long2Payload(RCVersion) ; 
payload(3) = Short2Payload(StatusPeriod*100) ;
payload(4) = Short2Payload(BitPeriod*100) ;
payload(5) = Short2Payload(TravelInfoPeriod*100) ;
payload(6) = Short2Payload(Permission) ;

str = struct('OpCode',14 ,'Payload',payload ) ; 

msg = BuildHostSciString( str.Payload , str.OpCode  ) ; 

end 