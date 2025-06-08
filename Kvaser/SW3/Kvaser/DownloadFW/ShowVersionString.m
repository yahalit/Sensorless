function str = ShowVersionString( vr )
MonTable = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
conv = 2.^[0:1:31] ; 
yr  = sum( bitget(vr,21:32) .* conv(1:12) ) ; 
mon = sum( bitget(vr,17:20) .* conv(1:4) ) ; 
day = sum( bitget(vr,9:16) .* conv(1:8) ) ;
subver = sum( bitget(vr,1:8) .* conv(1:8)) ;
if mon < 1 || mon > 12   
    monstr = ['Unknown month: ',num2str(mon)]; 
else
    monstr =  MonTable{mon};
end 
str = [num2str(yr),'-', monstr ,'-', num2str(day) , '  Subversion:' num2str(subver) ] ;
end

