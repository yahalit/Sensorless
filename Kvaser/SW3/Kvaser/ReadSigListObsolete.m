function sList = ReadSigList( fname )
fi = fopen( fname,'r')  ; 
sList = []; 
cnt = 0 ; 
while (1) 
    s = fgets( fi ) ; 
    if isequal ( s, -1) 
        break ; 
    end 
    if cnt == 0 
        cnt = 1 ; 
        continue ; 
    end
    
    place = strfind( s ,'{') ; 
    place2 = strfind( s ,',') ; 
    flagsnum = str2num( strtrim ( s( place+1:place2-1)) )  ;  %#ok<ST2NM>
    flags = struct ( 'IsFloat' , 0 , 'IsShort' , 0 , 'IsUnsigned' , 0 , 'IsNoWrite' , 0 ); 
    
    if  bitget( flagsnum , 2 )
        flags.IsFloat = 1 ; 
    else
        if bitget( flagsnum , 3 )
            flags.IsUnsigned = 1 ; 
        end 
        if bitget( flagsnum , 4 )
            flags.IsShort = 1 ; 
        end 
    end 
    if bitget( flagsnum , 5 )
        flags.IsNoWrite = 1 ; 
    end 
    
    place = strfind( s ,'//') ; 
    if length( place) ~= 1 
        error ( 'Signal comment not found') ; 
    end 
    s = s( place+2:end) ;
    
    place = strfind( s ,':') ; 
    if length( place) ~= 1 
        error ( 'Signal descriptor not found') ; 
    end 
    next = str2num( s(1: place) );  %#ok<ST2NM>
    if ( next ~= cnt ) 
        error ( 'Error in signal numbers') ; 
    end
    NextCell = { flags , strtrim(s(place+1:end)) }; 
    if isempty ( sList )
        sList = {NextCell }; 
    else
        sList = [sList ,{NextCell} ] ;  %#ok<AGROW>
    end 
    cnt = cnt + 1 ; 
end
fclose( fi) ; 
end

