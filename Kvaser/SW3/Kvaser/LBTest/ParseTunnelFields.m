function Codes  = ParseTunnelFields( fname  ) 
%function [Codes,fieldnames] = ParseTunnelFields( fname  ) 
DataType = GetDataType() ; 

kaka = cell(1,256) ; 
Codes = struct('name',[],'base',[],'dim',[],'ftype',[],'mux',kaka)  ;

ncell = 0; 
fi = fopen ( fname , 'r' ) ; 
if isequal(fi,-1) 
    errordlg({'Tunnel description file',fname,'Not found'}) ; 
    return ; 
end

[Codes,ncell] = AddPtrList(fi,'FloatBitPtrs[]',Codes,DataType.float,ncell,0); 
[Codes,ncell] = AddPtrList(fi,'ConstFloatObjectReads[]',Codes,DataType.float,ncell,1); 
[Codes,ncell] = AddPtrList(fi,'ULongBitPtrs[]',Codes,DataType.long,ncell,0); 
[Codes,ncell] = AddPtrList(fi,'ConstULongObjectReads[]',Codes,DataType.long,ncell,1); 
[Codes,ncell] = AddPtrList(fi,'UShortBitPtrs[]',Codes,DataType.long,ncell,0); 


fclose(fi) ; 
Codes = Codes(1:ncell) ; 

bases = {Codes.base}; 
names = {Codes.name}; 
ubases = unique(bases ); 
nubase = length(ubases) ; 
% ubases = setdiff(ubases,{'base'});
% isbase  = strcmp('base',bases);
% indbase = find(isbase) ; 
% nbase = sum(isbase) ;
fi = fopen("..\Tunnel\MainFieldNames.h",'w+') ; 

puts(fi,['#define TOTAL_DATA_LEN ',num2str(length(bases))]) ; 

puts(fi,['#define NUMBER_OF_FIELDS ',num2str(nubase) ]) 
nf = zeros(1,nubase) ; 


for cnt = 1:nubase
    ind = find(strcmp(bases,ubases{cnt})); 
    nf(cnt) = length(ind) ; 
    puts(fi,['#define N_',ubases{cnt},'FIELDS ',num2str(nf(cnt))]) ; 
    puts( fi , ['const char* ',ubases{cnt},'_fields[] = {']) ;
    puts( fi, ['"',names{ind(1)},'"']); 
    for c1 = 2:nf(cnt)  
        next = ind(c1) ; 
        puts( fi, [',"',names{next},'"']); 
    end 
    puts( fi,'};'); 
    puts(fi,'');
    
    puts( fi , ['const unsigned int ',ubases{cnt},'_fieldsmap[] = {']) ;
    puts( fi, num2str(ind(1)-1)); 
    for c1 = 2:nf(cnt)  
        next = ind(c1) ; 
        puts( fi, [',',num2str(next-1)]); 
    end 
    puts( fi,'};'); 
    puts(fi,'');
    
    
end
fwrite( fi , ['const int unsigned str_len[',num2str(nubase),']={',num2str(nf(1))] ) ; 
for cnt = 2:nubase
    fwrite( fi ,[',',num2str(nf(cnt))]) ; 
end
puts( fi,'};'); 

fwrite( fi , ['const char** str_ptr[',num2str(nubase),']={',ubases{1},'_fields'] ) ; 
for cnt = 2:nubase
    fwrite( fi ,[',',ubases{cnt},'_fields']) ; 
end
puts( fi,'};'); 


fwrite( fi , ['const int unsigned* map_ptr[',num2str(nubase),']={',ubases{1},'_fieldsmap'] ) ; 
for cnt = 2:nubase
    fwrite( fi ,[',',ubases{cnt},'_fieldsmap']) ; 
end
puts( fi,'};'); 

fwrite( fi , ['const char* struct_names[',num2str(nubase),'] = {']) ;
fwrite( fi, ['"',ubases{1},'"']); 
for cnt = 2:nubase
    fwrite( fi, [',"',ubases{cnt},'"']); 
