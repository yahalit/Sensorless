function r = DecodeSwitchesStatus( RecStr  )
r  = RecStr ; 

    cw = RecStr.SwitchStatus; 


    SwitchStatus = struct('TargetArmDone',mybitget(cw,5:8),'RSwitchDetectMarker',bitget(cw,1),'LSwitchDetectMarker',bitget(cw,2),...
        'RInductiveSensor',bitget(cw,3),'LInductiveSensor',bitget(cw,4),...
        'RValid',mybitget(cw,17:20),'RValidUse',mybitget(cw,21:24),...
        'LValid',mybitget(cw,25:28),'LValidUse',mybitget(cw,29:32)) ;
    r.SwitchStatus = SwitchStatus ; 

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