/*
 * StructDef.h
 *
 *  Created on: 22 במרץ 2025
 *      Author: Yahali
 */

#ifndef DRIVERS_APPLICATION_STRUCTDEF_H_
#define DRIVERS_APPLICATION_STRUCTDEF_H_

#include <math.h>
#include <stdio.h>


#include "f28x_project.h"
#include "..\device_support\f28p65x\common\include\driverlib.h"
#include "..\device_support\f28p65x\common\include\device.h"

#ifdef VARS_OWNER
#define EXTERN_TAG
#pragma DATA_SECTION(ClaRecsCopy, ".data"); // Assure in DMA-accesible RAM
#else
#define EXTERN_TAG extern
#endif

#include "ConstDef.h"
#include "CanStruct.h"
#include "BITTimerAlloc.h"
#include "TimerArr.h"
#include "WhoIsThisProject.h"

#include "Revisions.h"
#include "HwConfig.h"
#include "ProjControlPars.h"
#include "Estimator.h"

#include "..\Recorder\Recorder.h"
#include "..\Control\ClaDefs.h"
#include "Revisions.h"
#include "..\Control\TrapezeProfiler.h"
#include "..\Drivers\EEPROM_Config.h"
#include "..\Core2Interface\S2MM2S.h"

// Byte  0:1 Control word. Thats: .0: motor on, 1: Fault reset, :2..4: Loop type : 5..7: Reference type
// Bytes 2..3 : Current limit, 10mAmp units
// Bytes 4..7: Command

struct CControlWord
{
    int unsigned MotorOn : 1 ;
    int unsigned FaultReset : 1 ;
    int unsigned LoopType  : 3 ;
    int unsigned RefType   : 3 ;
    int unsigned Reserved  : 4 ;
};

union UControlWord
{
    struct CControlWord CWord ;
    short  unsigned us ;
};

struct CPDO1Rx
{
    union UControlWord UCWord ;
    short unsigned CurLimit10mAmp   ;
    float Command ;
};

union UPDO1Rx
{
    struct CPDO1Rx PDO1Rx ;
    long unsigned ul[2] ;
    short unsigned us[4] ;
    short s[4] ;
    float f[2] ;
};



union UPDO2Rx
{
    float f[2] ;
    long unsigned ul[2] ;
    short unsigned us[4] ;
};


struct CFlashProg
{
    long PassWord ; // !< Must be 0x12345678 to work
    long unsigned AddressInFlash ; // !< Address in flash
    short unsigned InternalBufOffset ;
};
EXTERN_TAG struct CFlashProg  FlashProg ;

struct CTiming
{
    float Ts ;
    float TsTraj  ; // Sampling time for trajectory calculations
    float OneOverTsTraj  ; // 1/Sampling time for trajectory calculations
    long  unsigned ClocksOfInt ;
    long  unsigned LmeasClocksOfInt ;
    long unsigned UsecTimer ;
    long unsigned IntCntr ;
    short unsigned TsInTicks ;
    short unsigned PwmFrame ;
    float AutoCommandAge ;
};


struct CPosControl
{
    float PosReference  ; // !< Reference to the position controller
    float PosFeedBack   ; // !< Feedback for position control
    float PosError      ;
    float PosErrorR      ; // !< Realized pos error, after dead band consideration
    float SpeedLimitedPosReference ;
    float FilteredPosReference ;
    short DeadZoneState ; // 0 if in dead zone
    float PosErrorExt    ;
    float SpeedFFExt     ;
    float SpeedFFExtState     ;
    long unsigned RefTimer   ;
};

struct CSpeedControl
{
    float ProfileAcceleration    ; // !< Profiled acceleration to Target to the speed controller
    float SpeedTarget    ; // !< Target to the speed controller
    float SpeedReference ; // !< Reference to the speed controller
    float SpeedCommand   ; // !< Command to the speed controller composed of Reference and of position corrections
    float SpeedError     ; // !< Error of speed from command
    float PIState        ; // !< State of PI controller
    float PiOut          ; // !< Output of PI controller
};

//struct CCurrentControl
//{
//    short unsigned bInCurrentRefLimit ; // 1 if current reference is limited
//};


struct CVoltageControl
{
    float VoltageReference ;
    float MaxVoltage ;
    float VoltageCommands[3] ;
};


struct CRtBit
{
    float I2tInt  ; // I2t RT integrator
    float I2tState ; // State of I2t
    short unsigned I2tIntegrationCount ;  // I2t integrator counter
};



struct CAnalogProc
{
    float FiltCurAdcOffsetRef[3] ;
    float FiltCurAdcOffset[3] ;
    float Temperature ;
    short unsigned bOffsetCalculated ;
};


struct COuterSensor
{
    union
    {
        long l ;
        short unsigned us[2] ;
        short s[2] ;
        unsigned long ul ;
    }OuterPosInt ;
    float PotValue ;
    float OuterPos ;
    float OuterMerge ;
    float OuterMergeState ;
    float OuterMergeCst ;
};


