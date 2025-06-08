function str = DrvVersionString( vr )
if vr ==0 
	str = 'Unknown' ; 
    return ;
end
MonTable = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
conv = 2.^(0:1:31) ; 
yr  = sum( bitget(vr,25:32) .* conv(1:8) ) + 2000 ; 
mon = sum( bitget(vr,21:24) .* conv(1:4) ) ; 
day = sum( bitget(vr,16:20) .* conv(1:5) ) ;
ver = sum( bitget(vr,9:15) .* conv(1:7)) ;
subver = sum( bitget(vr,5:8) .* conv(1:4)) ;
patch = sum( bitget(vr,1:4) .* conv(1:4)) ;
if mon < 1 || mon > 12   
    error( ['Unknown month: ',num2str(mon)]); 
else
    monstr =  MonTable{mon};
end 
str = [num2str(yr),'-', monstr ,'-', num2str(day) , ' Ver:', num2str(ver),':', num2str(subver),':', num2str(patch)] ;
end

