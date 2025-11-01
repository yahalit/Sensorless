/*
 * SixStep.c
 *
 *  Created on: 31 срхїз 2025
 *      Author: Yahali
 */
#include "StructDef.h"

extern float GetCurrentCmdForSpeedErr(  float CurrentFF , float SpeedFB   );
extern float Mod1Distance(float x, float y);


static float mat[3][3];
static float bm[3] ;
#define R_MINIMUM 0.01f

typedef struct
{
    float Ia       ;
    float Ib       ;
    float Ic       ;
    float Va       ;
    float Vb       ;
    float Vc       ;
    float QThetaPU ;
} VarMirror_T ;
VarMirror_T VarMirror ;


inline float __SignedFrac(float x)
{// Return always positive fraction
    return __fracf32(__fracf32(x)+1.5f) - 0.5f;
}


static short TryUpdateClaMailOut()
{
    long samp ;
    samp = ClaMailOut.UpdateFlag ;
    if ( samp & 1 )
    {
        return 0 ;
    }
    VarMirror.Ia = ClaMailOut.Ia ;
    VarMirror.Ib = ClaMailOut.Ib ;
    VarMirror.Ic = ClaMailOut.Ic ;
    VarMirror.Va = ClaMailOut.Va ;
    VarMirror.Vb = ClaMailOut.Vb ;
    VarMirror.Vc = ClaMailOut.Vc ;
    VarMirror.QThetaPU = ClaMailOut.QThetaPU ;
    if ( samp == ClaMailOut.UpdateFlag )
    {
        return 1 ;
    }
    return 0 ; // Counter changed so set cannot be considered coherent
}

short unsigned xx[6];


static void SixStepsRObserver( void )
{
// Read the CLA vars
    short oldstep ;

    while(TryUpdateClaMailOut() == 0) ;
    SLessState.SixStepObs.Step = (short) (VarMirror.QThetaPU * 6 ) ;
    oldstep = SLessState.SixStepObs.OldStep ;
    SLessState.SixStepObs.OldStep  = SLessState.SixStepObs.Step ;
    if (SLessState.SixStepObs.Step != oldstep  )
    {// Identify commutation step transition
        SLessState.SixStepObs.TransitionTimeOut = 0 ;
    }
    if ( SLessState.SixStepObs.TransitionTimeOut < SLPars.Pars6Step.nTransitionTime + SLPars.Pars6Step.nSummingTime)
    {
        SLessState.SixStepObs.TransitionTimeOut += 1  ;
        if ( SLessState.SixStepObs.TransitionTimeOut == SLPars.Pars6Step.nTransitionTime + SLPars.Pars6Step.nSummingTime )
        {
            SLessState.SixStepObs.SetSpeedCtl = 1 ;
        }
    }

    // Buffer is not updated when given to background processing
    if ( SLessState.SixStepObs.bUpdateBuf )
    {

        if ( SLessState.SixStepObs.bUpdateBuf  == 1 )
        { // Pre stage
            xx[0] += 1 ;
            if (SLessState.SixStepObs.Step != oldstep  )
            {// Identify commutation step transition
                if ( SLessState.SixStepObs.AbsPutPtr < SLPars.Pars6Step.nSummingTime)
                {
                    // We have a transition, yet we cant exploit it as we did not accumulate enough data
                    SLessState.SixStepObs.AbsPutPtr = -SLPars.Pars6Step.nTransitionTime ;
                    SLessState.SixStepObs.PutPtr = ( 64 - SLPars.Pars6Step.nTransitionTime)  ;
                }
                else
                {
                    SLessState.SixStepObs.bUpdateBuf = 2 ;
                    SLessState.SixStepObs.AnaPreStep = oldstep ;
                    SLessState.SixStepObs.AnaPostStep = SLessState.SixStepObs.Step ;
                }
            }
            else
            {
                SLessState.SixStepObs.sumCurPreA[SLessState.SixStepObs.PutPtr] = VarMirror.Ia;
                SLessState.SixStepObs.sumCurPreB[SLessState.SixStepObs.PutPtr] = VarMirror.Ib;
                SLessState.SixStepObs.sumCurPreC[SLessState.SixStepObs.PutPtr] = VarMirror.Ic;
                SLessState.SixStepObs.sumVPreA[SLessState.SixStepObs.PutPtr] = VarMirror.Va;
                SLessState.SixStepObs.sumVPreB[SLessState.SixStepObs.PutPtr] = VarMirror.Vb;
                SLessState.SixStepObs.sumVPreC[SLessState.SixStepObs.PutPtr] = VarMirror.Vc;
                SLessState.SixStepObs.PutPtr = ( SLessState.SixStepObs.PutPtr + 1 ) & 63 ;
                SLessState.SixStepObs.AbsPutPtr += 1 ;
            }
        }
        else
        {
            if ( SLessState.SixStepObs.bUpdateBuf  == 2 )
            {
                //xx[2] += 1 ;
                //SLessState.SixStepObs.TransitionTimeOut += 1 ;
                if ( SLessState.SixStepObs.TransitionTimeOut >= SLPars.Pars6Step.nTransitionTime)
                {
                    xx[3] += 1 ;
                    SLessState.SixStepObs.bUpdateBuf  = 3 ;
                    SLessState.SixStepObs.PostPutPtr  = 0 ;
                }
            }
            else
            {
                xx[4] += 1 ;
                SLessState.SixStepObs.sumCurPostA[SLessState.SixStepObs.PostPutPtr] = VarMirror.Ia;
                SLessState.SixStepObs.sumCurPostB[SLessState.SixStepObs.PostPutPtr] = VarMirror.Ib;
                SLessState.SixStepObs.sumCurPostC[SLessState.SixStepObs.PostPutPtr] = VarMirror.Ic;
                SLessState.SixStepObs.sumVPostA[SLessState.SixStepObs.PostPutPtr] = VarMirror.Va;
                SLessState.SixStepObs.sumVPostB[SLessState.SixStepObs.PostPutPtr] = VarMirror.Vb;
                SLessState.SixStepObs.sumVPostC[SLessState.SixStepObs.PostPutPtr] = VarMirror.Vc;
                SLessState.SixStepObs.PostPutPtr += 1 ;
                if ( SLessState.SixStepObs.PostPutPtr >= SLPars.Pars6Step.nSummingTime)
                {
                    xx[5] += 1 ;
                    SLessState.SixStepObs.bProcREstimate = 1 ; // Turn over to BG processing
                    SLessState.SixStepObs.bUpdateBuf  =  0 ;
                }
            }
        }
    }
}


