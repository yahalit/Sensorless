/*
 * Testing.c
 *
 *  Created on: Jun 6, 2023
 *      Author: yahali
 */
#include "StructDef.h"

/* Start the action - clear all the summations */
void CF_StartTime(void)
{

    if ( ( Correlations.nSamplesForFullTake < 2 ) || (Correlations.nCyclesInTake  < 1 ))
    { // Ilegal, abandon
        Correlations.state     = ECF_Inactive ;
    }

    SysState.Debug.TRef.On = 1 ;
    SysState.Debug.GRef.On = 1 ;
    SysState.Debug.TRef.Time = Correlations.TRefPhase;
    SysState.Debug.GRef.Time = 0;

    TRefGenPars.f = (float) Correlations.nCyclesInTake / ( Correlations.nSamplesForFullTake * SysState.Timing.Ts ) ;
    Correlations.nTakesCnt = 0 ;
    Correlations.nInCycleCnt = 0xffff ;
    Correlations.sCor1[0] = 0 ; // Sine
    Correlations.sCor1[1] = 0 ;
    Correlations.sCor1[2] = 0 ;

    Correlations.cCor1[0] = 0 ; // Cosine
    Correlations.cCor1[1] = 0 ;
    Correlations.cCor1[2] = 0 ;

    Correlations.aCor1[0] = 0 ; // Constant
    Correlations.aCor1[1] = 0 ;
    Correlations.aCor1[2] = 0 ;

    Correlations.tCor1[0] = 0 ; // Trend
    Correlations.tCor1[1] = 0 ;
    Correlations.tCor1[2] = 0 ;

    Correlations.sCor2[0] = 0 ;
    Correlations.sCor2[1] = 0 ;
    Correlations.sCor2[2] = 0 ;

    Correlations.cCor2[0] = 0 ;
    Correlations.cCor2[1] = 0 ;
    Correlations.cCor2[2] = 0 ;

    Correlations.aCor2[0] = 0 ;
    Correlations.aCor2[1] = 0 ;
    Correlations.aCor2[2] = 0 ;

    Correlations.tCor2[0] = 0 ;
    Correlations.tCor2[1] = 0 ;
    Correlations.tCor2[2] = 0 ;

    Correlations.SumS2 = 0 ;
    Correlations.SumC2 = 0 ;
    Correlations.Sum1  = 0 ;
    Correlations.SumT2 = 0 ;
    Correlations.SumSC = 0 ;
    Correlations.SumST = 0 ;
    Correlations.SumS  = 0 ;
    Correlations.sumCT = 0 ;
    Correlations.SumC  = 0 ;
    Correlations.SumT  = 0 ;
    Correlations.Sum1  = 0 ;



    Correlations.CorTime  = 0 ;
    Correlations.state     = ECF_WaitStabilize ;
}

// Correlations inactive - do nothing
void CF_Inactive(void)
{

}
// Correlations inactive as done - do nothing
void CF_Done(void)
{

}

void CF_sumCorr2(void)
{
    float a , b, c ;
    if ( Correlations.nTakesCnt == Correlations.nSumTakes )
    {
        Correlations.nTakesCnt = 0 ;
        SysState.Debug.TRef.On = 0 ;
        Correlations.state = ECF_Done ;
        SysState.Debug.TRef.On = 0 ;
        SysState.Debug.GRef.On = 0 ;
        return ;
    }
    a = *Correlations.fPtrs[0] ;
    b = *Correlations.fPtrs[1] ;
    c = *Correlations.fPtrs[2] ;

    Correlations.sCor2[0] += SysState.Debug.TRef.sinwt * a ;
    Correlations.sCor2[1] += SysState.Debug.TRef.sinwt * b ;
    Correlations.sCor2[2] += SysState.Debug.TRef.sinwt * c ;

    Correlations.cCor2[0] += SysState.Debug.TRef.coswt * a ;
    Correlations.cCor2[1] += SysState.Debug.TRef.coswt * b ;
    Correlations.cCor2[2] += SysState.Debug.TRef.coswt * c ;

    Correlations.aCor2[0] += a ;
    Correlations.aCor2[1] += b ;
    Correlations.aCor2[2] += c ;

    Correlations.tCor2[0] += a * Correlations.CorTime ;
    Correlations.tCor2[1] += b * Correlations.CorTime ;
    Correlations.tCor2[2] += c * Correlations.CorTime ;


    Correlations.CorTime += 1.0f ;
}

