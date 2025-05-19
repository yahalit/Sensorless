#include "Structdef.h"
#include <math.h>

long unsigned  SetConfigPar( struct CSdo * pSdo ,short unsigned nData);
long unsigned  GetConfigPar( struct CSdo * pSdo ,short unsigned *nData);


long unsigned  SetFloatPar( struct CSdo * pSdo ,short unsigned nData);
long unsigned  GetFloatPar( struct CSdo * pSdo ,short unsigned *nData);

long unsigned  SetRecorder( struct CSdo * pSdo ,short unsigned nData);
long unsigned  GetRecorder( struct CSdo * pSdo ,short unsigned *nData);
long unsigned  GetSignalFlags(  struct CSdo * pSdo ,short unsigned *nData);

long unsigned  SetSignal(   struct CSdo * pSdo ,short unsigned nData);
long unsigned  GetSignal(   struct CSdo * pSdo ,short unsigned *nData);


long unsigned  SetMotionPar(   struct CSdo * pSdo ,short unsigned nData);
long unsigned  GetMotionPar(   struct CSdo * pSdo ,short unsigned *nData);

long unsigned  GetAtpData( struct CSdo * pSdo ,short unsigned *nData);

long unsigned  GetShortData( struct CSdo * pSdo ,short unsigned *nData);
long unsigned  SetShortData( struct CSdo * pSdo ,short unsigned nData);

long unsigned  GetFloatData( struct CSdo * pSdo ,short unsigned *nData);
long unsigned  SetFloatData( struct CSdo * pSdo ,short unsigned nData);

long unsigned  SetCalibCmd( struct CSdo * pSdo ,short unsigned nData);
long unsigned  GetCalibCmd( struct CSdo * pSdo ,short unsigned *nData);


long unsigned  SetParamCmd( struct CSdo * pSdo ,short unsigned nData);
long unsigned  GetParamCmd( struct CSdo * pSdo ,short unsigned *nData);

long unsigned  SetMiscTest( struct CSdo * pSdo ,short unsigned nData);
long unsigned  GetMiscTest( struct CSdo * pSdo ,short unsigned *nData);

long unsigned  SetControlWord( struct CSdo * pSdo ,short unsigned nData);
long unsigned  SetOperationMode( struct CSdo * pSdo ,short unsigned nData);
long unsigned  GetOperationMode(   struct CSdo * pSdo ,short unsigned *nData);

long unsigned  SetPdo1RxParam( struct CSdo * pSdo ,short unsigned nData);
long unsigned  SetPdo1TxParam( struct CSdo * pSdo ,short unsigned nData);
long unsigned  SetPdo2TxParam( struct CSdo * pSdo ,short unsigned nData);
long unsigned  SetQuickStopOptionCode( struct CSdo * pSdo ,short unsigned nData);
long unsigned  SetHaltOptionCode( struct CSdo * pSdo ,short unsigned nData);
long unsigned  SetSyncArrivalTime( struct CSdo * pSdo ,short unsigned nData);
long unsigned  SetValueOnHoming( struct CSdo * pSdo ,short unsigned nData);
long unsigned  SetHomingMethod( struct CSdo * pSdo ,short unsigned nData);
long unsigned  SetPositionTarget( struct CSdo * pSdo ,short unsigned nData);

long unsigned  SetDynIdentification( struct CSdo * pSdo ,short unsigned nData);
long unsigned  GetDynIdentification( struct CSdo * pSdo ,short unsigned *nData);

long unsigned  GetRecorderCRC( struct CSdo * pSdo ,short unsigned *nData);


long unsigned  NoSuchGetObject( struct CSdo * pSdo ,short unsigned *nData);
long unsigned  NoSuchSetObject( struct CSdo * pSdo ,short unsigned nData);

long unsigned  GetRatedCurrent( struct CSdo * pSdo ,short unsigned *nData);
long unsigned  GetPeakCurrentPromils( struct CSdo * pSdo ,short unsigned *nData);

long unsigned  SetFwCmd(    struct CSdo * pSdo ,short unsigned nData);
long unsigned  GetFwCmd(    struct CSdo * pSdo ,short unsigned *nData);

long unsigned  SetBHControlWord( struct CSdo * pSdo ,short unsigned nData);


const struct CObjDictionaryItem ObjDictionaryItem [] =
{
{ 0x1400 , 2 , SetPdo1RxParam , NoSuchGetObject },
{ 0x1800 , 2 , SetPdo1TxParam , NoSuchGetObject },
{ 0x1801 , 2 , SetPdo2TxParam , NoSuchGetObject },
{ 0x2000 , 2 , SetRecorder , GetRecorder } ,
{ 0x2001 , 2 , NoSuchSetObject , GetSignalFlags } ,
{ 0x2002 , 4 , SetSignal , GetSignal } ,
{ 0x2006 , 2 , NoSuchSetObject , GetRecorderCRC } ,
{ 0x2208  , 4 , SetFloatPar , GetFloatPar },
{ 0x220d  , 4 , SetConfigPar , GetConfigPar },
{ 0x2220  , 2 , SetMiscTest , GetMiscTest },
{ 0x2221  , 2 , SetDynIdentification , GetDynIdentification },
{ 0x2222  , 2 , NoSuchSetObject , GetAtpData },
{ 0x2223  , 2 , SetShortData , GetShortData },
{ 0x2224  , 2 , SetBHControlWord , NoSuchGetObject },
{ 0x2225  , 2 , SetFloatData , GetFloatData },
{ 0x2301 , 4 , SetFwCmd , GetFwCmd },
{ 0x2302 , 4 , SetCalibCmd , GetCalibCmd },
{ 0x2304 , 4 , SetParamCmd , GetParamCmd },
{ 0x2400 , 0 , SetMotionPar , GetMotionPar },
{ 0x5007 , 2 , SetSyncArrivalTime , NoSuchGetObject },
{ 0x6040 , 2 , SetControlWord , NoSuchGetObject },
{ 0x605a , 2 , SetQuickStopOptionCode , NoSuchGetObject },
{ 0x605d , 2 , SetHaltOptionCode , NoSuchGetObject },
{ 0x6060 , 2 , SetOperationMode , GetOperationMode },
{ 0x6073 , 2 , NoSuchSetObject , GetPeakCurrentPromils },
{ 0x6075 , 2 , NoSuchSetObject , GetRatedCurrent },
{ 0x607a, 4 , SetPositionTarget , NoSuchGetObject},
{ 0x6098, 2 , SetHomingMethod , NoSuchGetObject},
{ 0x7fff , 4 , NoSuchSetObject , (GetDictFunc) 0 }
};

const short unsigned SizeofObjDict =  sizeof(ObjDictionaryItem)/sizeof(struct CObjDictionaryItem) ;

#define BURN_DATA_BUFFER RecorderBuffer
#define PROG_BUF_LEN 2048
#if REC_BUF_LEN < PROG_BUF_LEN
#error "Allocation failure for program buffer"
#endif


float fGetSamplingTime( short unsigned ind)
{
    switch ( ind )
    {
        case 2:
            return (float)VLOOP_SAMPLE_TIME_USEC * 1e-6 ;
        case 3:
            return  (float)VLOOP_SAMPLE_TIME_USEC * 1e-6 / (float)FAST_TS_USEC ;
        default:
            break ;
    }
    return SysState.Timing.Ts  ;
}

/**
 * \brief Get the index of parameter in the parameters table , brute force search
 *
 * \param TargetIndex: The index of the parameter to look for
 */
short unsigned GetParIndex ( short unsigned TargetIndex )
{
    short unsigned L , R, m , Am , cnt ;

    L = 0 ; R = N_ParTable ;

    for ( cnt = 0 ; cnt < 10000; cnt++  )
    {
        if ( L > R ) return UNSIGNED_MINUS1_S ;
        m = (L+R)>>1 ;
        Am = ParTable[m].ind ; ;
        if ( Am < TargetIndex )
        {
            L = m + 1 ;
            continue ;
        }
        if ( Am > TargetIndex )
        {
            if ( R == 0 )
            {
                return UNSIGNED_MINUS1_S ; // Search too long
            }
            R = m - 1 ;
            continue ;
        }
        return m ;
    }
    return UNSIGNED_MINUS1_S ; // Search too long
}

/**
 * \brief Place holder in object dictionary for non-existing "Get" service
 */
long unsigned  NoSuchGetObject( struct CSdo * pSdo ,short unsigned *nData)
{
    (void) pSdo ;
    (void) nData ;
    return Unsupported_access_to_an_object ;
}



/**
 * \brief Place holder in object dictionary for non-existing "Set" service
 */
long unsigned  NoSuchSetObject( struct CSdo * pSdo ,short unsigned nData)
{
    (void) pSdo ;
    (void) nData ;
    return Unsupported_access_to_an_object ;
}


