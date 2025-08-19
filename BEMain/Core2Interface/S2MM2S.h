/*
 * S2MM2S.h
 *
 *  Created on: 25 αιεπι 2025
 *      Author: Yahali
 */

#ifndef APPLICATION_S2MM2S_H_
#define APPLICATION_S2MM2S_H_


#ifdef INTFC_OWNER
#define INTFC_EXTERN_TAG
#pragma DATA_SECTION(M2S, "MSGRAM_CPU1_TO_CPU2");
#pragma DATA_SECTION(S2M, "MSGRAM_CPU2_TO_CPU1");
#else
#define INTFC_EXTERN_TAG extern
#endif


#include "SealInterface.h"

struct CLimitsBitField
{
    int unsigned CurrentLimit   : 1 ;
    int unsigned I2tCurrentLimit: 1 ;
    int unsigned VoltageLimit   : 1 ;
    int unsigned SpeedCommandLimit : 1 ;
    int unsigned HighPosLimit : 1  ;
    int unsigned LowPosLimit  : 1  ;
    int unsigned Spare : 10 ;
};


union CUserMultiType
{
    short unsigned us[4] ;
    long unsigned ul[2] ;
    float f[2] ;
    long l[2] ;
    long long ll ;
    unsigned long long ull ;
    short s[4] ;
};

struct CUserMessage
{
    long unsigned CobId ;
    short unsigned Index ;
    short unsigned SubIndex ;
    short unsigned Dlc ;
    short unsigned Spare ;
    long  unsigned TimeStamp ;
    union
    {
        short unsigned us[16] ;
        long unsigned ul[8] ;
        float f[8] ;
        long l[8] ;
        long long ll[4] ;
        unsigned long long ull[4] ;
        short s[16] ;
    };
};


struct CObjectResponse
{
    long unsigned index ;
    short unsigned SubIndex ;
    short unsigned ResponseType ; // Type of interpreter response
    short unsigned ResponseCounter ; // Increments every new interpreter response
    short unsigned RequestStamp ; // A copy of the request stamp for which this is response
    union CUserMultiType Payload  ;
};

struct CCommString
{
    short unsigned PutCounter  ;
    short unsigned FetchCounterCopy ;
    unsigned short Status ;
    unsigned short AppHasComm  ; // 1 if the string communication is routed to the app.
    short unsigned Buffer[256] ;
};

struct CAppLimits
{
    double UpperPosLimit ;
    double LowerPosLimit ;
    float  SpeedLimit    ;
    float  CurrentLimit  ;
    long   Spare[8] ;
};

struct CM2S
{
    FeedbackBuf_T FeedbackBuf ;
    SetupReportBuf_T SetupReportBuf ;
    short  unsigned SensorConfig[8] ; // Sensor configuration
    struct CLimitsBitField LimitsBitField ;
    long unsigned ExceptionCode ; // Exception code
    long  unsigned ProfileStatus ; // TBD profiling status
    struct CObjectResponse InterpreterResponse  ; // Interpreter response
    short  unsigned AppCanId;
    short  unsigned UserMessagePutCounter  ;
    short  unsigned UserMessageOferflow ;
    short  unsigned CommBufferOverflow  ;
    long  long unsigned TimeStampUsec ;
    struct CCommString CommString ; // Communication string, incoming
    struct CUserMessage UserMessage[8] ;
    struct CAppLimits AppLimits ;
};

union UM2S
{
    long ul[512] ;
    struct CM2S M2S ;
};

struct CS2M
{
    DrvCommandBuf_T DrvCommandBuf ;
    short unsigned SnatchedBySeal ;
    struct CUserMessage UserMessage[8] ;
    short  unsigned UserMessageFetchCounter  ;
    struct CCommString CommString ; // Communication string, incoming
    short  unsigned ComBufferFetchCounter  ;
    short unsigned Algn ;
    short unsigned bValid ;
};

INTFC_EXTERN_TAG union UM2S M2S ;

union US2M
{
    long ul[512] ;
    struct CS2M S2M;
};

INTFC_EXTERN_TAG union US2M S2M ;

#endif /* APPLICATION_S2MM2S_H_ */
