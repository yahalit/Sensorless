/* =============================================================================
 *   Copyright (c) Texas Instruments Incorporated 2012-2015
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *
 *    Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 *    Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the
 *    distribution.
 *
 *    Neither the name of Texas Instruments Incorporated nor the names of
 *    its contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 *  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 *  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 *  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 *  \file stw_dataTypes.h
 *
 *  \brief Starterware header file containing standard data types.
 *
 */

#ifndef STW_DATATYPES_H_
#define STW_DATATYPES_H_

/* ========================================================================== */
/*                             Include Files                                  */
/* ========================================================================== */

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* ========================================================================== */
/*                           Macros & Typedefs                                */
/* ========================================================================== */
/*
typedef uint32_t      UInt32;
typedef int32_t       Int32;
typedef uint16_t      UInt16;
typedef int16_t       Int16;
typedef char          Char;
typedef void *        Ptr;
typedef uint32_t      UArg;
typedef double        Double;
typedef uint64_t      UInt64;
typedef unsigned char tBoolean;
typedef float         Float32;
*/
typedef uint16_t      Bool; // In sync with xdc/std.h



#if (!defined(DSP28_DATA_TYPES) && !defined(F28_DATA_TYPES))
#define DSP28_DATA_TYPES
#define F28_DATA_TYPES

#ifdef __TMS320C28XX_CLA__
typedef short                                   int16;
typedef long                                    int32;
typedef unsigned char                           Uint8;
typedef unsigned short                          Uint16;
typedef unsigned long                           Uint32;
typedef float                                   float32;
typedef long double                             float64;
typedef struct { Uint32 low32; Uint32 high32; } Uint64;
typedef struct { int32  low32; int32  high32; } int64;
#else // __TMS320C28XX__
typedef int                 int16;
typedef long                int32;
typedef long long           int64;
typedef unsigned int        Uint16;
typedef unsigned long       Uint32;
typedef unsigned long long  Uint64;
typedef float               float32;
typedef long double         float64;
#ifdef __TI_EABI__
typedef float         float32_t;
typedef double        float64_t;
#else // TI COFF
typedef float         float32_t;
typedef long double   float64_t;
#endif // __TI_EABI__
#endif

#endif //(!defined(DSP28_DATA_TYPES) && !defined(F28_DATA_TYPES))


/* To fix Misra-C errors */
#ifndef TRUE
#define TRUE  ((Bool) 1)
#endif
#ifndef FALSE
#define FALSE ((Bool) 0)
#endif

/* ========================================================================== */
/*                         Structure Declarations                             */
/* ========================================================================== */

/* None */

/* ========================================================================== */
/*                          Function Declarations                             */
/* ========================================================================== */

/* None */

#ifdef __cplusplus
}
#endif

#endif /* #ifndef STW_DATATYPES_H_ */