struct CMCanSupport
{
    long unsigned  *pFifo0Start ;
    short unsigned Fifo0ElementWidth ;
    short unsigned Fifo0NumElements ; // Must be 2^N
    long unsigned  *pTxBufStart ;
    short unsigned TxBufElementWidth ;
    short unsigned TxNumElements ; // Must be 2^N
    union UPDO1Rx uPDO1Rx ;
    union UPDO2Rx uPDO2Rx ;
    union UPDO2Rx uNMTRx  ;
    union
    {
        unsigned long  long ll ;
        long unsigned ul[2] ;
    } Pdo1RxTime ;
    //long unsigned SyncTrackTime ;
    float MaxInterMessage ;
    float NomInterMessageTime ;
    float OneOverNomInterMessageTime ;
    float MinInterMessage ;
    float LastInterMessageTime ;
    float InterMessageTime ;
    //long  Usec4Sync  ;
    //long  Usec4ThisMessage ;
    //float Usec4ThisMessageDebt ;
    float OneOverActMessageTime ;
    float OneOverNomMessageTime ;
    //short unsigned SyncValid ;
    short unsigned PdoDirtyBoard ;
    short unsigned InBufCounter  ;
    short unsigned NodeStopped  ;
    short unsigned bAutoBlocked ;
};



#define CBIT_MOTOR_ON_MASK 1
#define CBIT_MOTOR_ON_SHIFTS 0
#define CBIT_MOTOR_READY_MASK 2
#define CBIT_MOTOR_READY_SHIFTS 1
#define CBIT_STO_EVT_MASK 4
#define CBIT_STO_EVT_SHIFTS 2
#define CBIT_PROFILE_CONVERGED_MASK 8
#define CBIT_PROFILE_CONVERGED_SHIFTS 3
#define CBIT_MOTION_CONVERGED_MASK 16
#define CBIT_MOTION_CONVERGED_SHIFTS 4
#define CBIT_MOTION_FAULT_MASK 32
#define CBIT_MOTION_FAULT_SHIFTS 5
#define CBIT_QUICK_STOP_MASK 64
#define CBIT_QUICK_STOP_SHIFTS 6
#define CBIT_BRAKE_RELEASE_MASK 128
#define CBIT_BRAKE_RELEASE_SHIFTS 7
#define CBIT_POT_REF_FAIL_MASK 256
#define CBIT_POT_REF_FAIL_SHIFTS 8
#define CBIT_LOOP_CLOSURE_MASK 0xE00
#define CBIT_LOOP_CLOSURE_SHIFTS 9
#define CBIT_SYSTEM_MODE_MASK 0x7000
#define CBIT_SYSTEM_MODE_SHIFTS 12
#define CBIT_CURRENT_LIMIT_MASK 0x8000
#define CBIT_CURRENT_LIMIT_SHIFTS 15

#define CBIT_NO_CALIB_MASK 0x10000
#define CBIT_NO_CALIB_SHIFTS 16
#define CBIT_GYRO_NOT_READY_MASK 0x20000
#define CBIT_GYRO_NOT_READY_SHIFTS 17
#define CBIT_REC_WAIT_TRIGGER_MASK 0x40000
#define CBIT_REC_WAIT_TRIGGER_SHIFTS 18
#define CBIT_REC_ACTIVE_MASK 0x80000
#define CBIT_REC_ACTIVE_SHIFTS 19
#define CBIT_REC_READY_MASK 0x100000
#define CBIT_REC_READY_SHIFTS 20
#define CBIT_G_REFGEN_ON_MASK 0x200000
#define CBIT_G_REFGEN_ON_SHIFTS 21
#define CBIT_T_REFGEN_ON_MASK 0x400000
#define CBIT_T_REFGEN_ON_SHIFTS 22
#define CBIT_T_AXIS  23 // 24 and 25 also
#define CBIT_T_AXIS_MASK 0x7800000



