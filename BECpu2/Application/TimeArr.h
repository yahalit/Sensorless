/*
 * TimerArr.h
 *
 *  Created on: Dec 20, 2016
 *      Author: Yahali Theodor
 */

#ifndef APPLICATION_TIMER_H_
#define APPLICATION_TIMER_H_


struct CSysTimerStr
{
    long long unsigned SysTimer ;
    long long unsigned SysTimerCmpArray[NSYS_TIMER_CMP_ARRAY] ;
};


// Get the IPC system timer (SYSCLK rate)
void GetIpcTimer( unsigned long long *p);

// Get the timer at full 64 bit
long long unsigned GetLongTimer ( struct CSysTimerStr *pT );

// Initialize the system timer module
void InitSystemTimer( struct CSysTimerStr *pT);

// Update the time of the system timer, using the hardware clock
void UpdateSysTimer (void);

// Set a comparison target, at comparator of index tInd, WaitUsec microseconds ahead
void SetSysTimerTarget ( short unsigned tInd , long unsigned WaitUsec  ,struct CSysTimerStr *pT);

// Set a comparison target, at comparator of index tInd, sec seconds ahead
void SetSysTimerTargetSec ( short unsigned tInd , float sec ,  struct CSysTimerStr *pT  );

// Increment a comparison target, at comparator of index tInd, sec seconds
void IncrementSysTimerTargetSec ( short unsigned tInd , float sec , struct CSysTimerStr *pT  );

// Set minimum comparator target on a given timer
void SetAtLeastSysTimerTargetSec(short unsigned tInd, float sec, struct CSysTimerStr *pT);


// Limit the comparison target, at comparator of index tInd, to sec seconds ahead
void LimitSysTimerTargetSec(short unsigned tInd, float sec, struct CSysTimerStr *pT);

// Detect if the comparison time for comparator of index tInd arrived already
short unsigned IsSysTimerElapse( short unsigned tInd ,  struct CSysTimerStr *pT  );

// Wait timer to elapse
short WaitTimerElapse(short unsigned tInd , long unsigned MaxWait ,  struct CSysTimerStr *pT ) ;

// Wait for a given amount of microseconds
void WaitStam( long unsigned WaitUsec ,  struct CSysTimerStr *pT);

void WaitStamSec( float sec );

// Wait least 32 bits of timer now()
long unsigned GetShortTimer (  struct CSysTimerStr *pT );

// Get time until elapse
long unsigned GetRemainTime( short unsigned tInd ,  struct CSysTimerStr *pT  );

// \brief Get the remaining time till timer elapse
float GetRemainTimeSec( short unsigned tInd  );


#endif /* APPLICATION_TIMER_H_ */
