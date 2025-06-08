junk  = KvaserCom( 8 , [1536+124 ,1408+124 ,8194,29,DataType.float,0,100] ) 

stat = KvaserCom( 7 , [1536+124 ,1408+124 ,8194,29,DataType.float,0,100],1 ); % Recorder gap 
if stat , error ('Sdo failure') ; end 
