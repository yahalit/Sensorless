function x = SetNumResolution(y,d)
% function x = SetNumResolution(y,d)
% Set the numerical resolution of a number
% y: Source number to be truncated 
% d: Number of decimal digits to keep 
% (if d<0, use abs(d) as an absolute scale, otherwise d sets the number of significands) 

if nargin < 2
    d = 3 ; 
end

if abs(y) < 1e-18
    % Too small number, just kill it 
    x = 0 ; 
    return 
end

if ( d < 0 ) 
    d = -d ; 
    y = floor( y * 10^d)/10^d; 
end

if ( abs(y) < 2 * eps)
    x = 0 ;
else
    f = floor( log10(abs(y))); 
    x = round(y / 10^(f-d)) * 10^(f-d) ; 
end

end


