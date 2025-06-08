function str = DecodeHallStat(x) 

str = struct( ); 
x = x + 2^32 ; 
str.HallKey = bitand(x,7) ; 
str.HallAngle   = bitand(x,1023 * 2^6 ) / 2^16  ;  
HallValue   = bitand(x,7 * 2^3 ) / 2^3  ;  
ind =  ( HallValue  > 5  ) ; 
HallValue(ind) = -1 ; 
str.HallValue = HallValue ; 
str.Init = bitand(x,2^28)/2^28 ; 
str.CommException= bitand(x,2^29)/2^29 ; 
str.HallException= bitand(x,2^30)/2^30 ; 
str.HallGoodChange = bitand(x,2^31)/2^31 ; 
str.CommAngle = bitand(x,1023*2^16)/2^26 ;
end 