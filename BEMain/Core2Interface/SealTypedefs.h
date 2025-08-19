/*
 * SealTypedefs.h
 *
 *  Created on: 18 баев„ 2025
 *      Author: Yahali
 */

#ifndef CORE2INTERFACE_SEALTYPEDEFS_H_
#define CORE2INTERFACE_SEALTYPEDEFS_H_

typedef double real_T;
typedef float real32_T ;
typedef short int16_T  ;
typedef unsigned short uint16_T ;
typedef long int32_T;
typedef unsigned long uint32_T;


enum E_FunType
{
    E_Func_Initializer = 1,
    E_Func_Idle = 2,
    E_Func_ISR = 3,
    E_Func_Setup = 4,
    E_FuncException = 5 ,
    E_FuncAbort = 6
};

#endif /* CORE2INTERFACE_SEALTYPEDEFS_H_ */
