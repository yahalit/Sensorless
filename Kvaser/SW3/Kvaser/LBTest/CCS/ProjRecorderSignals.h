// Flags =  2 float , 4 unsigned , 8 short (see more options in the CCmdMode definition)
		{ 0 , (long unsigned *) & CanStat.CanCtl },
		{ 0 , (long unsigned *) & IsrTimer.UsecTimer }, //1:UsecTimer
		{ 0 , (long unsigned *) & IsrTimer.UsecTimerAtMsec },//2:UsecTimerAtMsec
		{ 0 , (long unsigned *) & IsrTimer.mSecTimer },//3:mSecTimer
		{ 0 , (long unsigned *) & IsrTimer.mSecTimerAtSec },//4:msecTimerAtMsec
		{ 0 , (long unsigned *) & IsrTimer.SecTimer },//5:SecTimer
		{ 0 , (long unsigned *) & EncRsltBuf[0]},//6:LeftWheelEncoder
		{ 0 , (long unsigned *) & EncRsltBuf[3]},//7:RightWheelEncoder
		{ 2 , (long unsigned *) & Analogs.NkPot1},//8:RightNeckPot
		{ 2 , (long unsigned *) & Analogs.NkPot2},//9:LeftNeckPot
		{ 2 , (long unsigned *) & Analogs.SteerPot1},//10:LeftSteerPot
		{ 2 , (long unsigned *) & Analogs.SteerPot2},//11:RightSteerPot
		{ 2 , (long unsigned *) & Analogs.UsSamp1},//12:LaserDist
		{ 2 , (long unsigned *) & Analogs.OverLoadkRWh2},//13:OveloadLeftWheel
		{ 2 , (long unsigned *) & Analogs.OverLoadkRNk},//14:OverloadNeck
		{ 2 , (long unsigned *) & Analogs.OverLoadkRSt1},//15:OverloadSteeringR
		{ 2 , (long unsigned *) & Analogs.OverLoadkRSt2}, //16:OverloadSteeringL
		{ 8 , (long unsigned *) & GyroRsltBuf[0]}, //17:RawGyro0
		{ 8 , (long unsigned *) & GyroRsltBuf[1]}, //18:RawGyro1
		{ 8 , (long unsigned *) & GyroRsltBuf[2]}, //19:RawGyro2
		{ 8 , (long unsigned *) & GyroRsltBuf[3]}, //20:RawAcc0
		{ 8 , (long unsigned *) & GyroRsltBuf[4]}, //21:RawAcc1
		{ 8 , (long unsigned *) & GyroRsltBuf[5]}, //22:RawAcc2
		{ 8 , (long unsigned *) & GyroRsltBuf[6]}, //23:RawStatus
		{ 8 , (long unsigned *) & GyroRsltBuf[7]},  //24:RawTemperature
		{ 2 , (long unsigned *) & SysState.Nav.Imu.Omega[0]},//25:ImuOmega0
		{ 2 , (long unsigned *) & SysState.Nav.Imu.Omega[0]},//26:ImuOmega1
		{ 2 , (long unsigned *) & SysState.Nav.Imu.Omega[0]},//27:ImuOmega2
		{ 2 , (long unsigned *) & SysState.Nav.Imu.LinAcc[0]},//28:ImuAcc0
		{ 2 , (long unsigned *) & SysState.Nav.Imu.LinAcc[0]},//29:ImuAcc1
		{ 2 , (long unsigned *) & SysState.Nav.Imu.LinAcc[0]},//30:ImuAcc2
		{ 2 , (long unsigned *) & SysState.Nav.Imu.Temperature} //31:ImuTemp
