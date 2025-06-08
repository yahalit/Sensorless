global DataType 
global comport
uiwait( msgbox('Connect the the USB connector to host COMM, press OK when ready') ) ; 

SendObj( [hex2dec('2220'),114] , 1234 , DataType.long , 'Set HOST USB to test mode' ) ;

ports = serialportlist ; 
if isempty( ports )
    error('No COM port found')  ; 
end

if length( ports) == 1 
    comport = ports{1} ; 
else
    h = GetComPort ;
    while( isvalid( h ) ) ; pause(0.1)  ; end 
end


s = serialport(comport,115200*2);
set(s,'Timeout',0.1) ; 

flush(s) ; 
write(s,'a','uint8'); 
pause( 0.1); 
write(s,'b','uint8'); 
pause( 0.1); 
write(s,'c','uint8'); 
pause( 0.1); 

if ~( s.NumBytesAvailable == 3 ) 
    kaka = [] ; 
else
    kaka = read( s , s.NumBytesAvailable , 'uint8');
end 
if  isequal( kaka, [97,98,99])
    disp('Host port tested with success') ; 
else
    disp('Host port tested and failed with shame') ; 
end 

delete(s) ;
 
