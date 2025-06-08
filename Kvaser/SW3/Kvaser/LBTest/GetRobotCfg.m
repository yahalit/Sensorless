function [cfg,CalibStr,errstr] = GetRobotCfg(bDefault) 

global RecStruct 
    cfg = struct() ; errstr = [] ; 
    Enums = RecStruct.Enums ;
    if nargin < 1 
        bDefault = 0 ; 
    end 
    
    try 
        CalibStr = SaveCalib ( [] , 'SetManipTypeParamsBackup.jsn' ); 
    catch 
        errstr = ["Cannot comunicate with robot","for reading its configuration"] ; 
        return ; 
    end 
    if ~isfield(CalibStr,'RobotConfig')  
        errstr = ["SW version does not","support robot configuration"];                
        return ; 
    end

    
    cfg.ManipType = bitand( CalibStr.RobotConfig , 15) ;
    switch cfg.ManipType 
        case Enums.ManipulatorType.None 
            cfg.ManipTypeName = 'None' ;
        case Enums.ManipulatorType.Scara 
            cfg.ManipTypeName = 'Scara' ;
        case Enums.ManipulatorType.Flex_Arm 
            cfg.ManipTypeName = 'Flex_Arm' ;
        otherwise
            if bDefault 
                cfg.ManipType = Enums.ManipulatorType.None ;
                cfg.ManipTypeName = 'Scara' ; 
                errstr =["Unidentified manipulator configuration","Defaulted to Scara"];
            else
                cfg    = []; 
                errstr ="Unidentified manipulator configuration";
                return ; 
            end
    end

    cfg.WheelArmType = bitand( bitshift(CalibStr.RobotConfig,-4) , 3) ;
    switch cfg.WheelArmType 
        case Enums.WheelArmType.Rigid 
            cfg.WheelArmTypeName = 'Rigid';
        case Enums.WheelArmType.Wheel_Arm24 
            cfg.WheelArmTypeName = 'Wheel_Arm24';
        case Enums.WheelArmType.Wheel_Arm28 
            cfg.WheelArmTypeName = 'Wheel_Arm28';
        case Enums.WheelArmType.Wheel_Arm30
            cfg.WheelArmTypeName = 'Wheel_Arm30';
        case Enums.WheelArmType.Wheel_Arm32 
            cfg.WheelArmTypeName = 'Wheel_Arm32';
        otherwise
            if bDefault 
                cfg.WheelArmType = Enums.WheelArmType.Rigid ;
                errstr = ["Unidentified wheel arm configuration","Defaulted to Rigid"] ;                 
                cfg.WheelArmTypeName = 'Rigid';       
            else
                errstr = "Unidentified wheel arm configuration" ;                 
                cfg = [] ; 
                return ; 
            end
    end

    cfg.RailSensorTyepName = 'Gyro';

    cfg.VerticalRailPitchType = bitand( bitshift(CalibStr.RobotConfig,-8) , 7) ;
    switch cfg.VerticalRailPitchType 
        case Enums.VerticalRailPitchType.Old_6p28 
            cfg.RailteethPitchTypeName = 'Old_6p28';
        case Enums.VerticalRailPitchType.New_6p35 
            cfg.RailteethPitchTypeName = 'New_6p35';
        otherwise
            if bDefault 
                cfg.RailteethPitchTypeName = 'Old_6p28';
                cfg.VerticalRailPitchType  = Enums.VerticalRailPitchType.Old_6p28 ; 
                errstr = ["Unidentified vertical pitch configuration","Default to Old_6p28"]; 
            else
                errstr = "Unidentified vertical pitch configuration" ;                 
                cfg = [] ; 
                return ; 
            end
    end

    cfg.ProtocolType = bitand( bitshift(CalibStr.RobotConfig,-11) , 7) ;
    switch cfg.ProtocolType 
        case Enums.ProtocolType.Early 
            cfg.ProtocolTypeName = 'Early';
        case Enums.ProtocolType.Versioned 
            cfg.ProtocolTypeName = 'Versioned';
        otherwise
            if bDefault 
                cfg.ProtocolTypeName = 'Early';
                cfg.VerticalRailPitchType  = ProtocolType.Early ; 
                errstr = ["Unidentified protocol configuration","Default to Early"]; 
            else
                errstr = "Unidentified protocol configuration" ;                 
                cfg = [] ; 
                return ; 
            end
    end
end