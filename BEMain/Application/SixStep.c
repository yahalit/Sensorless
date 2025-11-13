/*
 * SixStep.c
 *
 *  Created on: 31 October 2025
 *      Author: Yahali
 */
#include "StructDef.h"

extern float GetCurrentCmdForSpeedErr(  float CurrentFF , float SpeedFB   );
extern float Mod1Distance(float x, float y);


static float mat[3][3];
static float bm[3] ;
#define R_MINIMUM 0.01f
#define R_NOMINAL 0.1f

#define CUR_CONVERGENCE_WDW_TIME 5.0e-4f
#define ANGLE_EXTRAPOLATION_TIME_NAX 0.003f
#define MAX_GAIN_INCREASE_FAC 1.025f
#define MINIMUM_STEP_TIME 0.003f

inline float __SignedFrac(float x)
{// Return always positive fraction
    return __fracf32(__fracf32(x)+1.5f) - 0.5f;
}


short TryUpdateClaMailOut(void)
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
    VarMirror.OldQThetaPU = VarMirror.QThetaPU ;
    VarMirror.QThetaPU    = ClaMailOut.QThetaPU ;
    if ( samp == ClaMailOut.UpdateFlag )
    {
        return 1 ;
    }
    if ( ClaMailOut.AbortReason  )
    {
        ResetEstimatorTout() ;
    }
    return 0 ; // Counter changed so set cannot be considered coherent
}

short unsigned xx[6];


