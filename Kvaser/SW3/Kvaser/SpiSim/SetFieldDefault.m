function x = SetFieldDefault( str , fname , value )
% function x = SetFieldDefault( str , fname , value )
% if str is a struct and has a field str.fname, return str.fname. 
%   otherwise, return value 
if isempty(str) || ~isa( str , 'struct') || ~isfield( str , fname ) 
    x = value ; 
else
    x  = str.(fname); 
end 

end