static float SolveR3x3Symmetric( float _mat[3][3], float _b[3])
{
    float dr[3] ;
    float a = _mat[0][0] ;
    float b = _mat[0][1] ;
    float c = _mat[0][2] ;
    float d = _mat[1][1] ;
    float e = _mat[1][2] ;
    float f = _mat[2][2] ;
    float det = a * d * f + 2 * b * c * e - a * e * e - d * c * c - f * b * b ;

    if ( det < 1e-8 * ( a + b + c )  )
    {
        return 0 ;
    }

    dr[0] = b * e - c * d ;
    dr[1] = b * c - a * e ;
    dr[2] = a * d - b * b ;

    return (dr[0] * _b[0] + dr[1] * _b[1] + dr[2] * _b[2]) / det  ;
}

const float *pPreCurPosdirPlus[6] = { &SLessState.SixStepObs.sumCurPreC[0] ,
                              &SLessState.SixStepObs.sumCurPreB[0] ,
                              &SLessState.SixStepObs.sumCurPreB[0] ,
                              &SLessState.SixStepObs.sumCurPreA[0] ,
                              &SLessState.SixStepObs.sumCurPreA[0] ,
                              &SLessState.SixStepObs.sumCurPreC[0]
                            } ;
const float *pPreCurPosdirMinus[6] = { &SLessState.SixStepObs.sumCurPreA[0] ,
                              &SLessState.SixStepObs.sumCurPreA[0] ,
                              &SLessState.SixStepObs.sumCurPreC[0] ,
                              &SLessState.SixStepObs.sumCurPreC[0] ,
                              &SLessState.SixStepObs.sumCurPreB[0] ,
                              &SLessState.SixStepObs.sumCurPreB[0]
                            } ;

const float *pPreCurNegdirPlus[6] = { &SLessState.SixStepObs.sumCurPreB[0] ,
                              &SLessState.SixStepObs.sumCurPreA[0] ,
                              &SLessState.SixStepObs.sumCurPreA[0] ,
                              &SLessState.SixStepObs.sumCurPreC[0] ,
                              &SLessState.SixStepObs.sumCurPreC[0] ,
                              &SLessState.SixStepObs.sumCurPreB[0]
                            } ;

const float *pPreCurNegdirMinus[6] = { &SLessState.SixStepObs.sumCurPreC[0] ,
                              &SLessState.SixStepObs.sumCurPreC[0] ,
                              &SLessState.SixStepObs.sumCurPreB[0] ,
                              &SLessState.SixStepObs.sumCurPreB[0] ,
                              &SLessState.SixStepObs.sumCurPreA[0] ,
                              &SLessState.SixStepObs.sumCurPreA[0]
                            } ;


const float *pPreVoltPosdirPlus[6] = { &SLessState.SixStepObs.sumVPreC[0] ,
                              &SLessState.SixStepObs.sumVPreB[0] ,
                              &SLessState.SixStepObs.sumVPreB[0] ,
                              &SLessState.SixStepObs.sumVPreA[0] ,
                              &SLessState.SixStepObs.sumVPreA[0] ,
                              &SLessState.SixStepObs.sumVPreC[0]
                            } ;
const float *pPreVoltPosdirMinus[6] = { &SLessState.SixStepObs.sumVPreA[0] ,
                              &SLessState.SixStepObs.sumVPreA[0] ,
                              &SLessState.SixStepObs.sumVPreC[0] ,
                              &SLessState.SixStepObs.sumVPreC[0] ,
                              &SLessState.SixStepObs.sumVPreB[0] ,
                              &SLessState.SixStepObs.sumVPreB[0]
                            } ;

