% IntegrateOverSteps : Computes step-wise averaged values of structure fields between discrete changes
% in a specified control or step variable.
%
% r = IntegrateOverSteps(rx, field)
%
% This function segments the input record `rx` into intervals defined by
% changes in the specified step field `field`. For each interval, all
% non-scalar fields (except `field` itself) are averaged over that range.
%
% **Inputs**
% - `rx` — Structure containing at least:
%   - a vector field `t` (time stamps),
%   - a scalar sampling interval `Ts`,
%   - and a step-defining field (specified by `field`) whose discrete
%     changes determine integration boundaries.
% - `field` — Name of the field in `rx` used to detect step transitions.
%
% **Outputs**
% - `r` — Structure with the same fields as `rx`, but where each
%   non-scalar field (except the step field) is replaced by a vector of
%   averaged values, one per step interval.
%


function r = IntegrateOverSteps( rx , field   )
    r = rx ; 

    if ~isfield( r , field ) 
        error('Interpolation field is not found') ; 
    end
    if ~isfield( r , 't' ) || ~isfield( r , 'Ts' )
        error('Time field or sampling time are absent') ; 
    end

    f = fieldnames(r) ; 
    d = find( diff( r.(field) ) ); 
    nd = length(d) ; 
    if nd < 2 
        error('Not enough steps to integrate') ; 
    end
    
    n = length( r.t) ;

    for cnt = 1:numel(f)
        nextName = f{cnt};
        if ~isscalar( r.(nextName)) && ~strcmp(nextName,field)   
            r.(nextName) = zeros(1,nd-1);
            for c1 = 1:nd-1 
                r.(nextName)(c1) = mean(rx.(nextName)(d(c1):(d(c1+1)-1)) )  ; 
            end
        end
    end
end