void CF_sumCorr(void)
{
    float a , b , c ;
    if ( Correlations.nTakesCnt == Correlations.nSumTakes )
    {
        Correlations.nTakesCnt = 0 ;
        Correlations.state = ECF_sumCorr2  ;
        Correlations.CorTime  = -0.5f * ( Correlations.nSamplesForFullTake * Correlations.nSumTakes ) + 0.5f ;
        CF_sumCorr2() ; // Go to 2nd take
        return ;
    }
    a = *Correlations.fPtrs[0] ;
    b = *Correlations.fPtrs[1] ;
    c = *Correlations.fPtrs[2] ;

    Correlations.sCor1[0] += SysState.Debug.TRef.sinwt * a ;
    Correlations.sCor1[1] += SysState.Debug.TRef.sinwt * b ;
    Correlations.sCor1[2] += SysState.Debug.TRef.sinwt * c ;

    Correlations.cCor1[0] += SysState.Debug.TRef.coswt * a ;
    Correlations.cCor1[1] += SysState.Debug.TRef.coswt * b ;
    Correlations.cCor1[2] += SysState.Debug.TRef.coswt * c ;

    Correlations.aCor1[0] += a ;
    Correlations.aCor1[1] += b ;
    Correlations.aCor1[2] += c ;

    Correlations.tCor1[0] += a * Correlations.CorTime ;
    Correlations.tCor1[1] += b * Correlations.CorTime ;
    Correlations.tCor1[2] += c * Correlations.CorTime ;

    Correlations.SumS2 += SysState.Debug.TRef.sinwt * SysState.Debug.TRef.sinwt  ;
    Correlations.SumC2 += SysState.Debug.TRef.coswt * SysState.Debug.TRef.coswt  ;
    Correlations.SumT2 += Correlations.CorTime * Correlations.CorTime  ;
    Correlations.SumSC += SysState.Debug.TRef.sinwt * SysState.Debug.TRef.coswt ;
    Correlations.SumST += SysState.Debug.TRef.sinwt * Correlations.CorTime ;
    Correlations.SumS  += SysState.Debug.TRef.sinwt ;
    Correlations.sumCT += SysState.Debug.TRef.coswt * Correlations.CorTime ;
    Correlations.SumC  += SysState.Debug.TRef.coswt  ;
    Correlations.SumT  += Correlations.CorTime       ;
    Correlations.Sum1  += 1 ;



    Correlations.CorTime += 1.0f ;
}

// Wait stabilization
void CF_WaitStabilize(void)
{
    if ( Correlations.nTakesCnt == Correlations.nWaitTakes )
    {
        Correlations.state = ECF_sumCorr ;
        Correlations.nTakesCnt = 0  ;
        Correlations.CorTime  = -0.5f * ( Correlations.nSamplesForFullTake * Correlations.nSumTakes ) + 0.5f ;
        CF_sumCorr() ; // Begin to sum
    }
}


typedef void (*CorrFuncsType)(void);
CorrFuncsType CorrFuncs[] = {CF_Inactive,CF_StartTime,CF_WaitStabilize,CF_sumCorr,CF_sumCorr2,CF_Done};

/*
 * Get correlations to the sine for frequency response identification
 */
void GetSinCorrelation(void)
{
    // Advance counters, decide cycle package
    Correlations.nInCycleCnt += 1;
    if ( Correlations.nInCycleCnt == Correlations.nSamplesForFullTake)
    {
        Correlations.nInCycleCnt   = 0 ;
        Correlations.nTakesCnt     += 1 ;
    }
    CorrFuncs[Correlations.state]();
}


void RefGen(struct  CRefGenPars *pPars , struct CRefGenState *pState , float dt )
{
    float InvDuty , d , a , b , Out , dOut , slope  ;
    pState->Time = __fracf32(pState->Time + pPars->f * dt ) ;
    pState->sinwt = __sinpuf32( pState->Time  ) ;
    pState->coswt = __cospuf32( pState->Time  ) ;

    switch ( pState->Type * pState->On )
    {
    case E_S_Fixed:
        d = pState->State  ;
        if ( pPars->Amp > 0 )
        {
            slope = pPars->Amp * dt * pPars->f ;
            pState->State = pState->State + __fmax( __fmin( pPars->Dc - pState->State , slope ) , -slope ) ;
            dOut = ( pState->State - d ) / dt ;
        }
        else
        {
            pState->State = pPars->Dc ;
            dOut = 0 ;
        }
        Out  = pState->State ;
        break ;
    case E_S_Sine:
        Out   = pPars->Dc + pPars->Amp * pState->sinwt ;
        dOut  = Pi2 * pPars->f * pPars->Amp * pState->coswt ;
        break ;
    case E_S_Square:
        b = pPars->Amp ;
        a = 2 * b ;
        Out   = pPars->Dc - b + a * (pState->Time > pPars->Duty ? 0.0f : 1.0f ) ;
        dOut = 0 ;
        break ;
    case E_S_Triangle:
        b = pPars->Amp ;
        a = 2 * b ;
        if ( pState->Time < pPars->Duty  )
        {
            InvDuty = 1.0f / __fmax(pPars->Duty, pPars->f * dt );
            d =  a * InvDuty  ;
            Out   = pPars->Dc - b + d * pState->Time   ;
        }
        else
        {
            InvDuty = 1.0f / __fmax(1-pPars->Duty, pPars->f * dt );
            d =  -a * InvDuty  ;
            Out   = pPars->Dc - b + ( pState->Time-1)* d ;
        }
        dOut =  d * pPars->f ;

        break ;
    default:
        pState->State = 0 ;
        pState->Time = 0 ; // If off Time is reset
        Out = 0 ;
        dOut = 0 ;
    }
    if ( pPars->bAngleSpeed )
    {
        pState->dOut = Out ;
        Out  = pState->Out + dt * pState->dOut ;
        if ( Out < 0 )
        {
            Out += pPars->AnglePeriod ;
        }
        if ( Out >= pPars->AnglePeriod )
        {
            Out -= pPars->AnglePeriod ;
        }
    }
    else
    {
        pState->dOut = dOut ;
    }
    pState->Out = Out ;

}


