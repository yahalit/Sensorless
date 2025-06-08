function s = GetEncoders() 

global DataType 
s = struct() ;

s.RsteerPotRad = FetchObj( [hex2dec('2204'),30] , DataType.float ,'RsteerPotRad') ;
s.LsteerPotRad = FetchObj( [hex2dec('2204'),31] , DataType.float ,'LsteerPotRad') ;

s.NeckPotRad = FetchObj( [hex2dec('2204'),32] , DataType.float ,'NeckPotRad') ;
s.NeckPotDiffRad = FetchObj( [hex2dec('2204'),33] , DataType.float ,'NeckPotDiffRad') ;

s.RSteerPosEnc = FetchObj( [hex2dec('2204'),40] , DataType.float ,'RSteerPosEnc') ;
s.LSteerPosEnc = FetchObj( [hex2dec('2204'),41] , DataType.float ,'LSteerPosEnc') ;
s.NeckPosEnc = FetchObj( [hex2dec('2204'),42] , DataType.float ,'NeckPosEnc') ;
