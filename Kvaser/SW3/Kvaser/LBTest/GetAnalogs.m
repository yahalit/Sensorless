function s = GetAnalogs() 
global DataType ;

s = struct() ;

s.NkPot1 =  FetchObj( [hex2dec('2204'),1] , DataType.float , 'NkPot1') ;
s.NkPot2 =  FetchObj( [hex2dec('2204'),2] , DataType.float , 'NkPot2') ;
s.OverLoadkRNk =  FetchObj( [hex2dec('2204'),3] , DataType.float , 'OverLoadkRNk') ;
% s.OverLoadkRSt1 =  FetchObj( [hex2dec('2204'),4] , DataType.float , 'OverLoadkRSt1') ;
% s.OverLoadkRSt2 =  FetchObj( [hex2dec('2204'),5] , DataType.float , 'OverLoadkRSt2') ;
s.OverLoadkRWh1 =  FetchObj( [hex2dec('2204'),6] , DataType.float , 'OverLoadkRWh1') ;
s.OverLoadkRWh2 =  FetchObj( [hex2dec('2204'),7] , DataType.float , 'OverLoadkRWh2') ;
s.SteerPot1 =  FetchObj( [hex2dec('2204'),8] , DataType.float , 'SteerPot1') ;
s.SteerPot2 =  FetchObj( [hex2dec('2204'),9] , DataType.float , 'SteerPot2') ;
s.UsSamp1 =  FetchObj( [hex2dec('2204'),10] , DataType.float , 'UsSamp1') ;
s.UsSamp2 =  FetchObj( [hex2dec('2204'),11] , DataType.float , 'UsSamp2') ;

s.Position1 =  FetchObj( [hex2dec('2204'),20] , DataType.float , 'Position1') ;
s.Position2 =  FetchObj( [hex2dec('2204'),21] , DataType.float , 'Position2') ;

