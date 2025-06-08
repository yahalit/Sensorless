function calibRslt = CalcCalibNeck ( PotSummary )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Pot1 = PotSummary(:,1) ; 
Pot2 = PotSummary(:,2) ; 
Enc  = PotSummary(:,3) ; 
EncRef  = PotSummary(:,4) ; 
Roll  = PotSummary(:,5) ; 

Geom = struct('NeckMotCntRad' ,154000, ...
    'Neck1RatCenter' , 0.4522 , 'Neck2RatCenter' , 0.455 , ...
    'Neck1RatRad' , -6.9261 , 'Neck2RatRad' , -6.5172 ) ; 
 
    p1 = polyfit( Pot1 , Roll , 1) ; 
    gain = p1(1) ; 
    bias = -p1(2) / gain ; 
    calibRslt.RNeckPotCenter = bias - Geom.Neck1RatCenter ; 
    calibRslt.RNeckPotGainFac = gain - Geom.Neck1RatRad ;  

    p2 = polyfit( Pot2 , Roll , 1) ; 
    gain = p2(1) ; 
    bias = -p2(2) / gain ; 
    calibRslt.LNeckPotCenter = bias - Geom.Neck2RatCenter ; 
    calibRslt.LNeckPotGainFac = gain - Geom.Neck2RatRad ;  
   
end