end
puts( fi,'};'); 
puts(fi,'');

puts( fi,['int FieldTypes[',num2str(ncell),']={']);
for cnt = 1:ncell-1
    puts( fi,[num2str(Codes(cnt).ftype),', // ',Codes(cnt).name,' of  ', Codes(cnt).base]) ;    
end
cnt = ncell ; 
puts( fi,[num2str(Codes(cnt).ftype),' // ',Codes(cnt).name,' of  ', Codes(cnt).base]) ;    
puts( fi,'};') ;    



fclose(fi) ; 
 
end

function puts(fi,str) 
crlf = [char(13),newline];
fwrite( fi,[str,crlf ]); 
end


function strout = GetNextField(fi,hdr,IsObject)

    name=[];base=[];dim = [] ; mux = [] ; 
    strout = [] ; 
    struct('name',name,'base',base,'dim',dim,'mux',[])  ;  
    while 1 
        str = fgets(fi) ; 
        if isequal( str ,-1) 
            error(['Header : premature file end : ',hdr]) ; 
        end
        if contains(str,hdr) 
            return ; 
        end 
        
        if IsObject
            place1 = strfind(str,'{'); 
            place2 = strfind(str,'}'); 
            place3 = strfind(str,'//'); 
            if isempty(place3) || isempty(place1) 
                continue ;
            end
            if ~(length(place1)==2) || ~(length(place2)==2) || ~(length(place3)==1) || place3 < place2(1) || place2(1) < place1(1)+3 
                error(['string: bracing of object illegal: ',str]) 
            end
            place1 = place1(1);
            place2 = place2(1);
            place3 = place3(1);

            objstr = strsplit(str(place1+1:place2-1),',') ; 
            str = str(place3:end);  
            mux = zeros(1,2) ; 
            mux(1) = readnumber(objstr{1} ) ; 
            mux(2) = readnumber(objstr{2} ) ; 
        end
        
        place1 = strfind(str,'{'); 
        place2 = strfind(str,'}'); 
        place3 = strfind(str,'//'); 
        if isempty(place3) || isempty(place1) 
            continue ;
        end
        if ~(length(place1)==1) || ~(length(place2)==1) || ~(length(place3)==1) || place3 > place2 || place2 < place1+3 
            error(['string: bracing of pointer illegal: ',str]) 
        end
        str_in = str ; 
        str = strsplit(str(place1+1:place2-1),',') ; 
        if length(str) < 2 || length(str) > 3 
            error(['string: delimiting illegal: ',str_in]) 
        end 
        base = strtrim(str{2}) ; 
        name = strtrim(str{1}) ; 
        if length( str) > 2 
            dim = str2double(str{3}) ; 
        end
        strout = struct('name',name,'base',base,'dim',dim,'mux',[])  ;  
        return ;
    end
end

function x = readnumber(s) 
    s = lower(s) ; 
    p = strfind(s,'x'); 
    if ~isempty(p) 
        x = hex2dec(s(p+1:end)) ; 
    else
        x = str2double(s) ; 
    end
    if isempty(x) 
        error(['Could not read a number :',s ]); 
    end
end

function SearchHdr(fi,hdr)
    while 1
        str = fgets(fi) ; 
        if isequal( str ,-1) 
            error(['Header not found: ',hdr]) ; 
        end
        if contains(str,hdr) 
            return ; 
        end 
    end
end

function [Codes,ncell]=AddPtrList(fi,nextstr,Codes,ftype,ncell,IsObject)
    SearchHdr(fi,nextstr) ;
    while 1
        str = GetNextField(fi,nextstr,IsObject) ; 
        if isempty(str) 
            break; 
        end
        ncell = ncell + 1 ; 
        str.('ftype') = ftype ; 
        Codes(ncell) = str ; %{name,base,dim,ftype,mux} ;
    end
end