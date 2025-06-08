% function z = GetBitField(x,y) 
% Extract a bit field of an integer 
% x: Integer to extract from 
% y: List of bits, e.g. 2:4
% format (default: n = numeric) can also be 'd' for decimal string and 'x' for hex string 
% sn (default=0 , 1, interpret as a signed nyumber , 0: Unsigned) 
% Example: GetBitField( 6 ,2:3, 'n',0 ) yields 3 
function z = GetBitField(x,y,format , sn ) 
    if nargin < 4 || isempty(sn) 
        sn = 0 ; 
    end
    if any(x < 0 )
        ind = find(x < 0 ) ;
        x(ind)  = x(ind) + 2^32 ; 
    end 
    junk = 2.^(0:(length(y)-1));
    ord = 2^(length(y)-1) ; 

    z = x ; 
    
    for cnt = 1:length(z) 
        zz = bitget(x(cnt),y) ;
        zz = sum( zz.* junk) ; 
        if sn 
            if zz > ord 
                zz = zz - 2 * ord ; 
            end 
        end 
        z(cnt) = zz ; 
    end
    
    if nargin >= 3 && isa( format,'char') && ~(format=='n') 
        format = lower(format) ; 
        zz = z ; 
        z = cell(size(zz)) ; 
        if isequal( format,'d') 
            if ( length(z) == 1 ) 
                z = num2str(zz) ;
            else
                
                for cnt = 1:length(z) 
                    z{cnt} = num2str(zz(cnt)) ; 
                end 
            end
        elseif isequal( format,'x') 
            if ( length(z) == 1 ) 
                z = ['0x',dec2hex(zz)] ;
            else
                for cnt = 1:length(z) 
                    z{cnt} = ['0x',dec2hex(zz(cnt))] ; 
                end
            end 
        end 
    end
end

