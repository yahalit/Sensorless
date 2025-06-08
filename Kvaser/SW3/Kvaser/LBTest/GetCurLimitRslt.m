I2tVal = struct('I2tRslt',zeros(1,5),'BeanCnt',zeros(1,5),'RtCnt',zeros(1,5),'Bin1',zeros(1,8)) ; 
I2tVal.I2tRslt(1) = FetchObj( [hex2dec('2226'),29] , GetDataType('float'), 'Get parameter') ;
I2tVal.I2tRslt(2) = FetchObj( [hex2dec('2226'),30] , GetDataType('float'), 'Get parameter') ;
I2tVal.I2tRslt(3) = FetchObj( [hex2dec('2226'),31] , GetDataType('float'), 'Get parameter') ;
I2tVal.I2tRslt(4) = FetchObj( [hex2dec('2226'),32] , GetDataType('float'), 'Get parameter') ;
I2tVal.I2tRslt(5) = FetchObj( [hex2dec('2226'),33] , GetDataType('float'), 'Get parameter') ;

for cnt = 1:5
    u = FetchObj( [hex2dec('2226'),41+cnt] , GetDataType('long'), 'Get parameter') + 2^32 ;
    I2tVal.BeanCnt(cnt) = bitand( fix( u / 2^16  ), 65535 ); 
    I2tVal.RtCnt(cnt) = mod( fix( u ), 65535 ); 
end

for cnt = 1:8 
    I2tVal.Bin1(cnt) = FetchObj( [hex2dec('2226'),33+cnt] , GetDataType('float'), 'Get parameter')  ;
end
