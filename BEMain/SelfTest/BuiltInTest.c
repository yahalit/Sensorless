/*
 * BIT.c
 *
 *  Created on: May 12, 2023
 *      Author: Gal Lior
 */
#include "..\Application\StructDef.h"

//Control the brake release on motion start
//Routine is called only if motor ON
inline
void ManageBrakeRelease(void)
{
    // Delay for brake release
    if ( SysState.Mot.InBrakeReleaseDelay )
    {
        if ( SysState.Mot.InBrakeReleaseDelay == 1 )
        {// Phase 1: Motor starts, but brake will not release
            SysState.Mot.BrakeRelease = 0 ;
            if ( IsSysTimerElapse ( TIMER_RELEASE_BRAKE,  &SysTimerStr  ))
            { //Enough time for motor start, we now go to the overlap stage in which motor control is active beside the locked brak
                SetSysTimerTargetSec ( TIMER_OVERLAP_BRAKE     , ControlPars.BrakeReleaseOverlap ,  &SysTimerStr  );
                SysState.Mot.InBrakeReleaseDelay = 2 ;
            }
        }
        else
        {
            if ( IsSysTimerElapse ( TIMER_OVERLAP_BRAKE,  &SysTimerStr  ))
            { // Done , release brake
                SysState.Mot.BrakeRelease = 1 ;
                SysState.Mot.InBrakeReleaseDelay = 0 ;
            }
        }
    }
    else
    {
        // If brake is over ridden take the override; otherwise just release brake for motion
        SysState.Mot.BrakeRelease = 1 ;
    }
}


inline
void ManageBrakeEngage( enum E_MotorOffType method)
{
    float Time2Stop ;
    switch (SysState.Mot.InBrakeEngageDelay )
    {
    case INBD_EngageInit:
        // Set a stop time to get rid of any existing speed
        Time2Stop = __fmin( SysState.SpeedControl.SpeedReference / __fmax(ControlPars.MaxAcc,0.0001f) + 0.03f , 0.15f ) ;
        SetSysTimerTargetSec ( TIMER_ENGAGE_BRAKE     ,  Time2Stop ,  &SysTimerStr  );
        SysState.Mot.QuickStop = 1 ;
        SysState.Mot.InBrakeEngageDelay = INBD_WaitZeroSpeedRef  ;
        break ;
    case INBD_WaitZeroSpeedRef:
        SysState.Mot.QuickStop = 1 ;
        if ( IsSysTimerElapse ( TIMER_ENGAGE_BRAKE,  &SysTimerStr  ))
        { // Time elapsed, speed reference is by now zero + timed allotted for stabilization
            SysState.Mot.BrakeRelease = 0 ; // Command brake engage
            SysState.Mot.InBrakeEngageDelay = INBD_WaitBrakeEngage  ; // State is waiting for engagement
            SetSysTimerTargetSec ( TIMER_ENGAGE_BRAKE     ,  ControlPars.BrakeReleaseOverlap ,  &SysTimerStr  );
        }
        break ;
    case INBD_WaitBrakeEngage:
        // Wait time for brake engagement
        SysState.Mot.QuickStop = 1 ;
        if ( IsSysTimerElapse ( TIMER_ENGAGE_BRAKE,  &SysTimerStr  ))
        { // Elapsed
            if (ClaState.SystemMode == E_SysMotionModeSafeFault)
            {// If a fault is pending , activate it now
                LogException( EXP_FATAL , SysState.Mot.SafeFaultCode) ;
            }
            else
            {// Ok, just shut motor
                SetMotorOff(method) ;
            }
            SysState.Mot.InBrakeEngageDelay = INBD_EngageNothing;
        }
        break ;
    }
}

void TestPotRef(void)
{
     if ( ControlPars.UseCase  & (UC_USE_POT1|UC_USE_POT2|UC_USE_SW1_HM|UC_USE_SW2_HM)  )
     {
         if (ClaState.PotRefFail && ClaState.MotorOn )
         {
             LogException(EXP_SAFE_FATAL,exp_pot_ref_failed) ;
         }
     }
}


