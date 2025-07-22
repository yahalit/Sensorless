/*
 * Recorder.h
 *
 *  Created on: May 13, 2023
 *      Author: yahal
 */

#ifndef SHAREDH_RECORDER_H_
#define SHAREDH_RECORDER_H_


void RtRecorder(void);
void  SampleRecordedSignals(void);
void InitRecorder(long FastIntsInC, float FastTsUsec, long unsigned SdoBufLenLongs);

short EmptyRecorderTrigger(void);
short ImmediateRecorderTrigger(void);
short RecorderUpFloatTrigger(void);
short RecorderDnFloatTrigger(void);
short RecorderUpSuTrigger(void);
short RecorderDnSuTrigger(void);
short RecorderUpSTrigger(void);
short RecorderDnSTrigger(void);
short RecorderUpLuTrigger(void);
short RecorderDnLuTrigger(void);
short RecorderUpLTrigger(void);
short RecorderDnLTrigger(void);

long unsigned  SetRecorder( struct CSdo * pSdo ,short unsigned nData);
long unsigned  GetRecorder( struct CSdo * pSdo ,short unsigned *nData);
//long unsigned  SetRecorderTableEntry( struct CSdo * pSdo ,short unsigned nData);
long unsigned  SetSignal(   struct CSdo * pSdo ,short unsigned nData);
long unsigned  GetSignalFlags(  struct CSdo * pSdo ,short unsigned *nData);
long unsigned  GetSignal(   struct CSdo * pSdo ,short unsigned *nData);

long unsigned  GetGpio( struct CSdo * pSdo ,short unsigned *nData);
long unsigned  SetGpio( struct CSdo * pSdo ,short unsigned nData);

long  unsigned   ActivateProgrammedRecorder(void);

extern const short unsigned NREC_SIG;
extern const struct CRecorderSig RecorderSigRaw[];


//#ifdef _LPSIM
#define uRecLen unsigned long
#define RecLen  long
//#else
//#define uRecLen unsigned short
//#endif


/**
*\struct Bitfield: Define the properties of a numeric field
*/
struct CCmdMode
{
    int unsigned SetFun : 1;
    int unsigned IsFloat : 1;
    int unsigned IsUnsigned : 1;
    int unsigned IsShort : 1;
    int unsigned WriteProtect : 1;
    int unsigned IsDouble : 1;
    int unsigned IsSimOnly : 1;
    int unsigned IsCpu2 : 1;
    int unsigned IsSuperFast : 1; //256
    int unsigned rest : 7;
};

struct CUltraFast
{
    short unsigned MasterCntrAtTrigger ;
    short unsigned MasterCntrAfterTrigger ;
    short unsigned LastValidTransfer ;
    short unsigned UltraFastActive   ;
};
// Struct for the signal recorder
struct CRecorder
{
    long  Minus1        ; // Just the number (-1)
    long  RFlag         ; //!< Detector for the PutCntr exceeding GetCntr
    long  EndFlag       ; //!< Detector of end condition arrived
    long           TriggerLongVal ; // !< Trigger value for long comparison
    float          TriggerFloatVal ; // !< Trigger value for float comparison
    short (*TriggerFunc)(void) ; //!< The trigger event function
    unsigned long  * volatile pBuffer ;
    long unsigned *TriggerPtr ; //!< Points to trigger variable
    short Stopped ; //!< 1 if recorder is stopped
    RecLen PutCntr ; //!< Where to put next record
    //uRecLen GetCntr ; //!< Index of oldest valid record
    short unsigned GapCntr ; //!< decimation counter
    RecLen StartRec ; //!< The index taken as start of actual record
    RecLen EndRec   ; //!< The last valid index of the actual record
    RecLen PreTrigCnt; //!< The (maximal) number of records to place before the trigger event
    RecLen PreTrigTotalCnt ; //!< The (maximal) number of all-signal-records to place before the trigger event
    short TimeBasis ; // !< 0 for 16usec time basis, 1 for main process time basis
    RecLen BufSize ; //!< (not necessarily) 2^N-1, where the buffer length is 2^N longs
    short TriggerActive ; //!< Marker that the trigger condition had been met
    short unsigned  RecorderListLen ; //!< The number of signals that need be recorded
    RecLen RecLength ; //!< Length of a single signal record
    RecLen TotalRecLength ; // !< Total number of longs that consist a record
    short unsigned  RecorderGap ; //!< The decimation level
    short unsigned TriggerFlags; // !< Flags for the trigger type
    short unsigned Ready4Trigger; //!< 1 if ready to detect trigger
    short unsigned RecorderListIndex[N_RECS_MAX];   //!< List of indices of recorded variables
    long unsigned *RecorderList[N_RECS_MAX];    //!< List of pointers to recorded variables
    short unsigned RecorderFlags [N_RECS_MAX];  //!< List of CCmdMode flags for recorded variables
    short TriggerType ; // !< Type of recorder trigger
    short unsigned Sig2Bring ; // !< The signal index to upload
    long  BringStartIndex ; // !< The first index in the signal to upload
    long  BringEndIndex ; // !< The last index in the signal to upload
    short unsigned Active ; // !< 1 if recorder had been ever put to action
    short unsigned TriggerIndex ; // !< Index of signal to trigger by
    short BufferReady ;
    short TimerBasedTs  ;
    long  TimerBasedTsCntr   ;
    long  TimerBasedTsTstart ;
    long  TimerBasedTsTend   ;
    long FastIntsInC; // !< Fast interrupts in C loop
    float FastTsUsec;  // !< Fast interrupt TS
    long unsigned SdoBufLenLongs; // !< Largest available SDO buffer , in 32bit units
    struct CUltraFast uf ;
} ;

#ifdef REC_VARS_OWNER
#define REC_EXTERN_VAR
#else
#define REC_EXTERN_VAR extern
#endif
REC_EXTERN_VAR struct CRecorder Recorder;
REC_EXTERN_VAR struct CRecorder RecorderProg;

/*
struct CNavInfo
{
    float xc[2] ;
    float yaw   ;
    long  usec  ;
    long  Renc  ;
    long  Lenc  ;
};
*/

#ifdef REC_VARS_OWNER
// Flags = 0 for long , 2 + float (see more options in the CRecorderSig definition)
//struct CRecorderSig RecorderSig[SIG_TABLE_SIZE] ;
//unsigned long RecorderBuffer[REC_BUF_LEN]; //<! Recorder buffer

unsigned long volatile RecorderBuffer[REC_BUF_LEN]; //<! Recorder buffer
#pragma DATA_SECTION(RecorderBuffer, ".data"); // Assure in DMA-accesible RAM

#else
extern const struct CRecorderSig RecorderSigRaw[] ;
//extern const short unsigned NREC_SIG ;

//extern unsigned long RecorderBuffer[]; //<! Recorder buffer
extern unsigned long  volatile RecorderBuffer[] ;

#endif



#endif /* SHAREDH_RECORDER_H_ */
