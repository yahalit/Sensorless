global DataType
global SciStream

try
    classSciStream = class(SciStream) ;
catch
    classSciStream = [] ; 
end
if isequal(classSciStream, 'internal.Serialport') 
    delete(SciStream) ; 
end

ports = serialportlist ;
if isempty( ports )
    error('No COM port found')  ; 
end

if length( ports) == 1 
    comport = ports{1} ; 
else
    comport = GetComPort ;
end

SendObj( [hex2dec('2004'),111] , 6289 , DataType.short , 'Set RS485 to test mode' ) ;

uiwait( msgbox('Connect the RS485 to RS485 - DYN12 connector, press OK when ready') ) ; 

SciStream = serialport(comport,115200);
set(SciStream,'Timeout',0.1) ; 

flush(SciStream) ; 

pause(1) ; 
nb = SciStream.NumBytesAvailable; 
if  nb < 8  
    kaka = [] ; 
else
    kaka = read( SciStream , SciStream.NumBytesAvailable , 'uint8');
end 
if  ~isempty(kaka) && all ( char(kaka) == 'b') % isequal( kaka, [98,99,100])
    disp('PORT RS485#  DYN12 tested with success') ; 
else
    disp('PORT RS485# DYN12 tested and failed with shame') ; 
end 

uiwait( msgbox('Connect the RS485 to RS485 # DYN124 connector, press OK when ready') ) ; 

flush(SciStream) ; 

pause(1) ; 
nb = SciStream.NumBytesAvailable; 
if  nb < 8  
    kaka = [] ; 
else
    kaka = read( SciStream , SciStream.NumBytesAvailable , 'uint8');
end 
if  ~isempty(kaka) && all ( char(kaka) == 'a') % isequal( kaka, [98,99,100])
    disp('PORT RS485#  DYN24 tested with success') ; 
else
    disp('PORT RS485# DYN24 tested and failed with shame') ; 
end 
 
