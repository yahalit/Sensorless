function [y,y2] = mad4(x)

    a = min ( x(1),x(2)) ; 
    b = max ( x(1),x(2)) ;  
    c = min( max ( x(3),b),x(4)) ; 
    b = min ( x(3),b); 
    
    d = max(b,c) ; 
    b = max( min(b,c), a ) ;  
    y = (d+b) * 0.5 ; 

x = sort(x) ; 
y2 = mean( x(2:3));
