function x = mod2piS( y )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
x = mod( y , 2*pi ) ; 
if x >= pi 
    x = x - 2 * pi ; 
end 
if x < -pi 
    x = x + 2 * pi ; 
end 

end

