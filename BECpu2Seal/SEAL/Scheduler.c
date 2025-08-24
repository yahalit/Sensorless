/*
 * Scheduler.c
 *
 *  Created on: 23 Aug 2025
 *      Author: Yahali
 */


#include "..\Application\StructDef2.h"
#include "SealHeaders.h"


// Local functions
static void SealLoop();

typedef short unsigned* bPtr;

#define SEAL_MODULE_ADDRESS 0x84000UL





const short unsigned** SM_BufferPtrs = (const short unsigned**)(SEAL_MODULE_ADDRESS+0x40);
const short unsigned** SM_FuncDescriptorPtrs = (const short unsigned**)(SEAL_MODULE_ADDRESS + 0x80);
const short unsigned* pSealRevision = (const short unsigned*)(SEAL_MODULE_ADDRESS + 0xb0);
const short unsigned* pGenesisVerse = (const short unsigned*)(SEAL_MODULE_ADDRESS + 0xc0);
const UFuncDescriptor_T *FuncDescriptor = (const UFuncDescriptor_T*)(SEAL_MODULE_ADDRESS + 0x100);

const short unsigned SealExpectedVersions[4] = {1,2,3,4} ;

volatile short unsigned RunSealIdleLoop;

long long TickerValue;
short unsigned nIdleRun;

float GetControlTs()
{
    return 50e-6f ;
}


static void InitSealData(void)
{
    ClearMem((short unsigned *)&FuncDescriptor[0], sizeof(FuncDescriptor));
    ClearMem((short unsigned *)&SealState, sizeof(SealState));
    SealState.Ts = GetControlTs();
}


void main()
{
    // Test that Baruch Gamili is there
    short cnt, verseGood , versionGood , eol , funcgood ;

    float quo;

    InitSealData() ;

    verseGood = 1;
    for (cnt = 0; cnt < 53; cnt++)
    {
        if (GenesisVerse[cnt] != ((char*)pGenesisVerse)[cnt])
        {
            verseGood = 0;
        }
    }
    versionGood = 1;
    for (cnt = 0; cnt < 4; cnt++)
    {
        if (pSealRevision[cnt] != SealExpectedVersions[cnt])
        {
            versionGood  = 0;
        }
    }

    if (verseGood && versionGood)
    {
        SealSetup.pDrvCommandBuf = (DrvCommandBuf_T*)SM_BufferPtrs[0];
        SealSetup.pFeedbackBuf = (FeedbackBuf_T*)SM_BufferPtrs[1];
        SealSetup.pSetupReportBuf = (SetupReportBuf_T*)SM_BufferPtrs[2];
        SealSetup.pCANCyclicBuf_in = (CANCyclicBuf_T*)SM_BufferPtrs[3];
        SealSetup.pCANCyclicBuf_out = (CANCyclicBuf_T*)SM_BufferPtrs[4];
        SealSetup.pUartCyclicBuf_in = (UartCyclicBuf_T*)SM_BufferPtrs[5];
        SealSetup.pUartCyclicBuf_out = (UartCyclicBuf_T*)SM_BufferPtrs[6];
        SealSetup.pSEALVerControl = (SEALVerControl_T*)SM_BufferPtrs[7];
    }

    // Read the descriptor of functions
    eol = 0;
    SealSetup.nIdleFuncs = 0;
    SealSetup.nIsrFuncs = 0;
    SealSetup.nInitFuncs = 0;
    SealSetup.SetupFunc.desc.func = (voidFunc) 0;
    funcgood = 1;

    for (cnt = 0; cnt < N_FUNC_DESCRIPTORS ; cnt++ )
    {
        if (FuncDescriptor[cnt].desc.func == (voidFunc) 0 )
        {
            break;
        }
        switch (FuncDescriptor[cnt].desc.FunType)
        {
        case E_Func_Initializer:
            SealSetup.InitalizerFunc = FuncDescriptor[cnt];
            SealSetup.nInitFuncs += 1;
            break;
        case E_Func_Idle:
            SealSetup.IdleFuncs[SealSetup.nIdleFuncs].desc = FuncDescriptor[cnt].desc;
            SealSetup.nIdleFuncs += 1;
            break;
        case E_Func_ISR:
            SealSetup.IsrFuncs[SealSetup.nIsrFuncs].desc = FuncDescriptor[cnt].desc;
            SealSetup.nIsrFuncs += 1;
            quo = SealSetup.IsrFuncs[SealSetup.nIsrFuncs].desc.Ts / __fmax( SealState.Ts , 1.e-6f)  ;
            SealSetup.IsrFuncs[SealSetup.nIsrFuncs].desc.nInts = (short unsigned)(quo + 0.001);
            if (quo < 0.999f ||  fabsf(quo - SealSetup.IsrFuncs[SealSetup.nIsrFuncs].desc.nInts ) > 0.001f)
            {
                funcgood = 0 ;
            }
            break;
        case E_Func_Setup:
            SealSetup.SetupFunc= FuncDescriptor[cnt];
            SealSetup.nSetupFuncs += 1;
            break;
        default:
            eol = 1;
            break;
        }
        if (eol)
        {
            break;
        }
    }
    // Check one and only init func
    if (SealSetup.nSetupFuncs != 1)
    {
        funcgood = 0;
    }
    if (SealSetup.nInitFuncs != 1)
    {
        funcgood = 0;
    }
    RunSealIdleLoop = 0;
    if (funcgood)
    {

        PrepSetupReportBuf(SealSetup.pSetupReportBuf); // Done once

        // Initializer
        SealSetup.InitalizerFunc.desc.func();

        // Setup function array
        SealSetup.SetupFunc.desc.func();

        TickerValue = SealState.InterruptCnt.ll ;

        for (cnt = 0; cnt < N_FUNC_DESCRIPTORS; cnt++)
        {
            SealSetup.IsrFuncs[cnt].desc.Ticker = TickerValue;
            SealSetup.IdleFuncs[cnt].desc.Ticker = TickerValue;
        }
        nIdleRun = 0;
        while (RunSealIdleLoop == 0)
        {
            SealLoop();
        }
    }
}