struct CCiaControlWord
{
    int unsigned SwitchOn : 1 ;
    int unsigned EnableVoltage : 1 ;
    int unsigned NormalNotInQStop : 1 ;
    int unsigned MotorOn : 1 ;
    int unsigned NewSetPt : 1 ;
    int unsigned ApplySetPtImmediate : 1 ;
    int unsigned AbsoluteStPt : 1 ;
    int unsigned FaultReset : 1;
    int unsigned Halt : 1 ;
    int unsigned ChgOnSetPt : 1 ;
    int unsigned Reserved1 : 1 ;
    int unsigned ModuloTravelMode : 2 ;
    int unsigned Reserved2 : 3 ;
};
#define CIA_CWORD_SWON 1
#define CIA_CWORD_VoltEna 2
#define CIA_CWORD_MotorOn 8
#define CIA_CWORD_NewSetPt 16
#define CIA_CWORD_ApplyImmediate 32
#define CIA_CWORD_AbsSetPt 64
#define CIA_CWORD_FaultReset 0x80

#define CIA_CWORD_Halt 0x100
#define CIA_CWORD_ChgOnSetPt 0x200

/*
 * Access the BH PDO control interface via SDO
 */
long unsigned  SetBHControlWord( struct CSdo * pSdo ,short unsigned nData)
{
    short unsigned si ;
    si = pSdo->SubIndex ;

    union
    {
        long unsigned ul ;
        short unsigned us[0] ;
        short s[0] ;
       float f ;
    } u ;
    u.ul = *(long unsigned *) & pSdo->SlaveBuf[0] ;

    switch(si)
    {
    case 0:
        DecodeBhCW(u.ul) ;
        break ;
    case 1:
        DecodeBhCmdValue(u.f) ;
        break ;
    default:
        return Sub_index_does_not_exist ;
    }
    return 0 ;
}


/*
 * Object 0x6040 Set
 */
long unsigned  SetControlWord( struct CSdo * pSdo ,short unsigned nData)
{
    short unsigned us ;
    short stat ;
    if ( pSdo->SubIndex)
    {
        return Sub_index_does_not_exist;
    }
    us =  *(short unsigned *) & pSdo->SlaveBuf[0] ;

    if ( us & CIA_CWORD_FaultReset )
    {
        // Reset error
        SysState.Status.ResetFaultRequest = 1 ; // Reset fault condition
        SysState.Status.ResetFaultRequestUsed = 0;  // Make it good for one attempt
    }

    if ( us & CIA_CWORD_MotorOn )
    {
        stat = SetMotorOn(1) ;
        if ( stat )
        {
            LogException( EXP_FATAL, (long unsigned) stat ) ;
        }
    }
    else
    {
        SafeSetMotorOff() ;
    }

    SysState.Mot.QuickStop =  ( us & CIA_CWORD_Halt ) ? 1 : 0 ;

    return 0 ;
}



/*
 * Object 0x1400 Set
 */
long unsigned  SetPdo1RxParam( struct CSdo * pSdo ,short unsigned nData)
{
    return 0 ;
}

/*
 * Object 0x1800 Set
 */
long unsigned  SetPdo1TxParam( struct CSdo * pSdo ,short unsigned nData)
{
    return 0 ;
}
/*
 * Object 0x1801 Set
 */
long unsigned  SetPdo2TxParam( struct CSdo * pSdo ,short unsigned nData)
{
    return 0 ;
}

// Object 0x2006
long unsigned  GetRecorderCRC( struct CSdo * pSdo ,short unsigned *nData)
{
    long unsigned stat ;
    short unsigned crc , cnt , c , r  ;
    short unsigned * uPtr ;
    stat = GetRecorder( pSdo ,nData);
    if ( stat )
    {
         return stat ;
    }
    uPtr = (short unsigned *) pSdo->SlaveBuf ;
    crc  = 0xffff ;
    SysState.BlockUpload.nBytes = *nData ;
    for ( cnt = 0 ; cnt < (SysState.BlockUpload.nBytes>>1) ; cnt++ )
    {
        c = *uPtr++ ;
        crc = crc_ccitt_byte( crc, c & 0xff );
        crc = crc_ccitt_byte( crc, c >> 8   );
    }
    SysState.BlockUpload.crc = crc ;
    r = SysState.BlockUpload.nBytes % 7 ;
    SysState.BlockUpload.BytesEmptyAtEnd = ( r ? 7 - r : 0 );
    return 0 ;
}


/*
 * Object 0x605a Set
 */
long unsigned  SetQuickStopOptionCode( struct CSdo * pSdo ,short unsigned nData)
{
    return 0 ;
}

/*
 * Object 0x605d Set
 */
long unsigned  SetHaltOptionCode( struct CSdo * pSdo ,short unsigned nData)
{
    return 0 ;
}
/*
 * Object 0x5007 Set
 */
long unsigned  SetSyncArrivalTime( struct CSdo * pSdo ,short unsigned nData)
{
    return 0 ;
}



short TestCfgProgramming(void)
{
    short unsigned si , dirty  ;
    struct CFloatConfigParRecord *pPar ;
    for ( si = 0 ; si < nConfigPars ; si++)
    {
        pPar = ( struct CFloatConfigParRecord * ) &ConfigTable[si] ;
        dirty = CfgDirty[si>>3] & (1L <<(si&31)) ;
        if ( pPar->Flags & CFG_MUST_INIT )
        {
            if ( dirty == 0 )
            {
                return -1  ;
            }
        }
   }
   // Assure the config-done flag is written by remote host
   if( SysState.ConfigDone == 0 )
   {
       return -3 ;
   }
   return 0 ;
}




void ResetConfigPars(void)
{
    short unsigned cnt ;
    struct CFloatConfigParRecord *pPar ;
    float *fPtr ;
    for ( cnt = 0 ; cnt < nConfigPars ; cnt++)
    {
        pPar = ( struct CFloatConfigParRecord * ) &ConfigTable[cnt] ;

        fPtr = ConfigTable[cnt].ptr ;
        if ( pPar->Flags & CFG_FLOAT)
        {
            * fPtr = pPar->defaultVal ;
        }
        else
        {
            * ((long *)fPtr )= pPar->defaultVal ;
        }
    }
    FloatParRevision = ParametersSetRevision;
}


/**
 * \brief Get a configuration parameter
 *   Object 0x220d Get
 */
long unsigned  GetConfigPar( struct CSdo * pSdo ,short unsigned *nData)
{
    short unsigned si  ;
    float f ;
    long  l ;
    struct CFloatConfigParRecord *pPar ;

    si = pSdo->SubIndex ;
    *nData = 4 ;

    if ( si == 255 )
    {
        * ((long *) &pSdo->SlaveBuf[0] ) = nConfigPars ;
        return 0;
    }

    if ( si >= nConfigPars )
    {
        return Sub_index_does_not_exist ;
    }

    pPar = ( struct CFloatConfigParRecord * ) &ConfigTable[si] ;
    if ( pPar->Flags & CFG_FLOAT )
    {
        f = *  pPar->ptr ;
        * ((float *) &pSdo->SlaveBuf[0] ) = f ;
    }
    else
    {
        l = * (long *)pPar->ptr ;
        * ((long *) &pSdo->SlaveBuf[0] ) = l ;
    }



    return 0 ;
}



long unsigned TestCfgPar( const struct CFloatConfigParRecord *pPar  , long rawvalue )
{
    float f ;
    long  l ;
    float *fPtr;

    if ( (pPar->Flags & CFG_FLOAT) == 0 )
    {
        l = rawvalue  ;
        f = (float) l ;
    }
    else
    {
        f =* ((float *) &rawvalue );
        if ( isnan( f) )
        {
            return General_parameter_incompatibility_reason ;
        }
    }

    if ( f < pPar->lower ||  f > pPar->upper )
    {
        return GetManufacturerSpecificCode(ERR_OUT_OF_RANGE)  ;
    }

    fPtr = pPar->ptr ;
    if ( (pPar->Flags & CFG_FLOAT) == 0 )
    {
        * ((long*) fPtr) = l ;
    }
    else
    {
        *fPtr = f;
    }
    return 0 ;
}


/**
 * \brief Set a floating point configuration parameter .
 * Object 0x220d Set
 */
