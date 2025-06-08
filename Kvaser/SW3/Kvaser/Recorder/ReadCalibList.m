function sList = ReadCalibList( fname   )

fi = fopen( fname,'r')  ; 
sList = []; 
cnt = 0 ; 
while (1) 
    s = fgets( fi ) ; 
    if isequal ( s, -1) 
        break ; 
    end 
    sOrig = s ; 
    if cnt == 0 
        cnt = 1 ; 
        continue ; 
    end
    
    place = strfind( s ,'{') ; 
    place2 = strfind( s ,',') ; 
    flagsnum = str2num( strtrim ( s( place(1)+1:place2(1)-1)) )  ;  %#ok<ST2NM>
      
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
    if length( place(1)) ~= 1 
        continue ; % error ( 'Signal comment not found') ; 
    end 
    s = s( place(1)+2:end) ;
    
    place = strfind( s ,':') ; 
    if isempty( place)
        error ( ['Signal descriptor not found [',sOrig,']']) ; 
    end 
    place = place(1) ; 
    next = str2num( s(1:place-1) );  %#ok<ST2NM>
    if ( next ~= cnt ) 
        error ( ['Error in signal numbers, expected [',num2str(cnt),'], found [',num2str(next),']']) ; 
    end

    % Find help commentary 
    placebr1 = strfind( s ,'{') ; 
    placebr2 = strfind( s ,'}') ; 
    if isempty(placebr1) 
        helpstr = 'No help available' ; 
    else
        if ( placebr1 < 3 || isempty(placebr2) || length(placebr1)~=1 || length(placebr2)~=1 || placebr2 < placebr1+2 ) 
            error ( ['Format error in signal descriptor:', s  ]); 
        end 
        helpstr = s(placebr1+1:placebr2-1)  ; 
        s = s(1:placebr1-1) ; 
    end 
    
    
    % Find group 
    placebr1 = strfind( s ,'[') ; 
    placebr2 = strfind( s ,']') ; 
    if isempty(placebr1)  
        groupstr = 'General' ; 
    else
        if ( placebr1 < 3 || isempty(placebr2) || length(placebr1)~=1 || length(placebr2)~=1 || placebr2 < placebr1+2 ) 
            error ( ['Format error in signal descriptor:', s  ]); 
        end 
        groupstr = s(placebr1+1:placebr2-1)  ; 
        s = s(1:placebr1-1) ; 
    end 
    
    NextCell = { flags , strtrim(s(place+1:end)) , groupstr , helpstr , cnt }; 
    if isempty ( sList )
        sList = {NextCell }; 
    else
        sList = [sList ,{NextCell} ] ;  %#ok<AGROW>
    end 
    cnt = cnt + 1 ; 
end
fclose( fi) ; 
end

