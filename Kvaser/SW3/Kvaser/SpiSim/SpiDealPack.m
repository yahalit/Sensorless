function [str,reply] = SpiDealPack( QIndex,EntryIndex, cmd , DoTx ) 


if ( nargin < 4 ) 
    DoTx = 1 ; 
end 

cmd = struct ('OpCode',2 ,'QIndex',QIndex,'EntryIndex',EntryIndex, 'QOpCode' , 4, ...
    'ActionLoad', cmd.ActionLoad , 'Side' , cmd.Side , 'PackageDepth' , cmd.PackageDepth ,'PackageXOffset' , cmd.PackageXOffset , ...
    'Incidence' , cmd.Incidence ) ; % Just get a status report


[str,reply] = SendSpiSim( cmd ,0 , DoTx  ); 