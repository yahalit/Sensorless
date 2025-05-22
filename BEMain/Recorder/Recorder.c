/*
 * Recorder.c
 *
 *  Created on: Jun 28, 2023
 *      Author: yahal
 */
/*
 * Recorder.c
 *
 *  Created on: May 13, 2023
 *      Author: yahal
 */


#define REC_VARS_OWNER


#include "..\Application\StructDef.h"
void RtUltraFastRecorder(void);

#ifndef INTER_RECORDER_SET_ERR
#define INTER_RECORDER_SET_ERR 0x76 // [Interpreter:Error] {Recorder setting error}
#define INTER_RECORDER_NO_SIGLIST 0x77 // [Interpreter:Error] {Recorder list of sigmnals is empty}
#define INTER_RECORDER_SIGNAL_NOTPROG 0x78 // [Interpreter:Error] {A signal in the recorder list is empty}
#define INTER_RECORDER_SET_UNKNOWN_TRIGTYPE 0x79 // [Interpreter:Error] {Unknown recorder trigger type}
#endif

short RecorderStartFlag ;

void ClearDebugVars(void)
{
    short unsigned cnt ;
    for ( cnt = 0 ; cnt < N_LDEBUG ; cnt++ )
    {
        SysState.Debug.lDebug[cnt] = 0 ;
    }
    for ( cnt = 0 ; cnt < N_FDEBUG ; cnt++ )
    {
        SysState.Debug.fDebug[cnt] = 0 ;
    }
}

/**
 * \brief
 */
float *  GetFSignalPtr( short si )
{
    struct CCmdMode mode ;

    if ( si < 1 ||si >= NREC_SIG  ||
            (long unsigned)RecorderSigRaw[si].ptr == 0 ||
            (long unsigned)RecorderSigRaw[si].ptr == 0xffffffff)
    {
        return (float *) 0  ;
    }

    mode = *( (struct CCmdMode *) & RecorderSigRaw[si].flags ) ;
    if( mode.IsFloat == 0  )
    {
        return (float *) 0  ;
    }
    return (float *) RecorderSigRaw[si].ptr  ;
}



#ifdef PROJ_OPTIMIZE
#pragma FUNCTION_OPTIONS ( EmptyRecorderTrigger, "--opt_level=3" );
#endif

/**
 * brief: An empty trigger function; just when no trigger is required
 */
short EmptyRecorderTrigger(void)
{
    return 0 ; // No trigger
}

#ifdef PROJ_OPTIMIZE
#pragma FUNCTION_OPTIONS ( ImmediateRecorderTrigger, "--opt_level=3" );
#endif


/**
 * brief: A trivial trigger function; always trigger
 */
short ImmediateRecorderTrigger(void)
{
    Recorder.Ready4Trigger = 1;
    return 1 ; // Trigger now
}


#ifdef PROJ_OPTIMIZE
#pragma FUNCTION_OPTIONS ( FlagRecorderTrigger, "--opt_level=3" );
#endif


short FlagRecorderTrigger(void)
{
    if ( RecorderStartFlag)
    {
        Recorder.Ready4Trigger = 1;
        return 1 ; // Trigger now
    }
    else
    {
        return 0 ;
    }
}


#ifdef PROJ_OPTIMIZE
#pragma FUNCTION_OPTIONS ( RecorderUpFloatTrigger, "--opt_level=3" );
#endif



short RecorderUpFloatTrigger(void)
{
    float junk ;
    short cmp ;
    junk = * (( float*) Recorder.TriggerPtr ) ;
    cmp  = ( junk >= Recorder.TriggerFloatVal ) ? 1 : 0 ;
    if ( Recorder.Ready4Trigger == 0 )
    {
        if ( cmp == 0 )
        {
            Recorder.Ready4Trigger = 1;
        }
    }
    else
    {
        if ( cmp )
        {
            return 1 ;
        }
    }
    return 0 ;
}


#ifdef PROJ_OPTIMIZE
#pragma FUNCTION_OPTIONS ( RecorderDnFloatTrigger, "--opt_level=3" );
#endif


short RecorderDnFloatTrigger(void)
{
    float junk ;
    short cmp ;
    junk = * (( float*) Recorder.TriggerPtr ) ;
    cmp  = ( junk <= Recorder.TriggerFloatVal ) ? 1 : 0 ;
    if ( Recorder.Ready4Trigger == 0 )
    {
        if ( cmp == 0 )
        {
            Recorder.Ready4Trigger = 1;
        }
    }
    else
    {
        if ( cmp )
        {
            return 1 ;
        }
    }
    return 0 ;
}


#ifdef PROJ_OPTIMIZE
#pragma FUNCTION_OPTIONS ( RecorderEqFloatTrigger, "--opt_level=3" );
#endif


short RecorderEqFloatTrigger(void)
{
    float junk ;
    short cmp ;
    junk = * (( float*) Recorder.TriggerPtr ) ;
    cmp  = ( junk == Recorder.TriggerFloatVal ) ? 1 : 0 ;
    if ( Recorder.Ready4Trigger == 0 )
    {
        if ( cmp == 0 )
        {
            Recorder.Ready4Trigger = 1;
        }
    }
    else
    {
        if ( cmp )
        {
            return 1 ;
        }
    }
    return 0 ;
}



#ifdef PROJ_OPTIMIZE
#pragma FUNCTION_OPTIONS ( RecorderUpSuTrigger, "--opt_level=3" );
#endif



