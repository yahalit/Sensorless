%core - 1/2
function srcver = GetSourceVersion(fname, core) 

if core==1
    initials = 'LP_';
else %core==2
    initials = 'LP2_';
end
    
h = fopen(fname) ; 
miss = [1,1,1,1,1,1];
while(1) 
    str = fgets(h) ; 
    if isequal(str,-1)
        fclose(h) ;
        error(['Could not find version info in file:',fname]) ; 
    end
    str = strtrim(str) ; 
    sp = strsplit( str);
    if startsWith(str,"#define") && length(sp) > 2 
        fld = sp{2} ; 
        if startsWith(fld,initials) %if startsWith(fld,'LP_')
            fld = fld(4:end);
        end
        junk = sp{3} ; 
        junk = double(junk) ; 
        junk = junk( junk >= 48 & junk <= 57 ) ; 
        pp  = str2double(char(junk)) ; 
        switch fld 
            case 'FIRM_YR'
                miss(1) = 0 ; 
                yy = pp ;
            case 'FIRM_MONTH'
                miss(2) = 0 ; 
                mm = pp ; 
            case 'FIRM_DAY'
                miss(3) = 0 ; 
                dd = pp ; 
            case 'FIRM_VER'
                miss(4) = 0 ; 
                vv = pp ;
            case 'FIRM_SUBVER'
                miss(5) = 0 ; 
                sv = pp ;
            case 'FIRM_PATCH'
                miss(6) = 0 ; 
                pat = pp ;
        end
    end
    if ~any(miss) 
        fclose(h) ;
        break ; 
    end
end
%#define SubverPatch ( ((FIRM_YR-2000) << 24 ) + (FIRM_MONTH<<20) + (FIRM_DAY <<15) +(SRV_VER << 8) + (SRV_SUBVER<<4) + SRV_PATCH ) ;

srcver = (yy-2000)*2^24+mm*2^20+ dd*2^15+vv*2^8+sv*2^4+pat ; 
end