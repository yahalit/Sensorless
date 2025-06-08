function [pl,opcode,target] = GetUdpPayload(cntr,r,emod,exptype )
% Arguments
% cntr : Counter to compare that the response is indeed for the request 
% r    : Byte stream of accepted message 
% emod : expected modulo of net payload length ( not including opcode/target and cs) 
if nargin < 3
    emod = 4 ; 
end
if nargin < 4 
    exptype = 1 ; 
end 

pl = [] ; opcode = [] ; target = [] ; 
if length(r) < 6
    return ; % Not even a preamble - nothing to do 
end 

MsgType         = double(r(1)) ; 
MsgCounter      = double(r(3)) + double(r(4)) * 256 ;
PayloadSize     = length(r) - 2  ;

if ~(MsgType==exptype) || ~(MsgCounter==cntr) || (PayloadSize < 8 ) 
    return ; % Formals failed 
end

cs1 = sum(r(1:2:end)) ; 
cs2 = sum(r(2:2:end)) ; 
if mod( cs1 + 256 * cs2 ,  65536 )
    return ; % Checksum failed 
end 

opcode = double(r(1)) ; 
target = double(r(2)) ; 
PayloadSize = PayloadSize - 4 ; 
if mod(PayloadSize,emod)
    return ; % Expected 32bit fields 
end 

pl = uint8(r(5:PayloadSize+4)); 

end 