short RecorderUpSuTrigger(void)
{
    short unsigned junk ;
    short cmp ;
    junk = * (( short unsigned *) Recorder.TriggerPtr ) ;
    cmp  = ( junk >= (short unsigned)Recorder.TriggerLongVal ) ? 1 : 0 ;
    if ( Recorder.Ready4Trigger == 0 )
    {
        if ( cmp == 0 )
        {
            Recorder.Ready4Trigger = 1;
        }
    }
    else
    {
        if ( cmp )
        {
            return 1 ;
        }
    }
    return 0 ;
}



#ifdef PROJ_OPTIMIZE
#pragma FUNCTION_OPTIONS ( RecorderEqSuTrigger, "--opt_level=3" );
#endif



short RecorderEqSuTrigger(void)
{
    short unsigned junk ;
    short cmp ;
    junk = * (( short unsigned *) Recorder.TriggerPtr ) ;
    cmp  = ( junk == (short unsigned)Recorder.TriggerLongVal ) ? 1 : 0 ;
    if ( Recorder.Ready4Trigger == 0 )
    {
        if ( cmp == 0 )
        {
            Recorder.Ready4Trigger = 1;
        }
    }
    else
    {
        if ( cmp )
        {
            return 1 ;
        }
    }
    return 0 ;
}


#ifdef PROJ_OPTIMIZE
#pragma FUNCTION_OPTIONS ( RecorderDnSuTrigger, "--opt_level=3" );
#endif


short RecorderDnSuTrigger(void)
{
    short unsigned junk ;
    short cmp ;
    junk = * (( short unsigned *) Recorder.TriggerPtr ) ;
    cmp  = ( junk <= (short unsigned)Recorder.TriggerLongVal ) ? 1 : 0 ;
    if ( Recorder.Ready4Trigger == 0 )
    {
        if ( cmp == 0 )
        {
            Recorder.Ready4Trigger = 1;
        }
    }
    else
    {
        if ( cmp )
        {
            return 1 ;
        }
    }
    return 0 ;
}


#ifdef PROJ_OPTIMIZE
#pragma FUNCTION_OPTIONS ( RecorderUpSTrigger, "--opt_level=3" );
#endif


/**
 * \brief Recorder trigger on rising edge, short variable
 */
short RecorderUpSTrigger(void)
{
    short junk ;
    short cmp ;
    junk = * (( short  *) Recorder.TriggerPtr ) ;
    cmp  = ( junk >= (short )Recorder.TriggerLongVal ) ? 1 : 0 ;
    if ( Recorder.Ready4Trigger == 0 )
    {
        if ( cmp == 0 )
        {
            Recorder.Ready4Trigger = 1;
        }
    }
    else
    {
        if ( cmp )
        {
            return 1 ;
        }
    }
    return 0 ;
}


#ifdef PROJ_OPTIMIZE
#pragma FUNCTION_OPTIONS ( RecorderDnSTrigger, "--opt_level=3" );
#endif



/**
 * \brief Recorder trigger on falling edge, short variable
 */
short RecorderDnSTrigger(void)
{
    short junk ;
    short cmp ;
    junk = * (( short  *) Recorder.TriggerPtr ) ;
    cmp  = ( junk <= (short )Recorder.TriggerLongVal ) ? 1 : 0 ;
    if ( Recorder.Ready4Trigger == 0 )
    {
        if ( cmp == 0 )
        {
            Recorder.Ready4Trigger = 1;
        }
    }
    else
    {
        if ( cmp )
        {
            return 1 ;
        }
    }
    return 0 ;
}



#ifdef PROJ_OPTIMIZE
#pragma FUNCTION_OPTIONS ( RecorderEqSTrigger, "--opt_level=3" );
#endif


short RecorderEqSTrigger(void)
{
    short junk ;
    short cmp ;
    junk = * (( short  *) Recorder.TriggerPtr ) ;
    cmp  = ( junk == (short )Recorder.TriggerLongVal ) ? 1 : 0 ;
    if ( Recorder.Ready4Trigger == 0 )
    {
        if ( cmp == 0 )
        {
            Recorder.Ready4Trigger = 1;
        }
    }
    else
    {
        if ( cmp )
        {
            return 1 ;
        }
    }
    return 0 ;
}


#ifdef PROJ_OPTIMIZE
#pragma FUNCTION_OPTIONS ( RecorderUpLuTrigger, "--opt_level=3" );
#endif



////////////////////////////////////////////////////////////////////////
/**
 * \brief Recorder trigger on rising edge, long unsigned variable
 */

short RecorderUpLuTrigger(void)
{
    long unsigned junk ;
    short cmp ;
    junk = * (( long unsigned *) Recorder.TriggerPtr ) ;
    cmp  = ( junk >= (long unsigned)Recorder.TriggerLongVal ) ? 1 : 0 ;
    if ( Recorder.Ready4Trigger == 0 )
    {
        if ( cmp == 0 )
        {
            Recorder.Ready4Trigger = 1;
        }
    }
    else
    {
        if ( cmp )
        {
            return 1 ;
        }
    }
    return 0 ;
}



#ifdef PROJ_OPTIMIZE
#pragma FUNCTION_OPTIONS ( RecorderDnLuTrigger, "--opt_level=3" );
#endif



/**
 * \brief Recorder trigger on falling edge, long unsigned variable
 */