const float *pPreVoltNegdirPlus[6] = { &SLessState.SixStepObs.sumVPreB[0] ,
                              &SLessState.SixStepObs.sumVPreA[0] ,
                              &SLessState.SixStepObs.sumVPreA[0] ,
                              &SLessState.SixStepObs.sumVPreC[0] ,
                              &SLessState.SixStepObs.sumVPreC[0] ,
                              &SLessState.SixStepObs.sumVPreB[0]
                            } ;

const float *pPreVoltNegdirMinus[6] = { &SLessState.SixStepObs.sumVPreC[0] ,
                              &SLessState.SixStepObs.sumVPreC[0] ,
                              &SLessState.SixStepObs.sumVPreB[0] ,
                              &SLessState.SixStepObs.sumVPreB[0] ,
                              &SLessState.SixStepObs.sumVPreA[0] ,
                              &SLessState.SixStepObs.sumVPreA[0]
                            } ;


////////////////////////////////////////////////////////////////////////////

const float *pPostCurPosdirPlus[6] = { &SLessState.SixStepObs.sumCurPostC[0] ,
                              &SLessState.SixStepObs.sumCurPostB[0] ,
                              &SLessState.SixStepObs.sumCurPostB[0] ,
                              &SLessState.SixStepObs.sumCurPostA[0] ,
                              &SLessState.SixStepObs.sumCurPostA[0] ,
                              &SLessState.SixStepObs.sumCurPostC[0]
                            } ;
const float *pPostCurPosdirMinus[6] = { &SLessState.SixStepObs.sumCurPostA[0] ,
                              &SLessState.SixStepObs.sumCurPostA[0] ,
                              &SLessState.SixStepObs.sumCurPostC[0] ,
                              &SLessState.SixStepObs.sumCurPostC[0] ,
                              &SLessState.SixStepObs.sumCurPostB[0] ,
                              &SLessState.SixStepObs.sumCurPostB[0]
                            } ;

const float *pPostCurNegdirPlus[6] = { &SLessState.SixStepObs.sumCurPostB[0] ,
                              &SLessState.SixStepObs.sumCurPostA[0] ,
                              &SLessState.SixStepObs.sumCurPostA[0] ,
                              &SLessState.SixStepObs.sumCurPostC[0] ,
                              &SLessState.SixStepObs.sumCurPostC[0] ,
                              &SLessState.SixStepObs.sumCurPostB[0]
                            } ;

const float *pPostCurNegdirMinus[6] = { &SLessState.SixStepObs.sumCurPostC[0] ,
                              &SLessState.SixStepObs.sumCurPostC[0] ,
                              &SLessState.SixStepObs.sumCurPostB[0] ,
                              &SLessState.SixStepObs.sumCurPostB[0] ,
                              &SLessState.SixStepObs.sumCurPostA[0] ,
                              &SLessState.SixStepObs.sumCurPostA[0]
                            } ;


const float *pPostVoltPosdirPlus[6] = { &SLessState.SixStepObs.sumVPostC[0] ,
                              &SLessState.SixStepObs.sumVPostB[0] ,
                              &SLessState.SixStepObs.sumVPostB[0] ,
                              &SLessState.SixStepObs.sumVPostA[0] ,
                              &SLessState.SixStepObs.sumVPostA[0] ,
                              &SLessState.SixStepObs.sumVPostC[0]
                            } ;
const float *pPostVoltPosdirMinus[6] = { &SLessState.SixStepObs.sumVPostA[0] ,
                              &SLessState.SixStepObs.sumVPostA[0] ,
                              &SLessState.SixStepObs.sumVPostC[0] ,
                              &SLessState.SixStepObs.sumVPostC[0] ,
                              &SLessState.SixStepObs.sumVPostB[0] ,
                              &SLessState.SixStepObs.sumVPostB[0]
                            } ;

const float *pPostVoltNegdirPlus[6] = { &SLessState.SixStepObs.sumVPostB[0] ,
                              &SLessState.SixStepObs.sumVPostA[0] ,
                              &SLessState.SixStepObs.sumVPostA[0] ,
                              &SLessState.SixStepObs.sumVPostC[0] ,
                              &SLessState.SixStepObs.sumVPostC[0] ,
                              &SLessState.SixStepObs.sumVPostB[0]
                            } ;

const float *pPostVoltNegdirMinus[6] = { &SLessState.SixStepObs.sumVPostC[0] ,
                              &SLessState.SixStepObs.sumVPostC[0] ,
                              &SLessState.SixStepObs.sumVPostB[0] ,
                              &SLessState.SixStepObs.sumVPostB[0] ,
                              &SLessState.SixStepObs.sumVPostA[0] ,
                              &SLessState.SixStepObs.sumVPostA[0]
                            } ;


short freeze = 0 ;