static void SixStepsRObserver( void )
{
// Read the CLA vars
    short oldstep , dist ,nextdir ;
    unsigned long long ull ;
    float InvT  ;

    //while(TryUpdateClaMailOut() == 0) ;
    SLessState.SixStepObs.Step = (short) (VarMirror.QThetaPU * 6 ) ;
    oldstep = SLessState.SixStepObs.OldStep ;
    SLessState.SixStepObs.OldStep  = SLessState.SixStepObs.Step ;
    if (SLessState.SixStepObs.Step != oldstep  )
    {// Identify commutation step transition
        // If step is within transition, ignore it
        if ( ( ClaState.ConvergenceTime > CUR_CONVERGENCE_WDW_TIME  ) && ( SLessState.SixStepObs.TransitionTimeOut >= SLPars.Pars6Step.nTransitionTime))
        {
            GetIpcTimer( &ull );

            dist = SLessState.SixStepObs.Step - oldstep ;

            nextdir = (( dist == 1 || dist == -5 )) ? 1 : -1 ;
            if ( SLessState.SixStepObs.StepDirection == nextdir )
            {
                SLessState.SixStepObs.StepTime  =  __fmin(
                        __fmax( (float)( ull - SLessState.SixStepObs.StepTimeLL) * INV_CPU_CLK_HZ, MINIMUM_STEP_TIME ),
                                 SLPars.Pars6Step.MaxStepTime ) ;
                InvT = 1.0f /  SLessState.SixStepObs.StepTime  ;
                SLessState.SixStepObs.StepSpeed = SLessState.SixStepObs.StepDirection * 0.166666666666667f * InvT *nextdir  ;
                        //( 0.166666666666667f * CPU_CLK_HZ ) / __fmax( (float)( ull - SLessState.SixStepObs.StepTimeLL), 1e-5f) ;
            }
            else
            {
                SLessState.SixStepObs.StepSpeed = 0 ;
                SLessState.SixStepObs.StepTime = SLPars.Pars6Step.MaxStepTime  ;
                InvT = 1.0f /  SLessState.SixStepObs.StepTime  ;
            }
            // We need Kp = 1/T , KI = 1/9/T^2 but we need for discrete implementation KI * T = 1 / 9/ T
            // Both are normalized

            ControlPars.SpeedKi = __fmin( InvT * 0.111111f * SLPars.Pars6Step.JOverKT , ControlPars.SpeedKi * MAX_GAIN_INCREASE_FAC ) ;
            ControlPars.SpeedKp = __fmin( InvT * SLPars.Pars6Step.JOverKT , ControlPars.SpeedKp * MAX_GAIN_INCREASE_FAC );

            SLessState.SixStepObs.StepDirection = nextdir;

            SLessState.SixStepObs.StepTimeLL = ull ;
            SLessState.SixStepObs.TransitionTimeOut = 0 ;
            SLessState.SixStepObs.CmdTransitionTimeOut= 0 ;
        }
        //SLessState.SixStepObs.SetSpeedCtl = 1 ;
    }

    if ( SLessState.SixStepObs.TransitionTimeOut < SLPars.Pars6Step.nTransitionTime + SLPars.Pars6Step.nSummingTime)
    {
        SLessState.SixStepObs.TransitionTimeOut += 1  ;
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
                    // We have a transition, yet we can't exploit it as we did not accumulate enough data
                    ResetEstimatorTout() ;
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
                if ( SLessState.SixStepObs.TransitionTimeOut >= SLPars.Pars6Step.nTransitionTime)
                {
                    xx[3] += 1 ;
                    SLessState.SixStepObs.bUpdateBuf  = 3 ;
                    SLessState.SixStepObs.PostPutPtr  = 0 ;
                }
            }
            else
            {
                if ( SLessState.SixStepObs.bUpdateBuf  == 4 )
                { // Reset by speed control
                    if ( SLessState.SixStepObs.TransitionTimeOut >= SLPars.Pars6Step.nTransitionTime)
                    {
                        SLessState.SixStepObs.PostPutPtr  = 0 ;
                        SLessState.SixStepObs.PutPtr  = 0 ;
                        SLessState.SixStepObs.bUpdateBuf = 1 ;
                    }
                }
                else
                {
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
                        SLessState.SixStepObs.CalculationTime.CalcRequest = CpuTimer1Regs.TIM.all ;
                        if ( SLessState.SixStepObs.EnableREstimator )
                        {
                            SLessState.SixStepObs.bProcREstimate = 1 ; // Turn over to BG processing
                            SLessState.SixStepObs.bUpdateBuf  =  0 ;
                        }
                        else
                        {
                            SLessState.SixStepObs.bUpdateBuf = 1 ;
                            SLessState.SixStepObs.FilteredR = R_NOMINAL ;
                            SLessState.SixStepObs.RawR[0] = SLessState.SixStepObs.FilteredR ;
                            SLessState.SixStepObs.RawR[1] = SLessState.SixStepObs.FilteredR ;
                        }
                    }
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

    SLessState.SixStepObs.CalculationTime.CalcService = CpuTimer1Regs.TIM.all ;


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
    CurStep = ( CurTest - mat[0][2] * 0.5f ) * 2.0f * SLPars.Pars6Step.InvnSummingTime ;
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
        CurStep = ( CurTest - mat[0][2] * 0.5f ) * 2.0f * SLPars.Pars6Step.InvnSummingTime ;
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

        SLessState.SixStepObs.CalculationTime.Time2Service = SLessState.SixStepObs.CalculationTime.CalcRequest - SLessState.SixStepObs.CalculationTime.CalcService ;
        SLessState.SixStepObs.CalculationTime.Time2Answer  = SLessState.SixStepObs.CalculationTime.CalcService -  CpuTimer1Regs.TIM.all ;

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
    SLessState.FOM.ConvergenceGoodCounter = 0 ;
    SLessState.FOM.FOMFirstStabilizationTimer = 0;
    SLessState.SixStepObs.OldStep = ClaMailOut.QThetaPU ;
    SLessState.SixStepObs.Step = SLessState.SixStepObs.OldStep  ;
    SLessState.SixStepObs.TransitionTimeOut  = 0 ;
    SLessState.SixStepObs.CmdTransitionTimeOut  = 0 ;

    SLPars.Pars6Step.nSummingTime       = (short) ( __fmin(SLPars.Pars6Step.SummingTime / SLPars.dT , 32000.0f) ) ;
    SLPars.Pars6Step.nTransitionTime = (short) ( __fmin(SLPars.Pars6Step.TransitionTime / SLPars.dT , 32000.0f) ) | 1 ; // assure oddity
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
    SLessState.SixStepObs.OpenLoopCurrent = 0;
    ClaMailIn.IqdConvergenceTol = 0.5 ; // Amps : Window size for convergence
    InitSensorlessObserverFOM6Step() ;
}


void SixStepEstimatePU()
{
    float b, v1 , v2 , v3 , s , c, vn ;
    float ipart , thetaAtan ;
    if ( (SLessState.SixStepObs.CmdTransitionTimeOut < SLPars.Pars6Step.nTransitionTime ) || ClaState.ConvergenceTime < CUR_CONVERGENCE_WDW_TIME   )
    { // In transition, so not calculate angle or speed
        if ( SLessState.SixStepObs.CmdTransitionTimeOut * SLPars.dT < ANGLE_EXTRAPOLATION_TIME_NAX )
        {
            SLessState.SixStepObs.CmdTransitionTimeOut += 1 ;
            SLessState.SixStepObs.ThetaRawPU += SLessState.SixStepObs.StepSpeed * SLPars.dT ;
        }
    }
    else
    {
        v1 = VarMirror.Va - SLessState.SixStepObs.FilteredR * VarMirror.Ia;
        v2 = VarMirror.Vb - SLessState.SixStepObs.FilteredR * VarMirror.Ib;
        v3 = VarMirror.Vc - SLessState.SixStepObs.FilteredR * VarMirror.Ic;
        vn = ( v1 + v2 + v3 ) * 0.33333333333f ;
        v1 = v1 - vn ;
        v2 = v2 - vn ;
        v3 = v3 - vn ;
        c = (v2 - v3) * 0.577350269189626f ;
        s = v1 ;
        thetaAtan = __atan2puf32(s , c ) + 0.5f  ;
        SLessState.SixStepObs.ThetaRawPU = thetaAtan + __sin( thetaAtan * 3 + SLPars.Pars6Step.Har3Phase ) * SLPars.Pars6Step.Har3Amp ;
    }

    // Accumulate the angle
    SLessState.SixStepObs.ThetaPsi += __SignedFrac(SLessState.SixStepObs.ThetaRawPU - SLessState.SixStepObs.ThetaPsi);
    // Error from the angle estimate
    b = (SLessState.SixStepObs.ThetaPsi - SLessState.SixStepObs.ThetaHat) ;
    // Limit the error
    SLessState.SixStepObs.ETheta = __fmax(__fmin(b, 40), -40);

    SLessState.SixStepObs.OmegaState = SLessState.SixStepObs.OmegaState + SLPars.KiTheta * SLPars.dT * SLessState.SixStepObs.ETheta;
    SLessState.SixStepObs.WLPFState = SLessState.SixStepObs.WLPFState + 0.1 * ( SLPars.KpTheta * SLessState.SixStepObs.ETheta - SLessState.SixStepObs.WLPFState) ;
    SLessState.SixStepObs.OmegaHat   = SLessState.SixStepObs.OmegaState + SLessState.SixStepObs.WLPFState ;

    // Advance angle by w
    SLessState.SixStepObs.ThetaHat = modff(SLessState.SixStepObs.ThetaHat+SLessState.SixStepObs.OmegaHat * SLPars.dT, &ipart);
    SLessState.SixStepObs.ThetaPsi -= ipart;

// Get the local estimates of Id/Iq
    s = __sinpuf32(SLessState.SixStepObs.ThetaHat);
    c = __cospuf32(SLessState.SixStepObs.ThetaHat);
    SLessState.IAlpha = 0.666666f * (VarMirror.Ia - 0.5f * (VarMirror.Ib + VarMirror.Ic));
    SLessState.IBeta = 0.577350269189626f * (VarMirror.Ic - VarMirror.Ib);

    SLessState.VAlpha = 0.666666f * (VarMirror.Va - 0.5f * (VarMirror.Vb + VarMirror.Vc));
    SLessState.VBeta = 0.577350269189626f * (VarMirror.Vc - VarMirror.Vb);

    SLessState.Id = c * SLessState.IAlpha + s * SLessState.IBeta;
    SLessState.Iq = -s * SLessState.IAlpha + c * SLessState.IBeta;

    if ( fabsf( Mod1Distance(VarMirror.QThetaPU, VarMirror.OldQThetaPU) > 0.08333f ))
    { // Was a step, begin Iq summation for the next step
        if ( SLessState.SixStepObs.IqMeanSumTime > 0.150e-3 )
        {
            SLessState.SixStepObs.IqMean = SLessState.SixStepObs.IqMeanSum / SLessState.SixStepObs.IqMeanSumTime  ;
        }
        else
        {
            SLessState.SixStepObs.IqMean = SLessState.Iq ;
        }
        SLessState.SixStepObs.IqMeanSumTime = 0 ;
    }

    SLessState.SixStepObs.IqMeanSum     += SLessState.Iq ;
    SLessState.SixStepObs.IqMeanSumTime *= SLPars.dT ;
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
    float d ;
    //float delta ;

    d = Mod1Distance(VarMirror.QThetaPU, VarMirror.OldQThetaPU) ;


    if ( fabsf(d) < 0.08333f  )
    {// Identify commutation step transition, nothing to do if no step
        return 0 ;
    }
    SLessState.FOM.StepDistance = Mod1Distance( SLessState.SixStepObs.ThetaHat , SLessState.FOM.OldThetaHat ) ;
    SLessState.FOM.OldThetaHat  = SLessState.SixStepObs.ThetaHat ;

    if  ( fabsf( SLessState.FOM.StepDistance * 6 - 1 ) > SLPars.FomPars.ObserverConvergenceToleranceFrac )
    {
        SLessState.FOM.ConvergenceGoodCounter = 0 ;
        return 0 ;
    }

    // Test angle retard
    SLessState.FOM.FOMRetardAngleDistance = Mod1Distance (ClaState.QThetaElect,SLessState.SixStepObs.ThetaHat) ;
    if ( (SLessState.FOM.FOMRetardAngleDistance > SLPars.FomPars.MaximumSteadyStateFieldRetard) ||
            (SLessState.FOM.FOMRetardAngleDistance < SLPars.FomPars.MinimumSteadyStateFieldRetard) )
    {
        SLessState.FOM.ConvergenceGoodCounter = 0 ;
        return 0 ;
    }

    if ( SLessState.FOM.ConvergenceGoodCounter >= SLPars.FomPars.CyclesForConvergenceApproval * 6  )
    {
        return 1 ;
    }
    else
    {
        SLessState.FOM.ConvergenceGoodCounter += 1 ;
    }
    return 0 ;
}


static short ManageAccelerationToWorkZone6Step(float CurMax)
{
    short RetVal , ConvergeStat ;
    short unsigned excp ;
    float CurCmd , sr , acc ,  piOut ;
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
            SLessState.SixStepObs.OpenLoopCurrent += SysState.Timing.TsTraj * SLPars.Pars6Step.OpenLoopCurDiDtMax ;
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
        CurCmd = __fmin(SLessState.SixStepObs.OpenLoopCurrent, CurCmd) ;
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
        CurCmd = GetOpenLoopCurrentCmd( SysState.SpeedControl.SpeedTarget, 0 , CurMax) ;

        SysState.StepperCurrent.StepperAngle = __fracf32(SysState.StepperCurrent.StepperAngle +  SysState.SpeedControl.SpeedReference * SysState.Timing.TsTraj) ;
        ClaState.QThetaElect = __fracf32(SysState.StepperCurrent.StepperAngle+0.25f) ;

        ConvergeStat = EstimateSensorlessObserverFOM6Step( );

        // Use SysState.Debug.DebugSLessCycle to disable transition to full control
        if ( SysState.Debug.DebugSLessCycle == 0 )
        {
            if (   ConvergeStat== 1  )
            {
                SLessState.FOM.bAcceleratingAsV2FState  = E_EngagingSpeedControl ;
                // For six-step the engagement mechanism about Id/Iq will not work.
                // We want QThetaElect to be SLessState.SixStepObs.ThetaHat + 0.25 , we will drag the angle offset slowly to it
                SLessState.SixStepObs.DeltaCom2Close = Mod1Distance(SLessState.SixStepObs.ThetaHat, ClaState.QThetaElect + 0.25f);
                //SLessState.SixStepObs.SetSpeedCtl = 0 ; // Kill pending speed control requests
                SLessState.FOM.bAcceleratingAsV2FState  = E_EngagingSpeedControl ;

                SysState.Mot.ReferenceMode = E_RefModeSpeed ;//Avoid SetReferenceMode()  since it will reset profile
                SetLoopClosureMode(E_LC_Speed_Mode) ;
                piOut = __fmin( __fmax( SLessState.SixStepObs.IqMean , ClaState.CurrentControl.ExtCurrentCommand * 0.333f) , CurMax * 0.75f ) ;
                ResetSpeedController2Speed(SysState.SpeedControl.SpeedReference  , piOut ) ;

                SysState.SpeedControl.ProfileAcceleration= SLPars.WorkAcceleration  ;
                SysState.SpeedControl.SpeedTarget = SLPars.WorkSpeed  ;
                RetVal = 1;

                // At this stage we engage the speed controller.
                // Because the speed is supposed to be stable with Iq, we assume that Iq is the current to continue with, so that it becomes the state of the speed integrator.
                // We expect about 90deg difference between the stepper angle and the estimated observer angle.
                // We transform the integrator states by [Co So;-So Co] * [Cs -Ss;Ss Cs] where the o subscript is for the observer and the s for the stepper.
                // The commutation angle is set to this of the observer
                //ClaMailIn.CandidateMotorSpeedCompensationVoltage = SLPars.PhiM * SLessState.SixStepObs.OmegaHat ;
                // Angle difference in matches d-d frame
                //arg = __fracf32 ( SLessState.SixStepObs.ThetaHat - (ClaState.QThetaElect - 0.25f) ) * PI2 ;
                //ClaMailIn.CandidateElectAngleTxC = __cos(arg) ;
                //ClaMailIn.CandidateElectAngleTxS = __sin(arg) ;
                //ClaMailIn.CandidateQElectAngle    = __fracf32(SLessState.SixStepObs.ThetaHat+0.25f) ;
                //ClaMailIn.CandidateId   = SLessState.Id ;
                // Synchronize
                //ClaState.CommutationSyncDone  = 0 ;
                //CLA_forceTasks(CLA1_BASE, CLA_TASKFLAG_4);
            }
            if ( SLessState.FOM.FOMConvergenceTotalTimer > SLPars.FomPars.FOMConvergenceTimeout)
            {
                if ( SysState.Debug.DebugSLessCycle == 0 )
                { // May disable convergence timeout for debugging
                    excp = exp_sensorless_no_initconverge  ;
                    break ;
                }
            }
            else
            {
                SLessState.FOM.FOMConvergenceTotalTimer += SysState.Timing.TsTraj ;
            }
            if (  SLessState.SixStepObs.OmegaState < SLPars.FomPars.OmegaCommutationLoss )
            {
                excp = exp_sensorless_underspeed_whileFOM  ;
            }
        }

        break;
    //case E_EngagingAngleObserver:
        //if ( ClaState.CommutationSyncDone  )
        //break ;
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
        if ( SLessState.FOM.bAcceleratingAsV2FState < E_EngagingSpeedControl)
        {
            ClaState.CurrentControl.ExtCurrentCommand = CurCmd  ;
        }
    }

    return RetVal;
}