short RecorderDnLuTrigger(void)
{
    long unsigned junk ;
    short cmp ;
    junk = * (( long unsigned *) Recorder.TriggerPtr ) ;
    cmp  = ( junk <= (long unsigned)Recorder.TriggerLongVal ) ? 1 : 0 ;
    if ( Recorder.Ready4Trigger == 0 )
    {
        if ( cmp == 0 )
        {
            Recorder.Ready4Trigger = 1;
        }
    }
    else
    {
        if ( cmp )
        {
            return 1 ;
        }
    }
    return 0 ;
}



#ifdef PROJ_OPTIMIZE
#pragma FUNCTION_OPTIONS ( RecorderEqLuTrigger, "--opt_level=3" );
#endif




short RecorderEqLuTrigger(void)
{
    long unsigned junk ;
    short cmp ;
    junk = * (( long unsigned *) Recorder.TriggerPtr ) ;
    cmp  = ( junk == (long unsigned)Recorder.TriggerLongVal ) ? 1 : 0 ;
    if ( Recorder.Ready4Trigger == 0 )
    {
        if ( cmp == 0 )
        {
            Recorder.Ready4Trigger = 1;
        }
    }
    else
    {
        if ( cmp )
        {
            return 1 ;
        }
    }
    return 0 ;
}

#ifdef PROJ_OPTIMIZE
#pragma FUNCTION_OPTIONS ( RecorderUpLTrigger, "--opt_level=3" );
#endif




short RecorderUpLTrigger(void)
{
    long junk ;
    short cmp ;
    junk = * (( long  *) Recorder.TriggerPtr ) ;
    cmp  = ( junk >= (long )Recorder.TriggerLongVal ) ? 1 : 0 ;
    if ( Recorder.Ready4Trigger == 0 )
    {
        if ( cmp == 0 )
        {
            Recorder.Ready4Trigger = 1;
        }
    }
    else
    {
        if ( cmp )
        {
            return 1 ;
        }
    }
    return 0 ;
}


#ifdef PROJ_OPTIMIZE
#pragma FUNCTION_OPTIONS ( RecorderDnLTrigger, "--opt_level=3" );
#endif



short RecorderDnLTrigger(void)
{
    long junk ;
    short cmp ;
    junk = * (( long  *) Recorder.TriggerPtr ) ;
    cmp  = ( junk <= (long )Recorder.TriggerLongVal ) ? 1 : 0 ;
    if ( Recorder.Ready4Trigger == 0 )
    {
        if ( cmp == 0 )
        {
            Recorder.Ready4Trigger = 1;
        }
    }
    else
    {
        if ( cmp )
        {
            return 1 ;
        }
    }
    return 0 ;
}


#ifdef PROJ_OPTIMIZE
#pragma FUNCTION_OPTIONS ( RecorderEqLTrigger, "--opt_level=3" );
#endif


short RecorderEqLTrigger(void)
{
    long junk ;
    short cmp ;
    junk = * (( long  *) Recorder.TriggerPtr ) ;
    cmp  = ( junk == (long )Recorder.TriggerLongVal ) ? 1 : 0 ;
    if ( Recorder.Ready4Trigger == 0 )
    {
        if ( cmp == 0 )
        {
            Recorder.Ready4Trigger = 1;
        }
    }
    else
    {
        if ( cmp )
        {
            return 1 ;
        }
    }
    return 0 ;
}


/**
 * brief: Initialize the recorder database
 */
void InitRecorder(long FastIntsInC, float FastTsUsec , long unsigned SdoBufLenLongs)
{
    short unsigned cnt ;
    MemClr((short unsigned *)&Recorder,sizeof(struct CRecorder)  ) ;

    Recorder.FastIntsInC = FastIntsInC ;
    Recorder.FastTsUsec = FastTsUsec  ;
    Recorder.SdoBufLenLongs = SdoBufLenLongs;
    SdoMaxLenLongGlobal = SdoBufLenLongs ;

    Recorder.BufSize = REC_BUF_LEN ; // - 1 ;
    Recorder.RecorderGap = 1 ;
    Recorder.RecLength = 16 ;
    Recorder.Minus1 = -1 ;
    Recorder.TriggerFunc = EmptyRecorderTrigger;
    Recorder.pBuffer = (unsigned long  *) RecorderBuffer ;
    /*
    nrecsig = NREC_SIG-1 ;

    if ( nrecsig >= NREC_SIG)
    {
        nrecsig = NREC_SIG - 1 ; // Protect possible overflow by over-specified signal table
    }
    */



    for ( cnt = 0 ; cnt < N_RECS_MAX ; cnt++ ) Recorder.RecorderListIndex[cnt] = 0xffff ;

    /*
    for ( cnt = 0 ; cnt < nrecsig ; cnt++ )
    {
        RecorderSig[cnt] = RecorderSigRaw[cnt] ;
    }

    for ( cnt = nrecsig ; cnt < SIG_TABLE_SIZE ; cnt++ )
    {
        RecorderSig[cnt] = RecorderSig[cnt-1] ;
    }
    */

    Recorder.Stopped =  3; // Never initialized


    RecorderProg = Recorder ;
}