inline
short SpeedManageAutomaticBrakeEngage(short unsigned PreventAutoStop)
{

    float dUser , delta ;
    short unsigned mode  ;

    mode = 0 ;
    delta = ClaState.Encoder1.Pos - SysState.StartStop.RefEncoderCountsForAutoStop;
    dUser = fabsf(delta * ClaState.Encoder1.Bit2Rev * ClaState.Encoder1.Rev2Pos) ;

    SysState.StartStop.StartStopTimer =  GetRemainTimeSec( TIMER_AUTO_MOTOROFF );

    if (fabsf(SysState.SpeedControl.SpeedTarget ) > 1.0e-3f)
    { // Set to motor on, override "InAutoBrakeEngage" state
        mode |= 1 ;
        PreventAutoStop = 1  ;
    }
    if (fabsf(SysState.SpeedControl.SpeedTarget - SysState.SpeedControl.SpeedReference) > 1.0e-3f)
    { // Set to motor on, override "InAutoBrakeEngage" state
        mode |= 2 ;
        PreventAutoStop = 1  ;
    }
    if ( dUser  > ControlPars.HiAutoMotorOffThold   )
    { // Set to motor on, override "InAutoBrakeEngage" state
        mode |= 4 ;
        PreventAutoStop = 1  ;
    }

    if (  SysState.Mot.InAutoBrakeEngage   )
    {
        if ( PreventAutoStop )
        {
            SetMotorOn(2) ; // No auto stop in this mode
        }
    }
    else
    {
        if (   ClaState.MotorOnRequest )
        {  // Motor is on, seek conditions to shut
            if ( dUser  > ControlPars.LowAutoMotorOffThold   )
            { // Set to motor on, override "InAutoBrakeEngage" state
                mode |= 16 ;
                PreventAutoStop = 1  ;
            }
           // Test significant control error for wake-up
            if ( PreventAutoStop == 0 )
            {
               if ( IsSysTimerElapse ( TIMER_AUTO_MOTOROFF,  &SysTimerStr)  )
               {
                   mode |= 32 ;
                   SetMotorOff( E_OffForAutoEngage ) ;
               }
               else
               {
                   // Time the next possible shut-down ,and reset the the comparison position reference
                  mode |= 64 ;
                  ArmAutomaticMotorOff() ;
               }
            }
            else
            {
                // Time the next possible shut-down ,and reset the the comparison position reference
               mode |= 128 ;
               ArmAutomaticMotorOff() ;
            }
        }
    }
    SysState.StartStop.ErrorForAutoStop = dUser ;
    return mode ;
}