void ResetEstimatorTout()
{
    if ( SLessState.SixStepObs.bUpdateBuf >= 1 )
    {
        SLessState.SixStepObs.bUpdateBuf  = 4 ;
    }
    SLessState.SixStepObs.TransitionTimeOut = 0 ;
    SLessState.SixStepObs.CmdTransitionTimeOut = 0 ;
}

static float SixStepPI(void)
{
    // Speed control works every cycle for the integrator to function correctly
    // New current command shall be activated only after R-calculation data collection
    float Cand     ;
    SysState.SpeedControl.SpeedError =  SysState.SpeedControl.SpeedCommand - SLessState.SixStepObs.StepSpeed ;




    SysState.SpeedControl.PIState = SysState.SpeedControl.PIState  +
            ControlPars.SpeedKi * SysState.SpeedControl.SpeedError ; // ( SysState.SpeedControl.SpeedCommand -  SLessState.SixStepObs.OmegaHat ) ;

    Cand  = ControlPars.SpeedKp * SysState.SpeedControl.SpeedError + SysState.SpeedControl.PIState  ;
    SysState.SpeedControl.PiOut = fSat( Cand, ControlPars.MaxCurCmd ) ;
    SysState.SpeedControl.PIState = fSat( SysState.SpeedControl.PIState ,ControlPars.MaxCurCmd)  ;

    if (Cand == SysState.SpeedControl.PiOut)
    {
        SysState.bInCurrentRefLimit = 0;
    }
    else
    {
        SysState.bInCurrentRefLimit = 1 ;
    }
    return SysState.SpeedControl.PiOut ;
}


