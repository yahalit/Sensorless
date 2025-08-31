/*
 * Scheduler.c
 *
 *  Created on: 23 Aug 2025
 *      Author: Yahali
 */
#define SEAL_VARS_OWNER

#include "rtwtypes.h"
#include "..\Application\StructDef2.h"
#include "SealHeaders.h"


// Local functions
static void SealLoop();

typedef short unsigned* bPtr;

/*
FLASH_MODULE_SETUP_CALL_PTR : origin = 0x10001c, length = 0x2
FLASH_MODULE_INIT_CALL_PTR : origin = 0x10001e, length = 0x2
FLASH_BUFFER_PTRS : origin = 0x100020, length = 0x20
FLASH_ISR_FUNC_PTRS : origin = 0x100040, length = 0x20
FLASH_IDLE_FUNC_PTRS : origin = 0x100060, length = 0x20
FLASH_EXCEPTION_FUNC_PTRS : origin = 0x100080, length = 0x20
FLASH_ABORT_FUNC_PTRS : origin = 0x1000a0, length = 0x20
FLASH_SEAL_REV        : origin = 0x1000c0, length = 0x40
FLASH_GENESIS_VERSE   : origin = 0x100100, length = 0xc4
*/



#define SEAL_MODULE_ADDRESS 0x100000UL
const char unsigned GenesisVerse[196] = "In the beginning God created the heaven and the earth. And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters";
const short unsigned* pGenesisVerse = (const short unsigned*)(SEAL_MODULE_ADDRESS+100UL);

const short unsigned**SM_BufferPtrs = (const short unsigned**)(SEAL_MODULE_ADDRESS+0x20);
#define SM_InitDescriptor  ((voidFunc)(SEAL_MODULE_ADDRESS + 0x1e))
#define SM_SetupDescriptor ((voidFunc)(SEAL_MODULE_ADDRESS + 0x1c))

const UFuncDescriptor_T* SM_IsrDescriptorPtrs = (const UFuncDescriptor_T*)(SEAL_MODULE_ADDRESS + 0x40);
const UFuncDescriptor_T* SM_IdleLoopDescriptorPtrs = (const UFuncDescriptor_T*)(SEAL_MODULE_ADDRESS + 0x60);
const UFuncDescriptor_T* SM_ExceptionDescriptorPtrs = (const UFuncDescriptor_T*)(SEAL_MODULE_ADDRESS + 0x80);
const UFuncDescriptor_T* SM_AbortDescriptorPtrs = (const UFuncDescriptor_T*)(SEAL_MODULE_ADDRESS + 0xa0);

const short unsigned* pSealRevision = (const short unsigned*)(SEAL_MODULE_ADDRESS + 0xc0);


TestLegitimateEntryPoint( voidFunc fun , short * funcgood)
{
    long unsigned num = (uint32_T) fun ;
    if (( num < (SEAL_MODULE_ADDRESS+0x200) ) || (num > (SEAL_MODULE_ADDRESS+0x1FFF0)) )
    {
        *funcgood = 0 ;
    }
}


const short unsigned SealExpectedVersions[4] = {1,2,3,4} ;

volatile short unsigned RunSealIdleLoop;

long long TickerValue;
short unsigned nIdleRun;

static void InitSealData(void)
{
    ClearMem((short unsigned *)&SealState, sizeof(SealState));
    SealState.Ts = UM2S.M2S.ControlTs;
}


