#include "..\Application\StructDef.h"

/*
 * Homing.c
 *
 *  Created on: Nov 10, 2023
 *      Author: yahal
 */
long ImmediateHoming(void)
{
    unsigned short mask;
    if ( SysState.Mot.NoCalib )
    {
        return exp_homing_requires_calib;
    }
    mask = BlockInts();
    if (ControlPars.UseCase & (UC_USE_POT1 | UC_USE_POT2))
    {
        if (ClaState.PotRefFail)
        {
            RestoreInts(mask);
            return exp_canthome_pot_ref_failed;
        }
        ClaState.Encoder1.UserPos = SysState.OuterSensor.OuterPos;
        ClaState.Encoder1.UserPosOnHome = SysState.OuterSensor.OuterPos;
    }

    SysState.Mot.Homed = 1;
    ClaState.Encoder1.EncoderOnHome = ClaState.Encoder1.Pos;
    SysState.OuterSensor.OuterMergeState = 0;
    RestoreInts(mask);
    return 0;
}


long HomingHere(float f )
{
    unsigned short mask;
    if ( SysState.Mot.NoCalib )
    {
        return exp_homing_requires_calib;
    }
    mask = BlockInts();
    ClaState.Encoder1.UserPos = f;
    ClaState.Encoder1.UserPosOnHome = f ;
    SysState.Mot.Homed = 1;
    ClaState.Encoder1.EncoderOnHome = ClaState.Encoder1.Pos;
    //SysState.OuterSensor.OuterMergeState = 0;
    RestoreInts(mask);
    return 0;
}



/*
 * Homing profiler. Can only be done in the speed mode to avoid position jump.
 */
long HomeProfiler()
{
    long delta ;
    float d1 , d2 , backref;

    if ( SysState.Homing.Method == EHM_Immediate)
    {

        SysState.Homing.State = EMS_Done ;
        SysState.SpeedControl.SpeedReference = 0 ;
        return ImmediateHoming() ;
    }


    delta = ClaState.Encoder1.Pos - SysState.Homing.EncoderOnStart ;
    if ( fabsf(delta) > SysState.Homing.MaxEncoderTravelHoming )
    {
        SysState.Homing.Exception = exp_homing_too_faraway ;
    }

    if ( SysState.Homing.Exception &&  ( SysState.Homing.State < EMS_Decelerate2Fail) )
    {
        SysState.Homing.State = EMS_Decelerate2Fail ;
    }

    // Current filter, in use when the home method is "travel till hitting a wall"
    SysState.Homing.HomingCurrentFilt =  SysState.Homing.HomingCurrentFilt +  SysState.Homing.HomingCurrentFilterCst *
            (ClaState.CurrentControl.ExtIq -  SysState.Homing.HomingCurrentFilt) ;

    // Look for the homing event
    if ( SysState.Homing.State < EMS_LogEvent )
    {
        switch(SysState.Homing.Method )
        {
        case EHM_CollideLimit: // Looking for a hard end
            if ( SysState.Homing.HomingCurrentFilt * SysState.Homing.Direction >   SysState.Homing.HomingCurrent * 0.85f  )
            { // Found the hard end - end of homing
                SysState.Homing.State = EMS_LogEvent ;
                if ( SysState.Homing.Direction > 0 )
                {
                    ClaState.Encoder1.UserPosOnHome = SysState.UserPosOnHomingFW ;
                }
                else
                {
                    ClaState.Encoder1.UserPosOnHome = SysState.UserPosOnHomingRev ;
                }
            }
            break ;
        case EHM_SwitchLimit: // Looking for a switch
            if ( SysState.Homing.Direction > 0 )
            {
                ClaState.Encoder1.UserPosOnHome = SysState.UserPosOnHomingFW ;
            }
            else
            {
                ClaState.Encoder1.UserPosOnHome = SysState.UserPosOnHomingRev ;
            }
            if ( SysState.Homing.SwInUse  == 0 )
            {
                if ( IsDin1() )
                {
                    SysState.Homing.State = EMS_LogEvent ;
                }
            }
            else
            {
                if ( IsDin2() )
                {
                    SysState.Homing.State = EMS_LogEvent ;
                }
            }
            break ;
        }
    }

    switch( SysState.Homing.State )
    {
    case EHS_Init:
        // Acceleration towards homing speed, then traveling with it
        SysState.Mot.Homed = 0 ;
        d1 = SysState.Homing.HomingSpeed * SysState.Homing.Direction -  SysState.SpeedControl.SpeedReference ;
        d2 = fSat ( d1 , SysState.SpeedControl.ProfileAcceleration * SysState.Timing.Ts )  ;
        SysState.SpeedControl.SpeedReference  += d2 ;
        break;

    case EMS_LogEvent:
        // Found home, Log the homing event
        d1 = -SysState.SpeedControl.SpeedReference ;
        d2 = fSat ( d1 , ControlPars.MaxAcc * SysState.Timing.Ts )  ;
        SysState.SpeedControl.SpeedReference  += d2 ;
        ClaState.Encoder1.EncoderOnHome = ClaState.Encoder1.Pos ;
        SysState.Homing.State = EMS_Stop ;
        break ;

    case EMS_Stop:
        // Found home, Reduce speed to zero
        // Revert the speed command towards exit from home position: first null the speed command
        backref = -0.3f * SysState.Homing.HomingSpeed * SysState.Homing.Direction ; // Reference speed for exit
        d1 = backref  -SysState.SpeedControl.SpeedReference ; // Gap to cross in the speed command
        d2 = fSat ( d1 , ControlPars.MaxAcc * SysState.Timing.Ts )  ; // Limit the change to permitted acceleration
        SysState.SpeedControl.SpeedReference  += d2 ; // Update speed reference (entire gap or permitted acceleration, the smaller)
        if ( fabsf(SysState.SpeedControl.SpeedReference-backref) < 1e-3f)
        { // Speed converged to new reference
            SysState.SpeedControl.SpeedReference = backref;
            SysState.Homing.State = EMS_ExitHome ;
        }
        break ;

    case EMS_ExitHome: // Home already found, and back speed reference is converged just exit the home area
        if ( ( ClaState.Encoder1.UserPosOnHome - ClaState.Encoder1.UserPos ) * SysState.Homing.Direction  >=
                 SysState.Homing.HomingExitUserPos )
        {
            SysState.Homing.State = EMS_Final_Stop ;
        }
        break;
    case EMS_Final_Stop: // Exited enough, final stop after process is over
        d1 = -SysState.SpeedControl.SpeedReference ;
        d2 = fSat ( d1 , SysState.SpeedControl.ProfileAcceleration * SysState.Timing.Ts )  ;
        SysState.SpeedControl.SpeedReference  += d2 ;
        if ( fabsf(SysState.SpeedControl.SpeedReference) < 1e-3f)
        {
            SysState.Homing.State = EMS_Done ;
        }
        break;
    case EMS_Done:
        // Done
        SysState.Mot.Homed = 1 ;
        SysState.SpeedControl.SpeedReference = 0 ;
        break ;

    case EMS_Decelerate2Fail: // Decelerating to failure
        d1 = -SysState.SpeedControl.SpeedReference ;
        d2 = fSat ( d1 , ControlPars.MaxAcc * SysState.Timing.Ts )  ;
        SysState.SpeedControl.SpeedReference  += d2 ;
        if ( fabsf(SysState.SpeedControl.SpeedReference) < 1e-3f)
        {
            SysState.Homing.State = EMS_Failure ;
        }
        break ;
    }
    return SysState.Homing.Exception ;
}