inline
short PosManageAutomaticBrakeEngage(short unsigned PreventAutoStop )
{
    float dUser ;
    short unsigned mode  ;

    mode = 0 ;
    dUser = fabsf(SysState.PosControl.PosErrorR );
    SysState.StartStop.StartStopTimer =  GetRemainTimeSec( TIMER_AUTO_MOTOROFF );
    if (  SysState.Mot.InAutoBrakeEngage   )
    { // Test significant reference change for wake-up
        dUser = __fmax( dUser, fabsf(SysState.StartStop.RefPositionCommandForAutoStop - SysState.PosControl.PosReference ) );
        // Test significant control error for wake-up
        dUser = __fmax( dUser, fabsf(SysState.StartStop.RefPositionCommandForAutoStop - SysState.PosControl.PosFeedBack) ) ;

        if ( PreventAutoStop )
        {
            SetMotorOn(2) ; // No auto stop in this mode
        }
        else
        {
            if (  SysState.Mot.ReferenceMode == E_PosModePTP )
            {
                mode |= 1 ;
                dUser = __fmax( dUser, fabsf(SysState.Profiler.PosTarget - SysState.PosControl.PosReference ) ) ;
            }
            if ( dUser  > ControlPars.HiAutoMotorOffThold   )
            { // Set to motor on, override "InAutoBrakeEngage" state
                mode |= 2 ;
                SetMotorOn(2) ;
            }
        }
    }
    else
    {
        if (  (SysState.Mot.ReferenceMode == E_PosModePTP) && (SysState.Profiler.Done == 0 ))
        {
            PreventAutoStop = 1 ;
        }
        if (   ClaState.MotorOnRequest )
        {  // Motor is on, seek conditions to shut
            // Test significant control error for wake-up
            if ( PreventAutoStop == 0 )
            {
               mode |= 8 ;
               if (  dUser  < ControlPars.LowAutoMotorOffThold)
               { // Small enough error for enough time - shut down , and mark automatic shutdown
                   mode |= 16 ;
                   if ( IsSysTimerElapse ( TIMER_AUTO_MOTOROFF,  &SysTimerStr)  )
                   {
                       mode |= 32 ;
                       SetMotorOff( E_OffForAutoEngage ) ;
                   }
               }
               else
               {
                   // Time the next possible shut-down ,and reset the the comparison position reference
                  mode |= 64 ;
                  ArmAutomaticMotorOff() ;
               }
            }
            else
            {
                // Time the next possible shut-down ,and reset the the comparison position reference
               mode |= 128 ;
               ArmAutomaticMotorOff() ;
            }
        }
    }
    SysState.StartStop.ErrorForAutoStop = dUser ;
    return mode ;
}

/*
 * Manage automatic brake engagement if motion is converged
 */
void ManageAutomaticBrakeEngage(void)
{
    short unsigned PreventAutoStop ;
    if ( ClaState.MotorOnRequest)
    {
        if ( (ClaState.SystemMode == E_SysMotionModeSafeFault)
                || SysState.Mot.InBrakeReleaseDelay
                || SysState.Mot.InBrakeEngageDelay )
        { // Already in auto braking mode, do not disturb
            SetSysTimerTargetSec ( TIMER_AUTO_MOTOROFF , ControlPars.AutoMotorOffTime + ControlPars.BrakeReleaseOverlap + ControlPars.BrakeReleaseDelay , &SysTimerStr  );
            return  ;
        }
    }

    if ( (SysState.Mot.LoopClosureMode == E_LC_EXTDual_Pos_Mode)
            ||  (SysState.Mot.ReferenceMode == E_PosModePT)
            ||  SysState.Status.DisableAutoBrake
            ||  SysState.SteerCorrection.bSteeringComprensation  || SysState.IntfcDisableWheelAutoStop )
    {
        PreventAutoStop = 1 ;
    }
    else
    {
        PreventAutoStop = 0 ;
    }

    if ( SysState.Mot.LoopClosureMode > E_LC_Torque_Mode )
    {
        if ( SysState.Mot.LoopClosureMode == E_LC_Speed_Mode)
        {
            //TODO: Make it work SysState.StartStop.mode = SpeedManageAutomaticBrakeEngage(PreventAutoStop);
        }
        else
        {
            SysState.StartStop.mode = PosManageAutomaticBrakeEngage(PreventAutoStop);
        }
    }
#ifdef SLAVE_DRIVER
    // When steering moves controlled, wheels musn not auto-stop
    if ( ( SysState.Mot.InAutoBrakeEngage == 0 ) && ClaState.MotorOnRequest )
    {
        SysState.Cmd2Intfc.bit.DisableAutoBrake = 1;
    }
    else

    {
        SysState.Cmd2Intfc.bit.DisableAutoBrake = 0;

    }
#endif
}


/*
 * Test matching between motor encoder reading and wheel encoder reading
 */
