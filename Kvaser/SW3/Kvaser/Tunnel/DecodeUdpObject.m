function [Status,Data] = DecodeUdpObject(cntr,Dtype,r)
% Arguments
% cntr : Counter to compare that the response is indeed for the request 
% Dtype: Expected data type, per the DataType struct 
% r    : Byte stream of accepted message 
global DataType ; %#ok<GVMIS> 
Status = -5*ones(size(Dtype)) ; Data = [] ; 
[pl,opcode] = GetUdpPayload(cntr,r,4) ; 
if isempty( pl) || ~(opcode==1)
    return ; 
end
% retType = fix(opcode/16) ; 

nmsg = length(pl)  / 8 ;
if ~(length(Dtype)==nmsg) 
    return ; % Data type not specified uniquely for every item 
end 


Status = zeros(1,nmsg) ; Data = zeros(1,nmsg) ; 

for cnt = 1:nmsg
    Status(cnt) = typecast(uint8(pl((1:4)+(cnt-1)*8)), 'uint32'); 
    if ~Status(cnt) % Get ok 
        switch Dtype 
            case DataType.char 
                Data(cnt) = typecast(pl(1+4+(cnt-1)*8), 'uint8'); 
            case DataType.short  
                Data(cnt) = typecast(pl((1:2)+4+(cnt-1)*8), 'int16'); 
            case DataType.long 
                Data(cnt) = typecast(pl((1:4)+4+(cnt-1)*8), 'int32'); 
            case DataType.float 
                Data(cnt) = typecast(pl((1:4)+4+(cnt-1)*8), 'single'); 
        end        
    end 
end













