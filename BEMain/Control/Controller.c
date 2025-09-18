/*
 * Controller.c
 *
 *  Created on: May 12, 2023
 *      Author: Gal Lior
 */

#include "..\Application\StructDef.h"
#include <math.h>


void Steering2WheelCorrection()
{
 #ifdef SLAVE_DRIVER
    float delta ;
    float deltaFilt ;
    if ( SysState.AxisSelector != FSI_TAG_FOR_WHEEL )
    {
        SysState.SteerCorrection.SteeringFF = 0 ;
        return;
    }

    delta = (SysState.FeedForward - SysState.SteerCorrection.SteeringAngle_PU )
            * (Pi2/65536.0f)  * SysState.Timing.OneOverTsTraj;
    SysState.SteerCorrection.SteeringAngle_PU = SysState.FeedForward   ;
    deltaFilt = SysState.SteerCorrection.WheelAddZ * ( delta - SysState.SteerCorrection.WheelAddFilt) ;
    SysState.SteerCorrection.WheelAddFilt  = SysState.SteerCorrection.WheelAddFilt + deltaFilt;

    if ( SysState.SteerCorrection.bSteeringComprensation  )
    {// By wheel direction SteeringColumnDistRatio may be positive or negative
        SysState.SteerCorrection.SteeringFF =  SysState.SteerCorrection.WheelAddFilt * SysState.SteerCorrection.SteeringColumnDistRatio;
    }
    else
#endif
    {
        SysState.SteerCorrection.SteeringFF = 0 ;
    }
}


void PosPrefilterMotorOff(float y)
{
    long lPos ;
    float MidRange ;
    MidRange = (ControlPars.MaxPositionCmd + ControlPars.MinPositionCmd) * 0.5f ;
    y = __fmax( __fmin(y,ControlPars.MaxPositionCmd) ,ControlPars.MinPositionCmd) ;
    lPos = (long) ( ( y - MidRange) * PosPrefilter.InPosScale)  ;
    PosPrefilter.yold1.ul[0] = 0 ;
    PosPrefilter.yold1.l[1] =  lPos ;
    PosPrefilter.yold2.ul[0] = 0 ;
    PosPrefilter.yold2.l[1] =  lPos ;
    PosPrefilter.y1.ul[0] = 0 ;
    PosPrefilter.y1.l[1] =  lPos ;
    PosPrefilter.y2.ul[0] = 0 ;
    PosPrefilter.y2.l[1] =  lPos ;
    SysState.PosControl.SpeedLimitedPosReference = y ;
    SysState.PosControl.FilteredPosReference = y ;
}

#ifdef REF_FILT_UNIT_TEST
#pragma FUNCTION_OPTIONS ( PosPrefilterMotorOn, "--opt_level=0" );
#endif

float PosPrefilterMotorOn(float y , float *yf )
{
    extern float PosPref(long , struct CPosPrefilter* );
    long lPos ;
    float fspeed ;
    float dpMax , yl , MidRange;

    dpMax = SysState.Timing.TsTraj * ControlPars.MaxSpeedCmd ;

    SysState.PosControl.SpeedLimitedPosReference = __fmax( __fmin ( y ,SysState.PosControl.SpeedLimitedPosReference +dpMax) , SysState.PosControl.SpeedLimitedPosReference -dpMax ) ;

    yl = __fmax( __fmin(SysState.PosControl.SpeedLimitedPosReference,ControlPars.MaxPositionCmd) ,ControlPars.MinPositionCmd) ;
    MidRange = (ControlPars.MaxPositionCmd + ControlPars.MinPositionCmd) * 0.5f ;
    lPos = (long) ( ( yl - MidRange) * PosPrefilter.InPosScale)  ;
    fspeed = PosPref(lPos,&PosPrefilter) ;
    *yf = PosPrefilter.y2.l[1] * PosPrefilter.OutPosScale + MidRange ;

#ifdef REF_FILT_UNIT_TEST
    SysState.Debug.lDebug[1] = PosPrefilter.u1 ;
    SysState.Debug.lDebug[2] = PosPrefilter.u2 ;
    SysState.Debug.lDebug[3] = PosPrefilter.y1.l[0] ;
    SysState.Debug.lDebug[4] = PosPrefilter.y2.l[1] ;
#endif

    return fspeed * PosPrefilter.OutSpeedScale ;
}


float StepFilt(struct CFilt2 * pFilt, float u )
{
    float y , r ;
    y = pFilt->s0  + ( u - pFilt->s0) * pFilt->b00 + ( pFilt->s0 - pFilt->s1 ) * pFilt->a2 ;
    r = pFilt->b0 * y + pFilt->b1 * pFilt->s0 + pFilt->b2 * pFilt->s1 ;
    pFilt->s1 = pFilt->s0 ;
    pFilt->s0 = y ;
    return r ;
}


/*
 * Get the speed command from position error and required terminal speed
 *
 */
float GetSpeedCmdForPerr( float PosError, float vt  )
{
    float dVMotEncSec ;
    float a ;
    float alim  ;
    float t0 ;
    float vmax ;
    float  SpeedSat , SpeedSatByEdge , SpeedCmd , DeadZoneThold ;

    a = ControlPars.MaxAcc  ;
    alim = a ;
    t0 = ControlPars.SpeedCtlDelay;
    vmax = ControlPars.MaxSpeedCmd ;

    if ( PosError * vmax > 0  )

        t0 = __fmin(t0,PosError/ __fmax(vmax,1e-6f) ) ;
    else
        t0 = 0 ;


    if ( SysState.PosControl.DeadZoneState == 0 )
    { // Normal , un stabilized. THOLD is low, will change to high on crossing
        DeadZoneThold = ControlPars.LowDeadBandThold ;
        if ( fabsf(PosError) < ControlPars.LowDeadBandThold)
        {
            SysState.PosControl.DeadZoneState = 1 ;
        }
    }
    else
    {// Stabilized. THOLD is High, will change to high on crossing
        DeadZoneThold = ControlPars.HighDeadBandThold ;
        if ( fabsf(PosError) > ControlPars.HighDeadBandThold)
        {
            SysState.PosControl.DeadZoneState = 0 ;
        }
    }

    if ( PosError >= 0 )
    {
        PosError = __fmax( PosError - DeadZoneThold , 0 );
    }
    else
    {
        PosError = __fmin( PosError + DeadZoneThold , 0 );
    }
    SysState.PosControl.PosErrorR = PosError ;


    dVMotEncSec = a * SysState.Timing.Ts ;
    if ( PosError >= 0 )
    {
        if ( vt < 0 )
        {
            SpeedSat = vmax ;
            SpeedSatByEdge = vmax ;
        }
        else
        {
            SpeedSat =  __fmin( -(a * t0) + __sqrt(a * a * t0 * t0 + 2 * ( __fmax(PosError,vt*2*t0) * a)+vt*vt), vmax ) ;
            SpeedSatByEdge = -(alim * t0) + __sqrt(alim * alim * t0 * t0 + 2 * __fmax((ControlPars.MaxPositionCmd-SysState.PosControl.PosFeedBack)* alim,0) ) ;
        }
        SpeedSat = __fmin( SpeedSat , SpeedSatByEdge ) ;
        SpeedCmd = __fmin(__fmin(ControlPars.PosKp * PosError + vt , SpeedSat) , SysState.SpeedControl.SpeedCommand + dVMotEncSec )  ;
    }
    else
    {
        if ( vt > 0 )
        {
            SpeedSat = -vmax ;
            SpeedSatByEdge = -vmax ;
        }
        else
        {
            SpeedSat =  -__fmin( -(a * t0) + __sqrt(a * a * t0 * t0 + 2 * ( __fmax(-PosError,-vt*2*t0) * a)+vt*vt), vmax )  ;
            SpeedSatByEdge = (alim * t0) - __sqrt(alim * alim * t0 * t0 + 2 * __fmax((SysState.PosControl.PosFeedBack-ControlPars.MinPositionCmd)* alim,0) ) ;
        }
        SpeedSat = __fmax( SpeedSat ,SpeedSatByEdge ) ;
        SpeedCmd =    __fmax( __fmax(ControlPars.PosKp * PosError + vt , SpeedSat) , SysState.SpeedControl.SpeedCommand - dVMotEncSec ) ;
    }
    return SpeedCmd ;
}


