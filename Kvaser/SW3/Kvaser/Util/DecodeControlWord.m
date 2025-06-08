function r = DecodeControlWord( RecStr , CanId)
r  = RecStr ; 

if  any( CanId == [36 35 34 30 11 12 21 22] )
    cw = RecStr.ControlWord ; 
    CwField = struct('Mon', bitget(cw,1) ,'ResetFault',bitget(cw,2),'LoopClosureMode',mybitget(cw,3:5),...
        'ReferenceMode',mybitget(cw,6:8),'SwWidthSel',mybitget(cw,12:13),'KillHome',bitget(cw,14),...
        'Slow',bitget(cw,15),'ForceBrakeRelease',bitget(cw,16),'CurLimitFac',mybitget(cw,17:24)/255) ;  
    r.CwField = CwField ; 
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