/**
 * \brief Object 0x1FFF: Set the recorder signal table
 *

long unsigned  SetRecorderTableEntry(   struct CSdo * pSdo ,short unsigned nData)
{
#ifdef _LPSIM
    (void) pSdo;
    (void)nData;
    return Sub_index_does_not_exist;
#else
    short unsigned si ;
    long unsigned ul ;
    si = pSdo->SubIndex ;
    if ( si < 1 || si >= NREC_SIG)
    {
        return Sub_index_does_not_exist ;
    }
    if ( nData != 4 )
    {
        return length_of_service_parameter_does_not_match ;
    }

    ul = (long) GetUnalignedLong ((short unsigned *) pSdo->SlaveBuf);
    RecorderSig[si].ptr =  (long unsigned *) ( ul & 0xffffff ) ;
    RecorderSig[si].flags = (short unsigned) ( ( ul >> 24 ) & 0xff ) ;
#endif
    return 0 ;
}
 */



/**
 * \brief Object 0x2002: Set a signal marked by subindex
 *                       User responsibility by object 0x2001 to get the flags and put the result correctly
 */
long unsigned  SetSignal(   struct CSdo * pSdo ,short unsigned nData)
{
    short unsigned si ;
    struct CCmdMode mode ;
    short unsigned us ;
    long  unsigned ul ;

    si = pSdo->SubIndex ;
    if ( si >= 1 && si < NREC_SIG )
    {
        mode = *( (struct CCmdMode *) &RecorderSigRaw[si].flags ) ;
        if ( mode.IsShort)
        {
#ifdef _LPSIM
            if ( RecorderSigRaw[si].ptr == 0 )
            {
                return General_parameter_incompatibility_reason ;
            }
#else
            if ((long unsigned)RecorderSigRaw[si].ptr == 0 || (long unsigned)RecorderSigRaw[si].ptr == 0xffffffff)
            {
                return General_parameter_incompatibility_reason;
            }
#endif
            if ( nData != 2 || mode.WriteProtect)
            {
                return General_parameter_incompatibility_reason ;
            }
            us = *((short unsigned *) pSdo->SlaveBuf);
            * ((short unsigned *) RecorderSigRaw[si].ptr) = us ;
        }
        else
        {
            if ( nData != 4)
            {
                return General_parameter_incompatibility_reason ;
            }
            ul =* ((long unsigned *) pSdo->SlaveBuf);
            * ((long unsigned *) RecorderSigRaw[si].ptr) = ul ;
        }
    }
    else
    {
        return Sub_index_does_not_exist;
    }
    return 0 ;
}

void SetSuperSpeedGap( short unsigned gap );
/*
 * \brief Activate an already programmed recorder
 *  This function enables just the trigger of recorder action from within
 */
long  unsigned   ActivateProgrammedRecorder(void)
{
    struct CCmdMode cmd ;
    short unsigned cnt , maxlen ;
    uRecLen uss1 , uss2;
    short unsigned sr ;

    // Halt any contamination of recorder buffer by DMA
    StopDmaRecorder() ;


    if ( RecorderProg.RecorderListLen == 0 )
    {
        return Manufacturer_error_detail + INTER_RECORDER_SET_ERR  ;
    }

    for ( cnt = 0 ; cnt < RecorderProg.RecorderListLen ; cnt++ )
    {
        if ( RecorderProg.RecorderList[cnt] == 0 )
        {
            return Manufacturer_error_detail + INTER_RECORDER_SET_ERR  ;
        }
    }

    switch( RecorderProg.TriggerType )
    {
    case 0:
        RecorderProg.TriggerFunc = ImmediateRecorderTrigger ;
        break;
    case 1: // Up trigger
        cmd = * (( struct CCmdMode *) &  RecorderProg.TriggerFlags) ;

        if (  cmd.IsFloat )
        {
            RecorderProg.TriggerFunc = RecorderUpFloatTrigger ;
        }
        else
        {
            if ( cmd.IsUnsigned )
            {
                if ( cmd.IsShort )
                {
                    RecorderProg.TriggerFunc = RecorderUpSuTrigger ;
                }
                else
                {
                    RecorderProg.TriggerFunc = RecorderUpLuTrigger ;
                }
            }
            else
            {
                if ( cmd.IsShort )
                {
                    RecorderProg.TriggerFunc = RecorderUpSTrigger ;
                }
                else
                {
                    RecorderProg.TriggerFunc = RecorderUpLTrigger ;
                }
            }
        }
        break ;
    case 2: // Dn trigger
        cmd = * (( struct CCmdMode *) &  RecorderProg.TriggerFlags) ;
        if (  cmd.IsFloat )
        {
            RecorderProg.TriggerFunc = RecorderDnFloatTrigger ;
        }
        else
        {
            if ( cmd.IsUnsigned )
            {
                if ( cmd.IsShort )
                {
                    RecorderProg.TriggerFunc = RecorderDnSuTrigger ;
                }
                else
                {
                    RecorderProg.TriggerFunc = RecorderDnLuTrigger ;
                }
            }
            else
            {
                if ( cmd.IsShort )
                {
                    RecorderProg.TriggerFunc = RecorderDnSTrigger ;
                }
                else
                {
                    RecorderProg.TriggerFunc = RecorderDnLTrigger ;
                }
            }
        }
        break;
    case 3: // Equal trigger
        cmd = * (( struct CCmdMode *) &  RecorderProg.TriggerFlags) ;
        if (  cmd.IsFloat )
        {
            RecorderProg.TriggerFunc = RecorderEqFloatTrigger ;
        }
        else
        {
            if ( cmd.IsUnsigned )
            {
                if ( cmd.IsShort )
                {
                    RecorderProg.TriggerFunc = RecorderEqSuTrigger ;
                }
                else
                {
                    RecorderProg.TriggerFunc = RecorderEqLuTrigger ;
                }
            }
            else
            {
                if ( cmd.IsShort )
                {
                    RecorderProg.TriggerFunc = RecorderEqSTrigger ;
                }
                else
                {
                    RecorderProg.TriggerFunc = RecorderEqLTrigger ;
                }
            }
        }
        break ;
    case 4:
        RecorderStartFlag = 0 ;
        RecorderProg.TriggerFunc = FlagRecorderTrigger ;
        break ;
    default:
        return Manufacturer_error_detail + INTER_RECORDER_SET_ERR  ;
    }

    maxlen = REC_BUF_LEN / RecorderProg.RecorderListLen - 1 ;
    uss1 = RecorderProg.RecLength ;
    if ( uss1 > maxlen )
    {
        uss1 = maxlen ;
    }
    uss2 =  RecorderProg.PreTrigCnt;
    if ( uss2 >= (uss1-1))
    {
        uss2 = uss1-2 ;
    }
    if ( RecorderProg.uf.UltraFastActive)
    {
        if ( RecorderProg.RecorderGap > 15)
        {
            RecorderProg.RecorderGap = 15 ;
        }
        SetSuperSpeedGap(RecorderProg.RecorderGap) ;
        StartDmaRecorder() ;
    }
    sr = BlockInts() ;
    Recorder = RecorderProg ;
    Recorder.RecLength = uss1 ;
    Recorder.PreTrigCnt = uss2 ;
    Recorder.TotalRecLength =  Recorder.RecLength * Recorder.RecorderListLen;
    Recorder.PreTrigTotalCnt = Recorder.PreTrigCnt* Recorder.RecorderListLen;
    Recorder.Active  = 1 ;
    Recorder.Ready4Trigger = 0 ;
    Recorder.Stopped = 0 ; // Activate recorder function
    Recorder.EndRec = 0x7fffffff;
    Recorder.TriggerActive = 0 ;
    Recorder.BufferReady = 0 ;
    RestoreInts(sr) ;
    return 0 ;
}