// Sequence of action to be taken while the motor is on.
void MotorOnSeqAsSensorless6Step(void)
{
    float CurCmd , CurMax   , delta ;
    //short unsigned refmode , ClosureMode   ;
    short stat , step , nextstep ;

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

    if ( SLessState.SixStepObs.OmegaState < SLPars.FomPars.OmegaCommutationLoss )
    {
        if ( SLessState.SixStepObs.StopDetectCntr * SLPars.dT > 0.1f )
        {
            LogException( EXP_FATAL , exp_sensorless_underspeed )  ;
        }
        else
        {
            SLessState.SixStepObs.StopDetectCntr  += 1  ;
        }
        return  ;
    }
    else
    {
        SLessState.SixStepObs.StopDetectCntr  -= 3 ;
        if ( SLessState.SixStepObs.StopDetectCntr < 0 )
        {
            SLessState.SixStepObs.StopDetectCntr = 0 ;
        }
    }


    ClaMailIn.bNoCurrentPrefilter = 1 ; // Avoid excessive current stabilization time, not to kill the a
                                        // Electrical angle estimate

    // Limit the speed reference
    SysState.SpeedControl.SpeedCommand = fSatNanProt (SysState.SpeedControl.SpeedReference , ControlPars.MaxSpeedCmd ) ;


    // Decide commutation by electrical angle
    step = (short) ( ClaState.QThetaElect * 6 ) ;
    SLessState.SixStepObs.AngleCandidate = __fracf32 ( SLessState.SixStepObs.ThetaHat + 1.25f) ;
    delta = ( __fracf32( SLessState.SixStepObs.AngleCandidate) + 1 )  * 6.0f + 1.0f ;
    delta = delta - __fracf32(delta) ;
    ClaState.QThetaElect =  __fracf32((delta-0.5f) * 0.166666666666667f) ;
    nextstep = (short) ( ClaState.QThetaElect * 6 ) ;
    if ( nextstep != step)
    {
        CurCmd = SixStepPI() ;
        ResetEstimatorTout() ; // Eliminate angle counting till transient ends
        ClaState.CurrentControl.ExtCurrentCommand =  __fmin(__fmax( fSatNanProt( CurCmd , CurMax ) ,0),ClaState.CurrentControl.ExtCurrentCommand+1) ;
    }

#ifdef PIPIKAKI
    if ( SLessState.SixStepObs.SetSpeedCtl )
    {
    //ClaState.CurrentControl.ExtCurrentCommand = 0 ;
    //SLessState.SixStepObs.SetSpeedCtl = 0 ;

        // Wait R calculation completion
        if  ((SLessState.SixStepObs.bUpdateBuf==0) ||
                ( SLessState.SixStepObs.TransitionTimeOut >= SLPars.Pars6Step.nTransitionTime + SLPars.Pars6Step.nSummingTime ))
        {
            ResetEstimatorTout() ; // Eliminate angle counting till transient ends
            // Current command never goes negative , its not a servo
            // Also limit the rise rate
            ClaState.CurrentControl.ExtCurrentCommand =  __fmin(__fmax( fSatNanProt( CurCmd , CurMax ) ,0),ClaState.CurrentControl.ExtCurrentCommand+1) ;

            SLessState.SixStepObs.SetSpeedCtl = 0 ;
        }
    }


    if ( SLessState.SixStepObs.DeltaCom2Close )
    {
        // Mark not to take R or angle measurements
        ResetEstimatorTout() ;
        if ( SLessState.SixStepObs.DeltaCom2Close > 0 )
        {
            SLessState.SixStepObs.DeltaCom2Close = __fmax( SLessState.SixStepObs.DeltaCom2Close - 0.0417f , 0 ) ;
        }
        else
        {
            SLessState.SixStepObs.DeltaCom2Close = __fmin( SLessState.SixStepObs.DeltaCom2Close + 0.0417f , 0 ) ;
        }
    }
#endif


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

    SysState.Mot.ProfileConverged = SpeedProfiler() ;
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
 /*
    refmode = E_RefModeSpeed ;
    ClosureMode = E_LC_Speed_Mode ;
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
    */
}

