function [str,code] = GetDictEntry( dict , num , shift , mask )
if nargin < 3 
    code = num ; 
else
    code = GetCode( num , shift , mask )  ; 
end 
place = find ( [dict.Code]==code , 1) ; 
if isempty( place ) 
    str = ['unknown meaning for ',num2str(code) ]  ; 
else
    str = dict(place).Label ;
end

