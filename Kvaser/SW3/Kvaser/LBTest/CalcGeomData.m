Geom = struct('Calc',struct(),'TrackWidthCtl',struct()) ; 
ReadFromRobot = 0 ; 
try 
    Geom.WheelMotCntRadGnd = GetFloatPar('Geom.WheelMotCntRadGnd') ; 
    Geom.WheelCntRad = GetFloatPar('Geom.WheelCntRad') ; 
    Geom.rg = GetFloatPar('Geom.rg') ; 
    Geom.rrailnom = GetFloatPar('Geom.rrailnom') ; 
    Geom.Center2WheelDist = GetFloatPar('Geom.Center2WheelDist' ) ;

    Geom.TrackWidthCtl.WheelArmJointDist = GetFloatPar('Geom.WheelArmJointDist') ; 
    Geom.TrackWidthCtl.WheelArmRodLength4Pin = GetFloatPar('Geom.WheelArmRodLength4Pin') ; 

    Geom.TrackWidthCtl.WheelArmAngleRetract = GetFloatPar('Geom.WheelArmAngleRetract') ; 
     Geom.TrackWidthCtl.WheelArmAngleExtend32 = GetFloatPar('Geom.WheelArmAngleExtend32') ; 
    Geom.TrackWidthCtl.WheelArmAngleExtend30 = GetFloatPar('Geom.WheelArmAngleExtend30') ; 
   Geom.TrackWidthCtl.WheelArmAngleExtend28 = GetFloatPar('Geom.WheelArmAngleExtend28') ; 
    Geom.TrackWidthCtl.WheelArmAngleExtend24 = GetFloatPar('Geom.WheelArmAngleExtend24') ; 
    
    cfg = GetRobotCfg(0); 
    
    RailPitchType = cfg.VerticalRailPitchType ; 
    WheelArmType  = cfg.WheelArmType ; 
    
    Geom.TrackWidthCtl.RetractedWidth = FetchObj( [hex2dec('2224'),2] , DataType.float , 'RetractedWidth' ) ; 
    Geom.TrackWidthCtl.ExtendedWidth = FetchObj( [hex2dec('2224'),3] , DataType.float , 'RetractedWidth' ) ; 
    Geom.TrackWidthCtl.WheelArmAngleExtend= FetchObj( [hex2dec('2224'),4] , DataType.float , 'WheelArmAngleExtend' ) ; 
    ReadFromRobot = 1 ; 
catch 
end
if ( ReadFromRobot == 0 ) 
    Geom.WheelMotCntRadGnd = 2.757550884373431e+04 ; 
    %Geom.WheelMotCntRadRail = 1.167897380302427e+04;
    Geom.WheelCntRad = 722.0860 ; 
    Geom.rg = 0.1003; 
    Geom.rrailnom = 0.0199 ; 
    Geom.Center2WheelDist = 0.2510 ;
    RailPitchType = 1 ; 
    try
        WheelArmType  = RecStruct.Enums.WheelArmType.Wheel_Arm28 ; 
    catch
        RecStruct = struct('Enums',struct('WheelArmType',...
            struct('Wheel_Arm28',1,'Wheel_Arm24',2,'Wheel_Arm30',3,'Wheel_Arm32',4) )  ) ;
        WheelArmType  = RecStruct.Enums.WheelArmType.Wheel_Arm30 ; 
    end
    Geom.TrackWidthCtl.WheelArmJointDist = 0.6259 ; 
    Geom.TrackWidthCtl.WheelArmRodLength4Pin = 0.233 ;
    RoofAngle = (pi - 155.85 * pi /180)/2 ;
    RetractJointAngle = 86.4 * pi / 180 ; 
    ExtractJointAngle28 = 141.2 * pi / 180 ; 
    ExtractJointAngle24 = 113.7 * pi / 180 ; 
    ExtractJointAngle30 = 157.37 * pi / 180 ; 
    ExtractJointAngle32 = 180 * pi / 180 ; 
    Geom.TrackWidthCtl.WheelArmAngleRetract = -(pi/2 + RoofAngle - RetractJointAngle) ;
    Geom.TrackWidthCtl.WheelArmAngleExtend32  = -(pi/2 + RoofAngle - ExtractJointAngle32) ;
    Geom.TrackWidthCtl.WheelArmAngleExtend30  = -(pi/2 + RoofAngle - ExtractJointAngle30) ;
    Geom.TrackWidthCtl.WheelArmAngleExtend28  = -(pi/2 + RoofAngle - ExtractJointAngle28) ;
    Geom.TrackWidthCtl.WheelArmAngleExtend24  = -(pi/2 + RoofAngle - ExtractJointAngle24) ;
    [Geom.TrackWidthCtl.RetractedWidth]   = SolveActualTrackWidth(Geom.TrackWidthCtl.WheelArmJointDist ,  Geom.TrackWidthCtl.WheelArmRodLength4Pin ,  Geom.TrackWidthCtl.WheelArmAngleRetract ,  Geom.TrackWidthCtl.WheelArmAngleRetract  );