long unsigned InitHomingProc( void )
{
    long stat ;
    if ( (ControlPars.UseCase & US_SUPPORT_HOMING) == 0 )
    {
        return exp_homing_not_supported ;
    }

    if ( ControlPars.UseCase & (UC_USE_POT1|UC_USE_POT2) )
    {
        return exp_homing_with_abs_sensor ;
    }

    // Set to speed mode
    stat = SetLoopClosureMode(E_LC_Speed_Mode);
    if ( stat)
    {
        return stat ;
    }

    // Set the position count start here
    SysState.Homing.EncoderOnStart = ClaState.Encoder1.Pos;
    SysState.Homing.MaxEncoderTravelHoming = (long) (( ControlPars.MaxPositionCmd-ControlPars.MinPositionCmd) *  ClaControlPars.Pos2Rev *
            ClaState.Encoder1.Rev2Bit * 1.1f ) ;
    SysState.Homing.State = 0 ;
    SysState.Homing.Exception = 0;
    SysState.Homing.HomingCurrent = ControlPars.MaxCurCmd * SysState.Mot.CurrentLimitFactor ;
    SysState.Homing.HomingCurrentFilterCst = ( 1.0f - CUR_SAMPLE_TIME_USEC / 500000.0f   ) ;
    SysState.Homing.HomingCurrentFilt = 0;

    //SetReferenceMode(E_RefModeSpeed2Home) ;
    SysState.Mot.Homed = 0 ;

    return  0;
}

/*
 * Set the absolute homing per direct homing (DS402 emulation)
 */
long unsigned SetAbsPosition( float pos)
{
    short unsigned mask ;
    float dUserPos ;
    if ( ClaState.MotorOnRequest)
    {
        if ( SysState.Mot.LoopClosureMode > E_LC_Speed_Mode && ( SysState.Mot.ReferenceMode != E_PosModeStayInPlace) )
        {
            return GetManufacturerSpecificCode(ERR_ONLY_FOR_MOTOROFF) ;
        }
    }

    mask = BlockInts() ;
    dUserPos = pos - SysState.PosControl.PosFeedBack ;
    ClaState.Encoder1.UserPosOnHome = pos ; // ClaState.Encoder1.UserEncoderOnZero + dUserPos  ;
    ClaState.Encoder1.EncoderOnHome = ClaState.Encoder1.Pos ;

    SysState.PosControl.PosReference = SysState.PosControl.PosReference + dUserPos ;
    RestoreInts(mask) ;
    return 0 ;
}