long unsigned  SetConfigPar( struct CSdo * pSdo ,short unsigned nData)
{
    short unsigned si ;
    long unsigned stat ;
    struct CFloatConfigParRecord *pPar ;

    float cdone ;

    cdone = SysState.ConfigDone ;

    si = ( pSdo->SubIndex & 0xff ) ;

    if ( nData != 4 )
        return length_of_service_parameter_does_not_match;

    if ( si >= nConfigPars )
    {
        return Sub_index_does_not_exist ;
    }

    pPar = ( struct CFloatConfigParRecord * ) &ConfigTable[si] ;

    if ( pPar->Flags & CFG_REVISION  )
    {
        if (*(pPar->ptr) == ParametersSetRevision)
        {
            return 0 ;
        }
        else
        {
            return GetManufacturerSpecificCode(ERR_FIXED_PARAMETER)  ;
        }
    }

    stat = TestCfgPar(pPar, pSdo->SlaveBuf[0]) ;
    if ( stat )
    {
        return stat ;
    }


    CfgDirty[si>>3] |= (1L <<(si&31) ) ;

    // Approval need be the last
    if (pPar->Flags & CFG_KILLS_CFG)
    {
        SysState.ConfigDone = 0 ;
    }

    if ( pPar->Flags & CFG_RECALC )
    {
        if ( ClaState.MotorOnRequest + ClaState.MotorOn )
        {
            return GetManufacturerSpecificCode(ERR_ONLY_FOR_MOTOROFF)  ;
        }
        InitControlParams() ;
    }

    if ( cdone != SysState.ConfigDone )
    { // Changed configuration done flag, test if valid
        if ( TestCfgProgramming() )
        {
            SysState.ConfigDone = 0 ;
        }
    }

    return 0 ;
}


// Object 0x6075 Get rated current
long unsigned  GetRatedCurrent( struct CSdo * pSdo ,short unsigned *nData)
{
    short unsigned si  ;
    si = pSdo->SubIndex ;
    if ( si )
    {
        return Sub_index_does_not_exist ;
    }
    * ((long *) &pSdo->SlaveBuf[0] ) = (long unsigned) (ControlPars.MaxCurCmd * 1000.0f ) ;
    return 0 ;
}

// Object 0x6073 Get peak current in promils
long unsigned  GetPeakCurrentPromils( struct CSdo * pSdo ,short unsigned *nData)
{
    short unsigned si  ;
    si = pSdo->SubIndex ;
    if ( si )
    {
        return Sub_index_does_not_exist ;
    }
    * ((long *) &pSdo->SlaveBuf[0] ) = 1000 ; // Peak and continuous limits equal

    return 0 ;
}




/**
 * \brief object 0x2220: Miscellaneous services
 *
 */

long unsigned  GetMiscTest( struct CSdo * pSdo ,short unsigned *nData)
{
    short unsigned si  ;

    union
    {
        short us[2] ;
        long l ;
        long ul ;
    } u ;

    //short unsigned *pUs ;
    si = pSdo->SubIndex ;
    *nData = 4 ;
    u.l = 0 ;
    switch ( si )
    {
    case 0:
        break ;

    case 1:
        u.us[0] = HWREGH(CLA1_BASE + CLA_O_MCTL)   ;
        break ;
    case 3:
        u.us[0] = HWREGH(CLA1_BASE + CLA_O_MIER)  ;
        break ;
    case 4:
        u.us[0] = HWREGH(CLA1_BASE + CLA_O_MIFR) ;
        break ;
    case 5:
        u.us[0] = HWREGH(CLA1_BASE + CLA_O_MIRUN) ;
        break ;
    case 6:
        u.us[0] = HWREGH(CLA1_BASE + CLA_O_MIOVF) ;
        break ;

    case 7:
        u.us[0] = HWREGH(DACC_BASE + DAC_O_VALS);
        break ;

    case 8:
        u.us[0] = HWREGH(DACC_BASE + DAC_O_VALA);
        break ;

    case 98:
        u.ul = HallDecode.ComStat.ul ; // ComStat.fields.HallStat ;
        break ;

    case 99:
        u.l = SysState.CBit.all ;
        break ;

    case 100:
        u.l = ( Commutation.CommutationMode & 7 ) + (( Correlations.state & 7 ) << 3 ) + (ClaMailIn.bNoCurrentPrefilter ? (1  << 6) : 0  ) +
                (( ControlPars.MaxSupportedClosure & 7 ) << 7 )  + ( (SysState.Debug.bBypassPosFilter & 1) << 10 ) + ( (SysState.Profiler.bPeriodic & 1 ) << 11 ) +
                 (( SysState.Mot.ReferenceMode & 7 ) << 12 ) + (1UL<<15) +  (1UL<<16)
                 + ( (unsigned long)(SysState.SwState & 7 ) << 17  )+ (1UL<<20) ;

        break ;

    case 200:
        if ( (u.l < E_S_Nothing) || (u.l < E_S_Triangle) )
        {
            return General_parameter_incompatibility_reason ;
        }
        u.l = SysState.Debug.GRef.Type  ;
        break ;
    case 201:
        if ( (u.l < E_S_Nothing) || (u.l < E_S_Triangle) )
        {
            return General_parameter_incompatibility_reason ;
        }
        u.l = SysState.Debug.TRef.Type  ;
        break ;


    default:
        return Sub_index_does_not_exist ;
    }
    * ((long *) &pSdo->SlaveBuf[0] ) = u.l ;
    return 0 ;
}






struct CShortDesc
{
    short unsigned *pUs ;
    short unsigned lLimit ;
    short unsigned hLimit ;
};



const struct CShortDesc ShortDesc[] = {
{&Correlations.nCyclesInTake,1,128}, //0
{&Correlations.nSamplesForFullTake,3,16384}, //1
{&Correlations.nWaitTakes,1,128}, //2
{&Correlations.nSumTakes,1,128},  //3
{&Correlations.state,0,ECF_Done},  //4
{&SysState.Debug.bAllowRefGenInMotorOff,0,1}, // 5
{&SysState.Debug.bTestBiquads,0,1},  // 6
{&SysState.Debug.bBypassPosFilter,0,1} ,  // 7
{&SysState.Profiler.bPeriodic,0,1}  , // 8
{&SysState.Profiler.bSlow,0,1}   // 9
} ;


#define nShortDesc (sizeof(ShortDesc) / sizeof(struct CShortDesc) )

/**
 * \brief object 0x2221: Set Dynamic identification services
 *
 */
long unsigned  SetDynIdentification( struct CSdo * pSdo ,short unsigned nData)
{
    short unsigned si ;
    struct CShortDesc *pSd ;
    si = pSdo->SubIndex ;

    union
    {
        float f ;
        long l ;
        unsigned long ul ;
        unsigned short us ;
        float *fp ;
    }u ;
    u.l = * ((long*)pSdo->SlaveBuf) ;

    if ( si < nShortDesc)
    {
        pSd = (struct CShortDesc *) &ShortDesc[si];
        if ( (u.us >= pSd->lLimit) && (u.us <= pSd->hLimit) )
        {
            * pSd->pUs = u.us ;
            return 0 ;
        }
        else
        {
            return General_parameter_incompatibility_reason ;
        }
    }
    switch ( si )
    {
    case 10:
        if ( u.f >=0 && u.f <= 1)
        {
            Correlations.TRefPhase = __fracf32 ( __fracf32 ( u.f) + 1 ) ;  ;
        }
        break;
    case 21:
        u.fp = GetFSignalPtr( u.us ) ;
        if ( u.ul == 0)
        {
            return General_parameter_incompatibility_reason ;
        }
        Correlations.fPtrs[0] = u.fp ;
        break;
    case 22:
        u.fp = GetFSignalPtr( u.us ) ;
        if ( u.ul == 0)
        {
            return General_parameter_incompatibility_reason ;
        }
        Correlations.fPtrs[1] = u.fp ;
        break;
    case 23:
        u.fp = GetFSignalPtr( u.us ) ;
        if ( u.ul == 0)
        {
            return General_parameter_incompatibility_reason ;
        }
        Correlations.fPtrs[2] = u.fp ;
        break;
    default:
        return Sub_index_does_not_exist ;
    }
    return 0 ;
}



const float * pIdRslt[] =  {
&Correlations.sCor1[0] , // 0
&Correlations.sCor1[1] , // 1
&Correlations.sCor1[2] , // 2

&Correlations.cCor1[0] , // 3
&Correlations.cCor1[1] , // 4
&Correlations.cCor1[2] , // 5

&Correlations.tCor1[0] , // 6
&Correlations.tCor1[1] , // 7
&Correlations.tCor1[2] , // 8

&Correlations.aCor1[0] , // 9
&Correlations.aCor1[1] , // 10
&Correlations.aCor1[2] , // 11

&Correlations.sCor2[0] , // 12
&Correlations.sCor2[1] , // 13
&Correlations.sCor2[2] , // 14

&Correlations.cCor2[0] , // 15
&Correlations.cCor2[1] , // 16
&Correlations.cCor2[2] , // 17

&Correlations.tCor2[0] , // 28
&Correlations.tCor2[1] , // 19
&Correlations.tCor2[2] , // 20

&Correlations.aCor2[0] , // 21
&Correlations.aCor2[1] , // 22
&Correlations.aCor2[2] , // 23

&Correlations.SumS2 , // 24
&Correlations.SumC2 , // 25
&Correlations.Sum1  , // 26
&Correlations.SumT2 , // 27
&Correlations.SumSC , // 28
&Correlations.SumST , // 29
&Correlations.SumS  , // 30
&Correlations.sumCT , // 31
&Correlations.SumC  , // 32
&Correlations.SumT  , // 33
&Correlations.Sum1  , // 34
&SysState.Timing.Ts ,  // 35
&ClaState.Analogs.Vdc} ; // 36


