/*
 * PeriodicIsr.c
 *
 *  Created on: 23 Aug 2025
 *      Author: Yahali
 */

#include "StructDef2.h"


#pragma FUNCTION_OPTIONS ( PeriodicIsr, "--opt_level=3" );
__interrupt void PeriodicIsr(void)
{
    SealState.InterruptCnt.ll += 1 ;
}