/*
 * Run two sets of bi-quad filters
 */
float  RunBiquads(float CandR, float cursat)
{
    float out ;
    if ( ControlPars.qf0.Cfg.bit.IsInUse )
    {
        out =   StepFilt( & ControlPars.qf0 , CandR ) ;
        out =   fSat( out , cursat ) ;
    }
    else
    {
        out = CandR ;
        ControlPars.qf0.s0 = out ;
        ControlPars.qf0.s1 = out ;
    }


    if ( ControlPars.qf1.Cfg.bit.IsInUse )
    {
        out =   StepFilt( & ControlPars.qf1 , out ) ;
        out =   fSat( out , cursat ) ;
    }
    else
    {
        ControlPars.qf1.s0 = out ;
        ControlPars.qf1.s1 = out ;
    }
    return out ;
}


float GetCurrentCmdForSpeedErr(  float CurrentFF   )
{
    float Cand , CandR , out , cursat ;
    SysState.SpeedControl.SpeedError =  SysState.SpeedControl.SpeedCommand - ClaState.Encoder1.UserSpeed ;

    SysState.SpeedControl.PIState = SysState.SpeedControl.PIState  +
            ControlPars.SpeedKi * ( SysState.Timing.Ts * SysState.SpeedControl.SpeedCommand -
                    ClaState.Encoder1.UserPosDelta ) ;

    Cand  = ControlPars.SpeedKp * SysState.SpeedControl.SpeedError + SysState.SpeedControl.PIState + CurrentFF ;
    cursat = ControlPars.MaxCurCmd * SysState.Mot.CurrentLimitFactor ;
    CandR = fSat( Cand, cursat ) ;

    if (Cand == CandR)
    {
        SysState.bInCurrentRefLimit = 0;
    }
    else
    {
        SysState.bInCurrentRefLimit = 1 ;
    }


    SysState.SpeedControl.PIState = SysState.SpeedControl.PIState + (CandR - Cand ) * ControlPars.SpeedAWU ;
    SysState.SpeedControl.PiOut   = CandR ;

    // Run two quad filters
    out = RunBiquads(CandR,cursat) ;
    return out  ;
}




