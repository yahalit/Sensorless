function [str,reply] = SpiSetParam( Index, SubIndex , Value , Float , nData , DoTx ) 
% function [str,reply] = SpiSetParam( Index, SubIndex , Value , Float , nData , DoTx ) 
% Set a parameter via the SPI interface 
% Index,SubIndex: The multiplexor of the addressed object 
% Value                 : Value to send 
% Float (def=0)        : If the number to send is a floating point number
% nData (def=2)        : Number of valid bytes in Value
% DoTx (def = 1)       : If set , transmit. Otherwise, only translate
% message request to binary. 
% Returns: 
% str : Message to send, in binary
% reply: accepted message, in binary 

if ( nargin < 6 ) 
    DoTx = 1 ; 
end 
if ( nargin < 5 ) 
    nData = 2  ; 
end 
if ( nargin < 4 ) 
    Float = 0  ; 
end 



cmd = struct ('OpCode',12 ,'Index', Index , 'SubIndex' , SubIndex ,'nData',nData,'Value',Value,'Float',0) ; % Just get a status report
[str,reply] = SendSpiSim( cmd ,0 , DoTx  ); 