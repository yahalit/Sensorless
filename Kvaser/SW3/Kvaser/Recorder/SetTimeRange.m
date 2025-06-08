function r = SetTimeRange(r , range, RangeType )

if nargin < 3
    RangeType = 'ind' ; 
end 

if startsWith(lower(RangeType),'t') 
    if length(range) < 2 
        range = [range, max(r.t) ]  ; 
    end
    ind = find( (r.t >= range(1)) & (r.t <= range(2)) ) ; 
else
    if length(range) < 2 
        range = [range, length(r.t) ]  ; 
    end 
    ind = range(1):range(2) ; 
end 
fld = fieldnames(r) ; 
for cnt = 1:length(fld) 
    kuku = r.(fld{cnt}) ; 
    if length(kuku) > 1
        r.(fld{cnt}) =  kuku(ind) ; 
    end 
end

end 