struct CCBit
{
    int unsigned MotorOn    : 1 ; //0
    int unsigned MotorReady : 1 ; // 1
    int unsigned StoEvent   : 1 ; // 2!< Braking in anticipation for disable by STO
    int unsigned ProfileConverged : 1 ; //3 !< Indication that profile has converged
    int unsigned MotionConverged : 1 ; //4 !< Indication that motion tracks with desired precision
    int unsigned MotorFault : 1 ;//5
    int unsigned QuickStop : 1 ;//6
    int unsigned BrakesReleaseCmd : 1 ; //7
    int unsigned PotRefFail : 1 ; // 8 Failure of potentiometer reference voltage
    int unsigned LoopClosureMode : 3 ; // 9-11
    int unsigned SystemMode : 3 ; //12-14
    int unsigned CurrentLimit : 1 ;//15
    int unsigned NoCalib : 1 ; // 16 Calib failure
    int unsigned GyroNotReady : 1 ; // 17 Gyro still calibrates its offset
    int unsigned RecorderWaitTrigger : 1 ; //18
    int unsigned RecorderActive : 1 ; // 19
    int unsigned RecorderReady  : 1 ; // 20
    int unsigned RefGenOn  : 1 ; //21
    int unsigned TRefGenOn  : 1 ; //22
    int unsigned IsTemperature : 1 ; //23
    int unsigned ReferenceMode      : 3 ; //24-26
    int unsigned Pdo3IsPotDiff : 1 ; // 27
    int unsigned Configured      : 1 ; // 28
    int unsigned Homed : 1 ; // 29
    int unsigned Din1 : 1 ; // 30
    int unsigned Din2 : 1 ; //31
};


struct CCBitCpu2
{
    int unsigned Cpu2HadWatchdogReset: 1 ;
    int unsigned Spare: 15 ;
};


union UCBit
{
    struct CCBit  bit ;
    long unsigned all ;
    short unsigned us[2] ;
};

#define INFINEON_DIAG_MASK (0xff<<3)

struct CCBit2
{
    int unsigned bAutoBlocked : 1 ;
    int unsigned NodeStopped :  1 ;
    int unsigned YobtVoyomat :  1 ;
    int unsigned InfineonFault: 1 ;
    int unsigned IaDiagPhU : 1 ;
    int unsigned UaDiagPhU : 1 ;
    int unsigned IaDiagPhV : 1 ;
    int unsigned UaDiagPhV : 1 ;
    int unsigned IaDiagPhW : 1 ;
    int unsigned UaDiagPhW : 1 ;
    int unsigned IaDiagDc : 1 ;
    int unsigned UaDiagDc : 1 ;
    int unsigned bRsvd : 4 ;
};

union UCBit2
{
    struct CCBit2  bit ;
    short unsigned all ;
    long unsigned  Lall ;
};

union UCBitCpu2
{
    struct CCBitCpu2  bit ;
    short unsigned all ;
    long unsigned  Lall ;
};


struct CRejectWarning
{
    short IgnoreWarning ;
    short unsigned exp ;
    long Msec ;
};


struct CMotion
{
     short unsigned QuickStop ;
     short unsigned BrakeRelease ;
     short unsigned ExtBrakeReleaseRequest  ;
     short unsigned BrakeControlOverride ; // Flag brake override. Motor on deletes .1 bit (&0xfffd) , Motor off deletes .2 bit (&0xfffb)
     short unsigned InBrakeReleaseDelay ; // Flag the start of a motor ON process. The motor is let a given time to ON, then brake releases with motor engaged, but frozen
     short unsigned InBrakeEngageDelay ;// Flag the start of a motor Off process. The motor is let a given time to stop, then brake engages with motor engaged but frozen
     short unsigned SafeFaultCode ;
     short unsigned ExceptionCnt ;
     short unsigned ExceptionInit ;
     short ReferenceMode ; // !< Decide how reference is calculated
     short PositionMode  ;
     short LoopClosureMode  ;
     short ProfileConverged ;
     short MotionConverged ;
     short CurrentLimitCntr ;
     short OffsetMeasureCntr ;
     long unsigned MotionConvergeCnt ;
     float MotionConvergeTime ; // !< The time position error should be continuously within window to declare convergence
     float CurrentLimitFactor ;
     long  unsigned KillingException ;
     short unsigned DisablePeriodicService ;
     long unsigned  LastException ;
     short unsigned MotorFault  ;
     short unsigned NoCalib ;
     short unsigned GyroNotReady ;
     short unsigned Homed ;
     short unsigned InAutoBrakeEngage ;
     long  unsigned ExceptionTab[EXCEPTION_TAB_LENGTH] ;
     long unsigned TimeOfSafeFatal ;
     struct CRejectWarning RejectWarning ;

};


struct CStatus
{
     short unsigned HaltRequest  ;
     short unsigned ResetFaultRequest  ;
     short unsigned ResetFaultRequestUsed ;
     short unsigned bNewControlWord ;
     short unsigned StopCan ;
     long  unsigned AbortCnt ;
     long  unsigned LongException ;
     long  unsigned Statistics ;
};



struct CRefGenState
{
    float Time ;
    float Out  ;
    float dOut  ;
    float State ;
    float sinwt ;
    float coswt ;
    short unsigned Type ;
    short unsigned On   ;
};




struct CHallCatch
{
    long KeyCatch ;
    long EncoderOnCatch ;
};

struct CCurExp
{
    float VoltageLevelPU  ;
    float MaxCurrentLevel ;
    float VoltageAnglePU  ;
};

