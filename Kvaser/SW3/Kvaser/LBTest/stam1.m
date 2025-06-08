global DataType ;
global TargetCanId2 

% speed = 0 ; 
% w =-0 ; 
% SendObj( [hex2dec('220a'),1] , 1 , DataType.long ,'ignore tout') ;
% SendObj( [hex2dec('220a'),100] , speed , DataType.float ,'mode speed') ;
% SendObj( [hex2dec('220a'),101] , w , DataType.float ,'mode w') ;

SendObj( [hex2dec('2103'),7,TargetCanId2] , hex2dec('1234') , DataType.long ,'Motor off') ;
SendObj( [hex2dec('2103'),10,TargetCanId2] , 1 , DataType.long ,'Motor on') ;
SendObj( [hex2dec('2209'),120,TargetCanId2] , 0.1 , DataType.float ,'Line Speed') ;
x = 0 ; 
SendObj( [hex2dec('2103'),12,TargetCanId2] , x , DataType.float ,'Relative motion') ;

