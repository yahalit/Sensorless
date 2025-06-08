function [msg,str] = BuildDeviationReportMessage( str ) 

if nargin < 1 
    str = struct('Offset',0,'RelAzimuth',0,'TimeTag',1000) ;
end 

payload = zeros(1,4) ;  
payload(1) = Short2Payload( str.Offset) ; 
payload(2) = Short2Payload( str.RelAzimuth) ; 
payload(3:4) = Long2Payload( str.TimeTag) ; %tume tag should idealy be equal to the header timetag; didnt check it here.

str = struct('OpCode',10 ,'Payload',payload ) ; 

msg = BuildHostSciString( str.Payload , str.OpCode  ) ; 

end 