struct CDebug
{
    struct CRefGenState GRef ;
    struct CRefGenState TRef ;
    struct CHallCatch HallCatch;
    float  fDebug[8] ;
    long   lDebug[8] ;
    short unsigned  bAllowRefGenInMotorOff  ;
    short unsigned  bTestBiquads ;
    short unsigned  bBypassPosFilter ;
    short IgnoreHostCW ; // 1 to ignore PDO1 control words from host
    short unsigned bDisablePotEncoderMatchTest ; // Disable testing the encoder agains the potentiometer
    short DebugSLessCycle ;
    struct CCurExp CurExp ;
};


struct CHoming
{
    long  EncoderOnStart ;
    long  MaxEncoderTravelHoming ;
    float HomingCurrent ;
    float HomingCurrentFilt ;
    float HomingCurrentFilterCst ;
    float HomingSpeed ;
    float HomingExitUserPos ; // Relative exit from homing after meeting
    long  unsigned Exception ;
    short State ;
    short Method  ;
    short Direction ;
    short SwInUse  ;
};


struct CEncoderMatchTest
{
    long unsigned  MotorEncoderRef   ;
    long unsigned WheelEncoderRef ;
    float DeltaTestUser     ; // The motion distance (of any encoder) after which we check match
    float DeltaTestTol      ; // Encoders permitted deviation (mainly due to backlash) over match measurement interval
    float MaxPotentiometerPositionDeviation ; // Maximum permitted difference between filtered potentiometer and encoder reading
    float DeltaEncoderMotor ; // Distance covered by motor encoder
    float DeltaEncoderWheel ; // Distance covered by wheel encoder
    float DeltaDeviation ;   // Deviation between the two distance sources
    short  bTestEncoderMatch ; // Flag if to test encoder matching
    short unsigned Algn ;
};


union UMultiType
{
    short unsigned us[2] ;
    long unsigned ul ;
    float f ;
    long l ;
    short s[2] ;
};


struct CCorrelations
{
    float * fPtrs[3] ;
    float TRefPhase ;
    float sCor1[3] ;
    float cCor1[3] ;
    float sCor2[3] ;
    float cCor2[3] ;
    float aCor1[3] ;
    float tCor1[3] ;
    float aCor2[3] ;
    float tCor2[3] ;
    float SumS2 ;
    float SumC2 ;
    float Sum1  ;
    float SumT2 ;
    float SumSC ;
    float SumST ;
    float SumS  ;
    float sumCT ;
    float SumC  ;
    float SumT  ;
    float CorTime   ;
    short nTakesCnt   ;          // Counts done takes
    short unsigned nInCycleCnt ; // Internal counter for in-cycle counts
    short unsigned nCyclesInTake    ;     // Number of cycles in one take. Can be e.g. 2 if frequency is achieved by N+0.5 sampling time
    short unsigned nSamplesForFullTake     ;     // Number of samples in a full take
    short unsigned nWaitTakes ;          // Full cycles to wait before start for convergence
    short unsigned nSumTakes  ;           // Number of cycles for consecutive averaging
    short unsigned state   ;             // State machine management
};
EXTERN_TAG struct CCorrelations Correlations ;


struct CUartSwBuf
{
    short unsigned buf[UART_SW_INP_BUF_SIZE] ;
    short unsigned nPut ;
    short unsigned nGet ;
};
EXTERN_TAG struct CUartSwBuf UartSwBuf ;


struct CPT
{
    float Pnew ;           // The newest point available
    float Pnow ;           // The present position reference
    float Speed ;          // Speed by difference of consecutive position demands
    float SpeedCmd ;          // Speed by command
    float Dspeed ;         // Reference error on new arrival, normally because of timing jitter and mismatch
    float Index ;          // Time advance index since newest message acceptance
    float QuickStopAcc ; // Acceleration for quick stop
    short unsigned NewMsgReady; // Flag a new message is accepted by the CAN
    short unsigned Init ;   // 1 if initialized
    short unsigned InitStop;   // 1 if stop is initialized
    short unsigned Converged ;
};


struct CSteerCorrection
{
    short SteeringAngle_PU  ;
    short bSteeringComprensation ;
    float SteeringFF        ;
    float WheelAddFilt      ;
    float WheelAddZ         ;
    float SteeringColumnDistRatio         ;// Ratio Distance of steering column from centre of ground wheel / wheel radi
};



struct CLMeas
{
    short unsigned State    ;
    short unsigned SubState    ;
    short Fault   ;
    volatile float *pCurIn  ;
    volatile float *pCurOut ;
    float CurIn   ;
    float CurOut  ;
    float CurMean ;
    float Vdc ;
    float TholdLow  ;
    float TholdHigh ;
    float TholdZero ;
    float RecTime ;
    short unsigned *pPwmFrc[3] ;
    short unsigned *pPTripForce ;
    float Tout ;
    long unsigned TState[16];
    long unsigned ExtState  ;
};


