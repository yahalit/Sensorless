function [logamp,phdeg]  = G2DbDeg(g , startphasedeg )
% function [logamp,phdeg]  = G2DbDeg(g , startphasedeg )
% Get the db and degrees of a transfer function 
% g : Transfer function complex samples 
% startphasedeg (default=0): Initial guess for starting phase (deg), to resolve 360*n ambiguity 
    logamp = 20 * log10(abs(g(:))); 
    a = angle(g(:)) ;
    
    if nargin < 2 || isempty(startphasedeg) 
        startphasedeg = 0 ; 
    end 
    phdeg = unwrap( [startphasedeg * pi / 180 ; a])  * 180 / pi; 
    phdeg = phdeg(2:end) ; 
end