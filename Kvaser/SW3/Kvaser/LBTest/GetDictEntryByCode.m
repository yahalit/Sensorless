function [str,code] = GetDictEntryByCode( dict , code )
place = find ( [dict.Code]==code , 1) ; 
if isempty( place ) 
    str = ['unknown meaning for ',num2str(code) ]  ; 
else
    str = dict(place).Label ;
end