#define nIdData (sizeof(pIdRslt) / sizeof(float*))


/**
 * \brief object 0x2221: Get Dynamic identification services
 *
 */
long unsigned  GetDynIdentification( struct CSdo * pSdo ,short unsigned *nData)
{
    short unsigned si ;
    struct CShortDesc *pSd ;
    si = pSdo->SubIndex ;
    if ( si < nIdData )
    {
        * ((float *) pSdo->SlaveBuf) = *pIdRslt[si];
        return 0 ;
    }
    if ( si >= 100 )
    {
        si = si - 100 ;
        if ( si < nShortDesc )
        {
            pSd = (struct CShortDesc *) &ShortDesc[si];
            * ((long *) pSdo->SlaveBuf) = (long) *pSd->pUs ;
            return 0 ;
        }
    }
    return Sub_index_does_not_exist ;
}

struct CShortDataItem
{
    short * pShortData  ;
    short   dmin ;
    short   dmax ;
    short   LimiType ;
};
const struct CShortDataItem ShortDataItem[]={
                               {&SysState.Homing.Direction , -1, 1,1} , // 0
                               {&SysState.Homing.Method , 0 , 2 , 0 } , // 1
                               {&SysState.Homing.SwInUse ,0, 1 , 0} ,  // 2
                               {&SysState.Debug.IgnoreHostCW ,0,1,0 } , //3
                               {& SysState.EncoderMatchTest.bTestEncoderMatch , 0, 1, 0 } , // 4
                               {(short*) &SysState.MCanSupport.NodeStopped , 0 ,1,0 } ,  //5
                               { &SysState.Homing.State, 0 ,5,1 } ,  //6
                               {(short*)  &SysState.Debug.bDisablePotEncoderMatchTest,0,1,0} , // 8
                               {(short*)  &SysState.SteerCorrection.bSteeringComprensation ,0, 1 , 0}   // 9
};



const unsigned short nShortData = sizeof(ShortDataItem) / sizeof(struct CShortDataItem) ;
/*
 * \brief object 0x2223: GetShortData
 */
long unsigned  GetShortData( struct CSdo * pSdo ,short unsigned *nData)
{
    short unsigned si ;
//    struct CShortDesc *pSd ;
    si = pSdo->SubIndex ;
    if ( si < nShortData )
    {
        * ((long *) pSdo->SlaveBuf) = (long) (*ShortDataItem[si].pShortData) ;
        return 0 ;
    }
    return Sub_index_does_not_exist;
}


/**
 * \brief object 0x2223: SetShortData
 *
 */
long unsigned  SetShortData( struct CSdo * pSdo ,short unsigned nData)
{
    short unsigned si , ok ;
    short us  , dmin , dmax;
    short * pS ;
    si = pSdo->SubIndex ;

    us = * ((short*)pSdo->SlaveBuf) ;

    if ( si < nShortData)
    {
        dmin = ShortDataItem[si].dmin ;
        dmax = ShortDataItem[si].dmax ;
        ok = 0 ;
        if ( ShortDataItem[si].LimiType == 0 )
        {
            if ( us >= dmin && us <= dmax)
            {
                ok = 1  ;
            }
        }
        else
        {
            if ( us == dmin || us == dmax)
            {
                ok = 1  ;
            }
        }
        if ( ok )
        {
            pS = (short *) ShortDataItem[si].pShortData;
            *pS = us ;
            return 0 ;
        }
        else
        {
            return General_parameter_incompatibility_reason ;
        }
    }
    return Sub_index_does_not_exist;

}

const float BigFatZero = 0 ;

const float  * pFloatData[] =  {
                             &BigFatZero , // 0 (duplicate)
                             &BigFatZero , // 1
                             &BigFatZero, // 2
                             &BigFatZero,  // 3
                             &BigFatZero,  // 4
                             &ClaControlPars.PhaseOverCurrent, // 5
                             &ClaControlPars.VDcMax , // 6
                             &ClaControlPars.VDcMin , //7
                             &BigFatZero , //8
                             &BigFatZero ,// 9
                             &SysState.EncoderMatchTest.DeltaTestUser ,// 10
                             &SysState.EncoderMatchTest.DeltaTestTol , // 11
                             &SysState.EncoderMatchTest.MaxPotentiometerPositionDeviation ,//12
                             &SysState.UserPosOnHomingFW , // 13
                             &SysState.UserPosOnHomingRev, //14
                             &ControlPars.MotionConvergeWindow, // 15
                             &ControlPars.MotionConvergeTime, // 16
                             &ControlPars.SpeedConvergeWindow,  // 17
                             &ControlPars.MinPositionFb, //18
                             &ControlPars.MaxPositionFb, // 19
                             &SysState.SpeedControl.ProfileAcceleration, //20
                             &SysState.Profiler.slowvmax , //21
                             &ControlPars.KGyroMerge ,//22
                             &ControlPars.PosErrorExtRelGain ,//23
                             &ControlPars.PosErrorExtLimit ,//24
                             &SysState.SteerCorrection.WheelAddZ , //25
                             &SysState.SteerCorrection.SteeringColumnDistRatio ,// 26
                             &ControlPars.PdoCurrentReportScale , // 27
                             &ClaControlPars.ExtCutCst // 28
                             };


const unsigned short nFloatData = sizeof(pFloatData) / sizeof(float *) ;

/*
 * \brief object 0x2225 GetFloatData
 */
long unsigned  GetFloatData( struct CSdo * pSdo ,short unsigned *nData)
{
    short unsigned si ;
//    struct CShortDesc *pSd ;
    si = pSdo->SubIndex ;
    if ( si < nFloatData )
    { // Take one from the pointer list above
        * ((float *) pSdo->SlaveBuf) = *(pFloatData[si]) ;
        return 0 ;
    }
    return Sub_index_does_not_exist;
}


/**
 * \brief object 0x2225: SetFloatData
 *
 */
long unsigned  SetFloatData( struct CSdo * pSdo ,short unsigned nData)
{
    short unsigned si ;
    float f ;
    float * pf ;
    si = pSdo->SubIndex ;

    f = * ((float*)pSdo->SlaveBuf) ;

    if ( si < nFloatData)
    {
        pf = (float *) pFloatData[si];
        *pf = f ;
        return 0 ;
    }
    return Sub_index_does_not_exist;

}



/*
 * \brief object 0x2222: GetAtpData
 */
const float * pAtpRslt[] =  {
                             &SysState.AnalogProc.FiltCurAdcOffset[0] , // 0
                             &SysState.AnalogProc.FiltCurAdcOffset[1] , // 1
                             &SysState.AnalogProc.FiltCurAdcOffset[2] , // 2
                             & SysState.AnalogProc.Temperature , // 3
                             & ClaState.Analogs.BrakeVolts , // 4
                             & ClaControlPars.CurrentCommandDir // 5
                             };

const unsigned short nAtpData = sizeof(pAtpRslt) / sizeof(float *) ;

long unsigned  GetAtpData( struct CSdo * pSdo ,short unsigned *nData)
{
    short unsigned si ;
//    struct CShortDesc *pSd ;
    si = pSdo->SubIndex ;
    if ( si < nAtpData )
    {
        * ((float *) pSdo->SlaveBuf) = *pAtpRslt[si];
        return 0 ;
    }
/*
    if ( si >= 100 )
    {
        si = si - 100 ;
        if ( si < nShortDesc )
        {
            pSd = (struct CShortDesc *) &ShortDesc[si];
            * ((long *) pSdo->SlaveBuf) = (long) *pSd->pUs ;
            return 0 ;
        }
    }
*/
    return Sub_index_does_not_exist ;
}



/**
 * \brief object 0x2220: Miscellaneous services
 *
 */
