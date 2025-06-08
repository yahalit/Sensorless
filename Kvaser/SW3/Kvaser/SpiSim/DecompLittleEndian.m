function sh = DecompLittleEndian( x , bytes )
% function sh = DecompLittleEndian( x )
% Decompose a little endian bytes

if ( x < 0 ) 
    x = x + 2^32 ; 
end

byte0 = mod( x, 256) ;
x = (x-byte0) / 256 ; 
byte1 = mod( x, 256) ; 

switch ( bytes) 
    case 2
        sh = [byte0, byte1]  ; 
    case 4
        x = (x-byte1) / 256 ; 
        byte2 = mod( x, 256) ; 
        x = (x-byte2) / 256 ; 
        byte3 = mod( x, 256) ; 
        sh = [byte0, byte1,byte2, byte3]  ; 
    otherwise
        error('Bytes should be 2 or 4 ') ; 
end

end

