% val = KvaserCom( 8 , [1536+124 ,1408+124 ,hex2dec('2205') ,1,DataType.float,0,100] ); % Get records

disp('Testing RPB SPI communication lines ... ') ;
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,hex2dec('2205') ,5,DataType.short,0,100], 4668 ); % 0
if stat , error ('Sdo failure') ; end 
val = KvaserCom(  8 , [1536+124 ,1408+124 ,hex2dec('2205') ,5,DataType.short,0,100] ); % Get records
if ( val == 4668 ) 
    disp( 'Testing SPI MISO MOSI transmission PASS') ; 
else
    disp( 'Testing SPI MISO MOSI transmission FAIL') ; 
end 

disp('Testing console RS232, D1 and D2 ... ') ;

stat = KvaserCom( 7 , [1536+124 ,1408+124 ,hex2dec('2205') ,3,DataType.short,0,100], 0 ); % 0
if stat , error ('Sdo failure') ; end 
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,hex2dec('2205') ,4,DataType.short,0,100], 0 ); % 0
if stat , error ('Sdo failure') ; end 
val1 = KvaserCom( 8 , [1536+124 ,1408+124 ,hex2dec('2205') ,3,DataType.short,0,100] ); % Get records

if ( val1 == 0 ) 
    disp( 'Testing RS232, D1 and D2 and DBG1 at low level PASS') ; 
else
    disp( 'Testing RS232, D1 and D2 and DBG1 at low level FAIL') ; 
end 

stat = KvaserCom( 7 , [1536+124 ,1408+124 ,hex2dec('2205') ,3,DataType.short,0,100], 1 ); % 1
if stat , error ('Sdo failure') ; end 
val1 = KvaserCom( 8 , [1536+124 ,1408+124 ,hex2dec('2205') ,3,DataType.short,0,100] ); % Get records

stat = KvaserCom( 7 , [1536+124 ,1408+124 ,hex2dec('2205') ,3,DataType.short,0,100], 0 ); % 0
if stat , error ('Sdo failure') ; end 
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,hex2dec('2205') ,4,DataType.short,0,100], 1 ); % 0
if stat , error ('Sdo failure') ; end 
val2 = KvaserCom( 8 , [1536+124 ,1408+124 ,hex2dec('2205') ,3,DataType.short,0,100] ); % Get records

if ( val1 == 5 && val2 == 2) 
    disp( 'Testing RS232, D1 and D2 and DBG1 at high level PASS') ; 
else
    disp( 'Testing RS232, D1 and D2 and DBG1 at high level FAIL') ; 
end

uiwait( msgbox( 'Set the RESET switch to RESET' , 'Please','modal')) ;
stat1 = KvaserCom( 7 , [1536+124 ,1408+124 ,hex2dec('2205') ,3,DataType.short,0,100], 0 ); % 0

uiwait( msgbox( 'Set the RESET switch to NORMAL' , 'Please','modal')) ;
pause(0.1) ; 
stat2 = KvaserCom( 7 , [1536+124 ,1408+124 ,hex2dec('2205') ,3,DataType.short,0,100], 0 ); % 0

if ( stat1 < 0 && stat2 >= 0 ) 
    disp( 'Testing reset line PASS') ; 
else
    disp( 'Testing reset line FAIL') ; 
end
    


