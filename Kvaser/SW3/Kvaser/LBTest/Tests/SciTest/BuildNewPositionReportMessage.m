function [msg,str] = BuildNewPositionReportMessage( str ) 

if nargin < 1 
    %str = struct('X',0.1,'Y',0.1,'Z',0.1, 'Azimuth' , 0, 'TimeTag', 1000, 'ReportType' , 0) ;
    
    
    %str = struct('X',500,'Y',2,'Z',3, 'Quaternion' , [0.5320,0.7233,0.3919,-0.2006], 'TimeTag', 1000, 'ReportType' , 0) ;
    str = struct('X',500,'Y',2,'Z',3, 'Quaternion' , [0,0,-0.0292727,-0.999571], 'TimeTag', 1000, 'ReportType' , 0) ;
end 

payload = zeros(1,10) ;  
payload(1:2) = Long2Payload( str.X) ; 
payload(3:4) = Long2Payload( str.Y) ;
payload(5:6) = Long2Payload( str.Z) ;
%payload(7:8) = Long2Payload( IEEEFloat(str.Quaternion(1))) ;
%payload(9:10) = Long2Payload( IEEEFloat(str.Quaternion(2))) ; %same for
%Quaternion(3) and Quaternion(4).
payload(7:8) = Long2Payload( (str.Quaternion(1)*2147483647)) ;
payload(9:10) = Long2Payload( (str.Quaternion(2)*2147483647)) ;
payload(11:12) = Long2Payload( (str.Quaternion(3)*2147483647)) ;
payload(13:14) = Long2Payload( (str.Quaternion(4)*2147483647)) ;
payload(15:16) = Long2Payload( str.TimeTag) ; %tume tag should idealy be equal to the header timetag; didnt check it here.
payload(17) = Short2Payload( str.ReportType) ;

str = struct('OpCode',11 ,'Payload',payload ) ; 

msg = BuildHostSciString( str.Payload , str.OpCode  ) ; 

end 