/*
 * TimerArr.c
 *
 *  Created on: Aug 13, 2021
 *      Author: Yahali
 */


//#include "F2837x_Device.h"
#include "StructDef.h"
//#include "../Drivers/DriverDefs.h"

//#include "StructDef.h"
//#include "Functions.h"
//#include <SysUtils.h>





void ResetHardwareSysTimer(void) ;

#ifndef TIMER_ARR_STAM_WAIT_IDLE
#define TIMER_ARR_STAM_WAIT_IDLE 0
#endif

long long unsigned GetLongTimer ( struct CSysTimerStr *pT )
{
    return (long long unsigned) pT->SysTimer ;
}


void GetIpcTimer( unsigned long long *p)
{
    unsigned long * pp = (unsigned long *)p;
    pp[0] = Cpu1toCpu2IpcRegs.IPCCOUNTERL ;
    pp[1] = Cpu1toCpu2IpcRegs.IPCCOUNTERH ;
}

void UpdateSysTimer(void )
{// RT safe: Timer update in the assembler is in critical section
    long unsigned tmr ;
    short unsigned mask ;
    long unsigned *p ;
    p = (long unsigned *) &SysTimerStr.SysTimer ;
    mask = BlockInts() ;
    tmr = SysState.Timing.UsecTimer  ;
    if ( tmr <  p[0]   )
    {
        p[1] += 1   ;
    }
    p[0] = tmr  ;
    RestoreInts( mask) ;
}


long unsigned GetShortTimer ( struct CSysTimerStr *pT )
{
    return * ( (long unsigned *) & pT->SysTimer ) ;
}

void InitSystemTimer( struct CSysTimerStr *pT )
{
    short unsigned cnt ;
    //CpuTimer1Regs.TIM.all = 0 ;

    ResetHardwareSysTimer() ;
    pT->SysTimer = 0 ;


    // Send all the timer comparison array to hell
    for ( cnt = 0 ; cnt < NSYS_TIMER_CMP_ARRAY ; cnt++)
    {
        pT->SysTimerCmpArray[cnt] = 0x7fffffffffffffff ; // They will never elapse until explicitly set
    }
}

/*
 * \brief Set a comparator target on a given timer
 * \param  tInd : Index of timer
 * \param  sec  : Seconds ahead for timer elapse
 */
void SetSysTimerTargetSec ( short unsigned tInd , float sec , struct CSysTimerStr *pT  )
{
    short unsigned mask ;
    long long unsigned dT;
    if ( tInd < NSYS_TIMER_CMP_ARRAY )
    {
        dT  =(long long unsigned) ( 1.0e6f * sec );
        mask = BlockInts() ;
        pT->SysTimerCmpArray[tInd] = pT->SysTimer + dT  ;
        RestoreInts( mask) ;
    }
}

/*
 * \brief Set a comparator target on a given timer for as its previous target + increment
 * \param  tInd : Index of timer
 * \param  sec  : Seconds ahead for timer elapse
 */
void IncrementSysTimerTargetSec ( short unsigned tInd , float sec , struct CSysTimerStr *pT  )
{
    short unsigned mask ;
    long long unsigned next ;
    if ( tInd < NSYS_TIMER_CMP_ARRAY )
    {
        mask = BlockInts() ;
        next = pT->SysTimerCmpArray[tInd] + (long long unsigned) ( 1.0e6f * sec ) ;
        pT->SysTimerCmpArray[tInd] = next ;
        RestoreInts( mask) ;
    }
}


/*
* \brief Limit the comparator target on a given timer
* \param  tInd : Index of timer
* \param  sec  : Seconds ahead for maximum timer elapse
*/
void LimitSysTimerTargetSec(short unsigned tInd, float sec, struct CSysTimerStr *pT)
{
    short unsigned mask;
    long long unsigned MaxTTarget;
    if (tInd < NSYS_TIMER_CMP_ARRAY)
    {
        mask = BlockInts();
        MaxTTarget = pT->SysTimer + (long long unsigned) (1.0e6f * sec);
        if (MaxTTarget < pT->SysTimerCmpArray[tInd])
        {
            pT->SysTimerCmpArray[tInd] = MaxTTarget ;
        }
        RestoreInts(mask);
    }
}


/*
* \brief Set minimum comparator target on a given timer
* \param  tInd : Index of timer
* \param  sec  : Seconds ahead for maximum timer elapse
*/
void SetAtLeastSysTimerTargetSec(short unsigned tInd, float sec, struct CSysTimerStr *pT)
{
    short unsigned mask;
    long long unsigned MinTTarget;
    if (tInd < NSYS_TIMER_CMP_ARRAY)
    {
        mask = BlockInts();
        MinTTarget = pT->SysTimer + (long long unsigned) (1.0e6f * sec);
        if (MinTTarget > pT->SysTimerCmpArray[tInd])
        {
            pT->SysTimerCmpArray[tInd] = MinTTarget ;
        }
        RestoreInts(mask);
    }
}


