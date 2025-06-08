global DataType 
global comport 
SendObj( [hex2dec('2220'),110] , hex2dec('1234') , DataType.long , 'Set RS485 to test mode' ) ;

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

uiwait( msgbox('Connect the RS485 to RS485#1 connector, press OK when ready') ) ; 

s = serialport(comport,115200);
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
if  isequal( kaka, [98,99,100]+1)
    disp('PORT RS485#1 tested with success') ; 
else
    disp('PORT RS485#1 tested and failed with shame') ; 
end 

uiwait( msgbox('Connect the RS485 to RS485#2 connector, press OK when ready') ) ; 
delete(s) ;
s = serialport(comport,57600);

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
if  isequal( kaka, [98,99,100])
    disp('PORT RS485#2 tested with success') ; 
else
    disp('PORT RS485#2 tested and failed with shame') ; 
end 
delete(s) ;
 
