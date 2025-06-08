fi = fopen( 'StructDef.h')

structLevel = 0 ; 
for LineCnt = 1:1000000
    next = fgets( fi) ; 
    if isequal( next,-1) 
        fclose( fi) ; 
        break ; 
    end 
    
    % Strip any comments 
    
    next = strtrim(next);
    if isempty(next) || next(1) == ';' 
        continue ; 
    end 
    
    place = strfind( next,';' ) ; 
    if ~isempty(place) 
        next = next( 1:place-1) ; 
    end 
    next = split(next,'') ; 
    
    if structLevel == 0  
    end 
    
end 
