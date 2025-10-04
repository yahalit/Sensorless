function DefTable = ReadDefFile(fname,WhoIsThisProject) 
% function DefTable = ReadDefFile(fname,WhoIsThisProject) Get project #define variables from source h file

DefTable  = struct( 'Name' ,[],'Value',[])  ;  
DefSize  = 0 ; 
DefNames = cell(0,1) ; 
ReadState = zeros(1,100) ; 
ReadState(1) = 1; 
IfNesting = 1 ; 

if nargin < 2 
    WhoIsThisProject = [] ; %#ok<NASGU> 
else
    THISCARD = WhoIsThisProject ; %#ok<NASGU> 
end

fh = fopen(fname,'r') ; 
if isequal( fh , -1)
    error ( ['File : ',fname,' Could not be opened']); 
end

while 1 
    str = fgets( fh) ;
    if isequal( str , -1 )
        break ; 
    end


    if ( contains(str,'//'))
        place = strfind( str,'//');
        str = str ( 1:place-1) ; 
    end 
    str = strtrim(str) ; 
    if ~startsWith(str,'#')
        continue ;
    end 

    parts = strsplit( str , ' ') ; 
    cmd = strtrim(parts{1}) ; 
    if isequal(cmd,'#endif') 
       IfNesting = IfNesting - 1 ; 
       if ( IfNesting <= 0 ) 
           error('Unexpected #if close') ; 
       end
       continue ; 
    end
    
    if length( parts) < 2 
        arg = strtrim(parts{1}) ;
        if isequal(cmd,'#else') 
            ReadState(IfNesting)  = double(~logical(ReadState(IfNesting)))  ; 
        end
        continue ;
    end 
    
    arg = strtrim(parts{2}) ; 

    switch cmd
        case '#ifndef'
            IfNesting = IfNesting + 1 ; 
            if any( strcmp(DefNames,arg) )
                ReadState(IfNesting)  = 0 ; 
            else
                ReadState(IfNesting) = 1 ; 
            end 
        case '#ifdef'
            IfNesting = IfNesting + 1 ; 
            if any( strcmp(DefNames,arg) )
                ReadState(IfNesting)  = 1 ; 
            else
                ReadState(IfNesting) = 0 ; 
            end 
        case '#if'
            value = eval( str(4:end) ); 
            IfNesting = IfNesting + 1 ; 
            if value
                ReadState(IfNesting)  = 1 ; 
            else
                ReadState(IfNesting) = 0 ; 
            end 
                
        case '#define'
            if ReadState(IfNesting)
                if any( strcmp(DefNames,arg) )
                    error(['Mnemonic : ',arg,' Redefined']) ;
                end
                DefSize = DefSize+1; 
                DefTable(DefSize).Name = arg ; 
                if length( parts) > 2 
                    if length( parts) > 3
                        error(['string : ',str,' more than 3 parts']) ;
                    end 
                    val = strtrim(parts{3}) ; 
                    ppp = strfind (val,'f'); 
                    ppp = ppp( ppp > 1 ) ;
                    if ~isempty(ppp) 
                        ppp = ppp( val(ppp-1) >= '0' & val(ppp-1) <= '9'); 
                        val(ppp) = [] ; 
                    end
                    try 
                        eval([arg,'=',val,';']) ; 
                        value = eval(arg) ; 
                    catch 
                        value = [] ; 
                    end 

                    DefTable(DefSize).Value = value ; 
                end 
                DefNames = [DefNames, {arg} ] ; %#ok<AGROW> 
            end
    end 


end 
if ~ (IfNesting==1) 
    error ('Unclosed #if nesting') ; 
end

fclose(fh) ;


end 