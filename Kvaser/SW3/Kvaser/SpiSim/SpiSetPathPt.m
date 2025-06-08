function [str,reply,errcode] = SpiSetPathPt( Qindex , EntryIndex , X , cx , DoTx ) 
% function [str,reply] = ( Qindex , EntryIndex , X , cx , DoTx ) 
% Set a path way point in a queue via the SPI interface 
% Index,SubIndex: The multiplexor of the addressed object 
% Qindex                 : Index of target queue
% EntryIndex        : Entry within one queue
% Old option: 
%   X        : Spatial vector
%   cx        : Direction cosines
% New option: 
%   X        : struct('X','cx','TrackWidth') 
%   cx       : absent or empty 
% DoTx (def = 1)       : If set , transmit. Otherwise, only translate
% message request to binary. 
% Returns: 
% str : Message to send, in binary
% reply: accepted message, in binary 
errcode = [] ; 
if ( nargin < 5 ) 
    DoTx = 1 ; 
end

DefautTrackWidth = 0.502 ; 
IgnoreJunction   = 0 ; 
if isstruct(X) 
    if nargin > 3 && ~isempty(cx) 
        error('Either X , cx specification or struct(''X'',''cx'',''TrackWidth'')') ; 
    end
    if isfield(X,'TrackWidth')
        Protocol = 1 ; 
        TrackWidth = X.TrackWidth ;
        if isfield(X,'IgnoreJunction')
            IgnoreJunction =  X.IgnoreJunction ;
        end
    else
        Protocol = 0 ; 
        TrackWidth = DefautTrackWidth ;
    end
        
    cx         = X.cx ; 
    X          = X.X  ; 
else
    if length(X) < 4 
        Protocol = 0 ; 
        TrackWidth    = DefautTrackWidth ; 
    else
        Protocol = 1 ; 
        TrackWidth    = X(4) ; 
        if length(X) >= 5 
            IgnoreJunction =  X(5) ;
        end 
    end
        
end

cmd = struct ('OpCode', 2 ,'QIndex', Qindex ,'EntryIndex',EntryIndex, 'QOpCode' , 1 , 'X' , X(1), 'Y' , X(2), 'Z' , X(3) , 'cx' , cx(1) , 'cy' , cx(2) , 'cz' , cx(3) ,...
    'Protocol',Protocol,'TrackWidth',TrackWidth,'IgnoreJunction',IgnoreJunction)  ; % Just get a status report
[str,reply,errcode] = SendSpiSim( cmd ,0 , DoTx  ); 

if ~isempty( errcode ) 
    error (errcode) ; 
end 