// Sequence of action to be taken while the motor is on.
void MotorOnSeq(void)
{
    float CurCmd , CurMax , target , sr , acc ;
    long unsigned lstat ;
    short unsigned refmode , ClosureMode, expmode ;

    // Run reference generators
    CurMax = ControlPars.MaxCurCmd * SysState.Mot.CurrentLimitFactor;

    // Emergency stops are always in speed mode
    ClosureMode = SysState.Mot.LoopClosureMode ;
    refmode = SysState.Mot.ReferenceMode ;
    if ( (ClaState.SystemMode == E_SysMotionModeSafeFault) || ( refmode == E_PosModeStayInPlace ) || (SysState.Mot.QuickStop + SysState.Mot.InBrakeReleaseDelay ) ||
            ( SysState.NoFsiMsgCnt.us[0] > 5 )  )
    {
        ClosureMode =  __min(ClosureMode,E_LC_Speed_Mode)  ;
        refmode = E_PosModeStayInPlace ;
    }

    // If doing speed action, open position loop
    if ( ( refmode == E_RefModeSpeed) ||( refmode == E_RefModeSpeed2Home))
    {
        ClosureMode =  __min(ClosureMode,E_LC_Speed_Mode)  ;
    }

    // Open loop field direction
    if ( ClosureMode <= E_LC_OpenLoopField_Mode )
    { // Open loop mode always goes with debug waveforms - G for the current command and T for the angle
        if ( ClosureMode == E_LC_OpenLoopField_Mode )
        {

            if ( refmode == E_PosModeDebugGen )
            {
                CurCmd = SysState.Debug.TRef.Out;
                ClaMailIn.ThetaElect = __fracf32( __fracf32( SysState.Debug.GRef.Out ) + 1  );
            }
            else
            {
                sr = SysState.SpeedControl.SpeedReference ;
                switch (refmode )
                {
                case E_RefModeSpeed:
                    SysState.Mot.ProfileConverged = SpeedProfiler() ;
                    break ;
                case E_PosModePTP:
                    // here is point to point mode
                    SysState.Mot.ProfileConverged = AdvanceProfiler(&SysState.Profiler , SysState.Timing.TsTraj ) ;
                    SysState.SpeedControl.SpeedReference = SysState.Profiler.ProfileSpeed ;
                    break ;
                default: // case E_PosModeStayInPlace:
                    SysState.SpeedControl.SpeedTarget = 0 ;
                    SysState.Mot.ProfileConverged = SpeedProfiler() ;
                    break ;
                }

                acc = ( SysState.SpeedControl.SpeedReference - sr ) * SysState.Timing.OneOverTsTraj ;
                CurCmd = fSatNanProt( SysState.StepperCurrent.StaticCurrent +
                        fabsf(SysState.SpeedControl.SpeedReference) * SysState.StepperCurrent.SpeedCurrent +
                        fabsf(acc) * SysState.StepperCurrent.AccelerationCurrent,
                        CurMax ) ;
                ClaMailIn.ThetaElect += ( SysState.SpeedControl.SpeedReference * SysState.Timing.TsTraj );
            }

        }
        else
        {
            if ( ClosureMode <= E_LC_Voltage_Mode )
            {
                CurCmd = 0 ; // Just for variables to be defined
                ClaMailIn.ThetaElect = 0 ;
                expmode = (short unsigned)ClaMailIn.ExperimentMode ;
                switch (expmode)
                {
                case 0:
                    ClaMailIn.v_dbg_amp     = SysState.Timing.PwmFrame * 0.01333f * SysState.Debug.TRef.Out ;
                    ClaMailIn.v_dbg_angle   = __fracf32 (__fracf32 ( SysState.Debug.GRef.Out ) + 1 )  ;
                    break;
                default:
                    ClaMailIn.v_dbg_amp     = SysState.Timing.PwmFrame * __fmax( __fmin( SysState.Debug.CurExp.VoltageLevelPU,0.5f),0.0f)   ;
                    ClaMailIn.v_dbg_angle   = __fracf32 (__fracf32 ( SysState.Debug.CurExp.VoltageAnglePU) + 1 )  ;
                    //ClaMailIn.ExperimentCurrentThold  = __fmax( __fmin( SysState.Debug.CurExp.MaxCurrentLevel,25.0f),0.0f)   ;
                }
            }
        }
    }
    else
    {

        // Commutation runs
        if ( ClosureMode >= E_LC_Torque_Mode )
        {
            if ( ClaState.SystemMode == E_SysMotionModeManual )
            { // Manual mode - take current command from the G generator
                if ( refmode == E_PosModeDebugGen )
                    CurCmd = SysState.Debug.TRef.Out;
                else
                    CurCmd = 0 ;
            }
            else
            {
                CurCmd = ClaState.CurrentControl.CurrentReference ;
            }

            if ( Commutation.Status < 0 )
            {
                return ;
            }
            ClaMailIn.ThetaElect = Commutation.ComAnglePu + 0.25f ;
        }


        // Position controller
        if ( ClosureMode >= E_LC_Pos_Mode )
        {
            if ( ClosureMode == E_LC_EXTDual_Pos_Mode)
            {
                SysState.PosControl.PosError = ControlPars.PosErrorExtRelGain *
                        __fmax(__fmin( SysState.PosControl.PosErrorExt , ControlPars.PosErrorExtLimit ),-ControlPars.PosErrorExtLimit) ;
                SysState.PosControl.SpeedFFExtState = SysState.PosControl.SpeedFFExtState +
                        ControlPars.KGyroMerge  * ( (SysState.PosControl.SpeedFFExt - ClaState.Encoder1.UserSpeed) - SysState.PosControl.SpeedFFExtState )  ;
                SysState.SpeedControl.SpeedReference = -SysState.PosControl.SpeedFFExtState  ;
                PosPrefilterMotorOff(SysState.PosControl.PosFeedBack );

            }
            else
            {
                SysState.PosControl.SpeedFFExtState = 0 ;
                if ( SysState.Debug.bBypassPosFilter )
                {
                    PosPrefilterMotorOff(SysState.PosControl.PosReference) ;
                    SysState.SpeedControl.SpeedReference = 0 ;
                }
                else
                {
                    SysState.SpeedControl.SpeedReference = PosPrefilterMotorOn(SysState.PosControl.PosReference, &SysState.PosControl.FilteredPosReference) ;
                }
                if ( ClaState.PotRefFail && (ClosureMode == E_LC_Dual_Pos_Mode)  )
                {
                    LogException(EXP_SAFE_FATAL,exp_pot_ref_failed ) ;
                }
                SysState.PosControl.PosError =  SysState.PosControl.FilteredPosReference - SysState.PosControl.PosFeedBack ;
                if ( fabsf(SysState.PosControl.PosError) > ControlPars.PosErrorLimit )
                {
                    LogException(EXP_SAFE_FATAL,exp_pos_error_limit  ) ;
                }
            }

            SysState.SpeedControl.SpeedCommand = GetSpeedCmdForPerr( SysState.PosControl.PosError , SysState.SpeedControl.SpeedReference  );
        }
        else
        {
            Steering2WheelCorrection() ;
            SysState.SpeedControl.SpeedCommand = SysState.SpeedControl.SpeedReference + SysState.SteerCorrection.SteeringFF ;

            if ( ControlPars.MaxSupportedClosure  >= E_LC_Pos_Mode )
            { // Keep track should position control be requested
                SysState.PosControl.PosErrorR = 0 ;
                PosPrefilterMotorOff(SysState.PosControl.PosFeedBack) ;
                ProfileToStop ( &SysState.Profiler , SysState.PosControl.PosFeedBack , SysState.SpeedControl.SpeedCommand );
            }
        }

        // Limit the speed reference
        SysState.SpeedControl.SpeedCommand = fSatNanProt (SysState.SpeedControl.SpeedCommand , ControlPars.MaxSpeedCmd ) ;


        // Speed Controller
        if ( ClosureMode >= E_LC_Speed_Mode )
        {
            CurCmd = GetCurrentCmdForSpeedErr( CurCmd  );
        }

    }

    ClaState.CurrentControl.ExtCurrentCommand =  fSatNanProt( CurCmd , CurMax ) ;
    if ( fabsf(ClaState.CurrentControl.ExtCurrentCommand)  ==  CurMax )
    {
        if ( SysState.Mot.CurrentLimitCntr < 50 )
        {
            SysState.Mot.CurrentLimitCntr += 1 ;
        }
        else
        {
            SysState.Mot.CurrentLimitCntr = __max( SysState.Mot.CurrentLimitCntr - 3 , 0 );
        }
    }
    // Current controller
    //GetVoltageCmdForCurErr ( SysState.CurrentControl.ExtCurrentCommand , SysState.VoltageControl.VoltageReference , &SysState.VoltageControl.VoltageCommands[0]  );

    // Trajectory generator
    if ( ClosureMode >= E_LC_Pos_Mode )
    { // Position profile
        switch (refmode )
        {
        default: // case E_PosModeStayInPlace:

            LogException(EXP_FATAL,exp_unknown_pos_ref_mode  ) ;
            break ;
        case E_PosModeDebugGen:
            SysState.PosControl.PosReference = SysState.Debug.GRef.Out ;
            SysState.Mot.ProfileConverged = 1 ;
            break ;
        case E_PosModePTP:
            // here is point to point mode
            SysState.Mot.ProfileConverged = AdvanceProfiler(&SysState.Profiler , SysState.Timing.TsTraj ) ;
            if ( SysState.Mot.ProfileConverged == 0 )
            {
                SysState.Profiler.PauseCtr = 0 ;
            }
            if ( SysState.Profiler.bPeriodic )
            {
                if ( SysState.Profiler.PauseCtr < (250000/ CUR_SAMPLE_TIME_USEC ) ) // 0.25 sec pouse
                {
                    SysState.Profiler.PauseCtr += 1 ;
                }
                else
                {
                    SysState.Profiler.PauseCtr = 0 ;
                    target = SysState.Profiler.PosTarget ;
                    SysState.Profiler.PosTarget = SysState.Profiler.PosTarget2 ;
                    SysState.Profiler.PosTarget2 = target ;
                }
            }
            SysState.PosControl.PosReference = SysState.Profiler.ProfilePos ;
            //SysState.SpeedControl.SpeedReference = SysState.Profiler.ProfileSpeed ;
            break ;
        case E_PosModePT:
            SysState.Mot.ProfileConverged =  PTRunTimeDriver() ;
#ifdef PVTEnabled
            PVTRunTimeDriver(SysState.Timing.UsecTimer) ;
#endif
            SysState.PosControl.PosReference = SysState.InterpolationPosRef ;
            break ;
        }

        // Keep position to limits
        SysState.PosControl.PosReference = Sat2Side(SysState.PosControl.PosReference , ControlPars.MinPositionCmd , ControlPars.MaxPositionCmd ) ;


        // Test if motion converged
        if (( SysState.Mot.ProfileConverged == 0 ) ||( fabsf(SysState.PosControl.PosError ) > ControlPars.MotionConvergeWindow ))
        {
            SysState.Mot.MotionConverged  = 0  ;
            SysState.Mot.MotionConvergeCnt = 0  ;
        }
        else
        {
            if ( SysState.Mot.MotionConvergeCnt * SysState.Timing.TsTraj < ControlPars.MotionConvergeTime  )
            {
                SysState.Mot.MotionConvergeCnt += 1 ;
                SysState.Mot.MotionConverged  = 0  ;
            }
            else
            {
                SysState.Mot.MotionConverged  = 1  ;
            }
        }


    }
    else if ( ClosureMode == E_LC_Speed_Mode )
    { // Speed profiler
        SysState.PosControl.PosReference = SysState.PosControl.PosFeedBack ;
        switch (refmode )
        {
        case E_PosModeDebugGen:
             SysState.SpeedControl.SpeedReference = SysState.Debug.GRef.Out ;
             SysState.Mot.ProfileConverged = 1 ;
             break ;
        case E_RefModeSpeed:
            SysState.Mot.ProfileConverged = SpeedProfiler() ;
            break ;
        case E_RefModeSpeed2Home:
            lstat = HomeProfiler() ;
            if ( lstat )
            {
                LogException(EXP_SAFE_FATAL,lstat ) ;
            }
            break ;
        case E_PosModePTP:
            // here is point to point mode
            SysState.Mot.ProfileConverged = AdvanceProfiler(&SysState.Profiler , SysState.Timing.TsTraj ) ;
            SysState.SpeedControl.SpeedReference = SysState.Profiler.ProfileSpeed ;
            break ;
        default: // case E_PosModeStayInPlace:
            SysState.SpeedControl.SpeedTarget = 0 ;
            SysState.Mot.ProfileConverged = SpeedProfiler() ;
            break ;
        }

        // Test if motion converged
        if (( SysState.Mot.ProfileConverged == 0 ) ||( fabsf(SysState.SpeedControl.SpeedError ) > ControlPars.SpeedConvergeWindow ))
        {
            SysState.Mot.MotionConverged  = 0  ;
            SysState.Mot.MotionConvergeCnt = 0  ;
        }
        else
        {
            if ( SysState.Mot.MotionConvergeCnt * SysState.Timing.TsTraj < ControlPars.MotionConvergeTime  )
            {
                SysState.Mot.MotionConvergeCnt += 1 ;
                SysState.Mot.MotionConverged  = 0  ;
            }
            else
            {
                SysState.Mot.MotionConverged  = 1  ;
            }
        }
    }
    else
    {
        SysState.PosControl.PosReference = SysState.PosControl.PosFeedBack ;
        SysState.SpeedControl.SpeedReference = ClaState.Encoder1.UserSpeed ;
        SysState.Mot.MotionConvergeCnt = 0  ;
        SysState.Mot.MotionConverged   = 0  ;
    }
}

