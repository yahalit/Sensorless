function d = dydt( y , t )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
d = ( y(3:end) - y(1:end-2) ) ./ ( t(3:end) - t(1:end-2) ) ; 
d = d(:) ; d = d' ; 
d = [d(1) , d , d(end) ] ; 


end

