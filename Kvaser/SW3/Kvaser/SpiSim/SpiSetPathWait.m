function [str,reply] = SpiSetPathWait( Qindex , EntryIndex , waitTime , DoTx ) 
% [str,reply] = SpiSetPathWait( Qindex , EntryIndex , wait , DoTx )
% Set a wait entry to a queue via the SPI interface 
% Index,SubIndex: The multiplexor of the addressed object 
% Qindex                 : Index of target queue
% EntryIndex        : Entry within one queue
% waitTime        : Wait time, inf for wait forever = queue termination 
% DoTx (def = 1)       : If set , transmit. Otherwise, only translate
% message request to binary. 
% Returns: 
% str : Message to send, in binary
% reply: accepted message, in binary 

if ( nargin < 4 ) 
    DoTx = 1 ; 
end


if ( nargin < 3 ) 
    waitTime = inf ; 
end

cmd = struct ('OpCode', 2 ,'QIndex', Qindex ,'EntryIndex',EntryIndex, 'QOpCode' , 5 , 'WaitLen' , waitTime )  ; % Just get a status report
[str,reply] = SendSpiSim( cmd ,0 , DoTx  ); 