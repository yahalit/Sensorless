function [centercalib,gaincalib] = CalcCalibSteer ( pots, encs ,refs ) 
Geom = struct('SteerFinalRatCenter' ,0.51,'SteerFinalRatRev',-6.81,...
    'Neck1RatCenter' , 0.4522 , 'Neck2RatCenter' , 0.7424 , ...
    'Neck1RatRad' , -6.9261 , 'Neck2RatRad' , -6.5172 ) ; 

    angles = [-pi/2 , 0 , pi/2 ] ; 
    
    p1 = polyfit( pots , angles , 1) ; 
    gain = p1(1) ; 
    bias = -p1(2) / gain ; 
    centercalib = bias - Geom.SteerFinalRatCenter ; 
    gaincalib = gain - Geom.SteerFinalRatRev ;  

    doplots = 0 ; 
    if doplots == 1 
    figure() 
    subplot(2,1,1) ;
    plot(pots , angles ,'+-',pots,polyval(p1,pots) ); 
    subplot(2,1,2) ;
    plot(pots , angles - polyval(p1,pots),'+-' ); 
    end
    
    
% 	Calib.RSteerPotCenter = CalibTmp.RSteerPotCenter +  Geom.SteerFinalRatCenter ;
% 	Calib.LSteerPotCenter = CalibTmp.LSteerPotCenter + Geom.SteerFinalRatCenter ;
% 	Calib.RSteerPotGainFac = CalibTmp.RSteerPotGainFac + Geom.SteerFinalRatRev ;
% 	Calib.LSteerPotGainFac = CalibTmp.LSteerPotGainFac + Geom.SteerFinalRatRev ;
% 
% 	Calib.RNeckPotCenter = CalibTmp.RNeckPotCenter + Geom.Neck1RatCenter ;
% 	Calib.LNeckPotCenter = CalibTmp.LNeckPotCenter + Geom.Neck2RatCenter ;
% 	Calib.RNeckPotGainFac = CalibTmp.RNeckPotGainFac + Geom.Neck1RatRad ;
% 	Calib.LNeckPotGainFac = CalibTmp.LNeckPotGainFac + Geom.Neck2RatRad ;
