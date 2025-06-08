
function Rated = GetCurLimits() 
Rated = struct('Cont',zeros(1,5),'PeakRatio',zeros(1,5)) ; 
Rated.Cont(1) = FetchObj( [hex2dec('2226'),19] , GetDataType('float'), 'Get parameter') ;
Rated.Cont(2) = FetchObj( [hex2dec('2226'),20] , GetDataType('float'), 'Get parameter') ;
Rated.Cont(3) = FetchObj( [hex2dec('2226'),21] , GetDataType('float'), 'Get parameter') ;
Rated.Cont(4) = FetchObj( [hex2dec('2226'),22] , GetDataType('float'), 'Get parameter') ;
Rated.Cont(5) = FetchObj( [hex2dec('2226'),23] , GetDataType('float'), 'Get parameter') ;
Rated.PeakRatio(1) = FetchObj( [hex2dec('2226'),24] , GetDataType('float'), 'Get parameter') ;
Rated.PeakRatio(2) = FetchObj( [hex2dec('2226'),25] , GetDataType('float'), 'Get parameter') ;
Rated.PeakRatio(3) = FetchObj( [hex2dec('2226'),26] , GetDataType('float'), 'Get parameter') ;
Rated.PeakRatio(4) = FetchObj( [hex2dec('2226'),27] , GetDataType('float'), 'Get parameter') ;
Rated.PeakRatio(5) = FetchObj( [hex2dec('2226'),28] , GetDataType('float'), 'Get parameter') ;
end 