/**
 * \brief Object 0x2000: Set the recorder
 *
 */
long unsigned  SetRecorder( struct CSdo * pSdo ,short unsigned nData)
{
    short unsigned us , si , ind  ;
    long unsigned RetVal ;
    long unsigned ul ;
    long unsigned * ulPtr  ;

    if ( nData == 2 )
    {
        us =* ((short unsigned *) pSdo->SlaveBuf);
        ul = (long unsigned) us ;
    }
    else
    {
        ul = * ((long unsigned *) pSdo->SlaveBuf);
        us = (short unsigned) ul ;
    }

    si = pSdo->SubIndex ;
#ifdef _LPSIM
    if ( ( si >= 52 && si <=54) || si == 2 || si == 5 )
#else
    if ( si >= 52 && si <=54)
#endif
    {
        if ( nData != 4 )
        {
            return length_of_service_parameter_does_not_match ;
        }
    }
    else
    {
        if  ( ( nData != 2 ) &&  (ul & 0xffff0000 ) )
        {
            return length_of_service_parameter_does_not_match ;
        }
    }

    if ( pSdo->SubIndex >= 10 && pSdo->SubIndex < (10+N_RECS_MAX ) )
    {
        if ( us < NREC_SIG )
        {
            ind = si - 10 ;
            ulPtr = RecorderSigRaw[us].ptr ;
            RecorderProg.RecorderList[ind] = ulPtr ;

            RecorderProg.RecorderListIndex[ind] = us ;
            RecorderProg.RecorderFlags[ind] = RecorderSigRaw[us].flags;
            if ( RecorderProg.RecorderFlags[ind] & 512  )
            {
                RecorderProg.uf.UltraFastActive = 0;
            }
        }
        else
        {
            return General_parameter_incompatibility_reason ;
        }
        return 0;
    }

    switch ( si)
    {
    case 1:
        if ( ul > 32767 )
        {
            return General_parameter_incompatibility_reason ;
        }
        RecorderProg.RecorderGap = us ;
        break ;
    case 2:
        if ( ul >= REC_BUF_LEN )
        {
            return General_parameter_incompatibility_reason ;
        }
#ifndef _LPSIM
        RecorderProg.RecLength = us ;
#else
        RecorderProg.RecLength = ul ;
#endif
        break ;
    case 3:
        if ( us >= N_RECS_MAX )
        {
            return General_parameter_incompatibility_reason ;
        }
        RecorderProg.RecorderListLen = us ;
        break ;
    case 4:
        RecorderProg.TriggerType = us ;
        break ;
    case 5:
        if ( ul >= REC_BUF_LEN )
        {
            return General_parameter_incompatibility_reason ;
        }
#ifndef _LPSIM
        RecorderProg.PreTrigCnt = us ;
#else
        RecorderProg.PreTrigCnt = ul ;
#endif
        break;
    case 6: //0 for every interrupt, 1 sync to proc, 3 superspeed
        if ( us == 3 )
        {
            RecorderProg.uf.UltraFastActive = 1 ;
        }
        else
        {
            if ( us > 1 )
            {
                return General_parameter_incompatibility_reason ;
            }
            RecorderProg.uf.UltraFastActive = 0 ;
            RecorderProg.TimeBasis = us ;
        }
        break;

    case 7: // Index of signal to bring
        if ( us >= N_RECS_MAX )
        {
            return General_parameter_incompatibility_reason ;
        }
        RecorderProg.Sig2Bring = us ;
        break;

    case 8: // Index of first record to bring
        if ( ul >= REC_BUF_LEN  )
        {
            return General_parameter_incompatibility_reason ;
        }
        RecorderProg.BringStartIndex = ul ;
        break ;

    case 9: // Index of last record to bring
        if ( ul >= REC_BUF_LEN )
        {
            return General_parameter_incompatibility_reason ;
        }
        RecorderProg.BringEndIndex = ul ;
        break ;

    case 50:
        if ( us < NREC_SIG )
        {
            RecorderProg.TriggerFlags = RecorderSigRaw[us].flags;
            RecorderProg.TriggerPtr = RecorderSigRaw[us].ptr;
        }
        else
        {
            return General_parameter_incompatibility_reason ;
        }
        break ;
/*  case 51:
        if ( us < NREC_SIG )
        {
            RecorderProg.TriggerFlags = RecorderSigRaw[us].flags;
            RecorderProg.TriggerPtr = RecorderSigRaw[us].ptr;
        }
        else
        {
            return General_parameter_incompatibility_reason ;
        }
        break ;*/
    case 52: //long value for threshold
        RecorderProg.TriggerLongVal  = (long) GetUnalignedLong ((short unsigned *) pSdo->SlaveBuf);
        RecorderProg.TriggerFloatVal = (float)RecorderProg.TriggerLongVal  ;
        break ;
    case 53: //long float for threshold
        RecorderProg.TriggerFloatVal= GetUnalignedFloat ((short unsigned *) pSdo->SlaveBuf);
        RecorderProg.TriggerLongVal = (long)RecorderProg.TriggerFloatVal  ;
        break ;
    case 54:
        RecorderProg.uf.MasterCntrAfterTrigger = us ;
        break ;

    case 100:
        RecorderStartFlag = 0 ;
        RetVal = ActivateProgrammedRecorder() ;
        if ( RetVal ) return RetVal ;
        break ;

    case 101:
        RecorderStartFlag = 1  ;
        break ;

    }
    return 0 ;
}

