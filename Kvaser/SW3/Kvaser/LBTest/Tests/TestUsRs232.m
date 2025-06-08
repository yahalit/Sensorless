% val = KvaserCom( 8 , [1536+124 ,1408+124 ,hex2dec('2205') ,1,DataType.float,0,100] ); % Get records
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,hex2dec('2205') ,3,DataType.short,0,100], bitand(cnt,1) ); % The character 121
if stat , error ('Sdo failure') ; end 
val = KvaserCom( 8 , [1536+124 ,1408+124 ,hex2dec('2205') ,3,DataType.short,0,100] ); % Get records