void SetSysTimerTarget ( short unsigned tInd , long unsigned WaitUsec , struct CSysTimerStr *pT )
{
    short unsigned mask ;
        if ( tInd < NSYS_TIMER_CMP_ARRAY )
        {
            mask = BlockInts() ;
            pT->SysTimerCmpArray[tInd] = pT->SysTimer + (long long unsigned) WaitUsec ;
            RestoreInts( mask) ;
        }
}

/**
 * \brief Ask if timer elapsed
 * \param tInd : Timer index
 * \return 1 if elapsed, 0 otherwise
 */
short unsigned IsSysTimerElapse( short unsigned tInd , struct CSysTimerStr *pT  )
{
    short unsigned mask ;
    short RetVal ;
    RetVal = 0 ;
    if ( tInd < NSYS_TIMER_CMP_ARRAY )
    {
        mask = BlockInts() ;
        if ( pT->SysTimer >= pT->SysTimerCmpArray[tInd] )
        {
            RetVal = 1 ;
        }
        RestoreInts( mask) ;
    }
    return RetVal  ;
}

/**
 * \brief Wait until timer elapses. If the time that remains exceeds MaxWait, return immediately
 * \param tInd : Timer index
 * \param MaxWait : Maximum wait time in usec
 * \return 0 if timer elapsed, -1 on time too long to wait
 */
short WaitTimerElapse(short unsigned tInd , long unsigned MaxWait, struct CSysTimerStr *pT )
{
    UpdateSysTimer(  ) ;
    if ( GetRemainTime(tInd,pT) > MaxWait )
    {
        return -1 ;
    }
    while (  IsSysTimerElapse(tInd,pT) == 0 )
    {
        UpdateSysTimer(  ) ;
    }
    return 0 ;
}

/**
 * \brief Get the remaining time till timer elapse
 * \param tInd Index od considered timer
 *
 * \return: 0 if timer already elapsed
 *          0x7fffffff if time until elapse is greater or equal to 2^31-1 usec
 *          value in usec otherwise
 *
 */
long unsigned GetRemainTime( short unsigned tInd ,  struct CSysTimerStr *pT)
{
    long long unsigned delta ;
    if ( tInd < NSYS_TIMER_CMP_ARRAY )
    {
        if ( pT->SysTimer > pT->SysTimerCmpArray[tInd] ){
            return 0 ; // Already elapsed
        }
        delta = pT->SysTimerCmpArray[tInd] - pT->SysTimer ; // Time remained
        if ( delta > 0x7fffffff )
        {
            return 0x7fffffff ; // Too long
        }
        return (long unsigned) delta ; // return true elapse time
    }
    return 0 ;
}

/**
 * \brief Get the remaining time till timer elapse
 * \param tInd Index od considered timer
 *
 * \returns         value in sec, negative if elapsed
 *
 */
float GetRemainTimeSec( short unsigned tInd  )
{
    union
    {
        long long delta ;
        long long unsigned udelta ;
    }u;


    if ( tInd < NSYS_TIMER_CMP_ARRAY )
    {
        u.udelta = SysTimerStr.SysTimerCmpArray[tInd] - SysTimerStr.SysTimer ; // Time remained
        return (float)u.delta * 1.e-6f ; // return true elapse time
    }
    return 0 ;
}



#ifdef _LPSIM
    void RtCycle( ) ;
    void PDSimulator() ;
    void SimulateRobotComm ( void ) ;
#endif

void WaitStamSec( float sec )
{
    WaitStam( (long) (__fmax( __fmin(sec,2000.0f),1e-5f) * 1000000.0f )  ,  &SysTimerStr);
}

void WaitStam( long unsigned WaitUsec ,  struct CSysTimerStr *pT)
{
#ifndef _LPSIM
    short done ;
    if ( WaitUsec < 2 )
    {
        WaitUsec = 2 ;
    }
    UpdateSysTimer ( ) ;
    SetSysTimerTarget ( TIMER_ARR_STAM_WAIT_IDLE , WaitUsec , pT ) ;
    do {
        UpdateSysTimer (  ) ;
        done = IsSysTimerElapse(TIMER_ARR_STAM_WAIT_IDLE , pT ) ;
//        RtCycle() ;
//        PDSimulator();
//        SimulateRobotComm ( ) ;
        SysCtl_serviceWatchdog();
    } while ( done == 0 );
#endif
}