void AnalyzeR6Step(void)
{
    short cnt , c1 , c2 , k , offs  , offs2 ;
    short unsigned mask, bProc ;
    float v , cur , vn ;
    float *pCPosPre  , *pCNegPre  , *pVPosPre  , *pVNegPre ;
    float *pCPosPost , *pCNegPost , *pVPosPost , *pVNegPost;
    float CurTest , CurStep ;

    if ( (SLessState.SixStepObs.bProcREstimate == 0 ) || freeze )
    {
        return ;
    }

    mat[0][0] = SLPars.Pars6Step.nSummingTime + SLPars.Pars6Step.nTransitionTime ;

    offs =  SLPars.Pars6Step.nSummingTime + SLPars.Pars6Step.nTransitionTime / 2 ;
    offs2 = SLPars.Pars6Step.nTransitionTime / 2 + 1 ;

    cnt = SLessState.SixStepObs.AnaPostStep - SLessState.SixStepObs.AnaPreStep;
    if ( cnt < 0 ) cnt += 6 ;
    if ( cnt <= 1 )
    { // Positive
        pCPosPre = (float *) pPreCurPosdirPlus[SLessState.SixStepObs.AnaPreStep];
        pCNegPre = (float *) pPreCurPosdirMinus[SLessState.SixStepObs.AnaPreStep];
        pVPosPre = (float *) pPreVoltPosdirPlus[SLessState.SixStepObs.AnaPreStep];
        pVNegPre = (float *) pPreVoltPosdirMinus[SLessState.SixStepObs.AnaPreStep];

        pCPosPost = (float *) pPostCurPosdirPlus[SLessState.SixStepObs.AnaPreStep];
        pCNegPost = (float *) pPostCurPosdirMinus[SLessState.SixStepObs.AnaPreStep];
        pVPosPost = (float *) pPostVoltPosdirPlus[SLessState.SixStepObs.AnaPreStep];
        pVNegPost = (float *) pPostVoltPosdirMinus[SLessState.SixStepObs.AnaPreStep];
    }
    else
    {
        pCPosPre = (float *) pPreCurNegdirPlus[SLessState.SixStepObs.AnaPreStep];
        pCNegPre = (float *) pPreCurNegdirMinus[SLessState.SixStepObs.AnaPreStep];
        pVPosPre = (float *) pPreVoltNegdirPlus[SLessState.SixStepObs.AnaPreStep];
        pVNegPre = (float *) pPreVoltNegdirMinus[SLessState.SixStepObs.AnaPreStep];

        pCPosPost = (float *) pPostCurNegdirPlus[SLessState.SixStepObs.AnaPreStep];
        pCNegPost = (float *) pPostCurNegdirMinus[SLessState.SixStepObs.AnaPreStep];
        pVPosPost = (float *) pPostVoltNegdirPlus[SLessState.SixStepObs.AnaPreStep];
        pVNegPost = (float *) pPostVoltNegdirMinus[SLessState.SixStepObs.AnaPreStep];
    }

    mat[0][0] = 0 ;
    mat[0][1] = 0 ;
    mat[0][2] = 0 ;
    mat[1][1] = 0 ;
    mat[1][2] = 0 ;
    mat[2][2] = 0 ;
    bm[0] = 0 ;
    bm[1] = 0 ;
    bm[2] = 0 ;
    CurTest = 0 ;

    mat[0][0] = SLPars.Pars6Step.nSummingTime * 2 ;
    c1 = ( SLessState.SixStepObs.PostPutPtr - SLPars.Pars6Step.nSummingTime) & 63 ;


    for ( cnt = 0 ; cnt < 2 * SLPars.Pars6Step.nSummingTime ; cnt++)
    {
        if ( cnt < SLPars.Pars6Step.nSummingTime)
        {
            k = cnt - offs  ;
            cur = pCPosPre[c1] ; // - pCNegPre[c1] ;
            vn = (SLessState.SixStepObs.sumVPreA[c1]
                 +SLessState.SixStepObs.sumVPreB[c1]
                 +SLessState.SixStepObs.sumVPreC[c1]) * 0.333333333333f;
            v   = pVPosPre[c1] - vn ; // pVNegPre[c1] ;
            c1 = ( c1 + 1 ) & 63 ;
        }
        else
        {
            c2 = cnt - SLPars.Pars6Step.nSummingTime ;
            k = c2 + offs2 ;
            cur = pCPosPost[c2] ; // + pCNegPost[cnt] ;
            vn = (SLessState.SixStepObs.sumVPostA[c2]
                 +SLessState.SixStepObs.sumVPostB[c2]
                 +SLessState.SixStepObs.sumVPostC[c2]) * 0.333333333333f;
            v   = pVPosPost[c2] - vn ; // pVNegPre[c1] ;
            //v   = pVPosPost[cnt] - pVNegPost[cnt] ;
            CurTest += cur ;
        }
        mat[0][1] += k ;
        mat[0][2] = mat[0][2] + cur  ;
        mat[1][1] += k * k  ;
        mat[1][2] = mat[0][2] + cur * k ;
        mat[2][2] = mat[2][2] + cur * cur ;


        bm[0] += v ;
        bm[1] += v * k  ;
        bm[2] += v * cur ;
    }
    // See if there is enough current change to calculate
    CurStep = ( CurTest - mat[0][2] * 0.5f ) * 1.33333333f * SLPars.Pars6Step.InvnSummingTime ;
    if ( fabsf(CurStep) <  SLPars.Pars6Step.MinimumCur4RCalc )
    {
       bProc = 0 ;
    }
    else
    {
        bProc = 1 ;
        SLessState.SixStepObs.RawR[0] = SolveR3x3Symmetric( mat, bm);
    }

    if ( bProc )
    {

        mat[0][1] = 0 ;
        mat[0][2] = 0 ;
        mat[1][1] = 0 ;
        mat[1][2] = 0 ;
        mat[2][2] = 0 ;
        bm[0] = 0 ;
        bm[1] = 0 ;
        bm[2] = 0 ;
        CurTest = 0 ;


        for ( cnt = 0 ; cnt < 2 * SLPars.Pars6Step.nSummingTime ; cnt++)
        {
            if ( cnt < SLPars.Pars6Step.nSummingTime)
            {
                k = cnt - offs  ;
                cur = pCNegPre[c1] ; // - pCNegPre[c1] ;
                vn = (SLessState.SixStepObs.sumVPreA[c1]
                     +SLessState.SixStepObs.sumVPreB[c1]
                     +SLessState.SixStepObs.sumVPreC[c1]) * 0.333333333333f;
                v   = pVNegPre[c1] - vn ; // pVNegPre[c1] ;
                c1 = ( c1 + 1 ) & 63 ;
            }
            else
            {
                c2 = cnt - SLPars.Pars6Step.nSummingTime ;
                k = c2 + offs2 ;
                cur = pCNegPost[c2] ; // + pCNegPost[cnt] ;
                vn = (SLessState.SixStepObs.sumVPostA[c2]
                     +SLessState.SixStepObs.sumVPostB[c2]
                     +SLessState.SixStepObs.sumVPostC[c2]) * 0.333333333333f;
                v   = pVNegPost[c2] - vn ;
                CurTest += cur ;
                //v   = pVPosPost[cnt] - pVNegPost[cnt] ;
            }
            mat[0][1] += k ;
            mat[0][2] = mat[0][2] + cur  ;
            mat[1][1] += k * k  ;
            mat[1][2] = mat[0][2] + cur * k ;
            mat[2][2] = mat[2][2] + cur * cur ;

            bm[0] += v ;
            bm[1] += v * k  ;
            bm[2] += v * cur ;
        }
        // See if there is enough current change to calculate
        CurStep = ( CurTest - mat[0][2] * 0.5f ) * 1.33333333f * SLPars.Pars6Step.InvnSummingTime ;
        bProc = 1 ;
        if ( fabsf(CurStep) <  SLPars.Pars6Step.MinimumCur4RCalc )
        {
           bProc = 0 ;
        }
        else
        {
            SLessState.SixStepObs.RawR[1] = SolveR3x3Symmetric( mat, bm);
        }
    }


    if ( bProc )
    {
        SLessState.SixStepObs.FilteredR = SLessState.SixStepObs.FilteredR +
                0.1f *  ( __fmax  ( 0.5f * (SLessState.SixStepObs.RawR[0]+SLessState.SixStepObs.RawR[1]), R_MINIMUM )  -SLessState.SixStepObs.FilteredR  ) ;
    }

    if ( SysState.Debug.DebugSLessCycle < 2  )
    {
        mask = BlockInts() ;
        SLessState.SixStepObs.PutPtr = 0 ;
        SLessState.SixStepObs.AbsPutPtr =0 ;
        SLessState.SixStepObs.bProcREstimate  = 0 ;
        SLessState.SixStepObs.bUpdateBuf  =  1 ;
        RestoreInts(mask) ;
    }


}

