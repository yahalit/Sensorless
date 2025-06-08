function [errcode ,rxstr] =VerifyAck(rxstr,newdata,opcode)

global SciConfig
% str = struct('Payload',[],'Next',a,'TxCtr',[],'OpCode',[],'TimeTag',[],'Odd',0) ; 
rxstr=DecomposeMessage(rxstr,newdata); 
if ~( length(rxstr.Payload ) == 3 ) 
    errcode = -1 ; 
    return ; 
end 

if ~isequal(SciConfig.txMessageCtr, rxstr.Payload(1) ) 
    errcode = -2 ; 
    return ; 
end 

if nargin >= 3 
    if ~isequal(opcode, rxstr.OpCode)  
        errcode = -3 ; 
        return ; 
    end 
end

errcode =  rxstr.Payload(2) + 65536 * rxstr.Payload(3) ;
