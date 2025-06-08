% Test fine motion 
dist = 0.6 ; 
SendObj( [hex2dec('2207'),62] , dist , DataType.float , 'Set fine motion command' ) ;

SendObj( [hex2dec('2220'),35] , 0 , DataType.long , 'Disable further drift compensation ' ) ;
SendObj( [hex2dec('2220'),34] , 0 , DataType.long , 'Initialize raw yaw report ' ) ;