typedef struct
{
    float StaticCurrent ;
    float SpeedCurrent  ;
    float AccelerationCurrent ;
    float StepperAngle ;
} StepperCurrent_T;

struct CSysState
{
    struct CStatus Status ;
    struct CMotion Mot ;
    struct CTiming Timing ;
    struct CProfiler Profiler ;
    struct CPosControl PosControl ;
    struct CSpeedControl SpeedControl ;
    StepperCurrent_T StepperCurrent;
    //struct CCurrentControl CurrentControl ;
    struct CVoltageControl VoltageControl ;
    struct CRtBit RtBit ;
//    struct CPVT PVT ;
    struct CAnalogProc AnalogProc ;
    struct COuterSensor OuterSensor ;
    struct CMCanSupport MCanSupport ;
    struct CBlockUpload BlockUpload ;
    struct CBlockDnload BlockDnload ;
    struct CEncoderMatchTest EncoderMatchTest;
    struct CSteerCorrection SteerCorrection;
    struct CDebug Debug ;
    struct CHoming  Homing ;
    struct CPT PT ;
    union UCBit CBit ; // !< Status summary
    union UCBitCpu2 CbitCpu2 ;
    float IdPinVolts ; // !< Volts at the ID pin
    float ConfigDone ; // Approve that master completed configuration
    float InterpolationPosRef ; // Position reference for interpolation
    float UserPosOnHomingFW ;
    float UserPosOnHomingRev;
    union UCBit2 CBit2 ;
    short unsigned SeriousError  ;
    short unsigned AlignRefGen ;
    short unsigned IsInParamProgramming ;
    short unsigned ParamProgSector ;
    short unsigned FlashPrepared  ;
    union UMultiType  NoFsiMsgCnt ;
    long  unsigned EcapOnInt ;
    short unsigned IntfcDisableWheelAutoStop ;
    short unsigned SwState   ;
    short unsigned InterruptRoutineBusy ;
    short unsigned bHighSpeedCanLogger   ;
    short unsigned bCore2IsDead ; // Mark that core 2 is dead
    short unsigned WTF   ;
    short unsigned WTF1   ;
    short unsigned bInCurrentRefLimit ; // 1 if current reference is limited
    short unsigned Algn   ;
    long  unsigned ControlWord       ; // Last sample of control word
    struct CLMeas CLMeas ;
};

EXTERN_TAG struct CSysState SysState ;



struct CMasterBlaster
{
    long unsigned PassWord ;
};
EXTERN_TAG struct CMasterBlaster MasterBlaster;

union UOrder2Cfg
{
    struct COrder2Cfg
    {
        int unsigned IsInUse: 2  ;
        int unsigned IsSimplePole : 2 ;
        int unsigned IsSimpleZero : 2 ;
        int unsigned reserved : 10 ;
    } bit ;
    long unsigned ul ;
} ;


struct CFilt2
{
    float ZBw ;
    float ZXi ;
    float PBw ;
    float PXi ;
    union UOrder2Cfg Cfg ;
    float b00 ;
    float a2 ;
    float b0 ;
    float b1 ;
    float b2 ;
    float s0 ;
    float s1 ;
};


struct CControlPars
{
    float EncoderCountsFullRev ; // !< Encoder Resolution count/rev
    float MaxAcc   ; // !< Max acceleration . 1/sec^2
    float MaxSpeedCmd ; // Maximum permissible speed command
    float ProfileTau ; // Delay assumption in profile
    float SpeedCtlDelay ; // Delay to account for when preparing speed control command
    float PosKp ; //!< Proportional gain for the position controller
    float SpeedKp ; // !< Kp parameter of speed control
    float SpeedKi ; // !< Ki parameter of speed control
    float SpeedAWU ; // !< Anti windup parameter of speed control
    float MaxCurCmd ; //  !< Maximum permissible current command
    float I2tCurLevel    ; // !< Current level for I2C current protection
    float I2tCurTime     ; // !< Time in Current level for I2C current protection
    float I2tPoleS       ; // !<  I2T filter pole in rad/sec
    float I2tCurThold    ; // !< Exception Level for I2C current protection
    float MaxTemperature    ; // !< Exception Level for temperature protection
    float MinPositionCmd    ; // !< Minimum position command
    float MaxPositionCmd    ; // !< Maximum position command
    float MinPositionFb ;  // Minimum position feedback
    float MaxPositionFb ;  // Maximum position feedback
    float ShortCircuitLimitAmp ; // !< Short circuit limit Amperes
    float CurrentOffsetGain ; // !< Gain for correcting current measurement offset
    float StopDeceleration  ; // !< Deceleration for motion stop
    float FullAdcRangeCurrent        ; // !< Current for the full range of the ADC
    float SpeedFilterBWHz;   // !< Bandwidth of speed filter in Hz
    float CurrentFilterBWHz;   // !< Bandwidth of speed filter in Hz
    float BrakeReleaseVolts ; // !< Voltage required to release brakes
    float AbsoluteUndervoltage ;  // !< Under voltage hardware trip point
    float AbsoluteOvervoltage; // !<  Over voltage hardware trip point
    float DcShortCitcuitTripVolts ; //Delay assumption in profile
    float MotionConvergeWindow ; // User position window for motion convergence
    float PositionConvergeWindow     ; // !< Time window for position convergence
    float SpeedConvergeWindow ; // User speed window for motion convergence
    float MotionConvergeTime; // User position window time for motion convergence
    float PosErrorLimit  ; // Position error limit
    float BrakeReleaseDelay ; // :BrakeReleaseDelay [Control] {Delay from motor on to start of brake release}
    float BrakeReleaseOverlap; //  :BrakeReleaseDelay [Control] {Delay from brake release to start of motion referencing}
    float HighDeadBandThold ; // High side dead band hysteresis for position error
    float LowDeadBandThold  ; // Low side dead band hysteresis for position error;
    float AutoMotorOffTime  ; // Time for automatic motor off if motion converged
    float OuterSensorBit2User ; // Wheels only: conversion of wheel sensor to user units
    float KGyroMerge ; // Coefficient of merging for gyroscope data
    float PosErrorExtRelGain ; // Relative gain change when external pos error is applied
    float PosErrorExtLimit   ; // Limit of position error for the external error mode
    float PdoCurrentReportScale ; // The scale by which current reports at the PDO
    long  MaxSupportedClosure ;
    long  unsigned UseCase ;
    struct CFilt2 qf0 ;
    struct CFilt2 qf1 ;
};
EXTERN_TAG struct CControlPars ControlPars ;


