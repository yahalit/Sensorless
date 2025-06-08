function [str,reply] = SpiQueueExec( qind , qstart , Immediate , DoTx ) 


if ( nargin < 3 ) 
    Immediate = 1 ; 
end 
if ( nargin < 4 ) 
    DoTx = 1 ; 
end 

if ( qind > 65535 ||  qind < 0 ) 
    error ( 'Ilegal queue index')  ; 
end 

cmd = struct ('OpCode', 3, 'QIndex' , qind ,'EntryIndex' , qstart , 'SwitchImmediate' , Immediate ) ; 
[str,reply] = SendSpiSim( cmd ,0 , DoTx  ); 