void SetRecorderStartFlag(short value)
{
    RecorderStartFlag = value ;
}


/**
 * \brief Object 0x2002: Get flags for a signal marked by subindex
 *                       works together with object 0x2002
 */
long unsigned  GetSignalFlags(  struct CSdo * pSdo ,short unsigned *nData)
{
    short unsigned si ;
    short unsigned *sPtr ;
    si = pSdo->SubIndex ;
    if ( si >= 1 && si < NREC_SIG )
    {
        sPtr = (short unsigned *) &pSdo->SlaveBuf[0] ;
        sPtr[0] = RecorderSigRaw[si].flags ;
    }
    else
    {
        return Sub_index_does_not_exist;
    }
    *nData = 2 ;
    return 0 ;
}


/**
 * \brief Object 0x2002: Get a signal marked by subindex
 *                       User responsibility by object 0x2001 to get the flags and interpret the result correctly
 */
long unsigned  GetSignal(   struct CSdo * pSdo ,short unsigned *nData)
{
    short unsigned si ;
    short unsigned *sPtr ;
    struct CCmdMode mode ;

    si = pSdo->SubIndex ;
    if ( si >= 1 && si < NREC_SIG )
    {
        if ((long unsigned)RecorderSigRaw[si].ptr == 0 || (long unsigned)RecorderSigRaw[si].ptr == 0xffffffff)
        {
            return General_parameter_incompatibility_reason ;
        }
        mode = *( (struct CCmdMode *) & RecorderSigRaw[si].flags ) ;
        if( mode.IsShort )
        {
            sPtr = (short unsigned *) &pSdo->SlaveBuf[0] ;
            sPtr[0] = * ((short unsigned *)RecorderSigRaw[si].ptr);
            sPtr[1] = 0 ;
            if ( mode.IsUnsigned == 0 && (sPtr[0] & 0x8000) )
            {
                sPtr[1] = 0xffff ;
            }
        }
        else
        {
            * ((long unsigned *) &pSdo->SlaveBuf[0] ) = (* RecorderSigRaw[si].ptr);
        }
    }
    else
    {
        return Sub_index_does_not_exist;
    }
    *nData = 4 ;
    return 0 ;
}


short unsigned GetRecorderStat(void)
{
    return (short unsigned)( Recorder.Stopped
                    + ( Recorder.Ready4Trigger << 1 ) + (Recorder.TriggerActive << 2)  + ( Recorder.Active << 4) ) ;
}


/////////////////////////////////
// Get recorder object 0x2000 Get
/////////////////////////////////
volatile unsigned long  *  FarlPtr ;

