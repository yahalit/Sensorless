%InterpolateSteps Linearly smooths transients following steps in a field.
%   r = INTERPOLATESTEPS(rx, field, td) scans rx.(field) for sample-to-sample
%   changes (i.e., "steps"). For every detected step at index k, it linearly
%   interpolates ALL non-scalar fields of the struct rx (except the step field)
%   on the index window k : min(k+⌊td/rx.Ts⌋+1, end), replacing the original
%   values with a ramp from the window's first value to its last value.
%
%   This is useful for “smoothing out” the immediate jump after a known step
%   (e.g., a set-point change) so that other signals align with a gradual
%   transition rather than a hard discontinuity.
%
%   Inputs
%   ------
%   rx    : struct with at least:
%             .t   - time vector (length N)
%             .Ts  - scalar sample time in seconds (>0)
%             .(field) - vector used to detect steps (length N)
%           Can contain other fields (vectors length N, matrices with size
%           N along their first dimension, or scalars). Scalars are preserved.
%   field : char/string. Name of the field in rx where steps are detected.
%   td    : nonnegative scalar (seconds). Duration of the post-step region
%           to be interpolated for each detected step.
%
%   Output
%   ------
%   r     : struct, same as rx but with non-scalar fields (except rx.(field))
%           linearly interpolated over the post-step windows.
%


function r = InterpolateSteps( rx , field , td )

    r = rx ; 

    if ~isfield( r , field ) 
        error('Interpolation field is not found') ; 
    end
    if ~isfield( r , 't' ) || ~isfield( r , 'Ts' )
        error('Time field or sampling time are absent') ; 
    end

    f = fieldnames(r) ; 
    d = find( diff( r.(field) ) ); 
    trange = td/r.Ts ; 
    if trange < 1 
        return ; 
    end

    trange = trange  + 1 ; 
    n = length( r.t) ;

    for cnt = 1:numel(f)
        nextName = f{cnt};
        if ~isscalar( r.(nextName)) && ~strcmp(nextName,field)   
            for c1 = 1:length(d) 
                ind = d(c1):min(n,d(c1)+trange) ; 
                r.(nextName) = InterpolateInd( r.(nextName) , ind ) ; 
            end
        end
    end
end

function y = InterpolateInd( x , ind) 

    y = x ; 
    if length(ind) < 3
        return ; 
    end
    ystart = y(ind(1));
    yend   =  y(ind(end));
    if  abs(yend-ystart) > 1e-8 
        y(ind) = ystart:(yend-ystart)/(length(ind)-1):yend ; 
    end
end