static void InitSensorlessObserverFOM6Step()
{
    short c1 , c2 ;

    for ( c1 = 0 ; c1 < 3 ; c1++)
        for ( c2 = 0 ; c2 < 3 ; c2++)mat[c1][c2] = 0 ;

    SLessState.FOM.FOMConvergenceTotalTimer = 0 ;
    SLessState.FOM.FOMConvergenceGoodTimer = 0 ;
    SLessState.FOM.FOMFirstStabilizationTimer = 0;
    SLessState.SixStepObs.OldStep = ClaMailOut.QThetaPU ;
    SLessState.SixStepObs.Step = SLessState.SixStepObs.OldStep  ;
    SLessState.SixStepObs.TransitionTimeOutCnt = 0 ;

    SLPars.Pars6Step.nSummingTime       = (short) ( SLPars.Pars6Step.SummingTime / SLPars.dT ) ;
    SLPars.Pars6Step.nTransitionTime = (short) ( SLPars.Pars6Step.TransitionTime / SLPars.dT ) | 1 ; // assure oddity
    SLPars.Pars6Step.InvnSummingTime = 1.0f /SLPars.Pars6Step.nSummingTime ;


}





static void InitSensorlessMode6Step()
{
    SysState.Mot.ProfileConverged = 0 ;
    SysState.SpeedControl.SpeedReference = 0 ;
    SysState.SpeedControl.ProfileAcceleration= SLPars.FomPars.OpenLoopAcceleration  ;
    SysState.SpeedControl.SpeedTarget = SLPars.FomPars.FOMTakingStartSpeed  ;
    SLessState.FOM.bAcceleratingAsV2FState = E_PureF2FAcceleration ;
    SysState.Mot.InAutoBrakeEngage = 0 ;
    SysState.StepperCurrent.StepperAngle = 0 ;
    SLessState.SixStepObs.bUpdateBuf = 1 ;
    SLessState.SixStepObs.PutPtr = 0 ;
    SLessState.SixStepObs.AbsPutPtr =0 ;
    SLessState.SixStepObs.FilteredR  = SLPars.R ;
    InitSensorlessObserverFOM6Step() ;
}


