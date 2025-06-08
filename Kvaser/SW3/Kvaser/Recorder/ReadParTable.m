% function [sList,str] = ReadParTable( fname  , preamb , HwCfgFile, WhoIsThisProject)
% Prepare parameters list 
% The list has 255 items, indiced per the indices in fname. 
% When an index in fname is missing, the associated index in sList is empty
% fname: File to read parameters from 
% preamb : Preambles to append to parameters
% HwCfgFile: Hardware configuration file

function [sList,sfull] = ReadParTable( fname  , preamb ,HwCfgFile,WhoIsThisProject)

if nargin < 2 
    preamb = [] ; 
end 

if nargin > 3
    WhoIsThisProject = [] ; 
end

if nargin >= 3 
    DefTable = ReadDefFile(HwCfgFile,WhoIsThisProject); 
    DefNames = {DefTable.Name} ; 
else
    DefTable = [] ; 
    DefNames = [] ; 
end

fi = fopen( fname,'r')  ; 
if isequal( fi, -1) 
    error (['Cannot open file ', fname]) ; 
end

nprint = 1e6 ; 

sList = struct( 'Ind', cell(1,256) , 'Name' , [] );  
sfull  = struct( 'Ind', cell(1,256) , 'Name' , [] ,'MinVal',[],'MaxVal',[],'Value',[], 'Description',[]);  

sigindices = zeros( 1,256); 

for cntline = 1:100000  
    s = fgets( fi ) ; 
    if isequal ( s, -1) 
        break ; 
    end

    s = strtrim(s) ; 
    if isempty(s) || s(1)=='#'
        continue ; % Empty line or pragma 
    end 

    scomment = [] ; 
    place = strfind( s ,'//') ; 
    if ~isempty(place) 
        scomment = s( place(1)+2:end); 
        s = s( 1 : place(1)-1) ; 
    end 

    if ( fix(cntline/nprint) * nprint == cntline  ) 
        disp( ['Another:', num2str(cntline)] )  ; 
    end
    
    % Remove curly braces 
    placestart = strfind( s ,'{') ; 
    placeend = strfind( s ,'}') ; 
        
    if ~isempty( placestart ) 
        if ~(length(placestart)==1 ) 
            error ( ['Expected single set of {}...', s ] ) ; 
        end 
        if ~(length(placeend)==1 ) 
            error ( ['Expected One termination }...', s ] ) ; 
        end 
        if ( placeend < placestart + 4 ) 
            error ( ['Too short string in  { }...', s ] ) ; 
        end 
        s = s(placestart+1: placeend-1) ; 
    else
        continue ; 
    end    
        
    place2 = strfind( s ,',') ; 
    if ( length(place2) ~= 4 ) 
        error ( ['Expected 4 comma separated terms in  { }...', s ] ) ; 
    end 
    
    try 
        nextind = str2num(s(place2(1)+1:place2(2)-1)) ;  %#ok<*ST2NM>
    catch 
        error ( ['Failed to find signal index in  { }...', s ] ) ; 
    end 
    if nextind < 0 || nextind > 255  
        error ( ['Failed to find signal index in [0..255] at { }...', s ] ) ; 
    end 
    
    if ~isempty(sList(nextind+1).Ind) 
        error ( ['Repeated signal index in [0..255] at { }...', s ] ) ; 
    end 
    
    name = s(1:place2(1)-1) ; 
    place = strfind( name,'&' ) ; 
    if ~isempty(place) 
        name(1:place) = [] ; 
    end 
    name( isspace(name) ) = [] ;  

    sigindices(cntline) = nextind ; 

    sList(nextind+1).Ind = nextind ; 
    sList(nextind+1).Name = [preamb,name] ;    
    if nargout > 1 
        sfull(nextind+1).Ind = nextind ; 
        sfull(nextind+1).Name = [preamb,name] ;
        sfull(nextind+1).MinVal = ReadFValue(s(place2(2)+1:place2(3)-1))  ;
        sfull(nextind+1).MaxVal = ReadFValue(s(place2(3)+1:place2(4)-1))  ;
        
        valstr = strtrim(s(place2(4)+1:end)) ; 
        pp = strfind(strcmp( DefNames, valstr),1); 
        try
            if any( pp ) 
                val = DefTable(pp(1)).Value ; 
            else
                val =  ReadFValue(valstr)  ;
            end
        catch 
            val = []; 
        end
        if isempty(val) || ~isfinite(val) 
            error(['Could not read configuration default value :',sfull(nextind+1).Name]) ; 
        end

        sfull(nextind+1).Value = val ; 

        place = strfind( scomment ,'!<'); 
        if ~isempty(place )
            scomment = scomment(place(1)+2:end); 
        end 
        scomment = strtrim(scomment); 
        sfull(nextind+1).Description = scomment ;
    end 
end

sigindices = sigindices( logical(sigindices) ) ;
d = diff( sigindices ) ; 
if any(d < 0 ) 
    error(['Signals do not appear at increasing index order :',num2str(sigindices(d<0))]) ; 
end

fclose( fi) ; 
junk = cell(1,256) ; 
for cnt = 1:256  
    junk{cnt} = sList(cnt).Name ; 
end 
sList = junk ;

if nargout > 1 
    ind = true(1,256)  ; 
    for cnt = 1:256
        if isempty(sfull(cnt).Ind) 
            ind(cnt) = false ; 
        end 
    end 
    sfull = sfull(ind) ; 
end 

end

function x = ReadFValue(str)
place = strfind( str,'f') ; 
if ~isempty(place) 
    str= str(1:place-1) ; 
end
x = str2double(strtrim(str)) ; 

end 


