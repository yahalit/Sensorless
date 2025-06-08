function rslt = MergeStruct( str1 , str2 , TestInclude  )
% function rslt = MergeStruct( str1 , str2  )
% Merge two structs, atr1 and str2. 
% If TestInclude is specified, str2 may not include new fields. 
% All the fields of either str1 or str2 shall be present at the result. 
% When a field exists both sides, the value in str2 shall govern. 
% Yahali 

n = fieldnames(str2) ;

if nargin >= 3 && TestInclude
    n1 = fieldnames(str1) ;
    sd = setdiff( n , n1  ); 
    if ~isempty( sd ) 
        celldisp( sd) ; 
        error ( 'str2 included ilegal fields ') ; 
    end 
end 

rslt = str1 ; 
for cnt = 1:length(n) 
    rslt.(n{cnt}) = str2.(n{cnt}); 
end 

end

