function THISCARD = ReadWhoIsThisProject(fname) 
% function THISCARD = ReadWhoIsThisProject(fname) : Read project identifier from a source file 

fh = fopen(fname,'r') ; 
if isequal( fh , -1)
    error ( ['File : ',fname,' Could not be opened']); 
end

while 1 
    str = fgets( fh) ;
    if isequal( str , -1 )
        break ; 
    end
    parts = strsplit( str , ' ') ; 
    cmd = strtrim(parts{1}) ; 
    if length(parts) >= 3 && isequal(cmd,'#define') 
        eval( [strtrim(parts{2}),'=',strtrim(parts{3}),';']) ;
        if exist('THISCARD','var') 
            fclose(fh) ;
            return ;  
        end
    end
end
fclose(fh) ; 

error('Could not evaluate THISCARD') ;


end