void SixStepEstimatePU()
{
    float b , d , v1 , v2 , v3 , s , c, vn ;
    float ipart ;
    if ( SLessState.SixStepObs.TransitionTimeOut < SLPars.Pars6Step.nTransitionTime )
    { // In transition, so not calculate angle or speed
        return ;
    }
    TryUpdateClaMailOut();
    v1 = VarMirror.Va - SLessState.SixStepObs.FilteredR * VarMirror.Ia;
    v2 = VarMirror.Vb - SLessState.SixStepObs.FilteredR * VarMirror.Ib;
    v3 = VarMirror.Vc - SLessState.SixStepObs.FilteredR * VarMirror.Ic;
    vn = ( v1 + v2 + v3 ) * 0.33333333333f ;
    v1 = v1 - vn ;
    v2 = v2 - vn ;
    v3 = v3 - vn ;
    c = (v2 - v3) / 0.577350269189626f ;
    s = v1 ;
    SLessState.SixStepObs.ThetaRawPU = __atan2puf32(s , c ) ;
    SLessState.SixStepObs.ETheta = SLessState.SixStepObs.ThetaRawPU;

    SLessState.SixStepObs.ThetaPsi += __SignedFrac(SLessState.SixStepObs.ThetaRawPU - SLessState.SixStepObs.ThetaPsi);
    b = (SLessState.SixStepObs.ThetaPsi - SLessState.SixStepObs.ThetaHat) ;
    SLessState.SixStepObs.ETheta = __fmax(__fmin(b, 40), -40);
    SLessState.SixStepObs.OmegaState = SLessState.SixStepObs.OmegaState + SLPars.KiTheta * SLPars.dT * SLessState.SixStepObs.ETheta;
    SLessState.SixStepObs.OmegaHat = SLessState.SixStepObs.OmegaState + SLPars.KpTheta * SLessState.SixStepObs.ETheta;

    // Advance angle by w
    d = SLessState.SixStepObs.ThetaHat + SLessState.SixStepObs.OmegaHat * SLPars.dT;
    SLessState.SixStepObs.ThetaHat = d;

//#ifdef REMINT
    SLessState.SixStepObs.ThetaHat = modff(d, &ipart);
    SLessState.SixStepObs.ThetaPsi -= ipart;

}


///////////////////////////////////////////////////////////
/*
 * This routine estimates if the observer converged in a good manner. To do so we verify on a given amount of cycles
 * that the speed estimate correlates with the desired speed to within a tolerance, and also that the estimated field
 * angle matches the set electrical angle to given precision.
 * Note:
 * The "Field angle" measures the location of the motor's Q axis, which is electrically 90deg advanced w.r.t. the D axis
 * estimated by the observer. On no load, all the current is on the "D" so we expect the observer angle and the Electrical angle to coincide
 */
short EstimateSensorlessObserverFOM6Step()
{
    //float delta ;
    SLessState.FOM.FOMRetardAngleDistance = Mod1Distance (ClaState.QThetaElect,SLessState.ThetaHat) ;
    if  ( fabsf( SLessState.OmegaHat / SLPars.FomPars.FOMTakingStartSpeed - 1 ) > SLPars.FomPars.ObserverConvergenceToleranceFrac )
    {
        SLessState.FOM.FOMConvergenceGoodTimer = 0 ;
        return 0 ;
    }
    if ( (SLessState.FOM.FOMRetardAngleDistance > SLPars.FomPars.MaximumSteadyStateFieldRetard) ||
            (SLessState.FOM.FOMRetardAngleDistance < SLPars.FomPars.MinimumSteadyStateFieldRetard) )
    {
        SLessState.FOM.FOMConvergenceGoodTimer = 0 ;
        return 0 ;
    }
    if ( SLessState.FOM.FOMConvergenceGoodTimer >= SLPars.FomPars.CyclesForConvergenceApproval / __fmax( SLPars.FomPars.FOMTakingStartSpeed, 0.001f) )
    {
        return 1 ;
    }
    else
    {
        SLessState.FOM.FOMConvergenceGoodTimer += SysState.Timing.TsTraj ;
    }
    return 0 ;
}