inline
void TestEncoderMatching()
{
    long delta1 , delta2 , pos  , outint ;
    short unsigned mask ;

    mask = BlockInts() ;
    pos    = ClaState.Encoder1.Pos ;
    outint = SysState.OuterSensor.OuterPosInt.l ;
    RestoreInts(mask);
    //float dUser1 , dUser2 ;
    // Difference passed on motor encoder
        delta1 = pos - SysState.EncoderMatchTest.MotorEncoderRef ;
        // Transform it do distance in user units
        SysState.EncoderMatchTest.DeltaEncoderMotor = delta1 * ClaState.Encoder1.Bit2Rev * ClaState.Encoder1.Rev2Pos ;

        // Distance passed on auxiliary encoder
        delta2 = outint - SysState.EncoderMatchTest.WheelEncoderRef ;
        // Transform it do distance in user units
        SysState.EncoderMatchTest.DeltaEncoderWheel  = delta2 * ControlPars.OuterSensorBit2User ;

        if ( __fmax( fabsf(SysState.EncoderMatchTest.DeltaEncoderMotor) ,fabsf(SysState.EncoderMatchTest.DeltaEncoderWheel)) > SysState.EncoderMatchTest.DeltaTestUser)
        {
            SysState.EncoderMatchTest.DeltaDeviation = fabsf(SysState.EncoderMatchTest.DeltaEncoderMotor - SysState.EncoderMatchTest.DeltaEncoderWheel);
            if ( SysState.EncoderMatchTest.DeltaDeviation > SysState.EncoderMatchTest.DeltaTestTol)
            {//  Thats an error
                if (  SysState.EncoderMatchTest.bTestEncoderMatch  &&
                    ( SysState.Mot.LoopClosureMode == E_LC_Speed_Mode) && ClaState.MotorOnRequest )
                {
                    LogException( EXP_SAFE_FATAL , exp_wheel_encoder_mismatch);
                }
            }
            SysState.EncoderMatchTest.MotorEncoderRef = pos  ;
            SysState.EncoderMatchTest.WheelEncoderRef = outint ;
        }
}


