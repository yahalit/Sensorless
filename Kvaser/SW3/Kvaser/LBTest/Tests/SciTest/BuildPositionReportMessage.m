function [msg,str] = BuildPositionReportMessage( str ) 

if nargin < 1 
    str = struct('X',0.1,'Y',0.1,'Z',0.1, 'Azimuth' , 0, 'TimeTag', 1000, 'ReportType' , 0) ;
end 

payload = zeros(1,10) ;  
payload(1:2) = Long2Payload( str.X) ; 
payload(3:4) = Long2Payload( str.Y) ;
payload(5:6) = Long2Payload( str.Z) ;
payload(7) = Short2Payload( str.Azimuth) ;
payload(8:9) = Long2Payload( str.TimeTag) ; %tume tag should idealy be equal to the header timetag; didnt check it here.
payload(10) = Short2Payload( str.ReportType) ;

str = struct('OpCode',11 ,'Payload',payload ) ; 

msg = BuildHostSciString( str.Payload , str.OpCode  ) ; 

end 