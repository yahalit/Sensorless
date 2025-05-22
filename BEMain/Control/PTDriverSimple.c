/*
 * PVDriver.c
 *
 *  Created on: May 13, 2023
 *      Author: yahal
 */

// Take commands accepted on the CAN by inaccurate times and turn them into position trajectory
#include "..\Application\StructDef.h"






short PTRunTimeDriver(void)
{
float RunTime ,td , junk ,munk  ;
    if ( SysState.PT.NewMsgReady )
    {
        if ( SysState.PT.Init == 0 )
        {
            SysState.PT.Pnew = SysState.InterpolationPosRef ;
            SysState.PT.Pnow = SysState.PosControl.PosReference  ;
            SysState.PT.Init  = 1 ;
        }

        junk = ( SysState.InterpolationPosRef  - SysState.PT.Pnew ) * SysState.MCanSupport.OneOverNomInterMessageTime ;
        SysState.PT.SpeedCmd = SysState.PosControl.SpeedFFExt ;
        SysState.PT.Speed  = __fmax(-ControlPars.MaxSpeedCmd,__fmin(ControlPars.MaxSpeedCmd ,junk) )  ;
        munk = ( SysState.PT.Pnew - SysState.PT.Pnow ) * SysState.MCanSupport.OneOverNomInterMessageTime + SysState.PT.Speed;
        SysState.PT.Dspeed =  __fmax(-ControlPars.MaxSpeedCmd,__fmin(ControlPars.MaxSpeedCmd ,munk   ) )  ;
        SysState.PT.Pnew  = SysState.PT.Pnow  +  SysState.PT.Dspeed  * SysState.MCanSupport.NomInterMessageTime;
        SysState.PT.Index = 0 ;
        if (( SysState.PT.Speed == junk) && ( SysState.PT.Dspeed  == munk ) )
        {
            SysState.PT.Converged = 1 ;
        }
        else
        {
            SysState.PT.Converged = 0 ;
        }
    }
    RunTime = SysState.PT.Index * SysState.Timing.Ts  ;

    if ( RunTime <= SysState.MCanSupport.NomInterMessageTime)
    {
        SysState.PT.Pnow  += SysState.PT.Dspeed  * SysState.Timing.Ts ;
        SysState.PT.InitStop = 0 ;
        SysState.PT.Index += 1 ;
    }
    else
    {
        if ( SysState.PT.Index  <= 2.0f * SysState.MCanSupport.OneOverNomInterMessageTime * SysState.Timing.OneOverTsTraj )
        {
            SysState.PT.Pnow = SysState.PT.Pnew + (RunTime-SysState.MCanSupport.NomInterMessageTime) * SysState.PT.Speed ;
            SysState.PT.Index += 1 ;
        }
        else
        {
            if ( SysState.PT.InitStop == 0 )
            {
                SysState.PT.QuickStopAcc = (SysState.PT.Speed  >= 0 ? -1 : 1 ) * ControlPars.MaxAcc   ;
                SysState.PT.InitStop = 1 ;
            }
            td = (RunTime-2 * SysState.MCanSupport.NomInterMessageTime);

            if ( (td * SysState.PT.QuickStopAcc + SysState.PT.Speed) * SysState.PT.Speed > 0 )
            {
                SysState.PT.Pnow = SysState.PT.Pnew + (td + SysState.MCanSupport.NomInterMessageTime) * SysState.PT.Speed  + 0.5 * td * td * SysState.PT.QuickStopAcc  ;
                SysState.PT.Index += 1 ;
            }
        }
    }
    SysState.PosControl.PosReference = SysState.PT.Pnow ;

    return SysState.PT.Converged ;
}






