function [str,reply] = SpiClearQueue( qind , DoTx ) 


if ( nargin < 2 ) 
    DoTx = 1 ; 
end 

if ( qind > 65535 ||  qind < 0 ) 
    error ( 'Ilegal queue index')  ; 
end 

spicmd = struct ('OpCode', 1, 'QIndex' , qind  ) ; % Just get a status report
[str,reply] = SendSpiSim( spicmd ,0 , DoTx  ); 