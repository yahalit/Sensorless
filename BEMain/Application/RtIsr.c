/*
 * RtIsr.c
 *
 *  Created on: Jun 17, 2023
 *      Author: yahal
 */

#include "StructDef.h"




__interrupt void ControlIsr(void)
{

    // Take system time
    SysState.Timing.UsecTimer = ~HWREG( CPUTIMER1_BASE+CPUTIMER_O_TIM) ;
    if ( SysState.InterruptRoutineBusy | SysState.Mot.DisablePeriodicService )
    { // Avoid real time overflow
        return ;
    }
    SysState.InterruptRoutineBusy = 1 ;

    DINT ;
    SysState.InterruptRoutineBusy = 0 ;
}
