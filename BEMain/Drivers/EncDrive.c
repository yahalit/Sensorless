/*
 * EncDrive.c
 *
 *  Created on: May 12, 2023
 *      Author: Gal Lior
 */
#include "..\Application\StructDef.h"


void ProcessEncoderData(struct CEncoder *pEnc, long pos );




#define QEPSTS_CDEF_MASK 4



void setupQEP()
{
  //
  // Configure the decoder for quadrature count mode
  //
  EQEP_setDecoderConfig(EQEP1_BASE, (EQEP_CONFIG_2X_RESOLUTION |
                                     EQEP_CONFIG_QUADRATURE |
                                     EQEP_CONFIG_NO_SWAP));

  EQEP_setEmulationMode(EQEP1_BASE, EQEP_EMULATIONMODE_RUNFREE);

  //
  // Configure the position counter to be latched on a unit time out
  //

  EQEP_setLatchMode(EQEP1_BASE, EQEP_LATCH_UNIT_TIME_OUT);

  // Enable the unit timer, setting the frequency to the control interrupt
  //
  EQEP_enableUnitTimer(EQEP1_BASE, (unsigned short) (CPU_CLK_MHZ * CUR_SAMPLE_TIME_USEC) );

  // Disables the eQEP module position-compare unit
  EQEP_disableCompare(EQEP1_BASE);

  //
  // Configure and enable the edge-capture unit. The capture clock divider is
  // SYSCLKOUT/64. The unit-position event divider is QCLK/32.
  //
  EQEP_setCaptureConfig(EQEP1_BASE, EQEP_CAPTURE_CLK_DIV_32, EQEP_UNIT_POS_EVNT_DIV_1);

  EQEP_enableCapture(EQEP1_BASE);

  EALLOW ;
  HWREG(EQEP1_BASE + EQEP_O_QPOSMAX) = 0xffffffff ;
  HWREG(EQEP1_BASE + EQEP_O_QUPRD) = CPU_CLK_MHZ * ( CUR_SAMPLE_TIME_USEC - 1 ) ;
  //
  // Enable the eQEP module
  //

  EQEP_enableModule(EQEP1_BASE);

  return;
}

#define ClafSat fSat
#define __mmaxf32 __fmax
#define __mminf32 __fmin

