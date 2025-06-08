function [sList,sfull] = ReadCfgList( fname  )

fi = fopen( fname,'r')  ; 
sList = struct() ;  

sfull  = struct( 'Ind', cell(1,256) , 'Name' , [] ,'MinVal',[],'MaxVal',[],'defaultVal',[], 'Description',[],'Flags',[],'Group',[],'Value',[]);  

cnt = 0 ; 
maxind =  1; 

while (1) 
    s = fgets( fi ) ; 
    if isequal ( s, -1) 
        break ; 
    end 
    sOrig = s ; 
%     if cnt == 0 
%         cnt = 1 ; 
%         continue ; 
%     end
    
            
    s = strtrim(s) ; 
    place = strfind( s ,'//') ; 
    if length( place) ~= 1 
        continue ; % error ( 'Signal comment not found') ; 
    end 
    
    if ( place ==1) 
        continue ; % A totally commented line
    end 
    
    % Get the flag 
    flags_str = GetCfgField( s , 'Flags'  , 0);
    if contains(flags_str,'CFG_FLOAT')
        flags = 2 ; 
    else
        flags = 0 ; 
    end 
    if contains(flags_str,'CFG_MUST_INIT')
        flags = flags + 4  ; 
    end 
    if contains(flags_str,'CFG_MUST_AUTO')
        flags = flags + 8  ; 
    end 

    lowerLimit = GetCfgField( s , 'lower'  , 1);
    upperLimit = GetCfgField( s , 'upper'  , 1);
    defaultVal = GetCfgField( s , 'defaultVal'  , 1);
    varname = GetCfgField( s , 'ptr'  , 0); 
    padd = strfind(varname,'&') ; 
    varname = strtrim( varname(padd+1:end) ) ; %#ok<NASGU> 

    varind  = GetCfgField( s , 'ind'  , 1);

    % Work the comment 
    s = s( place+2:end) ;
    
    place = strfind( s ,':') ; 
    if isempty( place)
        error ( ['Signal descriptor not found [',sOrig,']']) ; 
    end 
    place = place(1) ; 

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
    
    NextCell = struct ( 'Ind' ,cnt , 'Group' , groupstr , 'Help' , helpstr ,'Flags',flags); 
    FieldName = strtrim(s(place+1:end)); 

    if isfield(sList,FieldName) 
        error(['File name : ',fname,' Field defined twice :',FieldName]) ; 
    end
    sList.(FieldName)  = NextCell  ; 
    cnt = cnt + 1 ; 

    if nargout > 1 
        sfull(varind+1).Ind = varind ; 
        sfull(varind+1).Name = FieldName ;
        sfull(varind+1).MinVal = lowerLimit  ;
        sfull(varind+1).MaxVal = upperLimit  ;
        sfull(varind+1).defaultVal =  defaultVal  ;
        sfull(varind+1).Flags =  flags  ;
        sfull(varind+1).Description = helpstr ;
        sfull(varind+1).Group = groupstr ;
        maxind = max(varind+1,maxind) ;  
    end 

end
fclose( fi) ; 

sfull = sfull(1:maxind) ;  

end

function val = GetCfgField( s , fld , IsNumber)
    if nargin < 3
        IsNumber = 0 ; 
    end 
    try 
        pf = strfind( s ,['.',fld]) ; 
        sf = s(pf+1:end) ; 
        pf = strfind( sf ,'=') ; 
        sf = sf(pf(1)+1:end) ; 
        pf = strfind( sf ,'}') ; 
        sf = sf(1:pf(1)-1) ; 
        pf = strfind( sf ,',') ; 

        if ~isempty (pf) 
            sf = sf(1:pf(1)-1) ; 
        end 
        
        val = strtrim(sf); 
        if IsNumber
            val = lower(val) ; 
            if endsWith(val,'f')
                val = val(1:end-1) ; 
            end 
            val = str2double(val) ;  
        end
    catch me
        disp(me.message) ;  
        error (['could not read config par: ',fld]) ; 
    end 
end






