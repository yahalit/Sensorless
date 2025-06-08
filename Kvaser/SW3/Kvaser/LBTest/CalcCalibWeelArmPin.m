function CalcCalibWeelArmPin(fname) 
r = load(fname) ; 
r = r.str ; 
calib = r.Calib ; 
if isequal( r.Type ,'WheelArmPin' )
    errorstr = [] ; 
    %Geom = r.Geom ; 
    d = diff(calib.PinEncoders(1:2)) ; 
    if d < 270 || d > 800 
        errorstr = ['Encoder difference between extreme states must be about 700, was ',num2str(d)] ;  
    else
        WheelArmZeroCnt = round( mean(calib.PinEncoders(1:2)) ) ; 
        WheelArmTravel  = min( d / 3.2 , 175) ; 
    end
else
    errorstr = 'Calibration type should be : WheelArmPin' ; 
end


    
if ~isempty(errorstr) 
    save 'CalibWheelArmRsltPin.mat' errorstr
else
    save 'CalibWheelArmRsltPin.mat' errorstr WheelArmZeroCnt WheelArmTravel 
end

end 