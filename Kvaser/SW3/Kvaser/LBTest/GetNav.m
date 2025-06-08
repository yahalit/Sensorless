function s = GetNav(  )
global DataType
s = struct ( 'LastPositionItemX' , FetchObj( [hex2dec('2221'),25] , DataType.float , 'LastPositionItemX' ) ) ; 
s.LastPositionItemY  = FetchObj( [hex2dec('2221'),26] , DataType.float , 'LastPositionItemY' ) ;
s.LastPositionItemZ  = FetchObj( [hex2dec('2221'),27] , DataType.float , 'LastPositionItemZ' ) ;

s.Xbase  = FetchObj( [hex2dec('2221'),20] , DataType.float , 'Xbase' ) ;
s.Ybase  = FetchObj( [hex2dec('2221'),21] , DataType.float , 'Ybase' ) ;
s.LeaderHight  = FetchObj( [hex2dec('2221'),22] , DataType.float , 'LeaderHight' ) ;
s.xc0 = GetSignal('Robotxc0') ; 
s.xc1 = GetSignal('Robotxc1') ; 
s.xc2 = GetSignal('Robotxc2') ; 
s.ShelfMode = GetSignal('ShelfMode') ; 
s.ShelfSubMode = GetSignal('ShelfSubMode') ; 


end

function x = ulong(x) 
    x = bitand( x + 2^32 , 2^32 -1 ); 
end

function z = bitgetvalue(x,y) 
    z = bitget(x,y) ; 
    junk = 2.^(0:(length(z)-1));
    z = sum( z.* junk) ; 
end

function c = motorcur(x,y)
c = bitgetvalue(x,y:y+5) ; 
if ( c > 31 ) 
    c = c - 64 ; 
end
end

