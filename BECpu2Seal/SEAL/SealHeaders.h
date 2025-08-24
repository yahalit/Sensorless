/*
 * SealHeaders.h
 *
 *  Created on: 23 баев„ 2025
 *      Author: Yahali
 */

#ifndef SEAL_SEALHEADERS_H_
#define SEAL_SEALHEADERS_H_

#ifdef SEAL_EXT_TAG
#undef SEAL_EXT_TAG
#endif

#ifdef SEAL_VARS_OWNER
#define SEAL_EXT_TAG
#else
#define SEAL_EXT_TAG extern
#endif


//#include "..\..\BEMain\Core2Interface\SealTypedefs.h"
//#include "..\..\BEMain\Core2Interface\SealInterface.h"
#include ".\Automatic\rtwtypes.h"
#include "Seal_errorcodes.h"
#include ".\Automatic\Seal.h"

enum E_FunType
{
    E_Func_None = 0,
    E_Func_Initializer = 1,
    E_Func_Idle = 2,
    E_Func_ISR = 3,
    E_Func_Setup = 4,
    E_FuncException = 5 ,
    E_FuncAbort = 6
};


typedef void (*voidFunc)(void);
typedef struct
{
    voidFunc func;
    float Ts;
    enum E_FunType FunType;
    short unsigned nInts  ;
    short unsigned Priority   ;
    short unsigned Algn;
    long  long     Ticker; // Interrupt counter on execution
} FuncDescriptor_T;

typedef  union
{
    FuncDescriptor_T desc ;
    unsigned short us[16] ;
}UFuncDescriptor_T;

#ifdef SEAL_VARS_OWNER
const char unsigned GenesisVerse[196] = "In the beginning God created the heaven and the earth. And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters";
#pragma DATA_SECTION (GenesisVerse,".GenesisVerse")
#include ".\Automatic\ExternSeal.h"
#else
extern const char unsigned GenesisVerse[];
#endif

#define MAX_TICKS_DELTA_4_EXCEPTION 16383

#define N_FUNC_DESCRIPTORS 16


typedef union
{
    short unsigned us[4] ;
    long unsigned ul[2] ;
    float f[2] ;
    long l[2] ;
    short s[4] ;
    long long ll ;
    long long unsigned ull ;
}UMultiTypeLL_T;

typedef union
{
    short unsigned us[2] ;
    long unsigned ul ;
    float f ;
    long l ;
    short s[2] ;
}UMultiType_T;


typedef struct
{
    short AbortRequest ;
    short AbortiveException ;
    short AbortHonored ;
    short Algn ;
    UMultiTypeLL_T InterruptCnt ;
    float Ts ;
} SealState_T;

SEAL_EXT_TAG SealState_T SealState ;


typedef struct
{
    short unsigned nIdleFuncs;
    short unsigned nIsrFuncs;
    short unsigned nInitFuncs;
    short unsigned nSetupFuncs;
    short unsigned nExceptionFuncs ;
    short unsigned nAbortFuncs ;

    UFuncDescriptor_T InitalizerFunc;
    UFuncDescriptor_T SetupFunc ;
    UFuncDescriptor_T IdleFuncs[N_FUNC_DESCRIPTORS];
    UFuncDescriptor_T IsrFuncs[N_FUNC_DESCRIPTORS];
    UFuncDescriptor_T ExceptionFuncs[N_FUNC_DESCRIPTORS];
    UFuncDescriptor_T AbortFuncs[N_FUNC_DESCRIPTORS];

    DrvCommandBuf_T* pDrvCommandBuf;
    FeedbackBuf_T* pFeedbackBuf;
    SetupReportBuf_T* pSetupReportBuf;
    CANCyclicBuf_T* pCANCyclicBuf_in;
    CANCyclicBuf_T* pCANCyclicBuf_out;
    UartCyclicBuf_T* pUartCyclicBuf_in;
    UartCyclicBuf_T* pUartCyclicBuf_out;
    SEALVerControl_T* pSEALVerControl;

} SealSetup_T;

SEAL_EXT_TAG SealSetup_T SealSetup ;


#include "SealFunctions.h"


#endif /* SEAL_SEALHEADERS_H_ */
