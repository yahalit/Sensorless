function [str,reply] = SpiChangeMode( Qindex , EntryIndex , Cmd , DoTx ) 
% function [str,reply] = SpiChangeMode( Qindex , EntryIndex , X , cx , DoTx ) 
% Set a path way point in a queue via the SPI interface 
% Index,SubIndex: The multiplexor of the addressed object 
% Qindex                 : Index of target queue
% EntryIndex        : Entry within one queue
% X        : Spatial vector
% cx        : Direction cosines
% DoTx (def = 1)       : If set , transmit. Otherwise, only translate (1 to
% Matlab, 2 through CAN to system) 
% message request to binary. 
% Returns: 
% str : Message to send, in binary
% reply: accepted message, in binary 

if ( nargin < 4 ) 
    DoTx = 1 ; 
end

Yew = Cmd(1) ; 
RotateCmd = Cmd(2) ; 
IsClimb = Cmd(3) ; 

cmd = struct ('OpCode', 2 ,'QIndex', Qindex ,'EntryIndex',EntryIndex, 'QOpCode' , 3 , ...
    'Yew' , Yew , 'RotateCmd' , RotateCmd, 'IsClimb' ,IsClimb )  ; 
[str,reply] = SendSpiSim( cmd ,0 , DoTx  ); 