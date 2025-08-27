/*
 * PeriodicIsr.c
 *
 *  Created on: 23 Aug 2025
 *      Author: Yahali
 */

#include "StructDef2.h"


#pragma FUNCTION_OPTIONS ( IPC3_ISR, "--opt_level=3" );


__interrupt void IPC3_ISR(void)
{
    // Interrupt CPU2

    // Reset interrupt source from the IPC
    HWREG(IPC_CPUXTOCPUX_BASE+IPC_O_CPU1TOCPU2IPCACK) = IPC_FLAG3;

    // Acknowledge the interrupt group
    HWREGH(PIECTRL_BASE + PIE_O_ACK) = INTERRUPT_ACK_GROUP1;

    // Step up the interrupt counter
    SealState.InterruptCnt.ll += 1 ;
    SealState.SystemTime += UM2S.M2S.ControlTs ;

    RtCanService() ;



}
