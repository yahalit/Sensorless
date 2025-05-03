/*
 * CurrentControl.c
 *
 *  Created on: Mar 31, 2025
 *      Author: user
 */
#include <math.h>
#include "StructDef2.h"

short unsigned PosFindRsltVec[8*1024] ;


struct CAnalogs
{
    float Vdc  ;
    float I[3] ;
};

struct CRawAnalogs
{
    short unsigned I[3] ;
    short unsigned Vdc ;
};

struct RawAnalogs
{
    short unsigned Vdc  ;
    short unsigned I[3] ;
};


struct CAnalogs Analogs ;
struct CAnalogs PrevAnalogs ;
struct CRawAnalogs RawAnalogs ;




struct CMotor
{
    float Rnominal ; // Nominal resistance
    float LNominal ; // Nominal inductance
};
struct CMotor Motor ;

void FindPosMgrFail(short unsigned ExpCode)
{
    FindPosMgr.State = FindPosMgrStateFailure  ;
    FindPosMgr.Exception = ExpCode ;
    return ;
}

void FindPosMgrSetState(short unsigned NextState, float modeTimeOut )
{
    FindPosMgr.State = NextState ;
    FindPosMgr.TimeInMode = FindPosMgrPosNothing ;
    FindPosMgr.ModeTimeOut = modeTimeOut ;
}


// Switch state according to management state
const short FPMSwSt1[16]      = {0, 1,-1,-1,0, 1, 1,-1,-1,-1,-1,-1,-1,-1,-1,-1} ;
const short FPMSwSt2[16]      = {0,-1, 1, 1,0,-1,-1, 1,-1,-1,-1,-1,-1,-1,-1,-1} ;
const short FPMSIsTerminal[16]= {0, 0, 0 ,0,0, 0, 0, 0, 1 , 1 ,1,1,1,1,1,1};



short sw[3] ;


void (*CurrentInterrupt)() ;


void ControlSequencer(void)
{
    CurrentInterrupt = FindPosMgrIsr;
}



/*
 * This is a 2usec interrupt. It reads a vector of 3 currents and the DC bus voltage, as well as the 3 phase currents
 * That is 7 variables , totaling 7K. The variables are stored as ADC values for further analysis.
 */
void FindPosMgrIsr()
{
    // Look for readiness
    short ind ;
    if ( FPMSIsTerminal[FindPosMgr.State]  )
    {
        FindPosMgr.FinalScore[FindPosMgr.PhaseSetIndex] = ( FindPosMgr.Lrslt[0]+FindPosMgr.Lrslt[1]+FindPosMgr.Lrslt[4]+FindPosMgr.Lrslt[5]) * 0.25f ;
        ind = FindPosMgr.PhaseSetIndex+3 ;
        if ( ind >= 3 ) ind-= 3 ;
        FindPosMgr.FinalScore[ind] = ( FindPosMgr.Lrslt[2]+FindPosMgr.Lrslt[3]) * 0.5f ;

        FindPosMgr.PhaseSetIndex += 1 ;
        if ( FindPosMgr.PhaseSetIndex < 3 )
        {
            FindPosMgr.ind1 = FindPosMgr.PhaseSetIndex ;
            FindPosMgr.ind2 = FindPosMgr.ind1 + 1 ;
            if (  FindPosMgr.ind2 >= 3 )
            {
                FindPosMgr.ind2 = 0 ;
            }
            FindPosMgrSetState(FindPosMgrPosNothing, 0.1f ) ;
        }
        else
        {
            // Analyze first motor position
            // Get the first and the second harmony
        }
    }

}