long unsigned  GetRecorder( struct CSdo * pSdo ,short unsigned *nData)
{


    short unsigned si , cnt , ind  , flags ;


    long unsigned  reclen, recnext;
    struct CCmdMode mode ;

    extern long unsigned GetSamplingTime( short unsigned ind);
    extern float fGetSamplingTime( short unsigned ind);

    si = pSdo->SubIndex ;

    if ( pSdo->SubIndex >= 10 && pSdo->SubIndex < (10+N_RECS_MAX ) )
    {
        ind   = si - 10 ;
        flags = Recorder.RecorderFlags[ind];
        * ((long unsigned *) &pSdo->SlaveBuf[0] ) =
                Recorder.RecorderListIndex[ind]  +
                    ((long unsigned)flags << 16 )   ;
        *nData = 4 ;
        return 0;
    }

    switch ( si)
    {
    case 1:
        * ((short unsigned *) &pSdo->SlaveBuf[0] ) = Recorder.RecorderGap  ;
        *nData = 2 ;
        break ;
    case 2:
#ifdef _LPSIM
        * ((long unsigned *) &pSdo->SlaveBuf[0] ) = Recorder.RecLength  ;
        *nData = 4 ;
#else
        * ((short unsigned *) &pSdo->SlaveBuf[0] ) = Recorder.RecLength  ;
        *nData = 2 ;
#endif
        break ;
    case 3:
        * ((short unsigned *) &pSdo->SlaveBuf[0] ) = Recorder.RecorderListLen  ;
        *nData = 2 ;
        break ;
    case 4:
        * ((short unsigned *) &pSdo->SlaveBuf[0] ) = Recorder.TriggerType  ;
        *nData = 2 ;
        break ;
    case 5:
#ifdef _LPSIM
        * ((long unsigned *) &pSdo->SlaveBuf[0] ) = Recorder.PreTrigCnt  ;
        *nData = 4 ;
#else
        * ((short unsigned *) &pSdo->SlaveBuf[0] ) = Recorder.PreTrigCnt  ;
        *nData = 2 ;
#endif
        break;
    case 6:
        * ((short unsigned *) &pSdo->SlaveBuf[0] ) = Recorder.TimeBasis  ;
        *nData = 2 ;
        break;
    case 7:
        * ((short unsigned *) &pSdo->SlaveBuf[0] ) = RecorderProg.Sig2Bring  ;
        *nData = 2 ;
        break;
    case 8:
        * ((long unsigned *) &pSdo->SlaveBuf[0] ) = RecorderProg.BringStartIndex  ;
        *nData = 4 ;
        break;
    case 9:
        * ((long unsigned *) &pSdo->SlaveBuf[0] ) = RecorderProg.BringEndIndex  ;
        *nData = 4 ;
        break;

    case 60:
        * ((long unsigned *) pSdo->SlaveBuf ) = REC_BUF_LEN  ;
        *nData = 4 ;
        break ;
    case 61:
        * ((short unsigned *) pSdo->SlaveBuf ) = N_RECS_MAX  ;
        *nData = 2 ;
        break ;
    case 62:
        * ((long unsigned *) pSdo->SlaveBuf ) =  GetSamplingTime(0)  ;
        *nData = 2 ;
        break ;
    case 63:
        * ((long unsigned *) pSdo->SlaveBuf ) = (long unsigned) GetSamplingTime(1)  ;
        *nData = 4 ;
        break ;

    case 64:
        * ((float *) pSdo->SlaveBuf ) =  fGetSamplingTime(0)  ;
        *nData = 4 ;
        break ;
    case 65:
        * ((float *) pSdo->SlaveBuf ) = fGetSamplingTime(1)  ;
        *nData = 4 ;
        break ;
    case 66:
        * ((float *) pSdo->SlaveBuf ) = fGetSamplingTime(3)  ;
        *nData = 4 ;
        break ;

    case 90: // Actual recorder sample time in usec
        * ((long unsigned *) &pSdo->SlaveBuf[0] ) =
                (long) ((( Recorder.TimeBasis ) ? Recorder.FastIntsInC : 1 ) * Recorder.FastTsUsec * Recorder.RecorderGap ) ;
        *nData = 4 ;
        break;
    case 91: // Actual recorder sample time in usec
        * ((float *) &pSdo->SlaveBuf[0] ) =
                1.0e-6f * ((( Recorder.TimeBasis ) ? Recorder.FastIntsInC : 1 ) * Recorder.FastTsUsec * Recorder.RecorderGap ) ;
        *nData = 4 ;
        break;
    case 99:
        * ((short unsigned *) &pSdo->SlaveBuf[0] ) = GetRecorderStat()  ;
        *nData = 2 ;
        break;
    case 100:
        if ( Recorder.Stopped != 1 ||
                (RecorderProg.Sig2Bring >= Recorder.RecorderListLen ))

        {
            return Manufacturer_error_detail + INTER_RECORDER_SET_ERR  ;
        }

        if ( (RecorderProg.BringStartIndex > RecorderProg.BringEndIndex ) ||
                ( RecorderProg.BringStartIndex >= Recorder.RecLength ) ||
                ( RecorderProg.BringEndIndex >= Recorder.RecLength ) )
        {
            return ( Manufacturer_error_detail + INTER_RECORDER_SET_ERR )  ;
        }

        reclen = RecorderProg.BringEndIndex - RecorderProg.BringStartIndex + 1 ;

        if ( reclen > (long unsigned) __lmin ( (long) Recorder.SdoBufLenLongs, (long) SdoMaxLenLongGlobal  ) )
        {
            return Out_of_memory ;
        }

        recnext = ( Recorder.StartRec+RecorderProg.Sig2Bring +
                    RecorderProg.BringStartIndex*Recorder.RecorderListLen);
        while ( recnext >=Recorder.TotalRecLength )
        {
            recnext -= Recorder.TotalRecLength;
        }
                            //& (REC_BUF_LEN -1) ;
        FarlPtr = RecorderBuffer + recnext  ;

        mode = * ( (struct CCmdMode*) & Recorder.RecorderFlags[RecorderProg.Sig2Bring] ) ;


        for ( cnt = 0 ; cnt < reclen ; cnt++)
        {
            if ( mode.IsShort  )
            {
                if ( mode.IsUnsigned )
                {
                    *FarlPtr = * ((short unsigned *)FarlPtr) ;
                }
                else
                {
                    * (long *)FarlPtr = * ((short*)FarlPtr) ;
                }
            }

            pSdo->SlaveBuf[cnt] = *FarlPtr ;
            recnext = ( recnext + Recorder.RecorderListLen ) ;//& (REC_BUF_LEN -1) ;
            while ( recnext >=Recorder.TotalRecLength )
            {
                recnext -= Recorder.TotalRecLength;
            }
            FarlPtr =  RecorderBuffer +  recnext  ;
            //break;
        }

        *nData = (unsigned short) (reclen * 4 ) ;
        break ;
    default:
        return Sub_index_does_not_exist;
    }
    return 0 ;
}



