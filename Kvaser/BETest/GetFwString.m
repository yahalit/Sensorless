function str = GetFwString( nver) 
%function str = GetFwString( nver)  Generate description string from version code
% #define SubverPatch ( ((FIRM_YR-2000) << 24 ) + (FIRM_MONTH<<20) + (FIRM_DAY <<15) +(SRV_VER << 8) + (SRV_SUBVER<<4) + SRV_PATCH ) ;
Yr  = bitand( nver , 2^24 * 127 ) / 2^24 + 2000; 
Mon = bitand( nver , 2^20 * 15 ) / 2^20  ; 
Day = bitand( nver , 2^15 * 31 ) / 2^15  ; 
Ver  = bitand(nver , 2^8 * 127 ) / 2^8 ; 
SubVer = bitand( nver , 2^4 * 15 ) / 2^4  ; 
Patch  = bitand( nver , 15) ; 

MonName = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'}; 
str = [num2str(Yr),'-',MonName{Mon},'-',num2str(Day),' :Ver:' , num2str(Ver),':',num2str(SubVer),':',num2str(Patch)] ; 


end 