void FindPosMgrSingleSet()
{
    float vnet , Itotal ;
    float bias  ;
    short unsigned *uPtr ;

    if ( FindPosMgr.State == FindPosMgrPosNothing )
    {

        // Wait current to fall below start threshold
        if ( fabsf(Analogs.I[0]) + fabsf(Analogs.I[1]) + fabsf(Analogs.I[2]) <  FindPosMgr.LowIThold)
        {
            FindPosMgr.BasicModeTimeOut = 2 * TimeForCurrent( FindPosMgr.HalfIThold *2  , Motor.Rnominal , Motor.LNominal ,  Analogs.Vdc);
            if ( FindPosMgr.BasicModeTimeOut > TIMEOUT_FIND_POS_CUR_MAX   )
            {
                FindPosMgrFail( exp_infinite_current_timeout) ;
                return ;
            }
            FindPosMgrSetState(FindPosMgrPosSlope1,FindPosMgr.BasicModeTimeOut )  ;
            ClearRegression(&Regression) ;
        }
        sw[0] = 0 ; sw[1] = 0 ; sw[2] = 0 ;
        FindPosMgr.cnt = 0 ;
        FindPosMgr.TimeInProcess = 0 ;
        return ;
    }

    FindPosMgr.TimeInMode += FindPosMgr.dT ;
    FindPosMgr.TimeInProcess += FindPosMgr.dT ;
    if (FindPosMgr.TimeInMode > FindPosMgr.ModeTimeOut )
    {
        FindPosMgrFail( exp_mode_timed_out) ;
    }


    // Recording
    uPtr = &PosFindRsltVec[(FindPosMgr.cnt*8) & 1023];
    uPtr[0] = RawAnalogs.I[0] ;
    uPtr[1] = RawAnalogs.I[1] ;
    uPtr[2] = RawAnalogs.I[2] ;
    uPtr[3] = RawAnalogs.Vdc  ;

    Itotal = Analogs.I[FindPosMgr.ind1] - Analogs.I[FindPosMgr.ind2] ;
    vnet = Analogs.Vdc - Analogs.I[FindPosMgr.ind1] * Motor.Rnominal ;

    switch (FindPosMgr.State )
    {
    case FindPosMgrPosSlope1:
        // Wait current to reach threshold
        if ( Itotal > FindPosMgr.HalfIThold)
        {
            RegressionAddXY(&Regression , Itotal , vnet ) ;
            if ( Itotal >= FindPosMgr.FullIThold)
            {
                RegressionSolve( &Regression ,&FindPosMgr.Lrslt[0] , &bias ) ;
                FindPosMgrSetState(FindPosMgrNegSlope1p1, FindPosMgr.BasicModeTimeOut * 0.5f  )  ;
                ClearRegression(&Regression) ;
            }
        }

        break ;
    case FindPosMgrNegSlope1p1:
        // Wait current to null
        if ( Itotal > FindPosMgr.HalfIThold)
        {
            RegressionAddXY(&Regression , Itotal , vnet ) ;
            if ( Itotal <= FindPosMgr.HalfIThold )
            {
                RegressionSolve( &Regression ,&FindPosMgr.Lrslt[1] , &bias ) ;
                ClearRegression(&Regression) ;
                FindPosMgrSetState(FindPosMgrNegSlope1p2,1.5f * FindPosMgr.BasicModeTimeOut )  ;
            }
        }
        break ;
    case FindPosMgrNegSlope1p2:
        // Wait current to null
        if ( Itotal < -FindPosMgr.HalfIThold)
        {
            RegressionAddXY(&Regression , Itotal , vnet ) ;
            if ( Itotal <= -FindPosMgr.FullIThold)
            {
                RegressionSolve( &Regression ,&FindPosMgr.Lrslt[2] , &bias ) ;
                ClearRegression(&Regression) ;
                FindPosMgrSetState(FindPosMgrNoSlope ,2 * FindPosMgr.BasicModeTimeOut )  ;
                FindPosMgr.TimeOfNextMode = FindPosMgr.TimeInProcess * 1.3333333333333333f;
            }
        }
        break ;
    case FindPosMgrNoSlope:
        //zero voltage intermission
        if ( FindPosMgr.TimeInProcess >= FindPosMgr.TimeOfNextMode)
        {
            FindPosMgrSetState(FindPosMgrPosSlope2p1 ,0.5f * FindPosMgr.BasicModeTimeOut )  ;
        }
        break ;
    case FindPosMgrPosSlope2p1:
        // Wait current to go beyond negative threshold
        RegressionAddXY(&Regression , Itotal , vnet ) ;
        if ( Itotal >= -FindPosMgr.HalfIThold)
        {
            RegressionSolve( &Regression ,&FindPosMgr.Lrslt[3] , &bias ) ;
            FindPosMgrSetState(FindPosMgrPosSlope2p2, FindPosMgr.BasicModeTimeOut * 1.5f  )  ;
            ClearRegression(&Regression) ;
        }
        break;
    case FindPosMgrPosSlope2p2:
        if ( Itotal > FindPosMgr.HalfIThold)
        {
            RegressionAddXY(&Regression , Itotal , vnet ) ;
            if ( Itotal >= FindPosMgr.FullIThold)
            {
                RegressionSolve( &Regression ,&FindPosMgr.Lrslt[4] , &bias ) ;
                ClearRegression(&Regression) ;
                FindPosMgrSetState(FindPosMgrPosSlope2 , FindPosMgr.BasicModeTimeOut )  ;
            }
        }
        break ;
    case FindPosMgrPosSlope2:
        if ( Itotal < FindPosMgr.HalfIThold)
        {
            RegressionAddXY(&Regression , Itotal , vnet ) ;
            if ( Itotal <= FindPosMgr.LowIThold)
            {
                RegressionSolve( &Regression ,&FindPosMgr.Lrslt[5] , &bias ) ;
                ClearRegression(&Regression) ;
                FindPosMgrSetState(FindPosMgrPosDone , 1e9f )  ;
            }
        }
        break ;
    case FindPosMgrPosDone:
        break;
    case FindPosMgrStateFailure:
        sw[0] = -1 ; sw[1] = -1 ; sw[2] =-1 ; // All off
        break ;
    }

    sw[FindPosMgr.ind1] = FPMSwSt1[FindPosMgr.State] ;
    sw[FindPosMgr.ind2] = FPMSwSt2[FindPosMgr.State] ; ;
    sw[FindPosMgr.ind3] = -1 ;

}



