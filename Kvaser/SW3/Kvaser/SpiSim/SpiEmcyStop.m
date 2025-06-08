function [str,reply] = SpiEmcyStop( DoTx ) 


if ( nargin < 2 ) 
    DoTx = 1 ; 
end 

cmd = struct ('OpCode',7   ) ; % Just get a status report
[str,reply] = SendSpiSim( cmd ,0 , DoTx  ); 