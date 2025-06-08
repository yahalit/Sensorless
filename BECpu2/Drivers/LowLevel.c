/*
 * LowLevel.c
 *
 *  Created on: 29 במאי 2025
 *      Author: Yahali
 */

#include "..\Application\StructDef2.h"


uint32_t GetNmiFlag()
{
    return HWREGH(NMI_BASE + NMI_O_FLG);
}
