// Flags =  0 : long , 2 float , 4 unsigned , 8 short , 64 dfloat (sim only)  (see more options in the CCmdMode definition)
        { 0 , (long unsigned *) & SysState.Timing.UsecTimer },
        { 4 , (long unsigned *) & SysState.Timing.UsecTimer }, //1:UsecTimer [Time] {Microsecond timer at hardware}
        { 4 , (long unsigned *) & SysState.CBit.all}, //:CBit [System] {CBit status bit field}
        { 0 , (long unsigned *) & SysState.Status.LongException}, //:LongException [Status] {Current exception and aborting exception}
        { 0 , (long unsigned *) & SysState.Mot.KillingException}, //:KillingException [Status] {Reason of motor kill}
        { 0 , (long unsigned *) & SysState.Mot.LastException}, //:LastException [Status] {Last exception}
        { 2 , (long unsigned *) & ClaState.Analogs.Vdc }, //:Vdc [Analogs] {Servo DC voltage}
        { 2 , (long unsigned *) & ClaState.Encoder1.UserPos }, //:UserPos [Sensors] {User position measured by encoder}
        { 2 , (long unsigned *) & ClaState.ThetaPuInUse }, //:ThetaElect [Current] {Electrical angle'}
        { 2 , (long unsigned *) & ClaState.CurrentControl.Iq }, //:Iq [Current] {Current Q channel}
        { 2 , (long unsigned *) & ClaState.CurrentControl.Id }, //:Id [Current] {Current D channel}
        { 2 , (long unsigned *) & ClaState.Encoder1.UserSpeed }, //:UserSpeed [Sensors] {User Speed measured by encoder}
        { 2 , (long unsigned *) & ClaState.Encoder1.UserPos }, //:UserPos [Sensors] {User position measured by encoder}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseCur[0] }, //:PhaseCur0 [Analogs] {Motor current A}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseCur[1] }, //:PhaseCur1 [Analogs] {Motor current B}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseCur[2] }, //:PhaseCur2 [Analogs] {Motor current C}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseCurAmc[0] }, //:PhaseCurAmc0 [Analogs] {Motor current AMC A}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseCurAmc[1] }, //:PhaseCurAmc1 [Analogs] {Motor current AMC B}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseCurAmc[2] }, //:PhaseCurAmc2 [Analogs] {Motor current AMC C}
        { 2 , (long unsigned *) & ClaState.va}, //:va [Voltage] {Voltage of phase A}
        { 2 , (long unsigned *) & ClaState.vb}, //:vb [Voltage] {Voltage of phase B}
        { 2 , (long unsigned *) & ClaState.vc}, //:vc [Voltage] {Voltage of phase C}
        { 2 , (long unsigned *) & ClaMailOut.PwmA}, //:PwmA [Voltage] {PWM of phase A}
        { 2 , (long unsigned *) & ClaMailOut.PwmB}, //:PwmB [Voltage] {PWM of phase B}
        { 2 , (long unsigned *) & ClaMailOut.PwmC}, //:PwmC [Voltage] {PWM of phase C}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseVoltUnCalib[0]}, //:PhaseVoltUnCalib0 [Analogs] {ADC Motor voltage raw sample A}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseVoltUnCalib[1]}, //:PhaseVoltUnCalib1 [Analogs] {ADC Motor voltage raw sample B}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseVoltUnCalib[2]}, //:PhaseVoltUnCalib2 [Analogs] {ADC Motor voltage raw sample C}
        { 2 , (long unsigned *) & ClaState.Analogs.DcCurUncalib}, //:DcCurUncalib [Analogs] {ADC DC current raw sample C}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseVoltUnCalibSum[0]}, //:PhaseVoltUnCalibSum0 [Analogs] {ADC Motor voltage raw sample A}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseVoltUnCalibSum[1]}, //:PhaseVoltUnCalibSum1 [Analogs] {ADC Motor voltage raw sample B}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseVoltUnCalibSum[2]}, //:PhaseVoltUnCalibSum2 [Analogs] {ADC Motor voltage raw sample C}
        { 2 , (long unsigned *) & ClaState.Analogs.DcCurUncalibSum}, //:DcCurUncalibSum [Analogs] {ADC DC current raw sample C}
        { 0 , (long unsigned *) & SysState.CLMeas.ExtState} , //:ExtLmeasState [LMeasure] {Extended process state}
        { 2 , (long unsigned *) & ClaState.DacValU[0]}, //:DacValU0 [Analogs] {DacValU0}
        { 2 , (long unsigned *) & ClaState.DacValU[1]}, //:DacValU1 [Analogs] {DacValU1}
        { 2 , (long unsigned *) & ClaState.DacValU[2]}, //:DacValU2 [Analogs] {DacValU2}
        { 2 , (long unsigned *) & ClaState.DacValDc}, //:DacValDc [Analogs] {DacValDc}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseVoltMeas[0]}, //:PhaseVoltMeas0 [Analogs] {PhaseVoltMeas0}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseVoltMeas[1]}, //:PhaseVoltMeas1 [Analogs] {PhaseVoltMeas1}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseVoltMeas[2]}, //:PhaseVoltMeas2 [Analogs] {PhaseVoltMeas2}
        { 2 , (long unsigned *) & ClaState.MotorOn}, //:MotorOn [System] {MotorOn}
        { 2 , (long unsigned *) & ClaState.MotorOnRequest}, //:MotorOnRequest [System] {MotorOnRequest}
        { 2 , (long unsigned *) & ClaState.vqd }, //:vqd [Current] {Vq output of q controller }
        { 2 , (long unsigned *) & ClaState.CurrentControl.CurrentCommand }, //:InternalCurrentCommand [Current] {Directional current command: speed correction + FF}
        { 2 , (long unsigned *) & ClaState.CurrentControl.ExtCurrentCommand }, //:CurrentCommand [Current] {Composite current command: speed correction + FF}
        { 2 , (long unsigned *) & ClaState.CurrentControl.CurrentCommandSlopeLimited }, //:CurrentCommandSlopeLimited [Current] {Limited Reference to current control}
        { 2 , (long unsigned *) & ClaState.CurrentControl.CurrentCmdFilterState0 }, //:CurrentCmdFilterState0 [Current] {Reference filter state 0 to current control}
        { 2 , (long unsigned *) & ClaState.CurrentControl.CurrentCmdFilterState1 }, //:CurrentCmdFilterState1 [Current] {Reference filter state 1 to current control}
        { 2 , (long unsigned *) & ClaState.CurrentControl.ExtCurrentCommandFiltered }, //:CurrentCommandFiltered [Current] {Reference to current control - final filtered}
        { 2 , (long unsigned *) & ClaState.CurrentControl.CurrentCommandFiltered }, //:InternalCurrentCommandFiltered [Current] {Reference to current control - final filtered}
        { 0 , (long unsigned *) & SysState.Timing.LmeasClocksOfInt }, //:LmeasClocksOfInt [LMeasure] {Max number of clocks in an interrupt}
        { 2 , (long unsigned *) & SLessState.ThetaEst}, //:SlessThetaEst  [SensorLess] {Sensorless ThetaEst}
        { 2 , (long unsigned *) & SLessState.ThetaPsi}, //:SlessThetaPsi  [SensorLess] {Sensorless ThetaPsi}
        { 2 , (long unsigned *) & SLessState.IAlpha}, //:SlessIAlpha  [SensorLess] {Sensorless IAlpha}
        { 2 , (long unsigned *) & SLessState.IBeta}, //:SlessIBeta  [SensorLess] {SensorlessIBeta }
        { 2 , (long unsigned *) & SLessState.VAlpha}, //:SlessVAlpha  [SensorLess] {SensorlessVAlpha }
        { 2 , (long unsigned *) & SLessState.VBeta}, //:SlessVBeta  [SensorLess] {Sensorless VBeta}
        { 2 , (long unsigned *) & SLessState.Id}, //:SlessId  [SensorLess] {Sensorless Id}
        { 2 , (long unsigned *) & SLessState.Iq}, //:SlessIq  [SensorLess] {Sensorless Iq}
        { 2 , (long unsigned *) & SLessState.Phida}, //:SlessPhida  [SensorLess] {Sensorless Phida}
        { 2 , (long unsigned *) & SLessState.FluxIntA}, //:SlessFluxIntA  [SensorLess] {Sensorless FluxIntA}
        { 2 , (long unsigned *) & SLessState.FluxIntB}, //:SlessFluxIntB  [SensorLess] {Sensorless FluxIntB}
        { 2 , (long unsigned *) & SLessState.FluxErrA}, //:SlessFluxErrA  [SensorLess] {Sensorless FluxErrA}
        { 2 , (long unsigned *) & SLessState.FluxErrB}, //:SlessFluxErrB  [SensorLess] {Sensorless FluxErrB}
        { 2 , (long unsigned *) & SLessState.FluxErrIntA}, //:SlessFluxErrIntA  [SensorLess] {Sensorless FluxErrIntA}
        { 2 , (long unsigned *) & SLessState.FluxErrIntB}, //:SlessFluxErrIntB  [SensorLess] {Sensorless FluxErrIntB}
        { 2 , (long unsigned *) & SLessState.VcompA}, //:SlessVcompA  [SensorLess] {Sensorless VcompA}
        { 2 , (long unsigned *) & SLessState.VcompB}, //:SlessVcompB  [SensorLess] {Sensorless VcompB}
        { 2 , (long unsigned *) & SLessState.ETheta}, //:SlessETheta  [SensorLess] {Sensorless ETheta}
        { 2 , (long unsigned *) & SLessState.OmegaHat}, //:SlessOmegaHat  [SensorLess] {Sensorless OmegaHat}
        { 2 , (long unsigned *) & SLessState.OmegaState}, //:SlessOmegaState  [SensorLess] {Sensorless OmegaState}
        { 2 , (long unsigned *) & SLessState.ThetaHat}, //:SlessThetaHat  [SensorLess] {Sensorless ThetaHat}
        { 2 , (long unsigned *) & SLessState.IdDemandPhase}, //:SlessIdDemandPhase  [SensorLess] {Sensorless IdDemandPhase}
        { 2 , (long unsigned *) & SLessState.IdDisturbancePhase}, //:SlessIdDisturbancePhase  [SensorLess] {Sensorless IdDisturbancePhase}
        { 2 , (long unsigned *) & SLessState.CommAngleDisturbance}, //:SlessCommAngleDisturbance  [SensorLess] {Sensorless CommAngleDisturbance}
        { 2 , (long unsigned *) & SLessState.CommAngleQuadDisturbance}, //:SlessCommAngleQuadDisturbance  [SensorLess] {Sensorless CommAngleQuadDisturbance}
        { 8 , (long unsigned *) & SLessState.On}, //:SlessOn  [SensorLess] {Sensorless On}
        { 8 , (long unsigned *) & SLessState.DInjectionOn}, //:SlessDInjectionOn [SensorLess] {Sensorless DInjectionOn}
        { 2 , (long unsigned *) & SLessData.V[0]}, //:SLessDataV0  [SensorLess] {Voltage A}
        { 2 , (long unsigned *) & SLessData.V[1]}, //:SLessDataV1  [SensorLess] {Voltage B}
        { 2 , (long unsigned *) & SLessData.V[2]}, //:SLessDataV2  [SensorLess] {Voltage C}
        { 2 , (long unsigned *) & SLessData.I[0]}, //:SLessDataI0  [SensorLess] {Current A}
        { 2 , (long unsigned *) & SLessData.I[1]}, //:SLessDataI1  [SensorLess] {Current B}
        { 2 , (long unsigned *) & SLessData.I[2]}, //:SLessDataI2  [SensorLess] {Current C}
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastVload  [ClaRecsCopy] {FastVload }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastVout  [ClaRecsCopy] {FastVout }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastIsense  [ClaRecsCopy] {FastIsense }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastIload  [ClaRecsCopy] {FastVload }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastVdc  [ClaRecsCopy] {FastVdc }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastD  [ClaRecsCopy] {FastD }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastVref  [ClaRecsCopy] {FastVref }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastCurrentDemand  [ClaRecsCopy] {FastCurrentDemand }
