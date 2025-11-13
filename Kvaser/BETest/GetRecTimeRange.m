%% GetRecTimeRange
% Extracts a subset of a record structure whose time values fall within a specified range.
%
% r = GetRecTimeRange(rx, trange)
%
% This function filters the fields of the input structure `rx` based on the
% time field `rx.t`. Any samples with time values outside the range `trange`
% are removed from all non-scalar fields of `rx`.
%
% **Inputs**
% - `rx` — Structure containing at least a time field `t` (vector) and
%   possibly other fields with data of the same length.
% - `trange` — 1×2 numeric vector `[t_min, t_max]` defining the inclusive
%   lower and upper time bounds.
%
% **Outputs**
% - `r` — Structure identical to `rx` but with all non-scalar fields reduced
%   to entries whose time values are within the specified range.
%
% **Behavior**
% - If all `rx.t` values are within `trange`, the function returns immediately.
% - Only non-scalar fields are filtered (scalars are left untouched).
%
% **Example**
% ```matlab
% rx.t = 0:0.1:10;
% rx.data = sin(rx.t);
% trange = [2 5];
% r = GetRecTimeRange(rx, trange);
% % r.t and r.data now contain only samples between t = 2 and t = 5
% ```
%
% **See also:** find, fieldnames, isempty, isscalar
function r = GetRecTimeRange( rx , trange  )
ind = find( rx.t < trange(1) | rx.t > trange(2) ) ;

r = rx ; 
if isempty(ind) 
    return ; 
end

f = fieldnames(r) ; 
for cnt = 1:numel(f)
    if ~isscalar( r.(f{cnt}))  
        r.(f{cnt})(ind) = [] ; 
    end
end

