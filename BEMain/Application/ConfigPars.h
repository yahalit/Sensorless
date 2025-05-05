     { .ind = 0 ,  .Flags = CFG_FLOAT | CFG_MUST_INIT | CFG_RECALC , .ptr = (float*) &SysState.ConfigDone, .lower =  0.0f,.upper = 2.0f, .defaultVal = 0.0f },// :ConfigDone [Management] {Approve configuration is done}
     { .ind = 1 ,  .Flags = CFG_FLOAT  , .ptr = (float*) &SysState.MCanSupport.MinInterMessage, .lower =  0.002f,.upper = 0.1f, .defaultVal = 0.006f },// :MinInterMessage [Timing] {minimum estimate for communication cycle}
     { .ind = 2 ,  .Flags = CFG_FLOAT  , .ptr = (float*) &SysState.MCanSupport.MaxInterMessage, .lower =  0.008f,.upper = 0.1f, .defaultVal = 0.05f },// :MaxInterMessage [Timing] {maximum estimate for communication cycle}
     { .ind = 3 ,  .Flags = CFG_FLOAT , .ptr = (float*) &SysState.MCanSupport.NomInterMessageTime, .lower =  0.002f,.upper = 0.1f, .defaultVal = 0.008192},// :NomInterMessageTime [Timing] {Nominal time for communication cycle}
     { .ind = 4 ,  .Flags = CFG_FLOAT , .ptr = &GRefGenPars.Amp,.lower =  -1000.0f,.upper = 1000.0f, .defaultVal = 0 },// :GRef_Amp [G_REF] { General reference generator amplitude}
     { .ind = 5 ,  .Flags = CFG_FLOAT , .ptr = &GRefGenPars.f,.lower =  -6000.0f,.upper = 6000.0f, .defaultVal = 100.0 },// :GRef_F [G_REF] { General reference generator Frequency}
     { .ind = 6 ,  .Flags = CFG_FLOAT , .ptr = &GRefGenPars.Dc,.lower =  -1000.0f,.upper = 1000.0f, .defaultVal = 0 },// :GRef_Dc [G_REF] { General reference generator DC value}
     { .ind = 7 ,  .Flags = CFG_FLOAT , .ptr = (float*) &GRefGenPars.Duty,.lower =  0.0f,.upper = 1.0f, .defaultVal = 0.5 },// :GRef_Duty [G_REF] { General reference generator Duty}
     { .ind = 8 ,  .Flags = 0 , .ptr = (float*) &GRefGenPars.bAngleSpeed,.lower =  0.0f,.upper = 1.0f, .defaultVal = 0.0f },// :GRef_bAngleSpeed [G_REF] { General reference generator speed mode flag}
     { .ind = 9 ,  .Flags = CFG_FLOAT , .ptr = (float*) &GRefGenPars.AnglePeriod,.lower =  0.0f,.upper = 100000.0f, .defaultVal = 1.0f },// :GRef_AnglePeriod [G_REF] { General reference generator AnglePeriod}
     { .ind = 10 ,  .Flags = CFG_FLOAT , .ptr = &TRefGenPars.Amp,.lower =  -1000.0f,.upper = 1000.0f, .defaultVal = 0 },// :TRef_Amp [G_REF] { Torque reference generator amplitude}
     { .ind = 11 ,  .Flags = CFG_FLOAT , .ptr = &TRefGenPars.f,.lower =  -6000.0f,.upper = 6000.0f, .defaultVal = 100.0f },// :TRef_F [G_REF] { Torque reference generator Frequency}
     { .ind = 12 ,  .Flags = CFG_FLOAT , .ptr = &TRefGenPars.Dc,.lower =  -1000.0f,.upper = 1000.0f, .defaultVal = 0 },// :TRef_Dc [G_REF] { Torque reference generator DC value}
     { .ind = 13 ,  .Flags = CFG_FLOAT , .ptr = (float*) &TRefGenPars.Duty,.lower =  0.0f,.upper = 1.0f, .defaultVal = 0.5f },// :TRef_Duty [G_REF] { Torque reference generator Duty}
     { .ind = 14 ,  .Flags = CFG_FLOAT , .ptr = (float*) &Commutation.MaxRawCommChangeInCycle, .lower =  0.0f,.upper = 1.0f, .defaultVal = 0.17f },// :MaxRawCommChangeInCycle [Commutation] {Maximum allowed raw commutation change in a cycle}
     { .ind = 15 ,  .Flags = 0 , .ptr = (float*) &Commutation.CommutationMode, .lower =  0.0f,.upper = 3.0f, .defaultVal = 3 },// :CommutationMode [Commutation] {Commutation mode: 1 Halls, 2: Std 3: Hall reset}
     { .ind = 16 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ClaState.Encoder1.UserPosOnHome, .lower =  -2147000000.0f,.upper = 2147000000.0f, .defaultVal = 0 },// :UserPosOnHome [Homing] {User position at homing location}
     { .ind = 17 ,  .Flags = 0  , .ptr = (float*) &ControlPars.MaxSupportedClosure , .lower =  1.0f ,.upper =6.0f, .defaultVal = 1.0f },// :MaxSupportedClosure [Control] {Maximum supported mode of loop closure}
     { .ind = 18 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.qf0.PBw , .lower =  1.0f,.upper = 1000000.0f, .defaultVal = 40.0f },// :qf0PBw [Control] {Filter 0 parameter Pole BW Hz}
     { .ind = 19 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.qf0.PXi , .lower =  0.05f,.upper = 10.0f, .defaultVal = 0.5f },// :qf0PXi [Control] {Filter 0 parameter Pole Xi}
     { .ind = 20 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.qf0.ZBw , .lower =  1.0f,.upper = 1000000.0f, .defaultVal = 40.0f },// :qf0ZBw [Control] {Filter 0 parameter zero BW Hz}
     { .ind = 21 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.qf0.ZXi , .lower =  0.02f,.upper = 10.0f, .defaultVal = 0.5f },// :qf0ZXi [Control] {Filter 0 parameter Zero BW}
     { .ind = 22 ,  .Flags = CFG_RECALC , .ptr = (float*) &ControlPars.qf0.Cfg.ul , .lower =  0.0f,.upper = 127.0f, .defaultVal = 0.0f },// :qf0Cfg [Control] {Filter 0 configuration}
     { .ind = 23 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.qf1.PBw , .lower =  1.0f,.upper = 1000000.0f, .defaultVal = 60.0f },// :qf1PBw [Control] {Filter 1 parameter Pole BW Hz}
     { .ind = 24 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.qf1.PXi , .lower =  0.05f,.upper = 10.0f, .defaultVal = 0.5f },// :qf1PXi [Control] {Filter 1 parameter Pole Xi}
     { .ind = 25 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.qf1.ZBw , .lower =  1.0f,.upper = 1000000.0f, .defaultVal = 60.0f },// :qf1ZBw [Control] {Filter 1 parameter zero BW Hz}
     { .ind = 26 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.qf1.ZXi , .lower =  0.02f,.upper = 10.0f, .defaultVal = 0.5f },// :qf1ZXi [Control] {Filter 1 parameter Zero xi}
     { .ind = 27 ,  .Flags = CFG_RECALC , .ptr = (float*) &ControlPars.qf1.Cfg.ul , .lower =  0.0f,.upper = 127.0f, .defaultVal = 0.0f },// :qf1Cfg [Control] {Filter 1 Configuration}
     { .ind = 28 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.SpeedKp , .lower =  0.0f,.upper = 10.0e6f, .defaultVal = 0.0f },// :SpeedKp [Control] {Speed Kp}
     { .ind = 29 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.SpeedKi , .lower =  0.0f,.upper = 1.0e6f, .defaultVal = 0.0f },// :SpeedKi [Control] {Speed Ki}
     { .ind = 30 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.PosKp , .lower =  0.0f,.upper = 1.0e6f, .defaultVal = 0.0f },// :PosKp [Control] {Position Kp}
     { .ind = 31 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.MaxAcc , .lower =  0.01f,.upper = 1.0e6f, .defaultVal = 1000.0f },// :MaxAcc [Control] {Maximum command acceleration}
     { .ind = 32 ,  .Flags = CFG_FLOAT , .ptr = (float*) &SysState.Profiler.vmax , .lower =  0.01f,.upper = 1.0e6f, .defaultVal = 0.1f },// :ProfileSpeed [Profile] {PTP profile speed}
     { .ind = 33 ,  .Flags = CFG_FLOAT , .ptr = (float*) &SysState.Profiler.accel , .lower =  0.01f,.upper = 1.0e6f, .defaultVal = 100.0f },// :ProfileAcc [Profile] {PTP profile acceleration}
     { .ind = 34 ,  .Flags = CFG_FLOAT , .ptr = (float*) &SysState.Profiler.dec , .lower =  0.01f,.upper = 1.0e6f, .defaultVal = 100.0f },// :ProfileDec [Profile] {PTP profile deceleration}
     { .ind = 35 ,  .Flags = CFG_FLOAT , .ptr = (float*) &SysState.Profiler.tau , .lower =  0.00f,.upper = 1.0e6f, .defaultVal = 0.01f },// :ProfileTau [Profile] {PTP profile assumed speed time delay}
     { .ind = 36 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.OuterSensorBit2User, .lower =  1.0e-6f,.upper = 1.0e-2f, .defaultVal = 1.389031223427680e-03 },// :OuterSensorBit2User [Control] {Wheels only: Ratio of wheel encoder to use position}
     { .ind = 37 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.MotionConvergeWindow, .lower =  0.00f,.upper = 7.0f, .defaultVal = 0.008f },// :MotionConvergeWindow [Control] {User position window for motion convergence}
     { .ind = 38 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.PosErrorLimit, .lower =  0.00f,.upper = 1.0e9f, .defaultVal = 1.e9f },// :PosErrorLimit [Control] {Position error limit for exception throwing}
     { .ind = 39 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.BrakeReleaseDelay, .lower =  0.00f,.upper = 10.0f, .defaultVal = 0.1f },// :BrakeReleaseDelay [Control] {Delay from motor on to start of brake release}
     { .ind = 40 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.BrakeReleaseOverlap, .lower =  0.00f,.upper = 10.0f, .defaultVal = 0.1f },// :BrakeReleaseOverlap [Control] {Delay from brake release to start of motion referencing}
     { .ind = 41 ,  .Flags = 0 , .ptr = (float*) &ControlPars.UseCase, .lower =  0.0f,.upper = 65535.0f, .defaultVal = 0.0f },// :UseCase [Control] {Use case for external digital inputs and potentiometers}
     { .ind = 42 ,  .Flags = CFG_FLOAT , .ptr = (float*) &SysState.OuterSensor.OuterMergeCst, .lower =  0.00f,.upper = 1.0f, .defaultVal =  2.000000000000000e-04f },// :OuterMergeCst [Control] {Filter constant for merging encoder & potentiometer data}
     { .ind = 43 ,  .Flags = CFG_FLOAT | CFG_REVISION , .ptr = (float*) &FloatParRevision, .lower =  -1.0e20f,.upper = 1.0e20f, .defaultVal = 0.0f },// :FloatParRevision [ParametersRevision] {ParametersRevision}
