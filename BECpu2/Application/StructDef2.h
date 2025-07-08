/*
 * StructDef2.c
 *
 *  Created on: Mar 27, 2025
 *      Author: user
 */

#ifndef APPLICATION_STRUCTDEF2_C_
#define APPLICATION_STRUCTDEF2_C_


#include "f28x_project.h"
#include "..\device_support\f28p65x\common\include\driverlib.h"
#include "..\device_support\f28p65x\common\include\device.h"


#include "..\Algorithm\ProjMath.h"
#include "..\SelfTest\ErrorCode.h"

#include "ConstDef.h"
#include "..\..\BEMain\Application\S2MM2S.h"

#ifdef CORE2_VARS_OWNER
#define EXTERN_TAG
#else
#define EXTERN_TAG extern
#endif

EXTERN_TAG struct CRegression Regression;

struct CFindPosMgr
{
    short State ; // Internal state
    short PhaseSetIndex ; // Index of the actve phase set
    short cnt  ;
    short ind1 ;
    short ind2 ;
    short ind3 ;
    short unsigned Exception ;
    float dT ; // Sampling time of algorithm
    float LowIThold ;
    float HalfIThold ;
    float FullIThold ;
    float TimeInProcess ;
    float TimeOfNextMode ; // The time to stay in the next mode (if it is timed)
    float TimeInMode ;
    float BasicModeTimeOut ;
    float ModeTimeOut ;
    float Lrslt[6] ;
    float FinalScore[6] ;
};
EXTERN_TAG struct CFindPosMgr FindPosMgr ;


#include "Functions.h"

#endif /* APPLICATION_STRUCTDEF2_C_ */
