/*
 * ClaDefs.h
 *
 *  Created on: Mar 30, 2025
 *      Author: user
 */
#ifndef CLA_DEF_DEFINED
#define CLA_DEF_DEFINED


#ifdef CLA_VARS_OWNER
#define CLA_GLOBAL
#pragma DATA_SECTION(ClaState,"Cla1DataRam")
#else
#define CLA_GLOBAL extern
#endif



struct CPosInit
{
    float InitCurrentThold ;
};
CLA_GLOBAL struct CPosInit PosInit ;


struct CClaState
{
    short Mode ;
    short State ;
};


CLA_GLOBAL struct CClaState ClaState ;

#endif



