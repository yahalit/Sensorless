function x = Long2Payload( a ) 
a = round( min( max( a, -2147483648),4294967295))  ; 
if a < 0 
    a = a + 4294967296 ; 
end 

x = zeros(1,2) ; 
x(1) = mod(a,65536 ) ; 
x(2) = ( a - x(1)) / 65536 ; 
end