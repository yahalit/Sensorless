/*
 * DmaDrv.c
 *
 *  Created on: 25 бреб„ 2024
 *      Author: Yahali
 */


#include "..\Application\StructDef.h"

#define CLA_DMA_TRANSFER_SIZE_WORDS (CLA_DMA_TRANSFER_SIZE_LONGS*2)

void StartDmaRecorder( )
{
    EALLOW ;
    HWREGH(DMA_CH1_BASE + DMA_O_CONTROL) =  0x94 ; // Soft reset, clear peripheral interrupts and error
    NOP ;
    NOP ;
    NOP ;
    NOP ;
    NOP ;
    NOP ;
    NOP ;
    NOP ;
    HWREGH(DMA_CH1_BASE + DMA_O_CONTROL) =  DMA_CONTROL_RUN  ; // run
}

void StopDmaRecorder( )
{
    EALLOW ;
    HWREGH(DMA_CH1_BASE + DMA_O_CONTROL) =  0x96 ; // Soft reset, clear peripheral interrupts and error, halt, dont run
}


void StopDmaUpdate( )
{
    EALLOW ;
    HWREGH(DMA_CH2_BASE + DMA_O_CONTROL) =  0x96 ; // Soft reset, clear peripheral interrupts and error, halt, dont run
}


short unsigned GetRecorderTotalLength(void )
{
    return (DMA_USE_LEN - CLA_DMA_TRANSFER_SIZE_LONGS) ;
}

short unsigned GetDMALastValid(void)
{
    short unsigned NowWriting =
            ( HWREGH(DMA_CH1_BASE + DMA_O_DST_ADDR_ACTIVE ) - HWREGH(DMA_CH1_BASE + DMA_O_DST_BEG_ADDR_SHADOW) )
                    >> 4   ;

    // Go 1 back because the last record may be half written (DMA may halt in the middle of a burst) ;
    return (NowWriting-2) & ( (DMA_USE_LEN / CLA_DMA_TRANSFER_SIZE_LONGS)-1) ;
}

