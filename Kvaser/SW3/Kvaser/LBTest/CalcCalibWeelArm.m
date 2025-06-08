function CalcCalibWeelArm( fname ) 
r = load(fname) ; 
r = r.str ; 
if isequal( r.Type ,'PotGain' )     
    Geom = r.Geom ; 
    Pot  = r.Calib.PotRslt ; 
    %disp('Left pot cheat') ; Pot(1) = 0.4205 ; % Cheat 
    %disp('Right pot cheat') ; Pot = [0.4394 0.3065] ; r.Calib.Direction = -1 ; % Cheat 
    dTht = Geom.WheelArmAngleExtend - Geom.WheelArmAngleRetract ; 
    
    dPot =  diff(Pot)   ; 
    tol = [0.66,1.5] * dTht / 6  ; 
    errorstr = [] ; 
    PotGain = Geom.WheelArmPotGain * r.Calib.Direction ;
    PotGainCorrection = 0 ; 
    if isequal(r.Calib.ID , 'LCalib') 
        PotOffsetNom = Geom.LWheelArmPotOffset ; 
    else
        PotOffsetNom = Geom.RWheelArmPotOffset ; 
    end
    PotOffset = PotOffsetNom ; 
    % if r.Calib.Direction * dPot < tol(1) || r.Calib.Direction * dPot > tol(2)
    if abs(dPot) < tol(1) || abs(dPot) > tol(2)
       errorstr = {'Failure: Potentiometer difference between the sides does not make sense',...
...%           ['Must be in range ',num2str(r.Calib.Direction*tol(1)),'..',num2str(r.Calib.Direction*tol(2)) ,' actually:' , num2str(dPot)]} ;
           ['Must be in range ',num2str(r.Calib.Direction*tol(1)),'..',num2str(r.Calib.Direction*tol(2)) ,' actually:' , num2str(abs(dPot))]} ;
    else
        PotGain = dTht / dPot ; 
        PotGainCorrection = r.Calib.Direction * PotGain / Geom.WheelArmPotGain - 1 ; 
        PotOffset = Pot(2) - Geom.WheelArmAngleExtend / PotGain ;
    end
    PotOffsetCorrection = -PotOffsetNom + PotOffset ; 
    save 'CalibWheelArmRslt.mat' errorstr PotGain PotGainCorrection PotOffset PotOffsetCorrection
else
    errorstr = 'Calibration type should be : PotGain' ; 
    save 'CalibWheelArmRslt.mat' errorstr 
end

end 