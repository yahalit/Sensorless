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

    if ( SysState.Homing.Method == EHM_Immediate)
    {

        SysState.Homing.State = EMS_Done ;
        SysState.SpeedControl.SpeedReference = 0 ;
        return ImmediateHoming() ;
    }

    SysState.Homing.Exception = exp_homing_too_faraway ;
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




