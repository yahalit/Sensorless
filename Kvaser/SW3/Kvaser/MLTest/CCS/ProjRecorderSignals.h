		{ 0 , (long unsigned *) & CanStat.CanCtl },
		{ 0 , (long unsigned *) & IsrTimer.UsecTimer }, //1:UsecTimer
		{ 0 , (long unsigned *) & IsrTimer.UsecTimerAtMsec }, //2:UsecTimerAtMsec
		{ 0 , (long unsigned *) & IsrTimer.mSecTimer }, //3:mSecTimer
		{ 0 , (long unsigned *) & CanStat.CanCtl }, //4:CanCtl
		{ 0 , (long unsigned *) & IsrTimer.UsecTimer }, //5:UsecTimerJunk
		{ 0 , (long unsigned *) & IsrTimer.UsecTimerAtMsec }, //6:UsecTimerAtMsec
		{ 0 , (long unsigned *) & IsrTimer.mSecTimer }, //7:mSecTimer
		{ 0 , (long unsigned *) & IsrTimer.mSecTimerAtSec }, //8:mSecTimerAtSec
		{ 0 , (long unsigned *) & IsrTimer.SecTimer }, //9:SecTimer
		{ 2 , (long unsigned *) & Analogs.Volts24}, //10:Volts24
		{ 2 , (long unsigned *) & Analogs.VServo},//11:VServo
		{ 2 , (long unsigned *) & Analogs.CurServo},//12:CurServo
		{ 2 , (long unsigned *) & Analogs.CurAirPump[0]}, //13:CurAirPump_0
		{ 2 , (long unsigned *) & Analogs.CurAirPump[1]}, //14:CurAirPump_1
		{ 2 , (long unsigned *) & Analogs.CurAirPump[2]}, //15:CurAirPump_2
		{ 2 , (long unsigned *) & Analogs.V36}, //16:V36
		{ 2 , (long unsigned *) & Analogs.VBat54[0]}, //17:VBat54_0
		{ 2 , (long unsigned *) & Analogs.VBat54[1]}, //18:VBat54_1
		{ 2 , (long unsigned *) & Analogs.Volts12[0]}, //19:Volts12_0
		{ 2 , (long unsigned *) & Analogs.Volts12[1]}, //20:Volts12_1
		{ 2 , (long unsigned *) & Analogs.Cur5},  //21:Cur5
		{ 2 , (long unsigned *) & Analogs.Volts5}, //22:Volts5
		{ 2 , (long unsigned *) & Analogs.IShunt}, //23:IShunt
		{ 2 , (long unsigned *) & Analogs.Cur24},  //24:Cur24
		{ 2 , (long unsigned *) & Analogs.Cur12},   //25:Cur12
		{ 12 , (long unsigned *) & Buck12Control.Exception},   //26:Buck12_Exception
		{ 12 , (long unsigned *) & Buck12Control.MotorOn} ,   //27:Buck12_MotorOn
		{ 12 , (long unsigned *) & Buck12Control.PwmLimitSatOut}  ,//28:Buck12_PwmLimitSatOut
		{ 2 , (long unsigned *) & Buck12Control.VSetPoint},  //29:Buck12_VSetPoint
		{ 12 , (long unsigned *) & Buck24Control.Exception},   //30:Buck24_Exception
		{ 12 , (long unsigned *) & Buck24Control.MotorOn} ,   //31:Buck24_MotorOn
		{ 12 , (long unsigned *) & Buck24Control.PwmLimitSatOut}  ,//32:Buck24_PwmLimitSatOut
		{ 2 , (long unsigned *) & Buck24Control.VSetPoint}  //33:Buck24_VSetPoint
