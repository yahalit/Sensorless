function calibRslt = CalcCalibLaser (LaserSummary,GainNom,OffsetNom,VoltageAtNoTarget) 

volts  = LaserSummary(:,2) ; 
usermm = LaserSummary(:,3) ; 

    p1 = polyfit( volts , usermm , 1) ; 

    gain = p1(1)  ; 
    bias = -p1(2) ; 
    
    mindist = polyval(p1,VoltageAtNoTarget) ; 
calibRslt = struct('LaserGainCorrection',gain/GainNom-1,'LaserOffsetCorrection',bias/OffsetNom-1,'LaserMinimumVolts',VoltageAtNoTarget+0.03 ,'MinDist',mindist) ; 
    

