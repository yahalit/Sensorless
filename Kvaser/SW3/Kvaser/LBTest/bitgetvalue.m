function z = bitgetvalue(x,y)
    y = y-1 ; 
    mask = sum(2.^y ) ; 
    x = x + 2^32 ;
    z = bitand( x , mask ) / 2^min(y) ; 
end
