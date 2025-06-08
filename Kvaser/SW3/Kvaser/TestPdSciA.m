success = KvaserCom(1) ; 
DataType=struct( 'long' , 0 , 'float', 1 , 'short' , 2 , 'char' , 3 ,'string', 9 ,'lvec' , 10 ,'fvec' , 11 , 'ulvec' , 20 ) ; 
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,hex2dec('2102'),2,DataType.long,0,100], hex2dec('12345678') ); % Recorder gap 
if stat , error ('Sdo failure') ; end 