void ResetSpeedController(void)
{
    SysState.PosControl.SpeedFFExtState = 0 ;
    SysState.SpeedControl.SpeedReference = ClaState.Encoder1.UserSpeed ; // !< Reference to the speed controller
    SysState.SpeedControl.SpeedCommand   = ClaState.Encoder1.UserSpeed ; // !< Command to the speed controller composed of Reference and of position corrections
    SysState.SpeedControl.SpeedError     = 0 ; // !< Error of speed from command
    SysState.SpeedControl.PIState        = 0 ; // !< State of PI controller
    SysState.SpeedControl.PiOut          = 0 ;
    ControlPars.qf0.s0 = 0 ;
    ControlPars.qf0.s1 = 0 ;
    ControlPars.qf1.s0 = 0 ;
    ControlPars.qf1.s1 = 0 ;
}


/*
 * Algorithm for holding the motor shut just because we have no justification to move
 */
void MotorHoldSeq(void)
{
//    SysState.SpeedControl
    ResetSpeedController() ;

    ClaState.CurrentControl.ExtCurrentCommand  = 0 ;
    SysState.Mot.CurrentLimitCntr = 0 ;

    ClaMailIn.v_dbg_amp = 0 ;

    //ClearMemRpt( (short unsigned *)&SysState.CurrentControl  , sizeof(struct CCurrentControl)  ) ;

    SysState.PosControl.PosError = SysState.PosControl.PosReference - SysState.PosControl.PosFeedBack  ;

    // Set something for commutation angle
    ClaMailIn.ThetaElect = Commutation.ComAnglePu + 0.25f ;

    SysState.SpeedControl.SpeedReference = 0 ;
    PosPrefilterMotorOff(SysState.PosControl.PosFeedBack );

    SysState.InterpolationPosRef = SysState.PosControl.FilteredPosReference ;

    SysState.Mot.ProfileConverged = 1 ;
    SysState.Mot.MotionConverged  = 1 ;
    SysState.Mot.MotionConvergeCnt = ControlPars.MotionConvergeTime * SysState.Timing.OneOverTsTraj + 1 ;


    SysState.PosControl.DeadZoneState =  0;
    Steering2WheelCorrection() ;
}


#define CURR_OFFSET_VANDAL