short bcnt ;
long unsigned  SetMiscTest( struct CSdo * pSdo ,short unsigned nData)
{
    short unsigned si  ,us   , YesNo ;
    short stat ;
    long unsigned ul ;
    float f ;
    (void) nData ;
    us =* ((short unsigned *) pSdo->SlaveBuf);
    ul =* ((long unsigned *) pSdo->SlaveBuf);
    f =* ((float *) pSdo->SlaveBuf);

    YesNo = (us) ? 1 : 0 ;
    si = pSdo->SubIndex ;
    switch ( si )
    {
    case 0:
        bcnt = __min(us,63)  ;
        break  ;
/*
    case 1:
        ptr = (short unsigned *) & SlaveSdoBuf[0];
        for ( cnt = 0 ; cnt < __min(bcnt,63) ; cnt++)
        {
            *ptr ++ = us++ ;
        }
        TxPutPtr = 0 ;
        stat = Put2TxBuf( (short unsigned *) & SlaveSdoBuf[0] , bcnt  );
        if ( stat < 0 )
        {
            return General_parameter_incompatibility_reason ;
        }
        TransmitTxBuf() ;
        return 0 ;
*/
    case 2:
        MasterBlaster.PassWord = ul ;
        break ;
    case 3:
        if ( MasterBlaster.PassWord != 0x12345 )
        {
            return General_parameter_incompatibility_reason ;
        }
        if ( ClaState.MotorOnRequest + ClaState.MotorOn )
        {
            return GetManufacturerSpecificCode(ERR_ONLY_FOR_MOTOROFF)  ;
        }
        switch ( us)
        {
        case 1:
            SetClaAllSw() ;
            ClaMailIn.v_dbg_angle = 0 ;
            ClaMailIn.v_dbg_amp   = 0 ;
            CLA_setTriggerSource(CLA_TASK_3, CLA_TRIGGER_ADCB1); // Kill normal tasks
            CLA_setTriggerSource(CLA_TASK_2, CLA_TRIGGER_SOFTWARE);
            CLA_enableTasks(CLA1_BASE, (CLA_TASKFLAG_3 | CLA_TASKFLAG_8));
            SysState.Mot.LoopClosureMode = E_LC_Voltage_Mode ;
            break ;
        }
        break ;
    case 4:
        if ( (ClaState.SystemMode != E_SysMotionModeManual) && (E_SysMotionModeFault >= E_SysMotionModeNothing ) )
        {
            return GetManufacturerSpecificCode(ERR_ONLY_FOR_MANUALMODE)  ;
        }
        switch ( us)
        {
        default:
            SafeSetMotorOff();
            break;
        case 1:
            stat = SetMotorOn(0) ;
            if ( stat )
            {
                return GetManufacturerSpecificCode(stat) ;
            }
            break ;
        case 2:
            SetMotorOff(E_OffForFinal); // Immediate
            break ;
        }
        break ;
    case 5:
        ClaMailIn.v_dbg_angle = f ;
        break ;

    case 6:
        ClaMailIn.v_dbg_amp   = f ;
        break ;

    case 8:
        // Set to loop closure mode
        stat = SetLoopClosureMode( us );
        if ( stat )
        {
            return GetManufacturerSpecificCode(stat) ;
        }
        break ;

    case 9:
        if ( SysState.Mot.LoopClosureMode != E_LC_OpenLoopField_Mode )
        {
            return General_parameter_incompatibility_reason ;
        }
        ClaMailIn.ThetaElect = f ;
        break ;

    case 10 :
        SysState.Status.ResetFaultRequest = 1 ; // Reset fault condition
        SysState.Status.ResetFaultRequestUsed = 0  ;
        break ;

    case 11:
        SysState.Mot.QuickStop = us ;
        break ;


    case 12:
        SetSystemMode(us) ;
        break ;


    case 14:
        if ( ClaState.MotorOn == 0 )
        {
            return GetManufacturerSpecificCode(ERR_ONLY_FOR_MOTORON)  ;
        }
        SysState.Mot.QuickStop = 0 ;
        return SetReferenceMode( us) ;

    case 15:
        SysState.AlignRefGen = us ;
        ClaMailIn.IdMode  = (float) us ;
        break ;

    case 16:
        SysState.AlignRefGen = us ;
        break;

/*
    case 15:
        HWREGH(CLA1_BASE + CLA_O_MIFRC)  = us ;
        break ;
    case 16:
        HWREGH(CLA1_BASE + CLA_O_MICLR)  = us ;
        break ;
*/

    case 17:
        if ( us )
        {// Stop reacting sync and PDO. NMT will be blocked in the idle loop, so master can't use NMT to restore action.
            SysState.MCanSupport.NodeStopped = 1 ;
            SysState.MCanSupport.bAutoBlocked =  1  ;
        }
        else
        {
            SysState.MCanSupport.bAutoBlocked = 0 ;
        }

        break ;

    case 18:
        if ( us ==1234 )
        {
            SysState.MCanSupport.NodeStopped = 1 ;
            SafeSetMotorOff();
        }
        break ;


    case 20:
        SysState.Mot.ExtBrakeReleaseRequest = YesNo ;
        break  ;

    case 21:
        // Set DAC-H to allowed MAX +ve current
        CMPSS_setDACValueHigh(CMPSS_VBUS_BASE, (short unsigned)(ControlPars.AbsoluteOvervoltage / ClaControlPars.Vdc2Bit2Volt ));
        // Set DAC-L to allowed MAX -ve current
        CMPSS_setDACValueLow(CMPSS_VBUS_BASE, (short unsigned)(ControlPars.AbsoluteUndervoltage / ClaControlPars.Vdc2Bit2Volt ));
        break ;

    case 22:
        CMPSS_setDACValueHigh(CMPSS_BUSCUR_BASE, (short unsigned)(ControlPars.DcShortCitcuitTripVolts * VOLT_2_ADC));
        break ;


    case 23:
        if ( SysState.Mot.BrakeControlOverride == us )
        {
            break ; // Nothing to do
        }
        if ( ClaState.MotorOnRequest  )
        {
            us &= 0x1 ;
        }
        SysState.Mot.BrakeControlOverride = us ;
        SysState.Mot.ExtBrakeReleaseRequest = 0 ;
        break ;

    case 24:
        if ( f < ControlPars.MinPositionCmd || f > ControlPars.MaxPositionCmd)
        {
            return length_of_service_parameter_does_not_match ;
        }
        SetAbsPosition(f) ;
        break ;

        // DO NOT CHANGE sub index 25. It is used by operational SW
    case 25:
        if ( us == 1234 )
        {
            if ( ClaState.MotorOn && ( SysState.Mot.LoopClosureMode ==  E_LC_Pos_Mode ) )
            { // Because motor will jump
                return  General_parameter_incompatibility_reason ;
            }
            ImmediateHoming() ;
        }
        break;
    case 26:
        HomingHere(f) ;
        break ;

    case 200:
        SysState.Debug.GRef.Type = us ;
        break ;
    case 201:
        SysState.Debug.TRef.Type = us ;
        break ;
    case 202:
        SysState.Debug.GRef.On = us ? 1 : 0 ;
        break ;
    case 203:
        SysState.Debug.TRef.On = us ? 1 : 0  ;
        break ;



    case 204:
        ClaMailIn.bNoCurrentPrefilter = us ? 1 : 0 ;
        break ;
#ifdef SIMULATION_MODE
    case 240:
        ClaMailIn.vOpenLoopTestA = f ;
        break ;
    case 241:
        ClaMailIn.vOpenLoopTestB = f ;
        break ;
    case 242:
        ClaMailIn.vOpenLoopTestC = f ;
        break ;
#endif

    default:
        return Sub_index_does_not_exist ;
    }
    return 0 ;
}


/*
 * Object 0x2400 Set
 */
long unsigned  SetMotionPar(   struct CSdo * pSdo ,short unsigned nData)
{
    short unsigned si , mask  ;
    short stat ;
    float f , fTemp ;

    si = pSdo->SubIndex ;

    if ( nData != 4 )
    {
        return length_of_service_parameter_does_not_match ;
    }
    f =* ((float *) pSdo->SlaveBuf);
    if ( isnan(f)  )
    {
        return General_parameter_incompatibility_reason ;
    }


    switch ( si )
    {
    case 3:
        SysState.Profiler.PosTarget = f ;
        break ;

    case 31:
        ResetProfiler( &SysState.Profiler , f , 0 , 0 );
        break ;
    case 32:
        ResetProfiler( &SysState.Profiler , SysState.PosControl.PosFeedBack , f , 1 );
        break ;

    case 40:
        SysState.Profiler.PosTarget2 = f ;
        break ;

    case 41:
        SysState.Profiler.PosTarget3 = f ;
        break ;

    case 42:
        SysState.Profiler.PosTarget4 = f ;

        mask = BlockInts() ;
        SysState.Profiler.PosTarget = SysState.Profiler.PosTarget3 ;
        SysState.Profiler.PosTarget2 = SysState.Profiler.PosTarget4 ;
        RestoreInts(mask) ;

        break ;

    case 50:
        // Set the I2T current level
        stat = IsInRange( &f , 0.1f ,ControlPars.MaxCurCmd );
        if ( stat )
        {
            return General_parameter_incompatibility_reason ;
        }

        ControlPars.I2tCurLevel = f ;
        fTemp = __fmin( ControlPars.I2tCurLevel , ControlPars.FullAdcRangeCurrent * 0.95f) ;
        ControlPars.I2tCurThold = fTemp * fTemp  ;
        break;

    case 51:
        // Set the I2t integration time
        stat = IsInRange( &f , 0.1f ,1000.0f );
        if ( stat )
        {
            return General_parameter_incompatibility_reason ;
        }
        ControlPars.I2tCurTime = f ;
        ControlPars.I2tPoleS = 1.0f - __iexp2( SysState.Timing.Ts * 256 * Log2OfE / __fmax( 0.0001f , ControlPars.I2tCurTime ) );

        break ;

    default:
        return Sub_index_does_not_exist ;

    }
    return 0 ;
}


