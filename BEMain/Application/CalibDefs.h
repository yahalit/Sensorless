// Flags =  2 float , 4 unsigned , 8 short , 64 dfloat (sim only)  (see more options in the CCmdMode definition)
        { 0 , GetOffsetC(PassWord,CCalib),0.0f}, //1:PassWord [Admin] {Need be 0x12345600 + rec len = 32 }
        { 2 , GetOffsetC(PhaseVoltGainU,CCalib),0.24f},//2:PotCenter1 [Neck] {Obsolete Potentiometer R center for the neck}
        { 2 , GetOffsetC(PhaseVoltGainV,CCalib),0.24f} ,//3:PotCenter2 [Neck] {Obsolete Potentiometer L center for the neck}
        { 2 , GetOffsetC(PhaseVoltGainW,CCalib),0.12f} ,//4:PotGainFac1 [Neck] {Obsolete Potentiometer R gain for the neck}
        { 2 , GetOffsetC(PhaseVoltOffsetU,CCalib),0.12f} ,//5:PotGainFac2 [Neck] {Obsolete Potentiometer L gain for the neck}
        { 2 , GetOffsetC(PhaseVoltOffsetV,CCalib),0.12f} ,//6:PotGainFac2 [Neck] {Obsolete Potentiometer L gain for the neck}
        { 2 , GetOffsetC(PhaseVoltOffsetW,CCalib),0.12f} ,//7:PotGainFac2 [Neck] {Obsolete Potentiometer L gain for the neck}
        { 2 , GetOffsetCC(qImu2ZeroENUPos,0,CCalib),1.01f} ,//8:qImu2ZeroENUPos0 [Neck] {Q IMU 2 Body 0}
        { 2 , GetOffsetCC(qImu2ZeroENUPos,1,CCalib),1.01f} ,//9:qImu2ZeroENUPos1 [Neck] {Q IMU 2 Body 1}
        { 2 , GetOffsetCC(qImu2ZeroENUPos,2,CCalib),1.01f} ,//10:qImu2ZeroENUPos2 [Neck] {Q IMU 2 Body 2}
        { 2 , GetOffsetCC(qImu2ZeroENUPos,3,CCalib),1.01f} ,//11:qImu2ZeroENUPos3 [Neck] {Q IMU 2 Body 3}
        { 2 , GetOffsetC(ACurGainCorr,CCalib),0.5f} ,//12:ACurGainCorr [FSpare] {Calibration of current measurement A}
        { 2 , GetOffsetC(BCurGainCorr,CCalib),0.5f} ,//13:BCurGainCorr [FSpare] {Calibration of current measurement B}
        { 2 , GetOffsetC(CCurGainCorr,CCalib),0.5f} ,//14:CCurGainCorr [FSpare] {Calibration of current measurement C}
        { 2 , GetOffsetC(ACurGainCorrAmc,CCalib),0.5f} ,//15:ACurGainCorrAmc [FSpare] {Calibration of current measurement A}
        { 2 , GetOffsetC(BCurGainCorrAmc,CCalib),0.5f} ,//16:BCurGainCorrAmc [FSpare] {Calibration of current measurement B}
        { 2 , GetOffsetC(CCurGainCorrAmc,CCalib),0.5f} ,//17:CCurGainCorrAmc [FSpare] {Calibration of current measurement C}
        { 2 , GetOffsetC(VdcGain,CCalib),201.0f} ,//18:VdcGain [FSpare] {Vdc gain}
        { 2 , GetOffsetC(VdcOffset,CCalib),201.0f} ,//19:VdcOffset [FSpare] {Vdc offset}
        { 2 , GetOffsetC(Pot2CalibP0,CCalib),201.0f} ,//20:Pot2CalibP0 [FSpare] {Pot 2 polynomial x^0}
        { 2 , GetOffsetCC(CalibSpareFloat,4,CCalib),1.01f} ,//21:CalibSpareFloat4 [FSpare] {Spare floats}
        { 2 , GetOffsetCC(CalibSpareFloat,3,CCalib),1.01f} ,//22:CalibSpareFloat3 [FSpare] {Spare floats}
        { 2 , GetOffsetCC(CalibSpareFloat,2,CCalib),1.01f} ,//23:CalibSpareFloat2 [FSpare] {Spare floats}
        { 2 , GetOffsetCC(CalibSpareFloat,1,CCalib),1.01f} ,//24:CalibSpareFloat1 [FSpare] {Spare floats}
        { 2 , GetOffsetCC(CalibSpareFloat,0,CCalib),1.01f} ,//25:CalibSpareFloat0 [FSpare] {Spare floats}
        { 0 , GetOffsetC(CalibSpareLong,CCalib),1.01f} ,//26:CalibSpareLong0 [LSpare] {Spare floats}
        { 0 , GetOffsetC(CalibDate,CCalib) ,0.0f }, //27:CalibDate [Admin] {Calibration date}
        { 0 , GetOffsetC(CalibData,CCalib), 0.0f }, //28:CalibData [Admin] {Extra calibration ID data}