static short ManageAccelerationToWorkZone6Step(float CurMax)
{
    short RetVal ;
    short unsigned excp ;
    float CurCmd , sr , acc , arg , piOut ;
    RetVal = 0 ;
    excp = 0 ;
    CurCmd = 0 ;

    // If speed is still lower than threshold, than V/F mode
    switch ( SLessState.FOM.bAcceleratingAsV2FState )
    {
    case E_AccelerationInit:
        InitSensorlessMode6Step() ;
        break ;
    case E_PureF2FAcceleration: // Accelerate to speed

        if ( SLessState.FOM.FOMFirstStabilizationTimer <  SLPars.FomPars.InitiallStabilizationTime)
        {
            SLessState.FOM.FOMFirstStabilizationTimer += SysState.Timing.TsTraj ;
            acc = 0 ;
        }
        else
        {
            sr = SysState.SpeedControl.SpeedReference ;
            // Synthesize pure V/F drive
            SysState.Mot.ProfileConverged = SpeedProfiler() ;

            acc = ( SysState.SpeedControl.SpeedReference - sr ) * SysState.Timing.OneOverTsTraj ;
        }

        CurCmd = GetOpenLoopCurrentCmd( SysState.SpeedControl.SpeedReference, acc , CurMax) ;
        SysState.StepperCurrent.StepperAngle  =
                __fracf32(SysState.StepperCurrent.StepperAngle +  SysState.SpeedControl.SpeedReference * SysState.Timing.TsTraj) ;
        ClaState.QThetaElect = __fracf32(SysState.StepperCurrent.StepperAngle +0.25f) ;

        if ( SysState.Mot.ProfileConverged)
        {
            InitSensorlessObserverFOM6Step();
            SLessState.FOM.bAcceleratingAsV2FState = E_TakingFOM ;
        }

        break ;

    case E_TakingFOM:
        SLessState.FOM.FOMConvergenceTotalTimer += SysState.Timing.TsTraj ;
        if ( SLessState.FOM.FOMConvergenceTotalTimer > SLPars.FomPars.FOMConvergenceTimeout)
        {
            if ( SysState.Debug.DebugSLessCycle == 0 )
            { // May disable convergence timeout for debugging
                excp = exp_sensorless_no_initconverge  ;
                break ;
            }
        }
        CurCmd = GetOpenLoopCurrentCmd( SysState.SpeedControl.SpeedTarget, 0 , CurMax) ;

        SysState.StepperCurrent.StepperAngle = __fracf32(SysState.StepperCurrent.StepperAngle +  SysState.SpeedControl.SpeedReference * SysState.Timing.TsTraj) ;
        ClaState.QThetaElect = __fracf32(SysState.StepperCurrent.StepperAngle+0.25f) ;

        // Use SysState.Debug.DebugSLessCycle to disable transition to full control
        if ( ( EstimateSensorlessObserverFOM6Step( ) == 1 ) && ( ( SysState.Debug.DebugSLessCycle == 0 ) ))
        {
            SLessState.FOM.bAcceleratingAsV2FState  = E_EngagingAngleObserver ;
            // At this stage we engage the speed controller.
            // Because the speed is supposed to be stable with Iq, we assume that Iq is the current to continue with, so that it becomes the state of the speed integrator.
            // We expect about 90deg difference between the stepper angle and the estimated observer angle.
            // We transform the integrator states by [Co So;-So Co] * [Cs -Ss;Ss Cs] where the o subscript is for the observer and the s for the stepper.
            // The commutation angle is set to this of the observer
            ClaMailIn.CandidateMotorSpeedCompensationVoltage = SLPars.PhiM * SLessState.OmegaHat ;
            // Angle difference in matches d-d frame
            arg = __fracf32 ( SLessState.ThetaEst - (ClaState.QThetaElect - 0.25f) ) * PI2 ;
            ClaMailIn.CandidateElectAngleTxC = __cos(arg) ;
            ClaMailIn.CandidateElectAngleTxS = __sin(arg) ;
            ClaMailIn.CandidateQElectAngle    = __fracf32(SLessState.ThetaEst+0.25f) ;
            ClaMailIn.CandidateId   = SLessState.Id ;
            // Synchronize
            ClaState.CommutationSyncDone  = 0 ;
            CLA_forceTasks(CLA1_BASE, CLA_TASKFLAG_4);
        }

        if ( ( SysState.Debug.DebugSLessCycle == 0 )  && ( SLessState.OmegaHat < SLPars.FomPars.OmegaCommutationLoss ))
        {
            excp = exp_sensorless_underspeed_whileFOM  ;
        }

        break;
    case E_EngagingAngleObserver:
        if ( ClaState.CommutationSyncDone  )
        {
            SLessState.SixStepObs.SetSpeedCtl = 0 ; // Kill ant pending speed control requests
            SLessState.FOM.bAcceleratingAsV2FState  = E_EngagingSpeedControl ;
            SetReferenceMode(E_RefModeSpeed)  ;
            SetLoopClosureMode(E_LC_Speed_Mode) ;
            ResetSpeedController() ;
            piOut = __fmin( __fmax( SLessState.Iq , 0.0f) , CurMax * 0.75f ) ;
            ControlPars.qf0.s0 = piOut ;
            ControlPars.qf0.s1 = piOut ;
            ControlPars.qf1.s0 = piOut ;
            ControlPars.qf1.s1 = piOut ;

            SysState.SpeedControl.ProfileAcceleration= SLPars.WorkAcceleration  ;
            SysState.SpeedControl.SpeedTarget = SLPars.WorkSpeed  ;
            SysState.SpeedControl.SpeedReference = SLessState.OmegaHat ;
            SysState.SpeedControl.PIState = piOut  ;
        }
        if ( SLessState.OmegaHat < SLPars.FomPars.OmegaCommutationLoss )
        {
            excp = exp_sensorless_underspeed_whileFOM2  ;
        }
        break ;
    case E_EngagingSpeedControl:

        RetVal = 1;
        break ;
    }

    if (  excp  )
    {
        MotorOffSeq();
        LogException(EXP_FATAL,excp  ) ;

        ClaState.CurrentControl.ExtCurrentCommand = 0 ;
        RetVal = -1 ;
    }
    else
    {
        if ( SLessState.FOM.bAcceleratingAsV2FState < E_EngagingAngleObserver)
        {
            ClaState.CurrentControl.ExtCurrentCommand = CurCmd  ;
        }
    }

    return RetVal;
}