void MotorOffSeq(void)
{
//    SysState.SpeedControl
    ResetSpeedController() ;

    ClaState.CurrentControl.ExtCurrentCommand  = 0 ;
    SysState.Mot.CurrentLimitCntr = 0 ;

    ClaMailIn.v_dbg_amp = 0 ;

    //ClearMemRpt( (short unsigned *)&SysState.CurrentControl  , sizeof(struct CCurrentControl)  ) ;

    SysState.PosControl.PosError    = 0 ;
    SysState.PosControl.PosErrorR   = 0 ;
    SysState.PosControl.PosReference = SysState.PosControl.PosFeedBack ;
    SysState.PosControl.PosErrorExt  = 0  ;
    SysState.PosControl.SpeedFFExt  = 0    ;

    SysState.SpeedControl.SpeedTarget = 0   ;
    SysState.SpeedControl.SpeedReference = 0   ;


    if ( fabsf( ClaState.Encoder1.UserSpeed ) < 1e-3 )
    { // Filter the offset
        SysState.AnalogProc.FiltCurAdcOffset[0] = SysState.AnalogProc.FiltCurAdcOffset[0] +
                ControlPars.CurrentOffsetGain * ( ClaState.AdcRaw.PhaseCurAdc[0] - 4096  - SysState.AnalogProc.FiltCurAdcOffset[0] ) ;
        SysState.AnalogProc.FiltCurAdcOffset[1] = SysState.AnalogProc.FiltCurAdcOffset[1] +
                ControlPars.CurrentOffsetGain * ( ClaState.AdcRaw.PhaseCurAdc[1] - 4096  - SysState.AnalogProc.FiltCurAdcOffset[1] ) ;
        SysState.AnalogProc.FiltCurAdcOffset[2] = SysState.AnalogProc.FiltCurAdcOffset[2] +
                ControlPars.CurrentOffsetGain * ( ClaState.AdcRaw.PhaseCurAdc[2] - 4096  - SysState.AnalogProc.FiltCurAdcOffset[2] ) ;


    // Test stability to set as offsets
        if ( __fmax(__fmax( fabsf(SysState.AnalogProc.FiltCurAdcOffset[0]-SysState.AnalogProc.FiltCurAdcOffsetRef[0]) ,
                fabsf(SysState.AnalogProc.FiltCurAdcOffset[1]-SysState.AnalogProc.FiltCurAdcOffsetRef[1]) ) ,
                fabsf(SysState.AnalogProc.FiltCurAdcOffset[2]-SysState.AnalogProc.FiltCurAdcOffsetRef[2])) > 3 )
        {
            SysState.Mot.OffsetMeasureCntr = 10000 ;
            SysState.AnalogProc.FiltCurAdcOffsetRef[0] = SysState.AnalogProc.FiltCurAdcOffset[0] ;
            SysState.AnalogProc.FiltCurAdcOffsetRef[1] = SysState.AnalogProc.FiltCurAdcOffset[1] ;
            SysState.AnalogProc.FiltCurAdcOffsetRef[2] = SysState.AnalogProc.FiltCurAdcOffset[2] ;
        }
        else
        {
            if ( SysState.Mot.OffsetMeasureCntr)
            {
                SysState.Mot.OffsetMeasureCntr -= 1 ;
            }
            else
            {
#ifdef CURR_OFFSET_VANDAL
                ClaMailIn.IaOffset = 0 ;
                ClaMailIn.IbOffset = 0;
                ClaMailIn.IcOffset = 0 ;
#else
                ClaMailIn.IaOffset = SysState.AnalogProc.FiltCurAdcOffset[0] ;
                ClaMailIn.IbOffset = SysState.AnalogProc.FiltCurAdcOffset[1] ;
                ClaMailIn.IcOffset = SysState.AnalogProc.FiltCurAdcOffset[2] ;
#endif
                SysState.AnalogProc.bOffsetCalculated = 1 ;
                SysState.Mot.OffsetMeasureCntr = 10000 ;
            }
        }
    }

    if ( SysState.Debug.bAllowRefGenInMotorOff == 0 )
    {
        ResetRefGens() ;
    }
    // Set something for commutation angle
    ClaMailIn.ThetaElect = Commutation.ComAnglePu + 0.25f ;


    SysState.InterpolationPosRef = SysState.PosControl.PosFeedBack;
    PosPrefilterMotorOff(SysState.PosControl.PosFeedBack );

    SysState.Mot.ProfileConverged = 0 ;
    SysState.Mot.MotionConverged  = 0 ;
    SysState.Mot.MotionConvergeCnt = 0  ;

    Steering2WheelCorrection() ;


}

/*
 * Trigger a chain of events: controlled stop, brake application, and later motor off
 */
void SafeSetMotorOff()
{
   SetMotorOff(E_OffForFinal) ;
}

/*
 * Shut down the motor drive and apply the brake
 */
void SetMotorOff(enum E_MotorOffType Method)
{
    //Set the PWM to off
    short unsigned mask ;
    mask = BlockInts();
    ClaState.MotorOnRequest = 0 ;
    SysState.PT.NewMsgReady = 0 ;


    if ( Method == E_OffForAutoEngage)
    {
        SysState.Mot.InAutoBrakeEngage = 1 ;
    }
    else
    {
        SysState.Mot.InAutoBrakeEngage = 0 ;
    }

    if (ClaState.SystemMode  == E_SysMotionModeSafeFault)
    {// Terminate a safe fault closure by actually shutting the motor and logging the exception as killer
        LogException(EXP_FATAL,SysState.Mot.SafeFaultCode)  ;
    }
    SysState.Mot.BrakeRelease = 0 ;
    RestoreInts( mask);
}



/*
 * Request a controlled state.
 * OnCondition = 0: Unconditional motor start, no auto stop
 * OnCondition = 1: Motor shall not start if stopped by convergence
 * OnCondition = 2: Motor shall start unconditionally, may stopped by convergence
 */
short SetMotorOn( short OnCondition)
{
    short unsigned mask , ReleaseAutoEngage;
    // If motor is already on, nothing to do
    if ( ClaState.MotorOnRequest > 0 )
    {
        return 0; // Trivial case - nothing to do
    }

    ReleaseAutoEngage = SysState.Mot.InAutoBrakeEngage ? 1 : 0 ;

    if ( OnCondition * ReleaseAutoEngage  == 1  )
    { // Commanded to motor on, motor shut down by convergence - avoid stray wakeup
        return 0 ;
    }

    SysState.Mot.InAutoBrakeEngage = 0 ;

    if ( DBaseConf.IsValidDatabase == 0 )
    {
        return ERR_IDENTITY_MISSING ;
    }

    if ( SysState.SeriousError )
    {
        return ERR_SERIOUS_ERROR ;
    }

    if ( ClaState.SystemMode <= E_SysMotionModeFault )
    {
        return ERR_RESET_FAILURE_FIRST;
    }
    if ( SysState.Mot.SafeFaultCode )
    {
        return ERR_IN_SAFE_FAULT_PROC ;
    }
/*
    if ( SetProjectSpecificData( ProjId) )
    {
        LogException(EXP_FATAL,err_undefined_proj_id) ;
    }
    else
    {
*/
    if ( InitControlParams() )
    {
        return err_bad_proj_pars ;
    }

    // Kill temporary brake control
    SysState.Mot.BrakeControlOverride &= 0xfffd ;

#ifdef SIMULATION_MODE
    ClaMailIn.IaOffset = 0 ;
    ClaMailIn.IbOffset = 0 ;
    ClaMailIn.IcOffset = 0 ;
#else
    if ( SysState.Mot.LoopClosureMode > E_LC_Voltage_Mode )
    { // On voltage mode it is possible to go on without current measurement
        if ( __fmax( __fmax( fabsf(SysState.AnalogProc.FiltCurAdcOffset[0]),fabsf(SysState.AnalogProc.FiltCurAdcOffset[1])) , fabsf(SysState.AnalogProc.FiltCurAdcOffset[2]) ) > MAX_ADC_CUR_OFFSET )
        {
            LogException( EXP_FATAL , exp_adc_offset_too_large ) ;
            return ERR_TOO_BIG_ADC_OFFSET ;
        }
    }

    if ( SysState.AnalogProc.bOffsetCalculated == 0 )
    {
        LogException( EXP_FATAL , exp_adc_offset_never_calculated ) ;
        return ERR_ADC_OFFSET_NOCALC ;
    }

#endif
    // Test initialized configuration
    if ( SysState.ConfigDone == 0 )
    {
        LogException( EXP_FATAL , configuration_not_complete ) ;
        return ERR_DRIVE_NOCONFIG  ;
    }


    SysState.Mot.ReferenceMode = E_PosModeNothing;
    SetReferenceMode ( E_PosModeStayInPlace )  ;
    SysState.Mot.InBrakeEngageDelay =  INBD_EngageNothing;

    //Brake release delay is entered only if brake condition is automatic (and was thus engaged)
    SetSysTimerTargetSec ( TIMER_RELEASE_BRAKE     ,  ControlPars.BrakeReleaseDelay ,  &SysTimerStr  );
    SysState.Mot.InBrakeReleaseDelay = 1 ;

    InitControlParams() ;
    // Re - initialize commutation
    Commutation.Init = 0 ;

    // Kill debugging flags
    ClaMailIn.bNoCurrentPrefilter = 0 ;
    SysState.Debug.bBypassPosFilter = 0 ;
    SysState.Profiler.bPeriodic = 0 ;
    SysState.Profiler.PauseCtr  = 0 ;

    ClearTrip() ;

    mask = BlockInts() ;
    PosPrefilterMotorOff(SysState.PosControl.PosFeedBack );
    RestoreInts(mask) ;

    // Clear exceptions
    SysState.Mot.KillingException = 0 ;
    SysState.Mot.LastException = 0    ;

    // Restart convergence counting
    if ( ReleaseAutoEngage == 0 )
    {
        SysState.Mot.MotionConvergeCnt = 0  ;
    }

    // Prep wheel encoder match test initial conditions

    mask = BlockInts() ;
    SysState.EncoderMatchTest.MotorEncoderRef = ClaState.Encoder1.Pos  ;
    SysState.EncoderMatchTest.WheelEncoderRef = SysState.OuterSensor.OuterPosInt.l ;
    RestoreInts(mask);

    // Set timer for a minimum of 3 seconds lifetime
    SetSysTimerTargetSec ( TIMER_AUTO_MIN_MOTORON , 3.0 , &SysTimerStr ) ;

    // Prepare voltage experiment
    ClaMailIn.ExperimentMode = 0.0f ;
    ClaState.ExperimentDir = 1.0 ;

    //Set the PWM to on
    SetGateDriveEnable(1) ;

    mask = BlockInts() ;
    SysState.Mot.MotorFault = 0 ; // Clear fault BIT and request motor on
    ClaState.MotorOnRequest  = 1 ;
    RestoreInts(mask) ;

    return 0 ;
}

