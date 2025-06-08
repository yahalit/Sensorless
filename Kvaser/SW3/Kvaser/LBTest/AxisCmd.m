% Useless test file 

global DataType

SendObj( [hex2dec('2206'),1] , 11000 , DataType.long , 'Speed W right' ) ;
SendObj( [hex2dec('2206'),2] , 11000 , DataType.long , 'Speed W left' ) ;
SendObj( [hex2dec('2206'),3] , 11000 , DataType.long , 'Speed S right' ) ;
SendObj( [hex2dec('2206'),4] , -11000 , DataType.long , 'Speed S left' ) ;
SendObj( [hex2dec('2206'),5] , 5000 , DataType.long , 'Speed Neck' ) ;

