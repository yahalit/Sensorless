/*
 * BIT.c
 *
 *  Created on: May 12, 2023
 *      Author: Gal Lior
 */
#include "..\Application\StructDef.h"
#define MCAN0_BASE MCANA_MSG_RAM_BASE



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
    short unsigned stat , mon  ;
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

#ifdef ON_BOARD_TEMPSENSOR_LINEAR
    {
        SysState.AnalogProc.Temperature  = GetTemperatureFromAdc( ClaState.AdcRaw.Temperature * 8.0566e-04 ) ; //ADC_getTemperatureC(ClaState.AdcRaw.Temperature, ADC_REFERENCE_INTERNAL, 3.3f);

        if ( SysState.AnalogProc.Temperature > ControlPars.MaxTemperature)
        {
            LogException(EXP_SAFE_FATAL,exp_overtemperature ) ;
        }
    }
#endif

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
        if ( mon )
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

    SysState.CBit.bit.Pdo3IsPotDiff = ( ((short unsigned) ControlPars.UseCase & 3 ) == 3 ) ? 1 : 0 ;


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
    LocalBit2.bit.bAutoBlocked = SysState.MCanSupport.bAutoBlocked ;
    LocalBit2.bit.NodeStopped =  SysState.MCanSupport.NodeStopped?  1 : 0  ;
    LocalBit2.all = (LocalBit2.all & ~INFINEON_DIAG_MASK ) | GetInfineonFault() ;


    SysState.CBit2.all = LocalBit2.all ;

    // If an L measurement experiment is done , restore
    if ( SysState.CLMeas.State >= ELM_Done )
    {
        KillMotor() ;
        SetupIsr();
        SysState.CLMeas.State = ELM_Nothing ;
        EINT;  // Enable Global interrupt INTM
    }

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

    SysState.CbitCpu2.bit.Cpu2HadWatchdogReset = Cpu2HadWatchdogReset ;
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