long unsigned SetReferenceMode( short us)
{
short unsigned mask ;
    if (SysState.Mot.ReferenceMode == us )
    {
        return 0 ;
    }

    mask = BlockInts() ;

    SysState.Mot.MotionConverged  = 0  ; // Kill convergence counters, as previous are  irrelevant
    SysState.Mot.MotionConvergeCnt = 0  ;

    switch ( us )
    {
    case E_PosModeDebugGen:
        SysState.Mot.QuickStop = 0 ; // No quick stop on debug modes
        break ;
    case E_PosModeStayInPlace:
        ClaState.CurrentControl.CurrentReference = 0 ;
        SysState.SpeedControl.SpeedTarget = 0   ;
        SysState.SpeedControl.SpeedReference = ClaState.Encoder1.UserSpeed  * 0.9f ;
        break ;
    case E_PosModePTP:
        SysState.Profiler.PauseCtr = 0  ;
        if ( SysState.Mot.LoopClosureMode == E_LC_Speed_Mode )
        {// Here the position reference is a don't care
            ProfileToStop ( &SysState.Profiler , 0 , SysState.SpeedControl.SpeedReference * 0.9f );
        }
        else
        {
            ProfileToStop ( &SysState.Profiler , SysState.PosControl.PosFeedBack , ClaState.Encoder1.UserSpeed * 0.9f );
        }
        break ;
    case E_PosModePT:
        SysState.InterpolationPosRef = SysState.PosControl.PosFeedBack;
        SysState.PT.Init = 0 ;
#ifdef PVTEnabled
        PVResetTraj();
#endif
        break ;
    case E_RefModeSpeed:
        ClaState.CurrentControl.CurrentReference = 0 ;
        SysState.SpeedControl.SpeedTarget = 0   ;
        SysState.SpeedControl.SpeedReference = ClaState.Encoder1.UserSpeed * 0.9f  ;
        break;

    case E_RefModeSpeed2Home:
        InitHomingProc()  ;
        break ;
    default:
        return GetManufacturerSpecificCode(ERR_OUT_OF_RANGE) ;
    }
    SysState.Mot.ReferenceMode = us ;

    RestoreInts(mask) ;

    if ( SysState.Mot.InAutoBrakeEngage )
    {
        SetMotorOn(2) ;
    }
    return 0 ;
}

long unsigned SetLoopClosureMode( short us )
{
    short unsigned mask ;

    /*
    if ( us == E_LC_DontChangeMode )
    {
        return 0  ;
    }
    */
    if ( us == SysState.Mot.LoopClosureMode)
    {
       return 0 ;
    }

    if ( SysState.Mot.LoopClosureMode == E_LC_Voltage_Mode )
    {
        return GetManufacturerSpecificCode(ERR_IN_VOLTAGE_OPEN_LOOP) ;
    }

    if ( us == SysState.Mot.LoopClosureMode)
    {
        return 0 ;
    }

    if ( us > ControlPars.MaxSupportedClosure )
    {
        return GetManufacturerSpecificCode(ERR_CLOSURE_MODE_NOT_SUPPORTED) ;
    }


    mask = BlockInts();
    SetReferenceMode(E_PosModeStayInPlace) ; // So that any real reference mode will need be initialized

    switch ( us )
    {
    case E_LC_OpenLoopField_Mode:
        // Kill the commutation
        ResetSpeedController();
        break ;
    case E_LC_Torque_Mode:
        ResetSpeedController();
        break ;
    case E_LC_Speed_Mode:
        break ;
    case E_LC_Pos_Mode:
        break ;
    case E_LC_Dual_Pos_Mode:
        if ( SysState.Mot.Homed == 0 )
        {
            return GetManufacturerSpecificCode(ERR_AVAIL_ONLY_IF_HOMED) ;
        }
        break ;
    case E_LC_EXTDual_Pos_Mode:
        SysState.PosControl.PosErrorExt = 0 ;
        SysState.PosControl.SpeedFFExt  = 0 ;
        break ;
    default:
        RestoreInts(mask) ;
        return GetManufacturerSpecificCode(ERR_NORMALLY_UNSUPPORTED_CLOSURE) ;
    }
    ClaState.CurrentControl.CurrentReference = 0 ;
    SysState.SpeedControl.SpeedReference = 0   ;
    SysState.PosControl.PosReference = SysState.PosControl.PosFeedBack        ;
    SysState.Debug.GRef.On = 0 ;
    SysState.Debug.TRef.On = 0 ;
    SysState.Mot.MotionConverged  = 0  ; // Kill convergence counters, as previous are  irrelevant
    SysState.Mot.MotionConvergeCnt = 0  ;
    SysState.Mot.LoopClosureMode = us ;

    RestoreInts(mask) ;

    if ( SysState.Mot.InAutoBrakeEngage )
    {
        SetMotorOn(2) ;
    }

    return 0 ;
}

/*
    // Byte 0: Control word. Thats: .0: motor on, 1: Fault reset, :2..4: Loop type : 5..7: Reference mode
    // Bytes 1: 0: Release brake (eff. only if Brake override), 1:Disable automatic braking   2: ApplySteeringCorrection , 3:4 SwitchSizeSelect : 5: KillHoming , 6: Slow , 7: Brake override
    // byte 2: Current limit, 1/256 of rated
    // Bytes 3: 0
    // Bytes 4..7: Command (floating point, meaning per reference mode)
 */
