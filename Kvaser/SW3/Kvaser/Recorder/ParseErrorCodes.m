function Codes = ParseErrorCodes( fname , IsDft ) 

if nargin < 2 
    IsDft = 0 ; 
end 

Codes = [] ; 
fi = fopen ( fname , 'r' ) ; 
if isequal(fname,-1) 
    errordlg({'Error description file',fname,'Not found'}) ; 
    return ; 
end

Codes = struct ('Code', zeros(1,1000) , 'Formal' , {cell(1,1000)}, 'ErrClass' , {cell(1,1000)} , ...
    'Group',  {cell(1,1000)} , 'Fatality', {cell(1,1000)} , 'Description', {cell(1,1000)})  ; 

group = 'Undefined' ; 
ind = 0 ; 
TabSizeMax = 1000 ; 
for cnt = 1:TabSizeMax 
    str = fgets(fi) ; 
    if cnt <= 2
        continue ; 
    end 
    
% #define exp_shilgum_yozgot 0x7000 // [General:Fatal] {Something terribly wrong with the software} 
    if strfind( str, '#define') 
        if ( IsDft )
            [code, formal , errclass , fatality , description ] = ParseErrorLineDFT(str) ; 
        else
            [code, formal , errclass , fatality , description ] = ParseErrorLine(str) ; 
        end
        ind = ind+ 1  ;
        if ind >= TabSizeMax 
            error ('Table exhausted, increse table size') ; 
        end
        
        Codes.Code(ind) = code ;
        Codes.Formal{ind} = formal ; 
        Codes.ErrClass{ind} = errclass ; 
        Codes.Group{ind} = group ; 
        Codes.Fatality{ind} = fatality ; 
        Codes.Description{ind} = description ; 
    else 
        if  ~IsDft
            if length( str) > 2 && isequal(str(1:2),'//' ) 
                try 
                    group = GetBrak(str(3:end),'[',']' ) ; 
                catch 
                    disp( ['Line:  ',num2str(cnt),' Failed to parse: ',str]) ; 
                end
            end 
        end
    end 
    
    if isequal( str, -1) 
        break; 
    end 
end
ind = 1:ind ; 
Codes.Code = Codes.Code(ind); 
[Codes.Code,ind] = sort(Codes.Code) ; 


Codes.Formal  =Codes.Formal(ind) ;
Codes.Group = Codes.Group(ind) ; 
Codes.Fatality = Codes.Fatality(ind) ; 
Codes.Description = Codes.Description(ind) ; 
Codes.ErrClass = Codes.ErrClass(ind) ; 

% Order the codes ...


fclose(fi) ;

end 

function n = ReadNum( str ) 
    if length(str) > 2 && ( isequal( str(1:2) , '0x' ) || isequal( str(1:2) , '0X' )) 
        n = hex2dec(str(3:end)) ; 
    else
        n = str2num( str ) ;  %#ok<ST2NM>
    end 
end 

function str = GetBrak ( str , b1 , b2  ) 
p1 = strfind( str,b1 ) ; 
p2 = strfind( str,b2 ) ; 
if length(p1) ~= 1 || length(p2) ~= 1 || p2 < p1+2  
    error ( 'Too many or bad delimiters')  ;
end 
str = str(p1+1:p2-1) ; 
end 

function  [code, formal , errclass , fatality , description ] = ParseErrorLine(str)
try 
    munk = strfind( str,'//') ;  
    p = strsplit(str(1:munk(1)-1) ) ; 
    formal = p{2}  ; 
    code   = ReadNum(p{3} ) ; 
    
    junk   = GetBrak(str(munk(1)+2:end),'[',']' )  ; 
    junk = strsplit(junk,':') ; 
    errclass = junk{1} ; 
    fatality = junk{2} ; 
    description = GetBrak(str(munk(1)+2:end),'{','}' )  ;   
catch 
    error (['Could not decode error string [', str,']' ] ) ; 
end 
end 


function  [code, formal , errclass , fatality , description ] = ParseErrorLineDFT(str)
try 
    description = 'No description' ; 
    munk = strfind( str,'//') ; 
    if ~isempty(munk)  
       p = strsplit(str(1:munk(1)-1) ) ; 
       try 
            description = strtrim( str( munk(1)+2:end) )  ; 
       catch 
            description = 'No description' ; 
       end 
    else
       p = strsplit(str) ;
    end 
    
    formal = p{2}  ; 
    p3 = strtrim(p{3} ) ; 
    if ( p3(end) == 'L' || p3(end) == 'l' ) 
        p3(end) = [] ; 
    end 
    code   = ReadNum(p3 ) ; 
    
    errclass = 'UnSupported' ; 
    fatality = 'Fatal' ; 
catch 
    error (['Could not decode error string [', str,']' ] ) ; 
end 
end 


