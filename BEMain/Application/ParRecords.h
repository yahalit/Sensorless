   {& ClaControlPars.Rev2Pos,1, -1.0f,1.0f,0.05f} ,// !< Scale encoder to position units, 1 / gear ratio
   {& ControlPars.FullAdcRangeCurrent,2, -100.0f,100.0f,FULL_ADC_RANGE_CURRENT_NECK} ,// !< Current for the full range of the ADC (over-ridden)
   {& ControlPars.MaxSpeedCmd,4, 1.0e-3f,1.0e6f,100.0f} ,// !< Maximum permissible speed command
   {& ControlPars.SpeedCtlDelay,5, 0.0f,1.0f,0.1f} ,// !< Delay to account for when preparing speed control command
   {& ControlPars.MaxCurCmd,9, 1.0f,1.0e6f,16.0f} ,// !< Maximum permissible current command
   {& ClaControlPars.VoltageDacGain,11, 1.0e-3f,1.0e6f,0.66667f} ,//  !< DAC gain for integrating phase voltage
   {& ClaControlPars.DcCurrentDacGain,12, 1.0e-3f,1.0e6f,1.0f} ,//  !< DAC gain for integrating DC supply current
   {& ClaControlPars.MaxCurCmdDdt,14, 1.0f,1.0e6f,1.0f} ,//  !< Maximum permissible rate for current command
   {& ClaControlPars.KeHz,15, 0.0000f,1.0e6f,0.0f} ,// !< Speed to required motor voltage
   {& ClaControlPars.KpCur,16, 1.0e-6f,4.0e1f,1.5f} ,// !< Kp for current control
   {& ClaControlPars.KiCur,17, 1.0e-6f,6.0e4f,6000.0f} ,// !< Ki for current control
   {& ClaControlPars.VectorSatFac,18, 0.1f,1.0f,0.63f} ,// !< Vector saturation factor
   {& ClaControlPars.KAWUCur,19, 0.0000001f,1.0e6f,0.95f} ,// !< Anti windup scale for current control
   {& ClaControlPars.VDcMax,20, 0.0000001f,1.0e6f,680.0f} ,// !< Maximum for VDC
   {& ClaControlPars.VDcMin,21, 0.0000001f,1.0e6f,17.0f} ,// !< Minimum for VDC
   {& ControlPars.I2tCurLevel,22, 0.0000001f,1.0e6f,20.0f} ,//// !< Level for I2C current protection
   {& ControlPars.I2tCurTime,23, 0.0000001f,1.0e6f,24.0f} ,// // !< Time in Current level for I2C current protection
   {& ControlPars.SpeedFilterBWHz,24, 1.0f,1.0e6f,500.0f} ,//  !< Speed filter BW in Hz
   {& ControlPars.CurrentFilterBWHz,25, 1.0f,1.0e6f,2000.0f} ,//  !< Current loop input filter BW in Hz
   {& ControlPars.MinPositionCmd,26, -1.0e6f,-0.000001f,-24.0f} , // !< Minimum position command
   {& ControlPars.MaxPositionCmd,27, 0.0000001f,1.0e6f,24.0f} , // !< Maximum position command
   {& ControlPars.ShortCircuitLimitAmp,28, 0.0000001f,1.0e6f,24.0f} , // !< Short circuit limit Amperes
   {& ControlPars.CurrentOffsetGain,29, 0.0000001f,1.0e6f,0.005f} , // !< Gain for correcting current measurement offset
   {& ClaControlPars.Vdc2Bit2Volt,30, -1.0f,1.0f,VDC_2_BIT_VOLTS_R2} ,// !< Scale bus voltage sampled bits to volts
   {& ClaControlPars.Adc2BusAmps,31, -1.0f,1.0f,0.0201f} ,// !< Scale bus current sampled bits to amperes
   {& ClaControlPars.nPolePairs,32, 1.0f,100.0f,N_POLE_PAIRS} ,// !< Number of pole pairs
   {& ControlPars.StopDeceleration,33, 0.0000001f,1.0e6f,270.0f} , // !< Deceleration for motion stop
   {& ControlPars.SpeedConvergeWindow,37, 0.0000001f,1.0e6f,0.1f} , // !< Time window for speed convergence
   {& ControlPars.ProfileTau,38, 0.0f,1.0f,0.10f} ,// !< Delay assumption in profile
   {& HallDecode.HallAngleOffset, 39, -1.0f,1.0f, HALL_SENSORS_OFFSET } ,// !< Offset to Hall sensors
   {& ControlPars.EncoderCountsFullRev,40, 32.0f,4.0e6f,ENC_COUNTS_PER_REV} ,// !< Commutation encoder counts in full revolution
   {& ClaControlPars.StoFatalThold,41, 0.0f,5.0f,2.1f} ,// !< STO Fatal threshold, volts
   {& ClaControlPars.StoWarnThold,42, 0.0f,5.0f,2.56f} ,// !< STO warning threshold, volts
   {& ControlPars.AbsoluteUndervoltage,43,11.0f,45.0f,SC_UNDERVOLTAGE_VOLTS} , // !< Under voltage hardware trip point
   {& ControlPars.AbsoluteOvervoltage,44, 11.0f,95.0f,ABS_OVERVOLTAGE_VOLTS} ,// !<  Over voltage hardware trip point
   {& ControlPars.DcShortCitcuitTripVolts,45, 0.01f,3.25f,SC_DC_CMP_VOLTS} ,// !< Delay assumption in profile
   {& ClaControlPars.PhaseOverCurrent,46, 0.50f,55.0f,PHASE_OVERCURRENT_AMP} ,// !< Out of range current for a motor phase
   {& ClaControlPars.MaxThetaPuDelta,47, 0.001f,0.17f,0.0333f} ,// !< Max change in PU field angle per cycle
   {& ClaControlPars.MinPotRef,90, -1.0f,4.0f,3.0f} ,// !< Minimum legal value for potentiometer reference
   {& ClaControlPars.PotFilterCst,91, 0.0f,1.0f,0.3f} ,// !< Potentiometer 1st order filter constant
   {& ControlPars.BrakeReleaseVolts,92, 15.0f,36.0f,16.5f} ,// !< Brake release volts
   {& ControlPars.MaxTemperature,93, 0.0f,150.0f,85.0f} ,// !< Temperature limit for exception
   {& SysState.Homing.HomingSpeed,94, 0.001f,15.0f,0.1f} ,// !< User Speed used for homing
   {& ControlPars.AutoMotorOffTime ,95, 0.001f,15.0f,3.0f}, // Time for automatic motor off if motion converged
   {& SysState.EncoderMatchTest.DeltaTestUser ,97, 0.001f,15.0f,1.0f}, // Position travel for encoder match test
   {& SysState.EncoderMatchTest.DeltaTestTol ,98, 0.001f,15.0f,0.065f}, // Encoder comparison tolerance  - Position travel for encoder match test
   {& SysState.EncoderMatchTest.MaxPotentiometerPositionDeviation ,99, 0.001f,15.0f,0.1f}, // EMaximum permitted difference between filtered potentiometer and encoder reading
   {& ControlPars.MotionConvergeTime ,100, 0.001f,15.0f,0.1f}, // Time required for within window error to declare motion convergence
   {& ControlPars.SpeedConvergeWindow ,101, 0.0001f,15.0f,0.05f}, // Required maximal error for consecutive MotionConvergeTime to declare motion convergence
   {& ControlPars.PositionConvergeWindow,102, 0.0000001f,1.0e6f,0.1f} , // !< Required maximal position error for consecutive MotionConvergeTime to declare motion convergence
   {& SysState.StepperCurrent.StaticCurrent, 105 , 0.0f,18.0f,14.0f} , // !<  Static Current for stepper mode
   {& SysState.StepperCurrent.SpeedCurrent , 106 , 0.0f,1.0e1f,1.0f} , // !<   Speed dependent Current for stepper mode
   {& SysState.StepperCurrent.AccelerationCurrent, 107 , 0.0f,1.0e2f,2.0f} , // !<  Acceleration dependent Current for stepper mode
   {& SLPars.PhiM, 110 , 0.0000001f,1.0e6f,0.130f} , // !<  Flux of magnet
   {& SLPars.Lq0, 111 , 0.0000001f,1.0e6f,5.0e-4f} , // !<  Nominal inductance for q
   {& SLPars.LqCorner2, 112 , 0.0000000f,1.0e6f,0.0f} , // !< Saturation current for q field
   {& SLPars.Ld0, 113 , 0.0000000f,1.0e6f,5.0e-4f} , // !<  Nominal inductance for d
   {& SLPars.LdSlope, 114 , 0.0000000f,1.0e6f,0.0f} , // !<  Linear dependence of D inductance in d current
   {& SLPars.R, 115 , 0.0000001f,1.0e6f,0.13f} , // !<  Resistance
   {& SLPars.KiTheta, 116 , 0.0000001f,1.0e6f,7.8026e+03f} , // !<  Ki of the theta PLL
   {& SLPars.KpTheta, 117 , 0.0000001f,1.0e6f,149.0188f} , // !<Kp of the theta PLL
   {& SLPars.KiFlux, 118 , 0.0000001f,1.0e6f,50.0f} , // !<KiFlux
   {& SLPars.KpFlux, 119 , 0.0000001f,1.0e6f,500.0f} , // !<KpFlux
   {& SLPars.DInjectionFreqFac, 120 , 0.0000001f,1.0e6f,0.0f} , // !<Factor between D injection frequency and motor frequency
   {& SLPars.DInjectionAmp, 121 , 0.0000001f,1.0e6f,0.9f} , // !<D injection amplitude in Amp
   {& SLPars.FomPars.CyclesForConvergenceApproval, 122 , 0.0000001f,1.0e6f,3.0f} ,// !< The number of cycles in open loop mode in which the observer must show convergence
   {& SLPars.FomPars.ObserverConvergenceToleranceFrac, 123 , 0.0000001f,1.0e6f,0.1f} , // !< The acceptable fraction of deviation from the expected speed
   {& SLPars.FomPars.MaximumSteadyStateFieldRetard, 124 , 0.000000f,1.0f,0.17f} ,  // !< The maximum field retard acceptable on steady state.
   {& SLPars.FomPars.MinimumSteadyStateFieldRetard, 125 , -1.0f,1.0f,-0.05f} , // !< The minimum field retard acceptable on steady state.
   {& SLPars.FomPars.FOMTakingStartSpeed, 126 , 0.0000001f,1.0e6f,4.0f} , // !< Speed following which FOM is taken
   {& SLPars.FomPars.OpenLoopAcceleration, 127 , 0.0000001f,1.0e6f,1.0f} , // !< The acceleration rate to OpenLoopEndSpeed
   {& SLPars.FomPars.FOMConvergenceTimeout, 128 , 0.0000001f,1.0e6f,3.0f} , // Timeout for FOM convergence decision
   {& SLPars.FomPars.OmegaCommutationLoss, 130 , 0.0000001f,1.0e6f,3.0f} , // Speed that if you go below you consider commutation loss
   {& SLPars.WorkAcceleration, 131 , 0.0000001f,1.0e6f,3.0f} , // Acceleration to working speed
   {& SLPars.WorkSpeed, 132 , 0.0000001f,1.0e6f,6.0f} , // Working speed
   {& SLPars.FomPars.InitiallStabilizationTime,133, 0.0000001f,1.0e6f,1.5f} , // Time for initial rotor stabilization
   {& SLPars.Pars6Step.TransitionTime,134, 0.0000001f,1.0e-2f,1.3e-3f} , // Time for transition allowance on 6-step event
   {& SLPars.Pars6Step.SummingTime,135, 0.0000001f,1.0e-2f,1.3e-3f} , // Time for summing voltage / current for R estimate
   {& SLPars.Pars6Step.MinimumCur4RCalc,136, 0.0000001f,1.0e2f,5.0f} , // Minimum current step for a well defined R evaluation
   {& SLPars.Pars6Step.OpenLoopCurDiDtMax,137, 0.0000001f,1.0e3f,12.0f} , // Maximum current rise rate for open loop mode
   {& ClaMailIn.StoTholdScale,239, -1.5f,1.5f,1.0f} ,// !< Simulation voltage DC bus
   {& ClaControlPars.DCurrentMaxDiDt,246, 0.000001f,99999999.0f,200.0f} ,// !< Maximum rate of D current commad change
   {& ClaControlPars.ExtCutCst,247, 0.000001f,0.99999999f,0.001666f} ,// !< Filter constant for torque report , about 30msec
   {& ControlPars.KGyroMerge,248, 0.00000f,0.99999999f,0.00125f} ,// !< Filter constant for gyro merge
   {& ControlPars.PosErrorExtRelGain,249, 0.00000f,9999.9999f,0.45f} , // Relative gain change when external pos error is applied
   {& ControlPars.PosErrorExtLimit,250, 0.00000f,0.99999999f,0.08f} , // Limit of position error for the external error mode
   {& SysState.SteerCorrection.WheelAddZ,251, 0.00000f,0.99999999f,0.002f} , // Filter coefficient for steering correction
   {& SysState.SteerCorrection.SteeringColumnDistRatio,252, -2.0f,2.0f,0.65f} , // Ratio Distance of steering column from centre of ground wheel / wheel radi