void DecodeBhCW(long unsigned data)
{
    extern void DealFaultState();
    short next , mon ,resetfault , stat  ;
    short unsigned MotorIsOn ;
    long  unsigned lstat ;
    union
    {
        long unsigned ul ;
        short unsigned us[2] ;
    } u ;
    u.ul = data ;

    SysState.ControlWord = u.ul ;
    MotorIsOn = ClaState.MotorOnRequest ? 1 : 0 ;

    mon = u.us[0] & 1 ;
    resetfault = u.us[0] & 2 ;


    SysState.SteerCorrection.bSteeringComprensation =   ( u.us[0] >> 10 ) & 1 ;

    if ( resetfault)
    {
        SysState.Status.ResetFaultRequest = 1 ; // Reset fault condition
    }
    else
    {
        SysState.Status.ResetFaultRequestUsed = 0 ;
    }
    DealFaultState() ;

    next = ( u.us[0]  >> 2 ) & 7 ;
    if (( next >= E_LC_Torque_Mode) && ( next <= E_LC_EXTDual_Pos_Mode ) )
    {
        lstat = SetLoopClosureMode(next) ;
        if ( lstat )
        {
            if ( mon == 0 )
            {
                SafeSetMotorOff() ;
            }
            return ;
        }
    }
    next = ( u.us[0]  >> 5 ) & 7 ;
    if (next >= E_PosModeStayInPlace)
    {
        lstat = SetReferenceMode( next ) ;
    }
    else
    {
        lstat = GetManufacturerSpecificCode(ERR_OUT_OF_RANGE)  ;
    }
    if ( lstat )
    {
        if ( mon == 0 )
        {
            SafeSetMotorOff() ;
        }
        return  ;
    }
    if ( next > E_PosModeStayInPlace )
    {
        SysState.Mot.QuickStop = 0 ;
    }

    next = ( u.us[1] ) & 0xff ;
    if ( next )
    {
        SysState.Mot.CurrentLimitFactor = (next+1) * 0.003906250000000f ;
    }
    else
    {
        SysState.Mot.CurrentLimitFactor = 0 ;
    }


    //SysState.Homing.Direction = ( u.us[0]  & (1<<9)  ) ? 1 : -1 ;
    //SysState.Homing.Method   = ( u.us[0]  & (3<<10)  ) ? 1 : 0 ;
    //SysState.Homing.SwInUse  = ( u.us[0]  & (1<<12)  ) ? 1 : 0 ;

    // Select the switch width (for wheels)
#ifdef SLAVE_DRIVER
    // This parameter is passed to the interface card to operate the switches
    SysState.Cmd2Intfc.bit.SwitchWidthSelect = (( u.us[0] >>11 ) & 3 ) ;
#endif


    //KillHoming
    if ( u.us[0]  & (1<<13)  )
    {
        SysState.Homing.State = 0 ;
        SysState.Mot.Homed = 0 ;
    }

    // Slow profiling
    if ( u.us[0]  & (1<<14)  )
    {
        SysState.Profiler.bSlow = 1 ;
    }
    else
    {
        SysState.Profiler.bSlow = 0 ;
    }


    // Forcing brake command
    if ( (u.us[0]  & (1U<<15))  )
    {
        SysState.Mot.BrakeControlOverride = 1 ;
        SysState.Mot.ExtBrakeReleaseRequest = ( u.us[0] >> 8 ) & 1 ;
    }
    else
    {
        SysState.Mot.BrakeControlOverride = 0  ;
    }
    // Set motor on or off by request
    if ( MotorIsOn  || ClaState.MotorOn || SysState.Mot.InAutoBrakeEngage )
    {
        if ( mon == 0 )
        {
            SafeSetMotorOff() ;
        }
    }
    else
    {
        if ( mon )
        {
            stat = SetMotorOn(1) ;
            if ( stat )
            {
                LogException( EXP_FATAL, (long unsigned) stat ) ;
            }
        }
    }
}




void DecodeBhCmdValue(float f )
{
    float ref , pcmd ;
    // Get the command
    if ( isnan(f) == 0 )
    {
        ref = f ;
        switch ( SysState.Mot.LoopClosureMode)
        {
        case E_LC_Torque_Mode:
            ClaState.CurrentControl.CurrentReference =  fSatNanProt (ref, ControlPars.MaxCurCmd * SysState.Mot.CurrentLimitFactor ) ;
            break ;
        case E_LC_Speed_Mode:
            if ( SysState.Mot.ReferenceMode == E_PosModePTP )
            {
                pcmd = __fmax( __fmin(ref,ControlPars.MaxPositionCmd),ControlPars.MinPositionCmd) ;
                SysState.PosControl.PosReference = pcmd  ;
                if ( SysState.Profiler.PosTarget != pcmd )
                {
                    SysState.Profiler.PosTarget = pcmd ;
                    SysState.Profiler.Done      = 0 ;
                }
            }
            else
            {
                SysState.SpeedControl.SpeedTarget = fSatNanProt (ref, ControlPars.MaxSpeedCmd ) ;
            }
            break ;
        case E_LC_Pos_Mode:
        case E_LC_Dual_Pos_Mode:
            pcmd = __fmax( __fmin(ref,ControlPars.MaxPositionCmd),ControlPars.MinPositionCmd) ;
            if ( SysState.Mot.InAutoBrakeEngage )
            { // Motor off because stable in place. Log the new reference for possible wakeup signal
                SysState.PosControl.PosReference = pcmd  ;
            }
            else
            {
                if ( SysState.Mot.ReferenceMode == E_PosModePTP )
                {
                    if ( SysState.Profiler.PosTarget != pcmd )
                    {
                        SysState.Profiler.PosTarget = pcmd ;
                        SysState.Profiler.Done      = 0 ;
                    }

                }
                else if ( SysState.Mot.ReferenceMode ==  E_PosModePT )
                {
                    SysState.PosControl.PosReference = pcmd  ;

                }
            }
            break ;
        }
    }
}



/*
 * Calculate controller filter parameters based on poles and damping
 */
