/*
 * IdleLoop.c
 *
 *  Created on: May 14, 2023
 *      Author: yahal
 */
#include "StructDef.h"

const long unsigned JtagPass[2] = {0x90abcdef,0xffffffff} ;
#pragma DATA_SECTION(JtagPass, ".statistics");
#pragma RETAIN(JtagPass );


long unsigned zevel ;

void IdleLoop(void)
{
    UpdateSysTimer() ;

/*
    if ( SysState.Timing.IntCntr - zevel > 100)
    {
        zevel =  SysState.Timing.IntCntr ;
        TxSingleChar('a' );
    }
*/

    IdleCbit() ;

    CanSlave();

    //UartService() ;

    // Test mode switch to automatic
    SysState.Timing.AutoCommandAge = (long) ( SysTimerStr.SysTimer - SysState.MCanSupport.Pdo1RxTime.ll ) * 1.e-6f ;

    if( SysState.Status.bNewControlWord )
    {
        if ( (SysState.Mot.ReferenceMode != E_PosModeDebugGen ) || ( ClaState.MotorOnRequest == 0 ))
        {
            DecodeBhCW(SysState.MCanSupport.uPDO1Rx.ul[0]) ;
            if ((SysState.Status.bNewControlWord & 2 ) == 0 )
            {
                DecodeBhCmdValue(SysState.MCanSupport.uPDO1Rx.f[1]) ;
            }
            SysState.Status.bNewControlWord = 0 ;
            SetSystemMode(E_SysMotionModeAutomatic) ;
        }
    }
    else
    {
        if ( SysState.Timing.AutoCommandAge > MAX_PDO_AGE_FOR_AUTOMATIC )
        { // Avoid stray automatic automatic passages by timer roll-off
            if ( ClaState.SystemMode == E_SysMotionModeAutomatic )
            { // Exit automatic by time out
                SetReferenceMode( E_PosModeStayInPlace );
            }
            SysState.MCanSupport.Pdo1RxTime.ll = SysTimerStr.SysTimer - ( 2 * MAX_PDO_AGE_FOR_AUTOMATIC * 1000000L) ;
        }
        //SysState.Profiler.bSlow = 0 ;
        if ( ClaState.SystemMode == E_SysMotionModeNothing)
        {
            SafeSetMotorOff();
        }
        DealFaultState() ; // Try release fault
    }
}


/*
 * Test if in fault state; if so, set motor off and test a request for fault reset
 */
void DealFaultState()
{
    if ( ClaState.SystemMode != E_SysMotionModeFault)
    {
        if ( SysState.Status.ResetFaultRequest && ( SysState.Status.ResetFaultRequestUsed == 0 ) )
        {
            SysState.Status.ResetFaultRequestUsed = 1 ;
            SysState.Mot.MotorFault = 0 ;
        }
        SysState.Status.ResetFaultRequest     = 0 ;
        return ;
    }

    SetMotorOff(E_OffForFinal);

    if ( SysState.Status.ResetFaultRequest && ( SysState.Status.ResetFaultRequestUsed == 0 ) )
    {
        LogException(EXP_RESET,0);
        SetSystemMode( E_SysMotionModeManual) ;
        SysState.Status.ResetFaultRequest     = 0 ;
        SysState.Status.ResetFaultRequestUsed = 1 ;
        SysState.Mot.MotorFault = 0 ;
    }
}