EXTERN_TAG union UIdentity IdentityProg;


EXTERN_TAG union UCalibProg CalibProg;

EXTERN_TAG long unsigned FlashCalib ;

union UHallStat
{
    struct
    {
        unsigned short HallStat ;
        unsigned short ThetaPu  ;
    } fields ;
    unsigned short us[2] ;
    long l ;
    long unsigned ul;
};

struct CHallDecode
{
    unsigned short HallKey ;
    unsigned short OldKey ;
    unsigned short Old2Key ;
    unsigned short HallValue ;
    unsigned short HallException  ;
    unsigned short Init  ;
    union UHallStat ComStat ;
    long TimerOnCatch  ;
    float HallAngle ;
    float HallAngleOffset ;
    float HallSpeed ;
};
EXTERN_TAG struct CHallDecode HallDecode ;



struct CCommutation
{
    float ComAnglePu   ;
    long  OldEncoder    ;
    long  EncoderCounts ;
    long  EncoderCountsFullRev  ;
    long  Encoder4Hall   ;
    float Encoder2CommAngle ;
    float MaxRawCommChangeInCycle ; // Maximum commutation angle change in a cycle
    long  CommutationMode ; //Must be long as config parameter
    short Status ;
    short Init ;
};
EXTERN_TAG struct CCommutation  Commutation ;



EXTERN_TAG struct CCanQueue CanSlaveInQueue ;
EXTERN_TAG struct CCanQueue CanSlaveOutQueue ;
EXTERN_TAG unsigned long SlaveSdoBuf[SDO_BUF_LEN_LONGS];
EXTERN_TAG struct CSdo SlaveSdo ;
EXTERN_TAG short unsigned CanId ;
EXTERN_TAG short unsigned HallTable[8];
EXTERN_TAG short unsigned ProjId ;

struct CDBaseConf
{
    short unsigned IsUserConfiguration ;
    short unsigned IsUserHwConfig      ;
    short unsigned IsUserProjId        ;
    short unsigned IsValidIdentity     ;
    short unsigned IsValidDatabase     ;
};

EXTERN_TAG struct CDBaseConf DBaseConf     ;


union UVars
{
    float f ;
    long  l ;
    unsigned long ul ;
    short s[2] ;
    unsigned short us[2];
};


struct CSnap
{
    union UVars SnapBuffer[N_RECS_MAX] ;
    long  UsecTimer ;
    short SnapCmd   ;
};
EXTERN_TAG struct CSnap Snap ;

EXTERN_TAG long unsigned SdoMaxLenLongGlobal ;
EXTERN_TAG struct CSysTimerStr SysTimerStr ;



struct CCalibRecord
{
    short unsigned flags ; // !< Define the properties of the number: refer CCmdMode
    long  unsigned ptr ;
    float limit ;
};



struct CRefGenPars
{
    float Amp ;
    float f  ;
    float Dc ;
    float Duty ;
    long  bAngleSpeed  ;
    float AnglePeriod ;
    float Slope ;
};

union uPos
{
     long l[2] ;
     unsigned long ul[2] ;
     long long ll ;
};


