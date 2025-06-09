// Flags =  0 : long , 2 float , 4 unsigned , 8 short , 64 dfloat (sim only)  (see more options in the CCmdMode definition)
        { 0 , (long unsigned *) & SysState.Timing.UsecTimer },
        { 4 , (long unsigned *) & SysState.Timing.UsecTimer }, //1:UsecTimer [Time] {Microsecond timer at hardware}
        { 0 , (long unsigned *) & SysState.Status.LongException}, //:LongException [Status] {Current exception and aborting exception}
        { 2 , (long unsigned *) & ClaState.Analogs.StoVolts }, //:StoVolts [Analogs] {STO pin voltage}
        { 2 , (long unsigned *) & ClaState.Analogs.Vdc }, //:Vdc [Analogs] {Servo DC voltage}
        { 2 , (long unsigned *) & ClaState.Encoder1.UserPos }, //:UserPos [Sensors] {User position measured by encoder}
        { 2 , (long unsigned *) & ClaState.ThetaPuInUse }, //:ThetaElect [Current] {Electrical angle'}
        { 2 , (long unsigned *) & ClaState.CurrentControl.Iq }, //:Iq [Current] {Current Q channel}
        { 2 , (long unsigned *) & ClaState.Encoder1.UserSpeed }, //:UserSpeed [Sensors] {User Speed measured by encoder}
        { 2 , (long unsigned *) & ClaState.Encoder1.UserPos }, //:UserPos [Sensors] {User position measured by encoder}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseCur[0] }, //:PhaseCur0 [Analogs] {Motor current A}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseCur[1] }, //:PhaseCur1 [Analogs] {Motor current B}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseCur[2] }, //:PhaseCur2 [Analogs] {Motor current C}
        { 8 , (long unsigned *) & ClaState.AdcRaw.PhaseCurAdc[0]}, //:PhaseCurAdc0 [Analogs] {ADC Motor current A}
        { 8 , (long unsigned *) & ClaState.AdcRaw.PhaseCurAdc[1]}, //:PhaseCurAdc1 [Analogs] {ADC Motor current B}
        { 8 , (long unsigned *) & ClaState.AdcRaw.PhaseCurAdc[2]}, //:PhaseCurAdc2 [Analogs] {ADC Motor current C}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseVolts[0]}, //:PhaseVolts0 [Analogs] {ADC Motor voltage raw sample A}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseVolts[1]}, //:PhaseVolts1 [Analogs] {ADC Motor voltage raw sample B}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseVolts[2]}, //:PhaseVolts2 [Analogs] {ADC Motor voltage raw sample C}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseVoltUnCalib[0]}, //:PhaseVoltUnCalib0 [Analogs] {ADC Motor voltage raw sample A}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseVoltUnCalib[1]}, //:PhaseVoltUnCalib1 [Analogs] {ADC Motor voltage raw sample B}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseVoltUnCalib[2]}, //:PhaseVoltUnCalib2 [Analogs] {ADC Motor voltage raw sample C}
        { 2 , (long unsigned *) & ClaState.Analogs.DcCurUncalib}, //:DcCurUncalib [Analogs] {ADC DC current raw sample C}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseVoltUnCalibSum[0]}, //:PhaseVoltUnCalibSum0 [Analogs] {ADC Motor voltage raw sample A}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseVoltUnCalibSum[1]}, //:PhaseVoltUnCalibSum1 [Analogs] {ADC Motor voltage raw sample B}
        { 2 , (long unsigned *) & ClaState.Analogs.PhaseVoltUnCalibSum[2]}, //:PhaseVoltUnCalibSum2 [Analogs] {ADC Motor voltage raw sample C}
        { 2 , (long unsigned *) & ClaState.Analogs.DcCurUncalibSum}, //:DcCurUncalibSum [Analogs] {ADC DC current raw sample C}
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastVload  [ClaRecsCopy] {FastVload }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastVout  [ClaRecsCopy] {FastVout }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastIsense  [ClaRecsCopy] {FastIsense }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastIload  [ClaRecsCopy] {FastVload }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastVdc  [ClaRecsCopy] {FastVdc }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastD  [ClaRecsCopy] {FastD }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastVref  [ClaRecsCopy] {FastVref }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastCurrentDemand  [ClaRecsCopy] {FastCurrentDemand }
