function [lsw,hsw] = TwoShorts( x ,s) 
if nargin < 2 
    s = 0 ; 
end 
if x < 0 
    x = x + 2^32 ; 
end 
lsw = mod( x , 65536 ); 
hsw = fix( x / 65536 ) ; 

if ( s) 
    if lsw > 32767 
        lsw = lsw - 65536 ; 
    end 
    if hsw > 32767 
        hsw = hsw - 65536 ; 
    end
end