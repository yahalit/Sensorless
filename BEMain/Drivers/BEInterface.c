/*
 * BEInterface.c
 *
 *  Created on: 30 במאי 2025
 *      Author: Yahali
 */
#include "..\Application\Structdef.h"

enum E_DACRouting
{
    DAC_Nothing = 0 ,
    DAC2PHU = 6 ,
    DAC2PHV = 4 ,
    DAC2PHW = 5 ,
    DAC2DC  = 7
};


// DAC1: EN = GPIO8 , A0 = GPIO9 , A1 = GPIO57
// DAC2: EN = GPIO6 , A0: 84 , A1: 7
short RouteDac(enum E_DACRouting dac1 , enum E_DACRouting dac2 )
{
    short unsigned dac1_val , dac2_val ;
    short unsigned ndac1_val , ndac2_val ;
    short retval = 0 ;
    unsigned long gpaset = 0 ;
    unsigned long gpaclear  = 0 ; ;
    unsigned long gpbset = 0 ;
    unsigned long gpbclear = 0 ;
    unsigned long gpcset = 0 ;
    unsigned long gpcclear = 0  ;

    dac1_val = (short unsigned) dac1 ;
    dac2_val = (short unsigned) dac2 ;
    ndac1_val = ~dac1_val ;
    ndac2_val = ~dac2_val ;

    if ( dac1_val * dac2_val && (dac1_val - dac2_val ) )
    {
        retval = -1 ;
        dac1_val = 0 ;
        dac2_val = 0 ;
    }
    else
    {
        gpaset =   ((   dac1_val & 4 )<<6)  +  ((   dac1_val & 1 )<<9)  + ((   dac2_val & 4 )<<4)  + ((   dac2_val & 2 )<<6)   ;
        gpaclear = ((  ndac1_val & 4 )<<6)  +  ((  ndac1_val & 1 )<<9)  + (( ndac2_val & 4 )<<4)  + ((ndac2_val & 2 )<<6)   ;
        gpbset =   ( (unsigned long)(  dac1_val & 2 )<<23)     ;
        gpbclear = ( (unsigned long)( ndac1_val & 2 )<<23)     ;
        gpcset =   ( (unsigned long)(  dac2_val & 1 )<<20)     ;
        gpcclear = ( (unsigned long)( ndac2_val & 1 )<<20)     ;
    }
    GpioDataRegs.GPACLEAR.all = gpaclear ;
    GpioDataRegs.GPASET.all   = gpaset   ;
    GpioDataRegs.GPBCLEAR.all = gpbclear ;
    GpioDataRegs.GPBSET.all   = gpbset   ;
    GpioDataRegs.GPCCLEAR.all = gpcclear ;
    GpioDataRegs.GPCSET.all   = gpcset   ;

    return retval ;
}

struct CTrackDacState
{
    short unsigned DacU  ;
    short unsigned DacV  ;
    short unsigned DacW  ;
    short unsigned DacDC ;
    short unsigned cycle ;
};
struct CTrackDacState TrackDacState ;

/*
 * This routine runs at 25usec cycle = 4 * 6.25 usec
 * At cycle 0 DAC is set
 */
void TrackVoltages()
{
   // if ( cyc)
}



void SetGateDriveEnable(short unsigned set  )
{
    if ( set == 1 )
    {
        GpioDataRegs.GPDSET.all= (1UL<<3)  ;//GPIO99
    }
    else
    {
        GpioDataRegs.GPDCLEAR.all = (1UL<<3)  ;
    }
}


short unsigned GetInfineonFault(void  )
{
    short unsigned RetVal  ;
    union UMultiType GPB ;
    union UMultiType GPC ;

    GPB.ul = GpioDataRegs.GPBDAT.all ;
    GPC.ul = GpioDataRegs.GPCDAT.all ;
    RetVal =  (( GPC.us[0] >> 12) & ( 1<<3) ) // Fault GPIO79 (c.15)
            + (( GPC.us[1] >> 9) & (1<<4))   // GPIO93 (C.29)
            +  (( GPC.us[1] << 3 ) & (1<<5)) // GPIO82 (C.18)
            + (( GPB.us[0] << 3 ) & (1<<6))   // GPIO35 (B.3)
            + (( GPB.us[0] << 5 ) & (1<<7))     // GPIO34 (B.2)
            + (( GPC.us[0] >> 1 ) & (1<<8))  // GPIO75 (C.9)
            + (( GPB.us[0] << 9 ) & (1<<9))   // GPIO32 (B.0)
            + (( GPB.us[0] << 5 ) & (1<<10)) // GPIO37 (B.5)
            + (( GPB.us[0] << 7 ) & (1<<11)); // GPIO36 (B.4)

    return RetVal;
}
