function type = GetDataType(typeid)
% function type = GetDataType(typeid)
% Get the DataType structure, or part thereof. 
% GetDataType() returns the DataType struct 
% GetDataType(type) , with type in {'long','float','short' ,'string','fvec','ulvec'}, returns the code specific to that type.


str = struct( 'long' , 0 , 'float', 1 , 'short' , 2 , 'char' , 3 ,'string', 9 ,'lvec' , 10 ,'fvec' , 11 , 'ulvec' , 20 ) ; 
if nargin 
    type = str.(typeid) ; 
else
    type = str ; 
end 

end