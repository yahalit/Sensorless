SendObj( [hex2dec('2220'),63,124] ,1 , DataType.float , 'Set gyro to stabilize' ) ;


%Gyro Rel
SendObj( [hex2dec('2208'),248,30],0.0015,DataType.float ) ; 

%  Relative gain 
SendObj( [hex2dec('2208'),249,30],0.45,DataType.float ) ; 


%  Error limit 
SendObj( [hex2dec('2208'),250,30],0.08,DataType.float ) ; 