end
  
[Geom.TrackWidthCtl.ExtendedWidth28,tilt28] = SolveActualTrackWidth(Geom.TrackWidthCtl.WheelArmJointDist ,  Geom.TrackWidthCtl.WheelArmRodLength4Pin ,  Geom.TrackWidthCtl.WheelArmAngleRetract ,  Geom.TrackWidthCtl.WheelArmAngleExtend28  );
[Geom.TrackWidthCtl.ExtendedWidth24,tilt24] = SolveActualTrackWidth(Geom.TrackWidthCtl.WheelArmJointDist ,  Geom.TrackWidthCtl.WheelArmRodLength4Pin ,  Geom.TrackWidthCtl.WheelArmAngleRetract ,  Geom.TrackWidthCtl.WheelArmAngleExtend24  );
[Geom.TrackWidthCtl.ExtendedWidth30,tilt30] = SolveActualTrackWidth(Geom.TrackWidthCtl.WheelArmJointDist ,  Geom.TrackWidthCtl.WheelArmRodLength4Pin ,  Geom.TrackWidthCtl.WheelArmAngleRetract ,  Geom.TrackWidthCtl.WheelArmAngleExtend30  );
[Geom.TrackWidthCtl.ExtendedWidth32,tilt32] = SolveActualTrackWidth(Geom.TrackWidthCtl.WheelArmJointDist ,  Geom.TrackWidthCtl.WheelArmRodLength4Pin ,  Geom.TrackWidthCtl.WheelArmAngleRetract ,  Geom.TrackWidthCtl.WheelArmAngleExtend32  );

if ReadFromRobot == 0 
    switch WheelArmType 
        case RecStruct.Enums.WheelArmType.Wheel_Arm28
            Geom.TrackWidthCtl.WheelArmAngleExtend = Geom.TrackWidthCtl.WheelArmAngleExtend28 ;
            Geom.TrackWidthCtl.ExtendedWidth = Geom.TrackWidthCtl.ExtendedWidth28 ;
        case RecStruct.Enums.WheelArmType.Wheel_Arm24
            Geom.TrackWidthCtl.WheelArmAngleExtend = Geom.TrackWidthCtl.WheelArmAngleExtend24 ;
            Geom.TrackWidthCtl.ExtendedWidth = Geom.TrackWidthCtl.ExtendedWidth24 ;
        case RecStruct.Enums.WheelArmType.Wheel_Arm30
            Geom.TrackWidthCtl.WheelArmAngleExtend = Geom.TrackWidthCtl.WheelArmAngleExtend30 ;
            Geom.TrackWidthCtl.ExtendedWidth = Geom.TrackWidthCtl.ExtendedWidth30 ;
        case RecStruct.Enums.WheelArmType.Wheel_Arm32
            Geom.TrackWidthCtl.WheelArmAngleExtend = Geom.TrackWidthCtl.WheelArmAngleExtend32 ;
            Geom.TrackWidthCtl.ExtendedWidth = Geom.TrackWidthCtl.ExtendedWidth32 ;
        %case RecStruct.Enums.WheelArmType.Wheel_ArmGeneric
        otherwise
            error ('Wheel Arm type not supported') ; 
    end
end

switch RailPitchType
case 0
    Geom.Calc.rrail = Geom.rrailnom ;
otherwise
    Geom.Calc.rrail = Geom.rrailnom * ( 6.35 / 6.28 )  ;
end


Geom.Calc.Rad2WheelCnt = 1.0 /Geom.WheelCntRad ;
Geom.Calc.Meter2WheelEncoderShelf  =  Geom.WheelCntRad   / (Geom.Calc.rrail * Geom.WheelMotCntRadGnd)  ; % Convert distance to wheel encoder
Geom.Calc.WheelEncoder2MeterShelf = 1.0 /Geom.Calc.Meter2WheelEncoderShelf  ;
Geom.Calc.WheelEncoder2MeterGnd = Geom.rg * Geom.Calc.Rad2WheelCnt  ;
Geom.Calc.Meter2MotEncoderGnd  = Geom.WheelMotCntRadGnd  / Geom.rg ; % Convert distance to wheel encoder
Geom.Calc.MotEncoder2MeterGnd = 1.0 / Geom.Calc.Meter2MotEncoderGnd ;
Geom.Calc.WheelEncoder2MotEncoder = Geom.WheelMotCntRadGnd * Geom.Calc.Rad2WheelCnt   ;% This ratio is FIXED regardless of travel conditions
Geom.Calc.Meter2MotEncoderShelf = Geom.Calc.Meter2WheelEncoderShelf * Geom.Calc.WheelEncoder2MotEncoder ;
Geom.Calc.MotEncoder2MeterShelf = 1.0 / Geom.Calc.Meter2MotEncoderShelf  ;