/*
 * Object 0x2400 Get
 */
long unsigned  GetMotionPar(   struct CSdo * pSdo ,short unsigned *nData)
{
    float f ;
    short unsigned si   ;

    si = pSdo->SubIndex ;


    switch ( si )
    {
    case 3:
        f = SysState.Profiler.PosTarget ;
        break ;
    default:
        return Sub_index_does_not_exist ;
    }

    * ((float *) pSdo->SlaveBuf) = f ;

    return 0 ;
}

/*
 * Object 0x6060  Get
 */
long unsigned  GetOperationMode(   struct CSdo * pSdo ,short unsigned *nData)
{
    long unsigned ul ;
    short unsigned si   ;

    si = pSdo->SubIndex ;

    if ( si )
    {
        return Sub_index_does_not_exist ;
    }


    switch ( SysState.Mot.LoopClosureMode )
    {
    case E_LC_Pos_Mode:
        ul = MODE_OF_OPERATION_PROFILED_POSITION ;
        break ;
    case E_LC_Speed_Mode:
        ul  = MODE_OF_OPERATION_PROFILED_VELOCITY ;
        break;
    case E_LC_Torque_Mode:
        ul = MODE_OF_OPERATION_PROFILED_VELOCITY;
        break ;
    default:
        ul  = MODE_OF_OPERATION_PROFILED_VELOCITY ;
        break ;
    }
    * ((long unsigned *) pSdo->SlaveBuf) = ul ;
    return 0 ;
}
/* Object 0x6060 */

long unsigned  SetOperationMode( struct CSdo * pSdo ,short unsigned nData)
{
    short unsigned si , stat ;
    long unsigned lstat ;

    unsigned short us =* ((short unsigned *) pSdo->SlaveBuf);

    si = pSdo->SubIndex ;
    if ( si )
    {
        return Sub_index_does_not_exist ;
    }

    switch (us)
    {
    case MODE_OF_OPERATION_PROFILED_POSITION:
        stat = SetLoopClosureMode(E_LC_Pos_Mode) ;
        if ( stat)
        {
            return stat ;
        }
        return (long unsigned) SetReferenceMode(E_PosModePTP) ;

    case MODE_OF_OPERATION_PROFILED_VELOCITY:
        return SetLoopClosureMode(E_LC_Speed_Mode) ; // Same as CSV

    case MODE_OF_OPERATION_PROFILED_TORQUE:
        return SetLoopClosureMode(E_LC_Torque_Mode) ;

    case MODE_OF_OPERATION_HOMING:
        lstat = SetAbsPosition(ClaState.Encoder1.UserPosOnHome) ;
        if ( lstat )
        {
            return lstat ;
        }
        break ;

    case MODE_OF_OPERATION_PROFILED_CSP:
        stat = SetLoopClosureMode(E_LC_Pos_Mode) ;
        if ( stat)
        {
            return stat ;
        }
        return (long unsigned) SetReferenceMode(E_PosModePTP) ;

    case MODE_OF_OPERATION_PROFILED_CSV:
         return SetLoopClosureMode(E_LC_Speed_Mode) ;

    default:
        return Sub_index_does_not_exist ;
    }
    return 0 ;
}



/**
 * \brief Set a floating point parameter  . Object 0x2208.
 *
 */
long unsigned  SetFloatPar( struct CSdo * pSdo ,short unsigned nData)
{
    short unsigned si ;
    float f ;
    short unsigned stat ;
    struct CFloatParRecord *pPar ;

    si = pSdo->SubIndex ;
    f =* ((float *) pSdo->SlaveBuf);
    if ( isnan( f) )
    {
        return General_parameter_incompatibility_reason ;
    }

    if ( nData != 4 )
        return length_of_service_parameter_does_not_match;

    stat = GetParIndex( si ) ;
    if ( stat & 0x8000 ) return Sub_index_does_not_exist ;
    pPar = ( struct CFloatParRecord * ) &ParTable[stat] ;
    if ( f >= pPar->lower &&  f <= pPar->upper )
    {
        * pPar->ptr = f;
    }
    else
    {
        return General_parameter_incompatibility_reason ;
    }

    InitControlParams() ;
    return 0 ;
}

/**
 * \brief Get a floating point parameter . Object 0x2208
 *
 */
long unsigned  GetFloatPar( struct CSdo * pSdo ,short unsigned *nData)
{
    short unsigned si  ;
    short unsigned stat ;
    float f ;
    struct CFloatParRecord *pPar ;

    si = pSdo->SubIndex ;
    stat = GetParIndex( si ) ;
    if ( stat & 0x8000) return Sub_index_does_not_exist ;
    pPar = ( struct CFloatParRecord * ) &ParTable[stat] ;
    f = *  pPar->ptr ;

    *nData = 4 ;
    * ((float *) &pSdo->SlaveBuf[0] ) = f ;

    return 0 ;
}

/**
 * \brief Object 0x2302
 */
long unsigned  GetCalibCmd( struct CSdo * pSdo ,short unsigned *nData)
{
    short unsigned si ;
    long unsigned ul ;
    long unsigned * pCalib ;

    si = pSdo->SubIndex ;

    if ( si == 0 )
    {
        ul = N_CALIB_RECS ;
    }

    else
    {
        if ( si < 100  )
        {
            pCalib = ((long unsigned *) &CalibProg.C.Calib) ;
        }
        else
        {
            pCalib = ((long unsigned *) &Calib);
            si -= 100 ;
        }

        if ( si == 0 || si > N_CALIB_RECS )
        {
            return Sub_index_does_not_exist ;
        }
        ul = pCalib[si-1] ;
    }

    * nData = 4 ;
    * ((long *) &pSdo->SlaveBuf[0] ) = ul ;
    return 0 ;
}




short SafePrepFlash(void)
{
    /*
    short stat ;
    short unsigned mask ;
    if (SysState.FlashPrepared )
    {
        return 0 ;
    }

    PauseInts() ;
    mask = BlockInts() ;
    SysState.Mot.DisablePeriodicService = 1 ;
    stat = PrepFlash4Burn();
    if ( stat == 0 )
    {
        SysState.FlashPrepared = 1 ;
    }
    SysState.Mot.DisablePeriodicService = 0 ;
    RestoreInts(mask) ;
    UnpauseInts() ;
    return stat ;
     *
     */
    return 0 ;
}

short SafeEraseFlash(long unsigned sect , long unsigned BufLen32 )
{
    short stat ;
    short unsigned mask ;
    SafePrepFlash();
    PauseInts() ;
    mask = BlockInts() ;
    SysState.Mot.DisablePeriodicService = 1 ;
    stat = EraseSectors( sect   , BufLen32 );
    SysState.Mot.DisablePeriodicService = 0 ;
    RestoreInts(mask)  ;
    UnpauseInts() ;
    return stat ;
}

short SafeProgramFlash( short unsigned * Buffer_in , long unsigned FlashAddress , long unsigned buflen)
{
    short stat ;
    short unsigned mask ;
    SafePrepFlash();
    PauseInts() ;
    mask = BlockInts() ;
    SysState.Mot.DisablePeriodicService = 1 ;

    stat = WriteToFlash(  FlashAddress , (long unsigned *) Buffer_in , buflen>>1) ;

    //stat = ProgramPageAutoECC(Buffer_in , FlashAddress , buflen ) ;
    SysState.Mot.DisablePeriodicService = 0 ;
    RestoreInts(mask)  ;
    UnpauseInts() ;
    return stat ;
}



/**
 * \brief Object 0x2302 Set calibration
 */
