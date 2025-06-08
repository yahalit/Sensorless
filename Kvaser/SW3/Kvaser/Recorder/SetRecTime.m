function [Gap,Len] = SetRecTime( T, nsig  , sync2c , nPointsMax  )


global DataType 


if nargin < 3 || isempty(sync2c) 
    sync2c = 1; 
end 



FullRecLen = FetchObj( [hex2dec('2000'),60] , DataType.long ,'FullRecLen') ;
MaxSigs = FetchObj( [hex2dec('2000'),61] , DataType.short ,'FullRecLen') ;
ShortTs = FetchObj( [hex2dec('2000'),62] , DataType.short ,'ShortTs') ;
CTs = FetchObj( [hex2dec('2000'),63] , DataType.long ,'CTs') ;


if sync2c
    ActTs = CTs * 1e-6  ; 
else
    ActTs = ShortTs * 1e-6 ;
end

if ( nsig > MaxSigs ) 
    error ('Too many recorder signals ') ; 
end 
if ( nsig < 1 || ~(fix(nsig)==nsig) ) 
    error ('signal list is empty or nsig not integer') ; 
end 


if nargin > 3 && ~isempty(nPointsMax) 
    nPointsMax = min(nPointsMax , fix(FullRecLen/nsig)  ) ; 
    FullRecLen = nPointsMax * nsig  ; 
end 

NumPointsPerSig = FullRecLen/max([1,nsig ])  ;
Gap = ceil(  (T / ActTs) / NumPointsPerSig)  ; 
Len = fix(T / ( ActTs * Gap) )  ; 




end