//#pragma FUNCTION_OPTIONS ( ReadEncPosition1, "--opt_level=0" );
#ifdef ON_BOARD_ENCODER
void ReadEncPosition1( void)
{
    long pos ;
    float  dpos ;
    long CountTime   ;
    float sg ;
    short unsigned ctr ;

    ctr = HWREGH(EPWM1_BASE + EPWM_O_TBCTR) ;
    HWREG(ENCODER_BASE + EQEP_O_QUTMR) = (long unsigned) ctr ;
    ClaState.Encoder1.Stat = HWREGH(ENCODER_BASE + EQEP_O_QEPSTS) ;
    pos  = HWREG(ENCODER_BASE + EQEP_O_QPOSLAT) ;
    ClaState.Encoder1.now =  HWREG (ECAP2_BASE + ECAP_O_TSCTR )  ; // runs at CPU rate (CPU_CLK_MHZ)
    ClaState.Encoder1.TimeLat   = (long unsigned)HWREGH(ENCODER_BASE + EQEP_O_QCTMRLAT); // Catch of pulse time
    if ( ClaState.Encoder1.Stat & QEPSTS_CDEF_MASK)
    { //If there was a change direction event, ok we note, and reset it
        HWREGH(ENCODER_BASE + EQEP_O_QEPSTS) |= QEPSTS_CDEF_MASK ;
    }


    if ( ClaState.Encoder1.InvertEncoder )
    {
        pos = -pos ;
    }

    if ( ClaState.Encoder1.Pos == pos )
    { // Nothing changed
        if (ClaState.Encoder1.Stat & QEPSTS_CDEF_MASK )
        {
            ClaState.Encoder1.MotSpeedHz = 0 ;
        }

        ClaState.Encoder1.DeltaT = __mmaxf32( (float) (ClaState.Encoder1.now - ClaState.Encoder1.SpeedTime) * INV_CPU_CLK_HZ , CUR_SAMPLE_TIME_USEC*1e-6f);

        if ( ClaState.Encoder1.DeltaT >  MAX_TIME_FOR_ZERO_SPEED)
        {
            ClaState.Encoder1.MotSpeedHz = 0 ;
        }

        if (ClaState.Encoder1.MotSpeedHz )
        {
            ClaState.Encoder1.MotSpeedHz = (ClaState.Encoder1.MotSpeedHz>=0?1:-1) * \
                    __mminf32( fabsf(ClaState.Encoder1.MotSpeedHz), ClaState.Encoder1.Bit2Rev  /  ClaState.Encoder1.DeltaT ) ;
        }
        else
        {
            ClaState.Encoder1.SpeedTime = ClaState.Encoder1.now ;
        }
    }
    else
    {
        dpos = pos - ClaState.Encoder1.Pos ;
        if ( dpos >= 0 )
        {
            sg = 1 ;
        }
        else
        {
            sg   = -1 ;
            dpos = -dpos ;
        }

        if (ClaState.Encoder1.Stat & QEPSTS_CDEF_MASK )
        { // Speed direction change occurred
            ClaState.Encoder1.MotSpeedHz = 0 ;
        }

        CountTime =  ClaState.Encoder1.now - ( ClaState.Encoder1.TimeLat << 5 )  ; // Time of capture

        if ( sg * ClaState.Encoder1.MotSpeedHz <= 0 )
        {
            ClaState.Encoder1.DeltaT = CUR_SAMPLE_TIME_USEC * 1e-6f ;
            if ( dpos == 1 )
            {
                ClaState.Encoder1.MotSpeedHz = ClaState.Encoder1.MinMotSpeedHz * sg ;
            }
            else
            {
                ClaState.Encoder1.MotSpeedHz = ClaState.Encoder1.Bit2Rev * (dpos-1) * sg / ClaState.Encoder1.DeltaT ;
            }
        }
        else
        {
            ClaState.Encoder1.DeltaT = __mmaxf32( (float) (CountTime - ClaState.Encoder1.SpeedTime) * INV_CPU_CLK_HZ , 0.2f * CUR_SAMPLE_TIME_USEC*1e-6f);
            ClaState.Encoder1.MotSpeedHz = dpos * ClaState.Encoder1.Bit2Rev * sg  / ClaState.Encoder1.DeltaT ;
        }
        ClaState.Encoder1.SpeedTime = CountTime ;
    }
    ProcessEncoderData(&ClaState.Encoder1, pos );
}
#endif
/*
 * Process the data of the encoder.
 * Arguments:
 * pEnc -> Encoder structure
 * pos  :  Latest position reading to update
 */
void ProcessEncoderData(struct CEncoder *pEnc, long pos )
{
    long dpos ;
    float bit2User ;
    long lNext , dlNext;

    // The motor position should count accurately the internal position within a revolution without accumulating floating point errors
    dpos = pos - pEnc->Pos ; // Correctly rolling 32 bit difference

    lNext  = pEnc->MotorPosCnt + dpos  ;

    dlNext = lNext - pEnc->Rev2Bit ; // This writing is since same algorithm runs in CLA, as CLA work around for flaw in integer comparison
    if ( dlNext >= 0  )
    {
        lNext = dlNext  ;
    }
    if ( lNext < 0  )
    {
        lNext += pEnc->Rev2Bit ;
    }
    pEnc->MotorPosCnt =  lNext ;

    // MotorPos is per-unit version of the in-revolution counter
    pEnc->MotorPos = pEnc->MotorPosCnt * pEnc->Bit2Rev  ;

    bit2User = pEnc->Bit2Rev * pEnc->Rev2Pos ;

    pEnc->UserPosDelta = dpos  * bit2User  ;

    pEnc->UserPos = (pos -  pEnc->EncoderOnHome ) * bit2User + pEnc->UserPosOnHome  ;

    pEnc->UserSpeed = pEnc->MotSpeedHz * pEnc->Rev2Pos ;

    pEnc->MotSpeedHzFilt  = pEnc->MotSpeedHzFilt + ClaControlPars.SpeedFilterCst * ( pEnc->MotSpeedHz - pEnc->MotSpeedHzFilt) ;

    pEnc->Pos = pos ;
}





