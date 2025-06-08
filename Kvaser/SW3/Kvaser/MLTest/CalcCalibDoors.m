function [calibRslt,pr,pl] = CalcCalibDoors ( CalibRaw )
%UNTITLED Summary of this function goes here

    cntr = [CalibRaw.ROpen(2),CalibRaw.RClose(2)] ; 
    degr = [0,60 * pi / 180 ] ; % [CalibRaw.ROpen(1),CalibRaw.RClose(1)] ; 
    
    cntl = [CalibRaw.LOpen(2),CalibRaw.LClose(2)] ; 
    degl = [0,60 * pi / 180 ] ; % [CalibRaw.LOpen(1),CalibRaw.LClose(1)] ; 

    Geom = struct ( 'RDoorCenter' , 3283 , 'RDoorGainFac', 0.0015 , 'LDoorCenter' , 2521 , 'LDoorGainFac' , 0.0015  ) ; 
    
    p1 = polyfit( cntr , degr , 1) ; 
    gain = p1(1) ; 
    bias = -p1(2) / gain ; 
    calibRslt.RDoorCenter = bias - Geom.RDoorCenter ; 
    calibRslt.RDoorGainFac = gain - Geom.RDoorGainFac ;  
    if ( gain * Geom.RDoorGainFac < 0 ) 
        uiwait( msgbox('Most probably the right door pushrod flipped side - try to pass the dead point mechanically') ) ; 
    end

    p2 = polyfit( cntl , degl , 1) ; 
    gain = p2(1) ; 
    bias = -p2(2) / gain ; 
    calibRslt.LDoorCenter = bias - Geom.LDoorCenter ; 
    calibRslt.LDoorGainFac = gain - Geom.LDoorGainFac ;  
    if ( gain * Geom.LDoorGainFac < 0 ) 
        uiwait( msgbox('Most probably the left door pushrod flipped side - try to pass the dead point mechanically') ) ; 
    end
    pr = p1 ; pl = p2 ; 
end

