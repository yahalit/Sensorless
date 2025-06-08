function LedBrightness ( x ) 

global DataType
if ( x < 0 || x > 255 ) 
    error ('Led brightness range is 0..255') ; 
end 

SendObj( [hex2dec('2203'),23] , fix(x) , DataType.long , 'Led brightness' ) ;