struct CPosPrefilter
{
    long unsigned b01 ;
    long unsigned a21 ;
    long unsigned zero1;
    long unsigned u1 ;
    union uPos yold1 ;
    union uPos y1    ;
    long unsigned b02 ;
    long unsigned a22 ;
    long unsigned zero2;
    long unsigned u2 ;
    union uPos yold2 ;
    union uPos y2 ;
    float InPosScale ;
    float OutPosScale ;
    float OutSpeedScale ;
};
EXTERN_TAG struct CPosPrefilter PosPrefilter;

EXTERN_TAG struct CRefGenPars GRefGenPars ;
EXTERN_TAG struct CRefGenPars TRefGenPars ;

EXTERN_TAG long unsigned CfgDirty[8] ;



EXTERN_TAG struct CClaRecs ClaRecsCopy ;
EXTERN_TAG short unsigned Cpu2HadWatchdogReset ;


struct CFloatParRecord
{
    float * ptr ;
    short unsigned ind;
    float lower ;
    float upper ;
    float dflt ;
} ;


EXTERN_TAG float FloatParRevision        ;

extern short RecorderStartFlag     ;

#define GetOffsetC(x,y)  offsetof(struct CCalib, x)
#define GetOffsetCC(x,y,z) offsetof(struct CCalib, x[y])


#ifdef VARS_OWNER

const union UIdentity FakeIdentity = {.C =
    {.PassWord = 0x12345678 ,
         .Identity = {.PassWord = 0x12345678, .HardwareRevision=1 , .ProductionDate = (2025UL<<16)+1*256+1 ,
                       .RevisionDate = (2025UL<<16)+1*256+1 , .SerialNumber = 1 , .HardwareType = BESENSORLESSCARD , .ProductionBatchCode = 0 , .IdentityRevision = 1 , .cs = 0x98765432},
    },
}  ;


const struct CFloatParRecord ParTable [] =
{
#include "ParRecords.h"
    {( float *)0,0xffff,0.0f}
};
const short unsigned N_ParTable = ( sizeof(ParTable) / sizeof(struct CFloatParRecord)  ) ;


const struct CCalibRecord CalibPtrTable [] =
{
#include "CalibDefs.h"
};
const short unsigned N_CALIB_RECS = (sizeof(CalibPtrTable) / sizeof(struct CCalibRecord ) ) ;

/*
 * These parameters must have fixed indices for other SW to identify
 */
const struct CFloatConfigParRecord ConfigTable[] =
{
#include "ConfigPars.h"
};
const short unsigned nConfigPars = sizeof(ConfigTable)/ sizeof(struct CFloatConfigParRecord) ;

const short unsigned crc_ccitt_table[256] = {
    0x0000, 0x1189, 0x2312, 0x329b, 0x4624, 0x57ad, 0x6536, 0x74bf,
    0x8c48, 0x9dc1, 0xaf5a, 0xbed3, 0xca6c, 0xdbe5, 0xe97e, 0xf8f7,
    0x1081, 0x0108, 0x3393, 0x221a, 0x56a5, 0x472c, 0x75b7, 0x643e,
    0x9cc9, 0x8d40, 0xbfdb, 0xae52, 0xdaed, 0xcb64, 0xf9ff, 0xe876,
    0x2102, 0x308b, 0x0210, 0x1399, 0x6726, 0x76af, 0x4434, 0x55bd,
    0xad4a, 0xbcc3, 0x8e58, 0x9fd1, 0xeb6e, 0xfae7, 0xc87c, 0xd9f5,
    0x3183, 0x200a, 0x1291, 0x0318, 0x77a7, 0x662e, 0x54b5, 0x453c,
    0xbdcb, 0xac42, 0x9ed9, 0x8f50, 0xfbef, 0xea66, 0xd8fd, 0xc974,
    0x4204, 0x538d, 0x6116, 0x709f, 0x0420, 0x15a9, 0x2732, 0x36bb,
    0xce4c, 0xdfc5, 0xed5e, 0xfcd7, 0x8868, 0x99e1, 0xab7a, 0xbaf3,
    0x5285, 0x430c, 0x7197, 0x601e, 0x14a1, 0x0528, 0x37b3, 0x263a,
    0xdecd, 0xcf44, 0xfddf, 0xec56, 0x98e9, 0x8960, 0xbbfb, 0xaa72,
    0x6306, 0x728f, 0x4014, 0x519d, 0x2522, 0x34ab, 0x0630, 0x17b9,
    0xef4e, 0xfec7, 0xcc5c, 0xddd5, 0xa96a, 0xb8e3, 0x8a78, 0x9bf1,
    0x7387, 0x620e, 0x5095, 0x411c, 0x35a3, 0x242a, 0x16b1, 0x0738,
    0xffcf, 0xee46, 0xdcdd, 0xcd54, 0xb9eb, 0xa862, 0x9af9, 0x8b70,
    0x8408, 0x9581, 0xa71a, 0xb693, 0xc22c, 0xd3a5, 0xe13e, 0xf0b7,
    0x0840, 0x19c9, 0x2b52, 0x3adb, 0x4e64, 0x5fed, 0x6d76, 0x7cff,
    0x9489, 0x8500, 0xb79b, 0xa612, 0xd2ad, 0xc324, 0xf1bf, 0xe036,
    0x18c1, 0x0948, 0x3bd3, 0x2a5a, 0x5ee5, 0x4f6c, 0x7df7, 0x6c7e,
    0xa50a, 0xb483, 0x8618, 0x9791, 0xe32e, 0xf2a7, 0xc03c, 0xd1b5,
    0x2942, 0x38cb, 0x0a50, 0x1bd9, 0x6f66, 0x7eef, 0x4c74, 0x5dfd,
    0xb58b, 0xa402, 0x9699, 0x8710, 0xf3af, 0xe226, 0xd0bd, 0xc134,
    0x39c3, 0x284a, 0x1ad1, 0x0b58, 0x7fe7, 0x6e6e, 0x5cf5, 0x4d7c,
    0xc60c, 0xd785, 0xe51e, 0xf497, 0x8028, 0x91a1, 0xa33a, 0xb2b3,
    0x4a44, 0x5bcd, 0x6956, 0x78df, 0x0c60, 0x1de9, 0x2f72, 0x3efb,
    0xd68d, 0xc704, 0xf59f, 0xe416, 0x90a9, 0x8120, 0xb3bb, 0xa232,
    0x5ac5, 0x4b4c, 0x79d7, 0x685e, 0x1ce1, 0x0d68, 0x3ff3, 0x2e7a,
    0xe70e, 0xf687, 0xc41c, 0xd595, 0xa12a, 0xb0a3, 0x8238, 0x93b1,
    0x6b46, 0x7acf, 0x4854, 0x59dd, 0x2d62, 0x3ceb, 0x0e70, 0x1ff9,
    0xf78f, 0xe606, 0xd49d, 0xc514, 0xb1ab, 0xa022, 0x92b9, 0x8330,
    0x7bc7, 0x6a4e, 0x58d5, 0x495c, 0x3de3, 0x2c6a, 0x1ef1, 0x0f78
};
const union UIdentity * const pUIdentity = &FakeIdentity ;