void GetInterruptCounter( long long *llPtr )
{
    *llPtr  = 0 ;
}


static void SealLoop()
{
    short unsigned cnt;
    short bestPrio , nfunc , prio ;
    UMultiType_T delta_ticker;
    FuncDescriptor_T * pDesc ;

    voidFunc NextFunc2Call;

    GetInterruptCounter( &SealState.InterruptCnt.ll ) ;
    TickerValue  = SealState.InterruptCnt.ll;
    // Queue interrupts
    bestPrio = -1;
    NextFunc2Call = (voidFunc)0;
    nfunc = 0;

    if ( SealState.AbortRequest * SealState.AbortiveException == 0)
    {
        for (cnt = 0; cnt < SealSetup.nIsrFuncs; cnt++)
        {
            pDesc = &SealSetup.IsrFuncs[cnt].desc;
            delta_ticker.l = TickerValue - pDesc->Ticker;
            if (delta_ticker.us[1] || (delta_ticker.us[0] > MAX_TICKS_DELTA_4_EXCEPTION) )
            {
                ThrowSealException(E_FATAL, seal_error_ticker_overflow) ;
            }
            if (delta_ticker.us[0] > pDesc->nInts)
            {
                prio = delta_ticker.us[0] - pDesc->nInts + pDesc->Priority;
                if (prio > bestPrio)
                {
                    bestPrio = prio;
                    nfunc = cnt;
                }
            }
        }
    }
    else
    {
        if (SealState.AbortHonored == 0)
        {
            SealState.AbortHonored = 1;
            if (SealState.AbortiveException)
            {
                for (cnt = 0; cnt < SealSetup.nExceptionFuncs; cnt++)
                {
                    SealSetup.ExceptionFuncs[cnt].desc.func();
                }
            }
            for (cnt = 0; cnt < SealSetup.nAbortFuncs; cnt++)
            {
                SealSetup.AbortFuncs[cnt].desc.func();
            }
        }
    }

    if (bestPrio >= 0)
    {
        NextFunc2Call = SealSetup.IsrFuncs[nfunc].desc.func;
        SealSetup.IsrFuncs[nfunc].desc.Ticker = TickerValue;
    }
    else
    {
        NextFunc2Call = SealSetup.IdleFuncs[nIdleRun].desc.func;
        nIdleRun += 1;
        if (nIdleRun >= SealSetup.nIdleFuncs)
        {
            nIdleRun = 0;
        }
    }

    if (NextFunc2Call == (voidFunc) 0 )
    {
        return;
    }

    // Decide next function to call

    // Prepare for the go
    PrepFeedbackBuf( SealSetup.pFeedbackBuf );

    NextFunc2Call();

    SealSetup.pDrvCommandBuf->bSetSealControl = 1 ;
    UpdateDrvCmdBuf( SealSetup.pDrvCommandBuf);

}