long unsigned  SetCalibCmd( struct CSdo * pSdo ,short unsigned nData)
{
    short unsigned si , cnt ;//,CalibFileVer ;
    short stat ;
    unsigned long ul ;
    unsigned long * uPtr;
    float f ;
    const struct CCalibRecord *pCr ;
    struct CCmdMode cmd ;

    si = pSdo->SubIndex ;
    ul =* ((unsigned long *) pSdo->SlaveBuf);
    f =* ((float *) pSdo->SlaveBuf);

    // Reject if motor is on
    if ( ClaState.MotorOnRequest)
    {
        return GetManufacturerSpecificCode(ERR_ONLY_FOR_MOTOROFF) ;

    }

    if ( si == 1 )
    {
        CalibProg.C.PassWord = ul ;
    }
    if ( (( CalibProg.C.PassWord != (0x12345600 + N_CALIB_RECS) ) && (si > 251) ) || nData != 4 )
    {
        return General_parameter_incompatibility_reason ;
    }
    if ( si == 1 )
    {
        ClearMemRpt( (short unsigned *) &CalibProg.C.Calib , sizeof(CalibProg.C.Calib ) );
        stat = SafePrepFlash() ;
        if ( stat )
        {
            return General_parameter_incompatibility_reason ;
        }
    }
    if (si >= 1 && si <= N_CALIB_RECS)
    {
        pCr = &CalibPtrTable[si-1] ;
        cmd = * (( struct CCmdMode *) &  pCr->flags ) ;
        if ( cmd.IsFloat )
        {
            stat = IsInRange( &f , pCr->limit , -pCr->limit );
            if ( stat )
            {
                return General_parameter_incompatibility_reason ;
            }
        }
        ((long unsigned*) &CalibProg.C.Calib)[si-1] = ul ;
        return 0 ;
    }

    switch ( si )
    {

    case 248:
        // Copy Calib to CalibProg
        Calib = CalibProg.C.Calib ;
        stat = 0 ;
        break ;
    case 249:
    //case 29: // Apply calibration
        DealCalibration(2) ;
        stat = 0 ;
        break ;
    case 250:
    //case 30:
        // Clear the calibration
        DealCalibration(0) ;
        stat = 0 ;
        break ;
    case 251:
    //case 31:
        stat = ReadCalibFromFlash ( (long unsigned*) &CalibProg.C.Calib ,  FlashCalib    ) ;
        if ( stat == 0 )
        {
            SysState.Mot.NoCalib = 0 ;
        }
        else
        {
            SysState.Mot.NoCalib = 1 ;
        }
        break ;

    case 252:
    //case 32:// Clear sector of calibration
        stat = SafeEraseFlash(Sector_AppCalib_start, CALIB_SECT_LENGTH )  ;
        if ( stat )
        {
            return GetManufacturerSpecificCode(ERR_COULD_NOT_ERASE_OLD_CALIB) ; ;
        }
        break ;

    case 253:
    //case 33: // Write and verify calibration
        /*
        if ( ul == CalibProg.C.Calib.CalibData)
        {
            CalibFileVer = 0 ;
        }
        else
        {
            if ( ul == ~CalibProg.C.Calib.CalibData)
            {
                CalibFileVer = 1 ;
            }
            else
            {
                return General_parameter_incompatibility_reason;
            }
        }
        */
        if ( CheckAlign ( (short unsigned *) &CalibProg.C.Calib , 1 ))
        {
            return General_parameter_incompatibility_reason ;
        }
        CalibProg.C.Calib.Password0x12345678 = 0x12345678  ; // + CalibFileVer ;
        CalibProg.C.Calib.cs = 0 ;
        uPtr = (unsigned long *) & CalibProg.C.Calib ;
        for ( cnt = 0 ; cnt < ((sizeof(CalibProg.C.Calib)>>1)-1) ; cnt++ )
        {
            CalibProg.C.Calib.cs -= *uPtr++  ;
        }

        stat = SafeEraseFlash(Sector_AppCalib_start,CALIB_SECT_LENGTH)  ;


        if ( stat )
        {
            return GetManufacturerSpecificCode(ERR_COULD_NOT_ERASE_OLD_CALIB) ; ;
        }

        stat = SafeProgramFlash((short unsigned * ) & CalibProg.C.Calib ,Sector_AppCalib_start  , 64 ) ;

        if ( stat )
        {
            SysState.Mot.NoCalib = 1 ;
            return GetManufacturerSpecificCode(ERR_COULD_NOT_BURN_CALIB) ;
//            break ;
        }
        if ( DealCalibration(1) == 0 )
        {
            SysState.Mot.NoCalib = 0 ;
        }
        else
        {
            SysState.Mot.NoCalib = 1 ;
            return GetManufacturerSpecificCode(ERR_COULD_NOT_READ_CALIB) ;
        }

        break ;
    default:
        return Sub_index_does_not_exist ;
    }
    if ( stat )
    {
        return General_parameter_incompatibility_reason ;
    }
    return 0 ;
}



short IsBufferUsedForProgramming(void)
{
    return SysState.IsInParamProgramming ;
}

/**
 * \brief Object 0x2304
 */
long unsigned  GetParamCmd( struct CSdo * pSdo ,short unsigned *nData)
{
    short unsigned si ;
    long unsigned ul ;

    si = pSdo->SubIndex ;
    if ( si == 0 )
    {
        ul = 1024 ;
    }
    else
    {
        if ( si >= 2 && si < 130 )
        {
            ul = RecorderBuffer[SysState.ParamProgSector*128 + si-2] ;
            return 0 ;
        }
        else
        {
            return Sub_index_does_not_exist ;
        }
    }

    * nData = 4 ;
    * ((long *) &pSdo->SlaveBuf[0] ) = ul ;
    return 0 ;
}

long unsigned NVParamsPassWord = 0 ;

/**
 * \brief Object 0x2304 Set parameters command
 */
long unsigned  SetParamCmd( struct CSdo * pSdo ,short unsigned nData)
{
    short unsigned si   ;
    short stat ;
    unsigned long ul ;

    si = pSdo->SubIndex ;
    ul =* ((unsigned long *) pSdo->SlaveBuf);

    // Reject if motor is on
    if ( ClaState.MotorOnRequest)
    {
        return GetManufacturerSpecificCode(ERR_ONLY_FOR_MOTOROFF) ;
    }
    if ( Recorder.Stopped == 0 )
    {
        return GetManufacturerSpecificCode(ERR_RECORDER_BUFF_IN_USE) ;
    }


    if ( si == 1 )
    {
        NVParamsPassWord = ul ;
    }
    if ( (( NVParamsPassWord !=  0x12345678  ) && (si > 249) && (si != 252) ) || nData != 4 )
    {
        return General_parameter_incompatibility_reason ;
    }
    SysState.IsInParamProgramming = 1 ;
    if ( si == 1 )
    {
        stat = SafePrepFlash();
        SysState.ParamProgSector = 0 ;
        if ( stat )
        {
            return General_parameter_incompatibility_reason ;
        }
        return 0 ;
    }

    if ( si >= 2 && si < 130 )
    {
        RecorderBuffer[SysState.ParamProgSector*128 + si-2] = ul ;
        return 0 ;
    }

    switch ( si )
    {

    case 251:
        if ( ul >= 8 )
        {
            SysState.ParamProgSector = ul ;
        }
        else
        {
            return General_parameter_incompatibility_reason ;
        }
        // Determine sub-sector
        break ;
    case 252:
    //case 32:// Clear sector of parameters
        if ( ul == 12345  )
        {
            stat = SafeEraseFlash(Sector_AppParams_start,PARAMS_SECT_LENGTH) ;
        }
        else
        {
            return General_parameter_incompatibility_reason ;
        }
        if ( stat )
        {
            return GetManufacturerSpecificCode(ERR_COULD_NOT_ERASE_OLD_PARAMS) ; ;
        }

        break ;

    default:
        return Sub_index_does_not_exist ;
    }
    return 0 ;
}



/**
 * \brief Find the dictionary item that fits a given index
 *
 * \detail Because of short dictionary, just running over all the records is cheapest
 *
 * \param TargetIndex   : The index to search
 * \param pObject   : The found object record
 * \return index in dictionary if OK, -1 no such object
 *
 * Remark: This routine is reentrant.
 *
 */
short GetObjIndex(short unsigned TargetIndex , struct CObjDictionaryItem **pObject, const struct CObjDictionaryItem *Dict)
{
    short L,R,m ;
    short unsigned Am  ;


    L = 0 ; R = GetOdSize() ;

    for ( ; ; )
    {
        if ( L > R ) return -1 ;
        m = (L+R)>>1 ;
        Am = Dict[m].Index ;
        if ( Am < TargetIndex )
        {
            L = m + 1 ;
            continue ;
        }
        if ( Am > TargetIndex )
        {
            R = m - 1 ;
            continue ;
        }
        break ;
    }
    *pObject =  (struct CObjDictionaryItem *) &Dict[m]  ;
    return m ;
}


long unsigned GetSamplingTime( short unsigned ind)
{
    /*
    if ( ind == 1 )
    {
        return (long)(SysState.Timing.TsTraj * 1e6f ) ;
    }
    */
    return (long)(SysState.Timing.Ts * 1e6f ) ;
}


/**
 * \brief Test if a variable is within the range, clamp it to range if necessary
 *
 * \param x-> Tested (possibly clamped) variable
 * \param xmax : Upper limit
 * \param xmin : Lower limit
 */
short IsInRange( float *x , float xmax , float xmin )
{
    if ( isnan( *x) ) return -1 ;
    if ( *x > xmax )
    {
        *x = xmax ; return 1 ;
    }
    if ( *x < xmin )
    {
        *x = xmin ; return 1 ;
    }
    return 0 ;
}

long unsigned GetManufacturerSpecificCode (long code)
{
    return ( ( code) ? Manufacturer_error_detail +  *(long unsigned*) &code : 0 ) ;
}




/*
 * Set object 0x6098
 */
long unsigned  SetHomingMethod( struct CSdo * pSdo ,short unsigned nData)
{
    short unsigned si = pSdo->SubIndex ;
        if ( si )
        {
            return Sub_index_does_not_exist ;
        }
        if (  (*(short unsigned*) &pSdo->SlaveBuf[0] ) != 35 )
        {
            return General_parameter_incompatibility_reason ;
        }
    return 0 ;
}


