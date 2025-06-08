function x = bitextract(y , mask, shift ) 
x = y ; 
next = (y < 0) ; 
y(next) = y(next) + 2^32 ; 
dshift = 1/(2^shift) ;
for cnt = 1 :length(y) 
    next =fix ( y(cnt) * dshift + 1e-11 )  ;
    
    x(cnt) = bitand( next, mask) ;   
end