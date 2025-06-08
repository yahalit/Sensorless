function motor(state,CanId)
DataType = GetDataType() ;
if nargin < 2
    SendObj([hex2dec('2220'),4],double( logical(state)) ,DataType.long,'Set motor enable/disable') ;
else
    SendObj([hex2dec('2220'),4,CanId],double( logical(state)) ,DataType.long,'Set motor enable/disable') ;
end 