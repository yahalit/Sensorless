function bytes = Num2Bytes(f,Dtype)
global DataType ; %#ok<GVMIS> 


switch Dtype 
    case DataType.float
        bytes = typecast(single(f),'uint8') ; 
    case DataType.long
        if f >= 2^31
            bytes = typecast(uint32(f),'uint8') ; 
        else
            bytes = typecast(int32(f),'uint8') ; 
        end
    case DataType.short
        if f > 32767 
            bytes = typecast(uint16(f),'uint8') ; 
        else
            bytes = typecast(int16(f),'uint8') ; 
        end
    case DataType.char
        bytes = uint8(char(f));
    case DataType.string
        bytes = uint8(f) ; 
        m1 = ceil( length(bytes) / 8 );
        bytes1 = uint8(zeros(1,m1*8)) ; 
        bytes1(1:length(bytes)) = bytes ; 
        bytes = bytes1 ;
    otherwise
        error('This function only deals with numeric types') ; 
end

if length( bytes ) < 4 
    bout = zeros(1,4);
    bout(1:length(bytes)) = bytes ; 
    bytes = bout ;
end


end


