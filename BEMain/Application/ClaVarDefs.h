/*
 * ClaDefs.h
 *
 *  Created on: Mar 30, 2025
 *      Author: user
 */
#ifndef CLA_DEF_DEFINED
#define CLA_DEF_DEFINED


#ifdef CLA_VAR_OWNER
#define CLA_GLOBAL
#else
#define CLA_GLOBAL extern
#endif



struct CPosInit
{
    float InitCurrentThold ;
};
CLA_GLOBAL struct CPosInit PosInit ;



#endif



