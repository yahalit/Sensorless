function [t,x1,x2,x3] = GetTrapezeTime( s , v , a , d) 
% function [t,x1,x2,x3] = GetTrapezeTime( s , v , a , d) 
% Get timing information for a trapeze trajectory with given distance (s), speed (v) , acceleration (a) and deceleration (d) 
v = abs(v) ; 
a = abs(a) ; 
d = abs(d) ; 
s = abs(s) ; 
if ( v == 0 || a == 0 || d == 0 )
    error('Cant go with zero speed') ;
end

if s == 0 
    t =  0 ; x1 = 0 ; x2 = 0 ; x3 = 0 ; 
    return ; 
end 

% First try a triangle 
x1 = s*d/(a + d); 
x2 =  0 ; 
x3 = a*s/(a + d); 
v1 = sqrt(2*a*x1) ; 

% Test if triangle is within the speed limits 
if v1 <= v
    t = 2 * sqrt( 2 * x1 / a ); 
    return ;
end

% If not, make a full trapeze 
x1 = v^2/2/a ; 
x3 = v^2/2/d ;
x2 = s - x1 - x3  ; 
t = ( x2 + 2 * ( x1 + x2)) / v ; 

end

