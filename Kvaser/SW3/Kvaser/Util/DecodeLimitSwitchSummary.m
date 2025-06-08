function r = DecodeLimitSwitchSummary( RecStr , CanId)
r  = RecStr ; 

if  any( CanId == [14,24] )
    cw = RecStr.LimitSwitchSummary ; 
    SwField = struct('PresentValue', bitget(cw,1) ,'ValuePNP',bitget(cw,2),'ValueNPN',bitget(cw,3),...
        'RiseMarker', bitget(cw,4) ,'FallMarker',bitget(cw,5),'SwitchDir',mybitget(cw,6:7)-1,...
        'SwitchDetectValid',mybitget(cw,9:16)) ;  
    r.SwField = SwField ; 
end

end

function y = mybitget(x,n) 
    y = bitget( x,n(1));
    if length(n) < 2 
        return ; 
    end 
    for cnt = 2:length(n) 
        y = y + 2^(n(cnt)-n(1)) * bitget( x,n(cnt) ) ;
    end
end