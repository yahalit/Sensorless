function str = BuildHostSciString( strIn , OpCode  ) 

global SciConfig 

% SciConfig = struct('Comport', 8 ,'BaudRate' , 232400  ) ; 
%  
% s = serialport(['COM',num2str(SciConfig.Comport)],SciConfig.BaudRate);
% SciConfig.s = s ; 
% 
% 
% SpiSetPosRpt( X , Azimuth , Mode , DoTx ) 
% s = serialport("COM8",232400);
% set( s , 'DataBits', 8, 'StopBits' , 1, 'Parity' , 'none' ,'FlowControl','none','Timeout',1 ) ; 
% write(device,1:5,'uint8')

ind = find( strIn < 0 ) ; 
if ~isempty(ind) 
    strIn(ind) = strIn(ind)  +65536 ; 
end 
if any(strIn < 0)  || any(strIn >= 65536)  
    error('Input string is out of range') ; 
end

lenIn = length( strIn) ; 

str = zeros(1,lenIn+7) ; 
str(1) = hex2dec('ac13') ; 
SciConfig.txMessageCtr = SciConfig.txMessageCtr + 1 ; 
str(2) = SciConfig.txMessageCtr; 
str(3) = OpCode ; 

nowtime = bitand( fix( toc(SciConfig.startTime) * 1e6 ) ,2^31-1 ) ; 
str(4+(0:1)) = DecompLong(nowtime) ;
str(6) = lenIn * 2 ;  % As Olivier transmits length in bytes 

str(7:7+lenIn-1) = strIn ; 


str1 = str ; 
str  = zeros(1,length(str1)*2) ; 
str(1:2:end) = bitand( str1, 255 ) ; 
str(2:2:end) = ( str1 - str(1:2:end) ) / 256 ; 

% Last, do the checksum 
cs1 = sum(str(1:2:end)) ; 
cs2 = sum(str(2:2:end)) ; 
cs  = bitand( 2^30-(cs1 + 256 * cs2), 65535 ); 
str(end-1) = mod(cs,256)  ;
str(end)   = (cs-str(end-1))/256 ; 


end 