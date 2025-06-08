function r = DecodeSwStatus( RecStr , side)
r  = RecStr ; 

    cw = RecStr.([side,'StatusAsPdo']) ; 

    SwitchDir =  1 - 2 * bitget(cw,5)  ;   
    SwitchWidth = (mybitget(cw,6:15) - 2048 * bitget(cw,16)) * 6.4000e-05  ;
    DistIntoWidth = (mybitget(cw,22:31) - 2048 * bitget(cw,32) ) *  6.4000e-05;


    RailField = struct('ValidCounter',mybitget(cw,1:3),'SwitchDir',SwitchDir,'PresentValue', bitget(cw,4) ,...
        'RiseMarker', bitget(cw,19) ,'FallMarker',bitget(cw,20),...
        'SwitchWidth',SwitchWidth,'DistIntoWidth',DistIntoWidth) ;  
    r.([side,'RailField']) = RailField ; 

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