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


#include "..\..\BEMain\Core2Interface\SealTypedefs.h"
#include "..\..\BEMain\Core2Interface\SealInterface.h"
#include "Seal_errorcodes.h"

#define MAX_TICKS_DELTA_4_EXCEPTION 16383

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
    double SystemTime ; // System time counted in seconds
    float Ts ;
} SealState_T;

SEAL_EXT_TAG SealState_T SealState ;


SEAL_EXT_TAG CANCyclicBuf_T  CANCyclicBuf_out;/* '<Root>/G_CANCyclicBuf_out' */
SEAL_EXT_TAG CANCyclicBuf_T  CANCyclicBuf_in;/* '<Root>/G_CANCyclicBuf_in' */
SEAL_EXT_TAG UartCyclicBuf_T UartCyclicBuf_in;/* '<Root>/G_UartCyclicBuf_in' */
SEAL_EXT_TAG UartCyclicBuf_T UartCyclicBuf_out;/* '<Root>/G_UartCyclicBuf_out' */


typedef struct
{
    short unsigned nIdleFuncs;
    short unsigned nIsrFuncs;
    short unsigned nInitFuncs;
    short unsigned nSetupFuncs;
    short unsigned nExceptionFuncs ;
    short unsigned nAbortFuncs ;

    FuncDescriptor_T IdleFuncs[N_FUNC_DESCRIPTORS];
    FuncDescriptor_T IsrFuncs[N_FUNC_DESCRIPTORS];
    FuncDescriptor_T ExceptionFuncs[N_FUNC_DESCRIPTORS];
    FuncDescriptor_T AbortFuncs[N_FUNC_DESCRIPTORS];

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
