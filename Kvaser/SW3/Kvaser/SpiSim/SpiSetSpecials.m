function [str,reply] = SpiSetSpecials( stype , pars , DoTx ) 
% function [str,reply] = SpiSetSpecials( stype , DoTx ) 
% Enter a special thing, always as first entry of the motion queue
% Arguments: 
% stype: 'Lassie': Shelf go find 
% pars : Struct of parameters. For Lassie: 'Dir' : 1 for forward, -1 for reversem 'Height' , shelf height in m 


if ( nargin < 2 ) 
    DoTx = 1 ; 
end 

if ( isequal(stype,'Lassie') ) 
    mode = 1 ; 
    if ~isfield(pars,'Dir') || ~(abs(pars.Dir)==1) 
        error('Direction specification for Lassie absent or bad') ; 
    end 
    if ~isfield(pars,'Height') || pars.Height < 0.2 ||  pars.Height > 50 
        error('Height specification for Lassie absent or bad') ; 
    end 
elseif isequal(stype,'SetHeight')
    mode = 2 ; 
    if ~isfield(pars,'Height') || pars.Height < 0.2 ||  pars.Height > 50 
        error('Height specification for Lassie absent or bad') ; 
    end 
elseif isequal(stype,'SetHeightRot')
    mode = 3 ; 
    if ~isfield(pars,'Height') || pars.Height < 0.2 ||  pars.Height > 50 
        error('Height specification for Lassie absent or bad') ; 
    end 
else    
    error('Unknown mode for special command') ; 
end 



cmd = struct ('OpCode', 2, 'QOpCode' , 2 , 'QIndex' , 1 ,'EntryIndex' , 0 ,'Mode', mode ) ; % Just get a status report
if ~isempty(pars) 
    cmd = MergeStruct( cmd , pars  ); 
end


[str,reply] = SendSpiSim( cmd ,0 , DoTx  ); 