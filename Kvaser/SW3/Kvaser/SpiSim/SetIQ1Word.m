function u = SetIQ1Word( x )
% function u = SetIQ1Word( x )
% Argument: 
% x : value in [-1:1] 
if ( abs(x) > 1 ) 
    error ( 'IQ1 overflow') ; 
end 

u = round( mod( x , 2) * 32768  ); 

if x > 0 && u > 32767 
    u = 32767 ; 
end 

end

