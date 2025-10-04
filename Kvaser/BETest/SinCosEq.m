% Junk calculation 
tht1 = 2 ; 
tht  = 4 ; 
A = 7 ;
m1 = A * cos(tht1);
m2 = A * cos(tht1+2*pi/3);
m3 = A * cos(tht1-2*pi/3);

q = cos(tht) * m1  + cos(tht+2*pi/3) * m2 + cos(tht-2*pi/3) * m3;
d = sin(tht) * m1  + sin(tht+2*pi/3) * m2 + sin(tht-2*pi/3) * m3;

t = tht ; 
m1a = 6.666666666666666e-01 * ( cos(tht) * q + sin(tht) * d ) ; 
m2a = 3.333333333333333e-01 * ( (-sqrt(3)*sin(t) - cos(t)) * q + ( sqrt(3)*cos(t) - sin(t)) * d  )  ; 

m1a / m1 
m2a / m2 
