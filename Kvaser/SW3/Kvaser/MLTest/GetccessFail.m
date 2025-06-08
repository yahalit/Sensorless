global DataType 

s = struct (); 
s.x =  FetchObj( [hex2dec('2102'),2] , DataType.float , 'BIT status' ) ;
s.y =  FetchObj( [hex2dec('2102'),3] , DataType.float , 'BIT status' ) ;
s.theta =  FetchObj( [hex2dec('2102'),4] , DataType.float , 'BIT status' ) ;
s.dtarget =  FetchObj( [hex2dec('2102'),5] , DataType.float , 'BIT status' ) ;
s.side =  FetchObj( [hex2dec('2102'),6] , DataType.long , 'BIT status' ) ;
s.code =  FetchObj( [hex2dec('2102'),7] , DataType.long , 'BIT status' ) ;
s.ytarget =  FetchObj( [hex2dec('2102'),8] , DataType.float , 'BIT status' ) ;

