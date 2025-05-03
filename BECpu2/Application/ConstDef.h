/*
 * ConstDef.h
 *
 *  Created on: Apr 8, 2025
 *      Author: user
 */

#ifndef APPLICATION_CONSTDEF_H_
#define APPLICATION_CONSTDEF_H_


enum E_FindPosMgrState
{
    FindPosMgrPosNothing = 0 ,
    FindPosMgrPosSlope1 = 1 ,
    FindPosMgrNegSlope1p1 = 2 ,
    FindPosMgrNegSlope1p2 = 3 ,
    FindPosMgrNoSlope = 4 ,
    FindPosMgrPosSlope2p1 = 5 ,
    FindPosMgrPosSlope2p2 = 6 ,
    FindPosMgrPosSlope2 = 7 ,
    FindPosMgrPosDone = 8 ,
    FindPosMgrStateFailure = 15
};

#define TIMEOUT_FIND_POS_CUR_MAX 0.1

#endif /* APPLICATION_CONSTDEF_H_ */
