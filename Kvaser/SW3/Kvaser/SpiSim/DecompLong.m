function sh = DecompLong( x )
% function sh = DecompLong( x )
% Decompose a long integer to its low and high words
% sh = [low word , high word] 
if ( x < 0 )
    if ( x < -2^31 ) 
        error ('Cannot take large negative numbers' ) ; 
    end
    x = x + 2^32 ; 
end 
x = fix(x) ; 
sh = [ mod(x,65536) , mod( fix( x / 65536) , 65536 ) ]; 
end

