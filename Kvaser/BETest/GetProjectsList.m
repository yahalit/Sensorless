function list = GetProjectsList( srcDir) 
%function list = GetProjectsList( srcDir) : Get the list of supported projects from constDef.h file 

srcFile = [srcDir,'ConstDef.h']; 
f = fopen(srcFile,'r') ; 
if isequal(f,-1)
    error(['Could not find file: ',srcFile]) ; 
end

list = [] ; 
state = 0; 
projvec = string(zeros(1,100)) ; 
nProj =  0 ; 
while 1
    str = fgets(f) ; 
%     disp(str) ; 
    if isequal(str,-1) 
        fclose(f) ; 
        error(['Could not find good project list info in file: ',srcFile]) ; 
    end
    str = strtrim(str) ; 
    s = strsplit(str) ; 
    if ~isequal(s{1},'#define') 
        continue ; 
    end 
    switch state 
        case 0
            if isequal(s{2},'PROJ_TYPE_UNDEFINED') 
                state = 1 ; 
            end    
        case 1
            if ~ (length(s) >= 3)
                error(['Bad project record [',str,'] in file: ',srcFile]) ; 
            end

            if isequal(s{2},'PROJ_TYPE_LAST') 
                if ~isequal(nProj+1,str2num(s{3})) %#ok<ST2NM> 
                    error(['Project last record number is incorrect [',str,'] in file: ',srcFile]) ;                     
                end
                
                fclose(f) ; 
                list = projvec(1:nProj) ; 
                return  ; 
            else
                nProj = nProj + 1 ; 
                if ~isequal(nProj,str2num(s{3})) %#ok<ST2NM> 
                    error(['Project record number out of sequence [',str,'] in file: ',srcFile]) ;                     
                end
                projvec(nProj) = s{2} ; 
            end   
    end
end 

end 