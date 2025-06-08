function x = ShuffleLong(y) 
y1 = mod(y,256) ; 
y = ( y - y1 ) / 256 ; 
y2 = mod(y,256) ; 
y = ( y - y2 ) / 256 ; 
y3 = mod(y,256) ; 
y4 = ( y - y3 ) / 256 ; 
x = [y1+y2*256+y3*65536+y4*2^24];
