function x = GetfDebuf()
global DataType
x = zeros(1,24) ; 
for cnt = 1:24
    x(cnt) = FetchObj( [hex2dec('2222'),cnt-1] , DataType.float ,'fdebug var') ;
end
end