// Sequence of action to be taken while the motor is on.
void MotorOnSeqAsSensorless6Step(void)
{
    float CurCmd , CurMax   ;
    short unsigned refmode , ClosureMode   ;
    short stat ;

    // Run reference generators
    CurMax = ControlPars.MaxCurCmd ;
    CurCmd = 0 ;

    // if the mode is emergence, than simply shut off PWM
    if ( (ClaState.SystemMode == E_SysMotionModeSafeFault) || SysState.Mot.QuickStop    )
    {
        LogException(EXP_FATAL,exp_unexpected_sensorless_mode ) ;
        MotorOffSeq() ;
        return ;
    }

    stat = ManageAccelerationToWorkZone6Step(CurMax);
    SixStepsRObserver();

    if ( stat != 1 )
    {
        return ;
    }

    if ( SLessState.OmegaHat < SLPars.FomPars.OmegaCommutationLoss )
    {
        LogException( EXP_FATAL , exp_sensorless_underspeed )  ;
        return  ;
    }


    refmode = E_RefModeSpeed ;
    ClosureMode = E_LC_Speed_Mode ;

    // Limit the speed reference
    SysState.SpeedControl.SpeedCommand = fSatNanProt (SysState.SpeedControl.SpeedReference , ControlPars.MaxSpeedCmd ) ;

    // New current command shall be calculated only after R
    if ( SLessState.SixStepObs.SetSpeedCtl )
    { // In transition, so not calculate angle or speed
        CurCmd = GetCurrentCmdForSpeedErr( CurCmd  , SLessState.OmegaHat );
        ClaState.CurrentControl.ExtCurrentCommand =  fSatNanProt( CurCmd , CurMax ) ;
    }
    else
    {
        ClaState.CurrentControl.ExtCurrentCommand = CurCmd ;
    }



    ClaState.QThetaElect = __fracf32 ( SLessState.ThetaHat + 0.25f) ;


    if ( fabsf(ClaState.CurrentControl.ExtCurrentCommand)  ==  CurMax )
    {
        if ( SysState.Mot.CurrentLimitCntr < 50 )
        {
            SysState.Mot.CurrentLimitCntr += 1 ;
        }
        else
        {
            SysState.Mot.CurrentLimitCntr = __max( SysState.Mot.CurrentLimitCntr - 3 , 0 );
        }
    }

    if ( ClosureMode == E_LC_Speed_Mode )
    { // Speed profiler
        switch (refmode )
        {
        case E_PosModeDebugGen:
             SysState.SpeedControl.SpeedReference = SysState.Debug.GRef.Out ;
             SysState.Mot.ProfileConverged = 1 ;
             break ;
        case E_RefModeSpeed:
            SysState.Mot.ProfileConverged = SpeedProfiler() ;
            break ;
        default: // case E_PosModeStayInPlace:
            SysState.SpeedControl.SpeedTarget = 0 ;
            SysState.Mot.ProfileConverged = SpeedProfiler() ;
            break ;
        }

        // Test if motion converged
        if (( SysState.Mot.ProfileConverged == 0 ) ||( fabsf(SysState.SpeedControl.SpeedError ) > ControlPars.SpeedConvergeWindow ))
        {
            SysState.Mot.MotionConverged  = 0  ;
            SysState.Mot.MotionConvergeCnt = 0  ;
        }
        else
        {
            if ( SysState.Mot.MotionConvergeCnt * SysState.Timing.TsTraj < ControlPars.MotionConvergeTime  )
            {
                SysState.Mot.MotionConvergeCnt += 1 ;
                SysState.Mot.MotionConverged  = 0  ;
            }
            else
            {
                SysState.Mot.MotionConverged  = 1  ;
            }
        }
    }
    else
    {
        SysState.PosControl.PosReference = SysState.PosControl.PosFeedBack ;
        SysState.SpeedControl.SpeedReference = ClaState.Encoder1.UserSpeed ;
        SysState.Mot.MotionConvergeCnt = 0  ;
        SysState.Mot.MotionConverged   = 0  ;
    }
}