void GoSeal()
{
    // Test that Bereshit verse is there
    short cnt, verseGood , versionGood ,  funcgood ;

    float quo;

    InitSealData() ;

    verseGood = 1;
    for (cnt = 0; cnt < 192; cnt++)
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
        SealSetup.pSEALVerControl = (SEALVerControl_T*)SM_BufferPtrs[7];
		// Transfer pointers to the communication buffers 
        *((CANCyclicBuf_T**)SM_BufferPtrs[3])  = &CANCyclicBuf_in  ;
        *((CANCyclicBuf_T**)SM_BufferPtrs[4])  = &CANCyclicBuf_out ;

        *((UartCyclicBuf_T**)SM_BufferPtrs[5])  = &UartCyclicBuf_in  ;
        *((UartCyclicBuf_T**)SM_BufferPtrs[6])  = &UartCyclicBuf_out ;

    }

    // Read the descriptor of functions
    SealSetup.nIdleFuncs = 0;
    SealSetup.nIsrFuncs = 0;
    SealSetup.nExceptionFuncs = 0;
    SealSetup.nAbortFuncs = 0;
    SealSetup.nInitFuncs = 0;
    funcgood = 1;

    for (cnt = 0; cnt < N_FUNC_DESCRIPTORS ; cnt++ )
    {
        if (SM_IsrDescriptorPtrs[cnt].desc.func != (voidFunc) 0 )
        {
            SealSetup.IsrFuncs[SealSetup.nIsrFuncs] = SM_IsrDescriptorPtrs[cnt].desc;
            SealSetup.nIsrFuncs += 1;
            quo = SealSetup.IsrFuncs[SealSetup.nIsrFuncs].Ts / __fmax( SealState.Ts , 1.e-6f)  ;
            SealSetup.IsrFuncs[SealSetup.nIsrFuncs].nInts = (short unsigned)(quo + 0.001);
            if (quo < 0.999f ||  fabsf(quo - SealSetup.IsrFuncs[SealSetup.nIsrFuncs].nInts ) > 0.001f)
            {
                funcgood = 0 ;
            }
            else
            {
                funcgood = TestLegitimateEntryPoint( SM_IsrDescriptorPtrs[cnt].desc.func, &funcgood) ;
            }
        }

        if (SM_IdleLoopDescriptorPtrs[cnt].desc.func != (voidFunc) 0 )
        {
            SealSetup.IdleFuncs[SealSetup.nIdleFuncs] = SM_IdleLoopDescriptorPtrs[cnt].desc;
            SealSetup.nIdleFuncs += 1;
            funcgood = TestLegitimateEntryPoint( SM_IdleLoopDescriptorPtrs[cnt].desc.func, &funcgood) ;
        }

        if (SM_ExceptionDescriptorPtrs[cnt].desc.func != (voidFunc) 0 )
        {
            SealSetup.ExceptionFuncs[SealSetup.nExceptionFuncs] = SM_ExceptionDescriptorPtrs[cnt].desc;
            SealSetup.nExceptionFuncs += 1;
            funcgood = TestLegitimateEntryPoint( SM_ExceptionDescriptorPtrs[cnt].desc.func, &funcgood) ;
        }

        if (SM_AbortDescriptorPtrs[cnt].desc.func != (voidFunc) 0 )
        {
            SealSetup.IdleFuncs[SealSetup.nAbortFuncs] = SM_AbortDescriptorPtrs[cnt].desc;
            SealSetup.nAbortFuncs += 1;
            funcgood = TestLegitimateEntryPoint( SM_AbortDescriptorPtrs[cnt].desc.func, &funcgood) ;
        }
        funcgood = 0 ; // Unknown
    }

    if (SM_SetupDescriptor != (voidFunc)0)
    {
        funcgood = TestLegitimateEntryPoint( SM_SetupDescriptor, &funcgood) ;
    }
    funcgood = TestLegitimateEntryPoint( SM_InitDescriptor, &funcgood) ;

    // Check one and only init func
    RunSealIdleLoop = 0;
    if (funcgood)
    {

        PrepSetupReportBuf(SealSetup.pSetupReportBuf); // Done once

        // Initializer
        SM_InitDescriptor();

        // Setup function (if defined)
        if (SM_SetupDescriptor != (voidFunc)0)
        {
            SM_SetupDescriptor();
        }

        TickerValue = SealState.InterruptCnt.ll ;

        for (cnt = 0; cnt < N_FUNC_DESCRIPTORS; cnt++)
        {
            SealSetup.IsrFuncs[cnt].Ticker = TickerValue;
            SealSetup.IdleFuncs[cnt].Ticker = TickerValue;
        }
        nIdleRun = 0;
        while (RunSealIdleLoop == 0)
        {
            TestAvailableConnections();

            SealLoop();
        }
    }
}




static void SealLoop()
{
    short unsigned cnt;
    short bestPrio , nfunc , prio ;
    UMultiType_T delta_ticker;
    FuncDescriptor_T * pDesc ;

    voidFunc NextFunc2Call;

    TickerValue  = SealState.InterruptCnt.ll;
    // Queue interrupts
    bestPrio = -1;
    NextFunc2Call = (voidFunc)0;
    nfunc = 0;

    if ( SealState.AbortRequest * SealState.AbortiveException == 0)
    {
        for (cnt = 0; cnt < SealSetup.nIsrFuncs; cnt++)
        {
            pDesc = &SealSetup.IsrFuncs[cnt];
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
                    SealSetup.ExceptionFuncs[cnt].func();
                }
            }
            for (cnt = 0; cnt < SealSetup.nAbortFuncs; cnt++)
            {
                SealSetup.AbortFuncs[cnt].func();
            }
        }
    }

    if (bestPrio >= 0)
    {
        NextFunc2Call = SealSetup.IsrFuncs[nfunc].func;
        SealSetup.IsrFuncs[nfunc].Ticker = TickerValue;
    }
    else
    {
        NextFunc2Call = SealSetup.IdleFuncs[nIdleRun].func;
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

