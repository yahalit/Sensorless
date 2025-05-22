/*
 * SpeedProfiler.c
 *
 *  Created on: May 12, 2023
 *      Author: yahal
 *
 *  Created on: May 12, 2023
 *      Author: Gal Lior
 */


#include "..\Application\StructDef.h"

#include <math.h>


short SpeedProfiler( )
{
    float d1 = SysState.SpeedControl.SpeedTarget -  SysState.SpeedControl.SpeedReference ;
    float d2 = fSat ( d1 , SysState.SpeedControl.ProfileAcceleration * SysState.Timing.Ts )  ;
    SysState.SpeedControl.SpeedReference  += d2 ;
    return ( d1==d2) ? 1 : 0 ;
}

