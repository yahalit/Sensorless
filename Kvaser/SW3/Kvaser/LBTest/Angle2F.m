function y = Angle2F(x) 
x = mod( x, 65536 ) ; 
if ( x >= 32768 ) 
    x = x - 65536 ; 
end 
y = x * pi / 32768 ; 