#pragma FUNCTION_OPTIONS ( RtRecorder, "--opt_level=3" );


void RtRecorder(void)
{
    short unsigned cnt ;
    short unsigned ** pList ;
    short unsigned * pNext ;
    union
    {
        short unsigned us[2] ;
        long unsigned ul ;
    }u;

    if ( Recorder.Stopped    )
    {
        return ;
    }

    if ( Recorder.uf.UltraFastActive)
    {
        RtUltraFastRecorder() ;
        return ;
    }

    if ( Recorder.PutCntr >= Recorder.PreTrigTotalCnt )
    {
        Recorder.BufferReady = 1 ;
    }

    if ( Recorder.TriggerActive == 0 )
    {
        if ( Recorder.BufferReady )
        {
            // Look for trigger
            Recorder.TriggerActive = Recorder.TriggerFunc() ;
            if ( Recorder.TriggerActive )
            { // Trigger is met
                if ( Recorder.PutCntr >= Recorder.PreTrigTotalCnt )
                {
                    Recorder.StartRec = ( Recorder.PutCntr - Recorder.PreTrigTotalCnt ) ;
                }
                else
                {
                    Recorder.StartRec = ( Recorder.PutCntr + Recorder.TotalRecLength- Recorder.PreTrigTotalCnt ) ;
                }

/*
                Recorder.StartRec = ( Recorder.PutCntr - Recorder.PreTrigTotalCnt ) ;
                if ( Recorder.StartRec < 0 )
                {
                    Recorder.StartRec += Recorder.TotalRecLength ;
                }
 */
                Recorder.EndRec = Recorder.StartRec + Recorder.TotalRecLength ;
                if ( Recorder.EndRec >= Recorder.TotalRecLength )
                {
                    Recorder.EndRec -= Recorder.TotalRecLength ;
                }
            }
        }
    } // end if ( Recorder.TriggerActive == 0 )
    Recorder.GapCntr += 1 ;
    if ( Recorder.GapCntr >= Recorder.RecorderGap)
    {
        Recorder.GapCntr = 0 ;
        pList = (short unsigned **) &Recorder.RecorderList[0];
        for ( cnt = 0 ; cnt < Recorder.RecorderListLen ; cnt++ )
        {
            pNext   = *pList++ ;
            u.us[0] = *pNext++ ;
            u.us[1] = *pNext ;
            Recorder.pBuffer[Recorder.PutCntr++] = u.ul ;
        }
        if ( Recorder.PutCntr >= Recorder.TotalRecLength)
        {
            Recorder.PutCntr = 0 ;
        }
        if ( Recorder.PutCntr == Recorder.EndRec )
        {
            Recorder.Stopped = 1 ;
        }
    }
}


#pragma FUNCTION_OPTIONS ( RtUltraFastRecorder, "--opt_level=3" );
void RtUltraFastRecorder(void)
{
    // We don't have direct access to counters so this is a matter of time
    if ( Recorder.PutCntr >= Recorder.PreTrigCnt )
    {
        Recorder.BufferReady = 1 ;
    }
    else
    {
        Recorder.PutCntr += 1 ;
    }

    if ( Recorder.BufferReady )
    {
        if ( Recorder.TriggerActive == 0 )
        {
            // Look for trigger
            Recorder.TriggerActive = Recorder.TriggerFunc() ;
            if ( Recorder.TriggerActive )
            { // Trigger is met
                Recorder.uf.MasterCntrAtTrigger = 0 ;
            }
        }
        else
        {
            Recorder.uf.MasterCntrAtTrigger += 1 ;
            if ( Recorder.uf.MasterCntrAtTrigger >= Recorder.uf.MasterCntrAfterTrigger)
            { // Stop the DMA
                StopDmaRecorder ()   ;
                Recorder.Stopped = 1 ;

                // Get the transfer counter
                Recorder.uf.LastValidTransfer = GetDMALastValid( ) ;
                Recorder.EndRec = Recorder.uf.LastValidTransfer * 8 ;
                Recorder.TotalRecLength = DMA_USE_LEN - 3 * CLA_DMA_TRANSFER_SIZE_LONGS;
                Recorder.StartRec = (Recorder.EndRec - Recorder.TotalRecLength) & (DMA_USE_LEN-1) ;
            }
        }
    } // end if ( Recorder.TriggerActive == 0 )
}


// Get a synchronized variable snap
void SnapIt( short unsigned * pSnap )
{
    short unsigned cnt ;
    short unsigned ** pList ;
    short unsigned * pNext ;
    pList = (short unsigned **) &RecorderProg.RecorderList[0];
    for ( cnt = 0 ; cnt < RecorderProg.RecorderListLen ; cnt++ )
    {
        pNext   = *pList++ ;
        *pSnap++ = *pNext++ ;
        *pSnap++ = *pNext ;
    }
}











