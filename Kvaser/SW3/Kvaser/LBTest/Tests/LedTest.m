
AtpStart 
global DataType

Order = [1 5 7 2 4 8 3 6 9] ; 

SendObj( [hex2dec('2203'),15] , 1 , DataType.short , 'Inhibit LED automation' ) ;

for  cnt = 1: 9  
    NextLed = Order(cnt) ; 
    SendObj( [hex2dec('2203'),NextLed] , 25  , DataType.short , 'Turn LED on ' ) ;

    pause (0.5) 
    SendObj( [hex2dec('2203'),NextLed] , 1 , DataType.short , 'Turn LED off ' ) ;
    pause( 0.5) ; 
end