void InitControlFilter(struct CFilt2 * pFilt , float Ts )
{
    float z , b00 , a1 , a2 , bw , xi , b0 , b1 , b2 , sum  ;
    short IsSimple ;
    short unsigned mask ;

    bw = pFilt->PBw ;
    xi = pFilt->PXi ;

    if ( pFilt->Cfg.bit.IsInUse )
    {
        IsSimple = pFilt->Cfg.bit.IsSimplePole ;

        if ( bw <= 10000 )
        {
            z = __iexp2( -Ts * Log2OfE * xi * bw * Pi2 );
        }
        else
        {
            z = 0 ;
        }

        if ( IsSimple )
        {
            a2 = 0 ;
            a1 = -z ;
        }
        else
        {
            a2 = z * z ;
            a1  = -2.0f * __cos( __sqrt(1-xi*xi) * bw * Pi2 * Ts ) * z ;
        }

        b00 = 1 + a1 + a2  ;

        bw = pFilt->ZBw ;
        xi = pFilt->ZXi ;
        IsSimple = pFilt->Cfg.bit.IsSimpleZero ;

        if ( bw <= 10000 )
        {
            z = __iexp2( -Ts * Log2OfE * xi * bw * Pi2 );
        }
        else
        {
            z = 0 ;
        }
        if ( IsSimple )
        {
            b2 = 0 ;
            b1 = -z ;
            b0 = 1  ;
        }
        else
        {
            b2 = z * z ;
            b1  = -2.0f * __cos( __sqrt(1-xi*xi) * bw * Pi2 * Ts ) * z ;
            b0 = 1 ;
        }
        sum = b0 + b1 + b2 ;
        if ( sum < 1e-7f )
        {
            b0 = 0 ; b1 = 0 ; b2 = 0 ;
        }
        else
        {
            sum = 1.0 / __fmax( sum, 1e-7f) ;
            b0 = b0 * sum ;
            b1 = b1 * sum ;
            b2 = b2 * sum ;
        }
    }
    else
    {
        b00 = 0 ;
        a2  = 0 ;
        b0 =  0 ;
        b1 =  0 ;
        b2 =  0 ;
    }
    mask = BlockInts() ;
    pFilt->b00 = b00 ;
    pFilt->a2  = a2 ;
    pFilt->b0  = b0 ;
    pFilt->b1  = b1 ;
    pFilt->b2  = b2 ;
    RestoreInts(mask) ;
}


short  SetMotionCommandLimits(void)
{
    short unsigned mask ;
    float  PosRange ;
    mask = BlockInts() ;
    if ( ControlPars.MaxSupportedClosure >= E_LC_Pos_Mode )
    {
        PosRange = ControlPars.MaxPositionCmd  - ControlPars.MinPositionCmd ;
        if ( PosRange <= 0.001f )
        {
            return exp_ilegal_position_range ;
        }

        // PosPrefilter.InPosScale = 536870912.0f / PosRange ;
        // PosPrefilter.OutPosScale = 1.862645149230957e-09f * PosRange ;
        // PosPrefilter.OutSpeedScale = PosPrefilter.OutPosScale * (0.00390625f / (CUR_SAMPLE_TIME_USEC*1e-6f)) ;

        PosPrefilter.InPosScale = 1073741824.0f / PosRange ; // 2^30  /PosRange
        PosPrefilter.OutPosScale = 9.313225746154785e-10f * PosRange ;
        PosPrefilter.OutSpeedScale = PosPrefilter.OutPosScale / (CUR_SAMPLE_TIME_USEC*1e-6f) ; // PosRange * 2^(-30)
        PosPrefilterMotorOff( SysState.PosControl.PosFeedBack );
    }

    RestoreInts(mask) ;
    return 0 ;
}



/*
 * Initialize controller parameters
 */
short InitControlParams(void)
{
    float fTemp , z , xi , a0   ;
    //InitOverCurrentTholds();

    ControlPars.SpeedAWU = ControlPars.SpeedKi * SysState.Timing.Ts /  \
            ( ControlPars.SpeedKp + ControlPars.SpeedKi * SysState.Timing.Ts ) ;

    ClaControlPars.OneOverPP = 1.0f / __fmax( ClaControlPars.nPolePairs, 1.0f) ;
    //ClaControlPars.Bit2Amp = ControlPars.FullAdcRangeCurrent * (1.0f/2048.0f) ;
    //ClaControlPars.Amp2Bit = 1.0f /__fmax( ClaControlPars.Bit2Amp, 1.e-7f) ;

    ClaControlPars.Pos2Rev = 1.0f / __fmax( ClaControlPars.Rev2Pos , 1e-8f) ; // !< Scale position units to revolutions

    //ClaMailIn.SimdT = SysState.Timing.Ts ;

    ControlPars.I2tPoleS = 1.0f - __iexp2( SysState.Timing.Ts * 256 * Log2OfE / __fmax( 0.0001f , ControlPars.I2tCurTime ) );
    ClaControlPars.SpeedFilterCst = 1.0f - __iexp2( SysState.Timing.Ts * Log2OfE * Pi2 * ControlPars.SpeedFilterBWHz  );

   // {& ClaControlPars.CurrentRefFiltA0,12, -1.0f,1.0e6f,-1.745485231989130f} ,//  !< Ref filter parameter A[0]
   // {& ClaControlPars.CurrentRefFiltA1,14, -1.0f,1.0e6f,0.776790921324546f} ,//  !< Ref filter parameter A[1]
    xi = 0.67f ;
    z = __iexp2( -SysState.Timing.Ts * Log2OfE * xi * ControlPars.CurrentFilterBWHz * Pi2 );

    ClaMailIn.CurPrefiltA1 = z * z ;
    a0  = -2.0f * __cos( __sqrt(1-xi*xi) * ControlPars.CurrentFilterBWHz * Pi2 * SysState.Timing.Ts ) * z ;
    ClaMailIn.CurPrefiltB  = 1 + a0 + ClaMailIn.CurPrefiltA1 ;

    fTemp = __fmin( ControlPars.I2tCurLevel , ControlPars.FullAdcRangeCurrent * 0.95f) ;
    ControlPars.I2tCurThold = fTemp * fTemp  ;

    Commutation.EncoderCountsFullRev = ControlPars.EncoderCountsFullRev ;
    ClaControlPars.InvEncoderCountsFullRev = 1.0f / __fmax( ControlPars.EncoderCountsFullRev, 1) ;
    Commutation.Encoder2CommAngle = (float)ClaControlPars.nPolePairs * ClaControlPars.InvEncoderCountsFullRev  ;

    ClaState.Encoder1.Bit2Rev = ClaControlPars.InvEncoderCountsFullRev ;
    ClaState.Encoder1.Rev2Bit = (long) ControlPars.EncoderCountsFullRev ;
    ClaState.Encoder1.Rev2Pos = ClaControlPars.Rev2Pos  ;

    SysState.Timing.OneOverTsTraj = 1.0f / SysState.Timing.TsTraj ;

    SysState.MCanSupport.OneOverNomMessageTime = 1.0f / __fmax( SysState.MCanSupport.NomInterMessageTime, 1e-4f ) ;
    SysState.MCanSupport.OneOverActMessageTime = SysState.MCanSupport.OneOverNomMessageTime ;
    SysState.MCanSupport.InterMessageTime = SysState.MCanSupport.NomInterMessageTime ;

    CLA_forceTasks(CLA1_BASE, CLA_TASKFLAG_7); // Initialize CLA current loop prefilter

    InitControlFilter( & ControlPars.qf0 , SysState.Timing.Ts );
    InitControlFilter( & ControlPars.qf1 , SysState.Timing.Ts );

    //SpeedScale/ Tics = speed
    ClaState.Encoder1.MinMotSpeedHz   = 0.05f / ( ControlPars.EncoderCountsFullRev * SysState.Timing.Ts)  ;

    SysState.MCanSupport.OneOverNomInterMessageTime = 1.0 / __fmax(SysState.MCanSupport.NomInterMessageTime,5.0e-5f);

    ControlPars.PdoCurrentReportScale = 680.0f / ControlPars.MaxCurCmd  ;
    // Keep position to limits
    return SetMotionCommandLimits() ;
}