/*
 * Set object 0x607a
 */
long unsigned  SetPositionTarget( struct CSdo * pSdo ,short unsigned nData)
{
    short unsigned si = pSdo->SubIndex ;
        if ( si )
        {
            return Sub_index_does_not_exist ;
        }
        SysState.PosControl.PosReference = (*(long unsigned*) &pSdo->SlaveBuf[0] ) * 1e-6f ;
    return 0 ;

}

/* Object 0x2301 */
long unsigned  GetFwCmd(    struct CSdo * pSdo ,short unsigned *nData)
{
    short unsigned si ;
    long unsigned * ulPtr ;
    ulPtr =  ((unsigned long *) pSdo->SlaveBuf);
    si = pSdo->SubIndex ;
    *nData = 4 ;

    switch ( si )
    {
    case 1:
        * ulPtr = FlashProg.PassWord  ;
        break ;
    case 2:
        * ulPtr = FlashProg.InternalBufOffset ;
        break ;
    case 3:
        * ulPtr = PROG_BUF_LEN ;
        break ;

    case 5: // Program identifier
        * ulPtr = PROJ_TYPE  ;
        break ;

    case 6:
        * ulPtr = 1 ;
        break ;

    case 7:
        * ulPtr = SubverPatch ;
        break ;

    case 8:
        * ulPtr = 100 ; // THISCARD ;
        break ;

    default:
        return Sub_index_does_not_exist;
    }

    return 0;
}

void KillCLA(void)
{
    // kill CLA
    EALLOW;

    //MV8 = HWREGH(CLA1_BASE + (uint16_t)CLA_MVECT_8) ;


    NOP ;
    NOP ;
    NOP ;
    NOP ;
    CLA_performHardReset(CLA1_BASE) ;
    NOP ;
    NOP;
    CLA_performSoftReset(CLA1_BASE) ;
    NOP ;
    NOP ;

    //Master Select for LSx RAM:
    // 00: Memory is dedicated to CPU.
    // 01: Memory is shared between CPU and CLA1.
    // 10: Reserved.
    // 11: Reserved.
    EALLOW ;
    HWREG(MEMCFG_BASE + MEMCFG_O_LSXMSEL) = 0 ;
    //Selects LS5 RAM as program or data memory for CLA:
    // 0: CLA Data memory.
    // 1: CLA Program memory.
    HWREG(MEMCFG_BASE + MEMCFG_O_LSXCLAPGM) = 0x0 ; // CLAPGM_LS3..CLAPGM_LS5


    NOP ;
    NOP ;

    //Cla1Regs.MVECT8   = MV8;

    //Cla1Regs.MMEMCFG.all = 0x0 ;
    //asm ("    NOP") ;
    //asm ("    NOP") ;
    EDIS;
}

void ResetCpu( void  )
{
    EALLOW ;
    DINT   ;
    NOP ; // Allow DINT to effect
    KillCLA();
    EALLOW ;
    CLA_mapTaskVector(CLA1_BASE, CLA_MVECT_8, 234) ;
    //((VoidFun)0x80000 )() ; // Fat Bertha from which nobody ever returned
    SysCtl_enableWatchdog() ; // Enable WD
    for (;; );
}


short TestFlashAddress( unsigned long ul )
{
    if ( ul < 0x82000 || ul >= 0xc0000 || ( ul & (PROG_BUF_LEN-1) ) )
    {
        return -1 ;
    }
    return 0 ;
}


/*
 * \brief Object 0x2301
 *
 */
long unsigned  SetFwCmd(    struct CSdo * pSdo ,short unsigned nData)
{
    short unsigned si  ;
    short stat ;
    unsigned long ul , pw ;
    //long mask ;
    si = pSdo->SubIndex ;
    ul =* ((unsigned long *) pSdo->SlaveBuf);

    if ( si == 1 )
    {
        pw = ul ;
    }
    else
    {
        pw = FlashProg.PassWord  ;
    }

    if ( (si != 130) && (  ClaState.MotorOnRequest + ClaState.MotorOn)  )
    {
        return GetManufacturerSpecificCode(ERR_ONLY_FOR_MOTOROFF)  ;
    }

    // Services that do not require flash preparation
    switch ( si)
    {
        case 244: // Back home to boot
            ResetCpu( ) ;
            //((VoidFun)0x80000 )() ; // Fat Bertha from which nobody ever returned
            break ; // Formal
    }

    if ( pw != 0x12345678 || nData != 4 )
    {
        return General_parameter_incompatibility_reason ;
    }

    switch ( si )
    {
    case 1:
        //mask = BlockInts() ;
        //stat = PrepFlash4Burn();
        //RestoreInts(mask) ;
        FlashProg.PassWord = ul ;
        //if ( stat )
        //{
        //    return General_parameter_incompatibility_reason ;
        //}
        break ; // Already accepted
    case 2:
        if ( ul > PROG_BUF_LEN - 256 )
        {
            return General_parameter_incompatibility_reason ;
        }
        FlashProg.InternalBufOffset = (short unsigned) ul ;
        break;
    case 100:
        if ( TestFlashAddress(ul) < 0   )
        {
            return General_parameter_incompatibility_reason ;
        }
        FlashProg.AddressInFlash = ul ;
        break ;
    case 130: // Clear section
        if ( ul != 31 )
        {
             return General_parameter_incompatibility_reason ;
        }
        stat = SafeEraseFlash(Sector_AppVerify_start,IDENTITY_SECT_LENGTH);

        if ( stat )
        {
            return GetManufacturerSpecificCode(ERR_COULD_NOT_CLEAR_STAT) ;
        }
        break ;
    case 131: // Program buffer
        //if ( stat )
        {
            return General_parameter_incompatibility_reason ;
        }
        //break ;


    case 245: // Back home to boot, Reset PD first

        LogException(EXP_FATAL, exp_reboot_request_submit ) ;
        WaitStam(20000, &SysTimerStr) ; // Wait interrupts to complete SDO send

        // Time to commit suicide
        ResetCpu( ); // ((VoidFun)0x80000 )() ; // Fat Bertha from which nobody ever returned
        break ; //Formal
    default:
        return Sub_index_does_not_exist;
    }
    return 0 ;
}


short SetSystemMode(short  x)
{
    short RetVal  ;

    if ( x == ClaState.SystemMode )
    { // Nothing to do
        return 0 ;
    }

    RetVal = 0 ;
    // Test reset ability
    if (  ClaState.SystemMode == E_SysMotionModeFault )
    {
        if ( IsResetBlocked() )
        {
            RetVal = ERR_SERIOUS_ERROR ;
        }
        else
        {
            SysState.Mot.MotorFault = 0 ;
        }
    }

// Transition to automatic - only if calibrated
    if ( x == E_SysMotionModeAutomatic)
    {
        if ( SysState.Mot.NoCalib )
        {
            RetVal = ERR_CALIBRATION_MISSING ;
        }
    }
    else
    {
        SysState.SteerCorrection.bSteeringComprensation  = 0 ;
    }

    if ( RetVal)
    { // IF failed then the next mode is FAULT
        x = E_SysMotionModeFault ;
    }

//    short unsigned mask ;
    if ((x <= E_SysMotionModeAutomatic) && ( x >= E_SysMotionModeSafeFault) )
    { // On mode change , nothing can execute
        if ( x == E_SysMotionModeFault )
        {
            ClaState.MotorOnRequest = 0 ; // Kill Cla
            SysState.Mot.BrakeControlOverride = 0 ;
            SysState.Mot.QuickStop = 1;
        }


        if ( x == E_SysMotionModeAutomatic)
        {
            if ( SysState.Mot.LoopClosureMode <= E_LC_OpenLoopField_Mode )
            {
                LogException( EXP_SAFE_FATAL , exp_auto_mode_requires_closedloop);
            }
            /*
            if ( ClaState.MotorOnRequest || ClaState.MotorOn )
            {
                LogException( EXP_SAFE_FATAL , exp_auto_mode_transition_requires_motoroff);
            }
            */
        }

        if ( ClaState.SystemMode == E_SysMotionModeFault )
        {
            SetMotorOff(E_OffForFinal) ;
            HallDecode.Init = 0 ;
        }

        if ( ClaState.SystemMode == E_SysMotionModeAutomatic)
        { // Changing from automatic
            SysState.Mot.CurrentLimitFactor = 1 ;
            SysState.Mot.QuickStop = 1;
        }

        if ( ClaState.SystemMode == E_SysMotionModeSafeFault )
        {
            SysState.Mot.QuickStop = 1;
        }

        ClaState.SystemMode = x ;
        SysState.CBit.bit.SystemMode = ((short) x ) & 7 ;
//        RestoreInts(mask) ;
    }
    if( RetVal)
    {
        SysState.Mot.MotorFault = 1 ;
    }
    return RetVal  ;
}