void IdleCbit(void)
{
// Test I2t
    union UCBit LocalBit ;
    union UCBit2 LocalBit2 ;
    union
    {
        short unsigned us[2] ;
        long  unsigned ul ;
    } u ;
    short unsigned stat , mon , br ;
    union UMultiType um ;
    long unsigned dt ;

    if ( ClaState.MotorOnRequestOld && (ClaState.MotorOn == 0 ))
    {
        ClaState.MotorOnRequest = 0 ; // Clear the request if motor is shut down
    }

    mon =ClaState.MotorOnRequest ? 1 : 0  ;

    if (SysState.RtBit.I2tState > ControlPars.I2tCurThold)
    {
        LogException(EXP_SAFE_FATAL,exp_overload ) ;
    }

    {
        SysState.AnalogProc.Temperature  = GetTemperatureFromAdc( ClaState.AdcRaw.Temperature * 8.0566e-04 ) ; //ADC_getTemperatureC(ClaState.AdcRaw.Temperature, ADC_REFERENCE_INTERNAL, 3.3f);

        if ( SysState.AnalogProc.Temperature > ControlPars.MaxTemperature)
        {
            LogException(EXP_SAFE_FATAL,exp_overtemperature ) ;
        }
    }

    // Manage exceptions thrown by the CLA
    if (  ClaMailOut.AbortCounter != SysState.Status.AbortCnt  )
    {
        LogException( EXP_FATAL ,  ClaMailOut.AbortReason ) ;
        SysState.Mot.KillingException = ClaMailOut.AbortReason ; // May be unmarked because motor is already off
        SysState.Status.AbortCnt = ClaMailOut.AbortCounter ;
    }

    // Construct BIT report - All the bits not to be set by this function remain unchanged
    LocalBit.all = 0  ;
    if ( SysState.Mot.MotorFault  || (ClaState.SystemMode < E_SysMotionModeNothing))
    {
        LocalBit.all |= CBIT_MOTION_FAULT_MASK ;
    }
    if ( SysState.Mot.NoCalib)
    {
        LocalBit.all |= CBIT_NO_CALIB_MASK ;
    }

    // Manage automatic brake engage (start/stop)
    if ( ControlPars.UseCase & US_SUPPORT_AUTOBRAKE )
    {
        if ( IsSysTimerElapse ( TIMER_AUTO_MIN_MOTORON,  &SysTimerStr)  )
        {
            ManageAutomaticBrakeEngage() ;
        }
        else
        {
            ArmAutomaticMotorOff() ;
        }
    }
    else
    {
        SysState.Status.DisableAutoBrake = 1 ;
    }

#ifdef SLAVE_DRIVER
    if ( SysState.AxisSelector == FSI_TAG_FOR_WHEEL   )
    {// Test encoders match
        TestEncoderMatching() ;
    }
#endif

    if ( SysState.Mot.Homed &&  (SysState.Mot.LoopClosureMode == E_LC_Dual_Pos_Mode ) && (SysState.Debug.bDisablePotEncoderMatchTest == 0 ) )
    {
        if ( fabsf(SysState.OuterSensor.OuterMergeState) >  SysState.EncoderMatchTest.MaxPotentiometerPositionDeviation)
        {
            LogException (EXP_FATAL , exp_pot_encoder_mismatch);
        }
    }

    // If auto on-off is disabled, exclude the brake manipulation time from readiness reports
    if ( ClaState.SystemMode > E_SysMotionModeFault)
    {
        if ( SysState.Mot.InAutoBrakeEngage || ((SysState.Status.DisableAutoBrake==0) && mon ) ||
                ( mon && (SysState.Mot.InBrakeReleaseDelay==0)  && (SysState.Mot.InBrakeEngageDelay==0) ) )
        {// Ready
            if ( SysState.Mot.MotionConverged )
            {
                LocalBit.all |= CBIT_MOTION_CONVERGED_MASK ;
            }
            LocalBit.us[0] |=  (( SysState.Mot.ProfileConverged << CBIT_PROFILE_CONVERGED_SHIFTS ) & CBIT_PROFILE_CONVERGED_MASK ) ;
            LocalBit.us[0] |= CBIT_MOTOR_READY_MASK  ;
        }
    }

    if (mon )
    {
        // Separate because brake management must be considered before later decisions of Motor On
        if ( SysState.Mot.InBrakeEngageDelay )
        {
            ManageBrakeEngage( SysState.Mot.InAutoBrakeEngage ? E_OffForAutoEngage :  E_OffForFinal  ) ;
        }
        else
        {
            ManageBrakeRelease() ;
        }
    }
    else
    {
        SysState.Mot.InBrakeReleaseDelay = INBD_EngageNothing ;
        SysState.Mot.InBrakeEngageDelay = 0 ;
    }


    if (mon )
    {
        //SysState.Mot.KillingException  = 0 ; // Motor is on - no killing exception

        LocalBit.us[0] |= CBIT_MOTOR_ON_MASK ;
        LocalBit.us[0] |= ( SysState.Mot.QuickStop << CBIT_QUICK_STOP_SHIFTS ) ;


        if (IsBadFloat(ClaState.va) || IsBadFloat(ClaState.vb) || IsBadFloat(ClaState.vc))
        {
            LogException( EXP_FATAL , exp_current_nan);
        }

        LocalBit.bit.MotorOn = 1 ;

    }
    else
    { // Motor is off
        SysState.Mot.BrakeRelease = 0 ;
    }


    if (ClaMailOut.StoEvent )
    {
        LocalBit.us[0] |= CBIT_STO_EVT_MASK  ;
        SysState.Mot.BrakeRelease = 0 ;
        SysState.Mot.QuickStop    = 1 ;
        if ( mon)
        {
            LogException(EXP_SAFE_FATAL,exp_expecting_sto ) ;
        }
    }

    if ( ClaState.SystemMode == E_SysMotionModeSafeFault )
    {
        um.ul = SysState.Timing.IntCntr - SysState.Mot.TimeOfSafeFatal ;
        if (  um.ul > 4000 )
        {
            LogException(EXP_FATAL,SysState.Mot.SafeFaultCode ? SysState.Mot.SafeFaultCode :  exp_unidentified_safe_fault ) ;
        }
    }


    if ( ClaState.PotRefFail )
    {
        LocalBit.us[0] |= CBIT_POT_REF_FAIL_MASK ;
    }

    if ( SysState.Mot.CurrentLimitCntr > 20 )
    {
        LocalBit.us[0] |= CBIT_CURRENT_LIMIT_MASK ;
    }

    LocalBit.us[0] = LocalBit.us[0] |  ( (SysState.Mot.LoopClosureMode << CBIT_LOOP_CLOSURE_SHIFTS) & CBIT_LOOP_CLOSURE_MASK) |
            ( ((short unsigned)ClaState.SystemMode << CBIT_SYSTEM_MODE_SHIFTS) & CBIT_SYSTEM_MODE_MASK);



    stat = GetRecorderStat() ;
    LocalBit.bit.RecorderActive = (stat == 22 ) & 1  ;
    LocalBit.bit.RecorderWaitTrigger = (stat == 18 ) ? 1 : 0   ;
    LocalBit.bit.RecorderReady = (stat ==23 ) ? 1 : 0   ;
    LocalBit.bit.RefGenOn = SysState.Debug.GRef.On ? 1 : 0 ;
    LocalBit.bit.TRefGenOn = SysState.Debug.TRef.On ? 1 : 0 ;

    LocalBit.bit.StoEvent = ( ClaMailOut.StoEvent ) ? 1 : 0 ;
    LocalBit.bit.Configured = SysState.ConfigDone ? 1 : 0 ;

    LocalBit.bit.SystemMode = ((short) ClaState.SystemMode ) & 7 ;
    LocalBit.bit.QuickStop = SysState.Mot.QuickStop ? 1 : 0 ;
    LocalBit.bit.ReferenceMode = ( SysState.Mot.ReferenceMode & 0x7 ) ;

    u.us[0] = SysState.Mot.LastException ;
    u.us[1] = SysState.Mot.KillingException ;
    SysState.Status.LongException = u.ul ;

    if ( ControlPars.UseCase &  UC_SUPPORT_BRAKE  )
    {
        if ( SysState.Mot.BrakeControlOverride )
        {
            br = SysState.Mot.ExtBrakeReleaseRequest ;
        }
        else
        {
            if ( LocalBit.bit.StoEvent == 0) // && (ClaState.SystemMode != E_SysMotionModeSafeFault) )
            {
                br = SysState.Mot.BrakeRelease ;
            }
            else
            {
                br = 0 ;
            }
        }
    }
    else
    {
        br = 0 ;
    }
    if ( br )
    {
        LocalBit.bit.BrakesReleaseCmd = 1 ;
        OutBrakeVolts( ControlPars.BrakeReleaseVolts  );
    }
    else
    {
        OutBrakeVolts( 0  );
    }

    SysState.CBit.bit.Pdo3IsPotDiff = ( ((short unsigned) ControlPars.UseCase & 3 ) == 3 ) ? 1 : 0 ;

    if ( ControlPars.UseCase &  UC_USE_SW1_HM )
    {
        LocalBit.bit.Din1 = IsDin1() ;
    }

    if ( ControlPars.UseCase &  UC_USE_SW2_HM )
    {
        LocalBit.bit.Din2 = IsDin2() ;
    }

/*
    // If this is a potentiometer axis, check if it is homed
    if ((short unsigned) ControlPars.UseCase & ( UC_USE_POT1 | UC_USE_POT2)  == (UC_USE_POT1 | UC_USE_POT2))
    {
        if (LocalBit.all & (CBIT_POT_REF_FAIL_MASK|CBIT_NO_CALIB_MASK)==0)
        {
            LocalBit.bit.Homed = 1 ;
        }
        else
        {
            LocalBit.bit.Homed = 0 ;
        }
    }
*/
    LocalBit.bit.Homed  = SysState.Mot.Homed ? 1 : 0 ;

    // Auto recover bus off condition
    if ( MCAN_getOpMode(MCAN0_BASE) == MCAN_OPERATION_MODE_NORMAL )
    {
        SetSysTimerTargetSec ( TIMER_MCAN_BUSOFF , BUS_OFF_RECOVERY_TIME ,  &SysTimerStr  );
    }
    if ( IsSysTimerElapse( BUS_OFF_RECOVERY_TIME ,  &SysTimerStr   ) )
    {
        MCAN_setOpMode(MCAN0_BASE, MCAN_OPERATION_MODE_NORMAL);
    }

    //If no more in auto mode, clear the start-stop control made by the auto process
    if (ClaState.SystemMode != E_SysMotionModeAutomatic)
    {
        SysState.Status.DisableAutoBrake &= (~2)  ;
    }


    if ( ClaState.MotorOnRequest == 0 )
    {
        ClaMailIn.Pot1CalibP0 = Calib.Pot1CalibP0;
        ClaMailIn.Pot1CalibP1 = Calib.Pot1CalibP1;
        ClaMailIn.Pot1CalibP2 = Calib.Pot1CalibP2;
        ClaMailIn.Pot1CalibP3 = Calib.Pot1CalibP3;
        ClaMailIn.Pot2CalibP0 = Calib.Pot2CalibP0;
        ClaMailIn.Pot2CalibP1 = Calib.Pot2CalibP1;
        ClaMailIn.Pot2CalibP2 = Calib.Pot2CalibP2;
        ClaMailIn.Pot2CalibP3 = Calib.Pot2CalibP3;
    }
    // Gyro test
#ifndef ON_BOARD_GYRO
    LocalBit.bit.GyroNotReady = 1 ;
#else
    if ( SysState.Mot.GyroNotReady)
    {
        LocalBit.all |= CBIT_GYRO_NOT_READY_MASK ;
//        LocalBit.bit.GyroAbsent  = SysState.Mot.GyroAbsent ? 1 : 0 ;
    }
#endif
    SysState.CBit.all = LocalBit.all ;

    LocalBit2.all = 0 ;
    LocalBit2.bit.EnableAutoBrakeEngage = ( SysState.Status.DisableAutoBrake ) ? 0 : 1 ;
    LocalBit2.bit.InAutoBrakeEngage = SysState.Mot.InAutoBrakeEngage ? 1  : 0 ;
    LocalBit2.bit.bAutoBlocked = SysState.MCanSupport.bAutoBlocked ;
    LocalBit2.bit.NodeStopped =  SysState.MCanSupport.NodeStopped?  1 : 0  ;
    LocalBit2.bit.InBrakeReleaseDelay = SysState.Mot.InBrakeReleaseDelay ? 1 : 0 ;
    LocalBit2.bit.InBrakeEngageDelay = SysState.Mot.InBrakeEngageDelay ? 1 : 0 ;


    SysState.CBit2.all = LocalBit2.all ;

    // Time out external control when activation is absent
    if ( SysState.Mot.LoopClosureMode == E_LC_EXTDual_Pos_Mode)
    {
        dt = SysState.Timing.UsecTimer - SysState.PosControl.RefTimer + 5000UL  ; // 5msec to avoid race
        if ( dt > 50000 )
        { // Abort mode
            SetReferenceMode(E_PosModeStayInPlace) ;
            SetLoopClosureMode(E_LC_Pos_Mode);
        }
    }
 }


