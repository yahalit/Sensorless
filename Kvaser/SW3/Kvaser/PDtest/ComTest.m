global TargetCanId 
disp( 'Running RS422 communication test for SCIA') ;
val1 = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2102') ,120,DataType.long,0,100] ); 

val2 = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2102') ,121,DataType.long,0,100] ); 
if ( val1 == 120 || val2 == 121 ) 
    disp('RS422 spare (SCIA) test PASSED' ) ; 
else
    disp('RS422 spare (SCIA) test FAILED' ) ; 
end 

disp( 'Running DISC1 - DISC2 test') ;
for expcnt = 1:3 , 
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),15,DataType.short,0,100], 1 ); % Set on  
    bs1 = GetBitStatus( ) ; 
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),15,DataType.short,0,100], 0 ); % Set off
    bs2 = GetBitStatus( ) ; 
    if ( bs1.Disc1 == 1 && bs1.Disc2 == 1 && bs2.Disc1 == 0 && bs2.Disc2 == 0 ) 
        disp('Discrete lines Disc1 and Disc2 test PASSED' ) ; 
    else
        disp('Discrete lines Disc1 and Disc2 test FAILED' ) ; 
    end 

    disp( 'Running RS485 MAN/STOP test') ;
    val1 = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2102') ,1,DataType.long,0,100] ); 
    if ( val1 == 524288 ) 
        disp( 'RS485 MAN/STOP test   PASS') ; 
        break  ; 
    end
end 
if ~( val1 == 524288 ) 
    disp( 'RS485 MAN/STOP test   FAIL') ; 
end 

