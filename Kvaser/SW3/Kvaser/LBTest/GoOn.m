global DataType  %#ok<GVMIS> 
FetchObj( [hex2dec('2222'),28]  , DataType.long, 'Get SysState.Debug.bWaitUser : GoOn' ) 

Anakuku
SendObj( [hex2dec('2222'),20] , 0 , DataType.long, 'SysState.Debug.bWaitUser : GoOn' ) ;

SendObj( [hex2dec('2220'),119] , 1 , DataType.long, 'Set wheel inversion' ) ;