short IsResetBlocked(void)
{
#ifdef SLAVE_DRIVER
    if ( SysState.AxisSelector == PROJ_TYPE_UNDEFINED)
    {
        return 1 ;
    }
#endif
    if ( (SysState.Mot.NoCalib ) && (ClaState.SystemMode == E_SysMotionModeAutomatic)  )
    {
        return 1 ;
    }
    return 0 ;
}


long unsigned LogException (   short fatality , long unsigned exp )
{
    short unsigned oldexp , oldmode  , usexp    ;
    short unsigned mask ;
    short sysmode ;
    long unsigned  *pExp ;
    mask = BlockInts() ;

    usexp   = (short unsigned)exp;
    sysmode = (short)ClaState.SystemMode;

    if ( fatality == EXP_SAFE_FATAL )
    { // A delayed FATAL
        if ( sysmode > E_SysMotionModeNothing )
        {
            SysState.Mot.SafeFaultCode = (short unsigned) exp ;
            SetSystemMode(E_SysMotionModeSafeFault) ;
            SafeSetMotorOff() ;
            SysState.Mot.TimeOfSafeFatal = SysState.Timing.IntCntr ;
            RestoreInts( mask) ;

            return 0 ;
        }
        else
        {
            if ( sysmode  == E_SysMotionModeSafeFault )
            { // Already in safe fail, no more action to take
                RestoreInts( mask) ;
                return 0 ;
            }
            else
            { // Was in motor off, no issue in playing safe fail, so its fatal
                fatality = EXP_FATAL ;
            }
        }
    }

    // Old exception to test if this report is really new
    if ( SysState.Mot.ExceptionInit )
    {
        oldexp = (short unsigned) (  SysState.Mot.ExceptionTab[(SysState.Mot.ExceptionCnt-1)&(EXCEPTION_TAB_LENGTH-1)] & 0xffff ) ;
    }
    else
    {
        SysState.Mot.ExceptionInit = 1 ;
        oldexp = 0 ;
    }

    oldmode = sysmode ; // Mode backup


    if ( ( fatality == EXP_FATAL ) && (( sysmode > E_SysMotionModeNothing ) || (sysmode == E_SysMotionModeSafeFault) ) )
    {
        SysState.Mot.SafeFaultCode = 0 ; // Terminate any safe fault process
        SetSystemMode(E_SysMotionModeFault);
        if ( exp == 0 )
        {
            exp = exp_unidentified_fault ;
        }
        SysState.Mot.KillingException = exp ;
        SysState.Mot.MotorFault = 1 ;
    }

    if ( usexp != oldexp )
    {
        // Prevent multiple registration of the same error.
        // Specifically, an error reset will be ignored if the error code is anyway 0

        if ( ( fatality == EXP_WARN) && SysState.Mot.RejectWarning.IgnoreWarning  )
        { // Warnings may be logged later if desired
            SysState.Mot.RejectWarning.exp = exp ;
        }
        else
        {// Log exception
            // Exception files:
            // Long[0]:
            // 0..15  : Exception code
            // 16..19 : ID of exception generator
            // 20..23 : Mode (Automatic, .... ) just before exception throw
            // 24..35 : Next position in queue (if relevant)
            // Long[1]:
            //  0..3: 0x80 if was running a queue
            //  4..7: Fatality code
            //  16..31: Extended exception code (high part of exception parameter)

            pExp = (long unsigned  * ) & SysState.Mot.ExceptionTab[SysState.Mot.ExceptionCnt] ;
            pExp[0] = (long unsigned) usexp  +  (( long unsigned) (oldmode &0xf) << 20 );
            SysState.Mot.ExceptionCnt =  ( SysState.Mot.ExceptionCnt+1) & (EXCEPTION_TAB_LENGTH-1)  ;
            SysState.Mot.LastException = usexp ;
         }
    }


    RestoreInts( mask) ;

    return exp ;
}


