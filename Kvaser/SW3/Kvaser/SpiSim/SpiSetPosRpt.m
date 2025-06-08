function [str,reply] = SpiSetPosRpt( X , Azimuth , Mode , DoTx ) 
% function [str,reply] = ( Qindex , EntryIndex , X , cx , DoTx ) 
% Set a parameter via the SPI interface 
% Index,SubIndex: The multiplexor of the addressed object 
% X        : Spatial vector
% Azimuth        : Direction w.r.t. x 
% DoTx (def = 1)       : If set , transmit. Otherwise, only translate
% message request to binary. 
% Returns: 
% str : Message to send, in binary
% reply: accepted message, in binary 

if ( nargin < 4 ) 
    DoTx = 1 ; 
end
if ( nargin < 3 ) 
    Mode = 0 ; 
end
%Azimuth = -Azimuth;  %  Vandal to cover Olivier's ass 
cmd = struct ('OpCode', 11 , 'X' , X(1), 'Y' , X(2), 'Z' , X(3) , 'Tht' , Azimuth ,'TimeTag' , 0 , 'Mode' , Mode )  ; % Just get a status report

%cmd.Tht = cmd.Tht + pi / 2; % Yahali Vandal : Correct for olivier bug in RB 

[str,reply] = SendSpiSim( cmd ,0 , DoTx  ); 