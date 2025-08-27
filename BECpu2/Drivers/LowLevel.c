/*
 * LowLevel.c
 *
 *  Created on: 29 Aug 2025
 *      Author: Yahali
 */

#include "..\Application\StructDef2.h"


uint32_t GetNmiFlag()
{
    return HWREGH(NMI_BASE + NMI_O_FLG);
}

void ClearMem(short unsigned *ptr_in , short unsigned n)
{
    short unsigned cnt ;
    short unsigned *ptr = ptr_in ;
    for ( cnt = 0 ; cnt < n ; cnt++)
    {
        *ptr++ = 0 ;
    }
}

void setupGpioCAN(void)
{

}