void SetupClaRecDma()
{
    union
    {
        long unsigned *pl ;
        uint16_t us[2] ;
    }u;
    EALLOW;

    // Entire module reset
    HWREGH(DMA_BASE + DMA_O_CTRL) =  3 ; // Peripheral and priority reset

    // 32 bit , continuous
    HWREGH(DMA_CH1_BASE + DMA_O_MODE) = (1<<14) + (1<<11) + (1<<8) + 1;
    HWREG(DMACLASRCSEL_BASE + SYSCTL_O_DMACHSRCSEL1) = DMA_TRIGGER_EPWM4SOCB + (DMA_TRIGGER_EPWM4SOCB<<8 );


    // Base addresses
    u.pl = (unsigned long * )&ClaRecs;
    HWREGH(DMA_CH1_BASE + DMA_O_SRC_BEG_ADDR_SHADOW)     = u.us[0]    ;
    HWREGH(DMA_CH1_BASE + DMA_O_SRC_ADDR_SHADOW) = HWREGH(DMA_CH1_BASE + DMA_O_SRC_BEG_ADDR_SHADOW) ;

    u.pl = (unsigned long * )&RecorderBuffer;
    HWREGH(DMA_CH1_BASE + DMA_O_DST_BEG_ADDR_SHADOW)     = u.us[0]    ;
    HWREGH(DMA_CH1_BASE + DMA_O_DST_ADDR_SHADOW) = HWREGH(DMA_CH1_BASE + DMA_O_DST_BEG_ADDR_SHADOW) ;
    //
    // Set up BURST registers.
    //
    HWREGH(DMA_CH1_BASE + DMA_O_SRC_WRAP_SIZE) = 0       ;  // Read the same address
    HWREGH(DMA_CH1_BASE + DMA_O_DST_WRAP_SIZE) = ((DMA_USE_LEN * 2)/CLA_DMA_TRANSFER_SIZE_WORDS)-1       ;
    HWREGH(DMA_CH1_BASE + DMA_O_SRC_WRAP_STEP) = 0       ;  // Wrapping returns to the same begin address
    HWREGH(DMA_CH1_BASE + DMA_O_DST_WRAP_STEP) = 0       ;

    HWREGH(DMA_CH1_BASE + DMA_O_BURST_SIZE)     = (CLA_DMA_TRANSFER_SIZE_WORDS-1)      ; // 8 fields
    HWREGH(DMA_CH1_BASE + DMA_O_SRC_BURST_STEP) = 2      ; // Always read the same array
    HWREGH(DMA_CH1_BASE + DMA_O_DST_BURST_STEP) = 2      ; // Write consecutive instances into recorder buffer (2 words = long)

    HWREGH(DMA_CH1_BASE + DMA_O_TRANSFER_SIZE)     = ((DMA_USE_LEN * 2)/CLA_DMA_TRANSFER_SIZE_WORDS)-1    ;
    HWREGH(DMA_CH1_BASE + DMA_O_SRC_TRANSFER_STEP) = 0xfff0    ; // Always read the same array
    HWREGH(DMA_CH1_BASE + DMA_O_DST_TRANSFER_STEP) = 0x2    ; // No special jump after array completion


    // DMA#2 update the ClaRecs at the CPU


    // 32 bit , continuous
    HWREGH(DMA_CH2_BASE + DMA_O_MODE) = (1<<14) + (1<<11) + (1<<8) + 1;


    // Base addresses
    u.pl = (unsigned long * )&ClaRecs;
    HWREGH(DMA_CH2_BASE + DMA_O_SRC_BEG_ADDR_SHADOW)     = u.us[0]    ;
    HWREGH(DMA_CH2_BASE + DMA_O_SRC_ADDR_SHADOW) = HWREGH(DMA_CH2_BASE + DMA_O_SRC_BEG_ADDR_SHADOW) ;

    u.pl = (unsigned long * )&ClaRecsCopy;
    HWREGH(DMA_CH2_BASE + DMA_O_DST_BEG_ADDR_SHADOW)     = u.us[0]    ;
    HWREGH(DMA_CH2_BASE + DMA_O_DST_ADDR_SHADOW) = HWREGH(DMA_CH2_BASE + DMA_O_DST_BEG_ADDR_SHADOW) ;
    //
    // Set up BURST registers.
    //
    HWREGH(DMA_CH2_BASE + DMA_O_SRC_WRAP_SIZE) = 0x0  ;  // Read the same address
    HWREGH(DMA_CH2_BASE + DMA_O_DST_WRAP_SIZE) = 0x0  ;  // We dont need wraps
    HWREGH(DMA_CH2_BASE + DMA_O_SRC_WRAP_STEP) = 0       ;  // Wrapping returns to the same begin address
    HWREGH(DMA_CH2_BASE + DMA_O_DST_WRAP_STEP) = 0       ;

    HWREGH(DMA_CH2_BASE + DMA_O_BURST_SIZE)     = (CLA_DMA_TRANSFER_SIZE_WORDS-1)      ; // 8 fields
    HWREGH(DMA_CH2_BASE + DMA_O_SRC_BURST_STEP) = 2      ; // Always read the same array
    HWREGH(DMA_CH2_BASE + DMA_O_DST_BURST_STEP) = 2      ; // Write consecutive instances into recorder buffer (2 words = long)

    HWREGH(DMA_CH2_BASE + DMA_O_TRANSFER_SIZE)     = 0   ;
    HWREGH(DMA_CH2_BASE + DMA_O_SRC_TRANSFER_STEP) = 0xfff0    ; // Always read the same array
    HWREGH(DMA_CH2_BASE + DMA_O_DST_TRANSFER_STEP) = 0xfff0    ; // No special jump after array completion

    // And it needs no command to act
    HWREGH(DMA_CH2_BASE + DMA_O_CONTROL) =  0x94 ; // Soft reset, clear peripheral interrupts and error
    NOP ;
    NOP ;
    NOP ;
    NOP ;
    NOP ;
    NOP ;
    NOP ;
    NOP ;
    HWREGH(DMA_CH2_BASE + DMA_O_CONTROL) =  DMA_CONTROL_RUN  ; // run

}