#else
extern const struct CFloatParRecord ParTable[] ;
extern const short unsigned N_ParTable ;
extern const short unsigned N_CALIB_RECS;
extern const struct CCalibRecord CalibPtrTable [] ;
extern const struct CFloatConfigParRecord ConfigTable[] ;
extern const short unsigned nConfigPars ;
extern const short unsigned crc_ccitt_table[] ;
extern const union UIdentity FakeIdentity ;
extern const union UIdentity * const pUIdentity  ;
#endif



    struct CRecorderSig
    {
        short unsigned flags ; // !< Define the properties of the number: refer CCmdMode
        long  unsigned * ptr ;
    };

    #ifdef VARS_OWNER

    const struct CRecorderSig RecorderSigRaw[] =
    {
    #include "ProjRecorderSignals.h"
    };
    const short unsigned NREC_SIG = sizeof(RecorderSigRaw) / sizeof(struct CRecorderSig);
    #endif


#include "Functions.h"



inline
short unsigned BlockInts(void)
{
    return (unsigned short) __disable_interrupts( );
}


inline
void RestoreInts(short unsigned d)
{
    __restore_interrupts(d) ;
}

inline
float fSat( float x , float y )
{
    return __fmax(__fmin(x,y),-y);
}


inline
float fSign( float x)
{
    return ( x >= 0 ? 1 : -1 ) ;
}

#define Sat2Side(x,xl,xh)  __fmin(__fmax((x),(xl)),(xh))

inline
long ExtendCnt ( long lpos , short unsigned pos )
{
    union
    {
        long unsigned l ;
        short unsigned us[2] ;
        short signed s[2] ;
    } u1 , u2  ;

    u1.l = lpos ;
    u2.us[0] = pos - u1.us[0] ;
    u2.l = (long) u2.s[0] + u1.l ;
    return u2.l ;
}

inline
short unsigned pu2Short(float pu)
{
    union
    {
        long l ;
        short unsigned us[2] ;
    }u ;
    u.l = pu * 65536.0f ;
    return u.us[0];
}


inline
float fSatNanProt( float x , float y )
{
    if ( isnan(x) )
    {
        LogException(EXP_FATAL,exp_nan_in_control) ;
        return 0 ;
    }
    return __fmax(__fmin(x,y),-y);
}


inline unsigned short crc_ccitt_byte(short unsigned _crc, short unsigned c)
{
    return (_crc >> 8) ^ crc_ccitt_table[(_crc ^ c) & 0xff];
}




#endif /* DRIVERS_APPLICATION_STRUCTDEF_H_ */
