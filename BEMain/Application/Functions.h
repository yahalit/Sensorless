/*
 * Functions.h
 *
 *  Created on: 23 במרץ 2025
 *      Author: Yahali
 */

#ifndef APPLICATION_FUNCTIONS_H_
#define APPLICATION_FUNCTIONS_H_

// AsmUtil
void CopyMemRpt( short unsigned * dst , short unsigned * src , short unsigned n ) ;
void ClearMemRpt( short unsigned * dst , short unsigned n ) ;
void MemClr(short unsigned *pTr, short unsigned siz); // Clear a memory chunk
long GetUnalignedLong(short unsigned *uPtr);
float GetUnalignedFloat(short unsigned *uPtr);

// GpioDrv
void setupGpio(void);
void setupGpioCAN(void);

// LowLevel

// LowLevel
void InitPeripherals(void) ;
void SetupIsr(void);
void PauseInts(void);
void UnpauseInts(void);
float GetTemperatureFromAdc(float volts);

void initCLAMemory(void);
void initCLA(void);
void SetClaAllSw(void);
void setupEcap(void);
void WaitUsec( long unsigned usec );
void setupHallInputs(void) ;

#ifdef ON_BOARD_CAN
void setupGpioCAN(void);
#endif

// AdcDrv
void ConfigureADC(void);
void SetupADCEpwm(Uint16 channel);

// ClaDrv
void CLA_configClaMemory(void) ;
void CLA_initCpu1Cla1(void);


// Commutation
short GetCommAnglePu(long Encoder);
short GetHallComm(void);
void InitHallModule(void);



// Controllers
void MotorOnSeq(void);
void MotorHoldSeq(void);
void MotorOffSeq(void);
void ArmAutomaticMotorOff(void);
short SetMotorOn(short OnCondition) ;
void SetMotorOff(enum E_MotorOffType  Method ) ;
void SafeSetMotorOff(void) ;
long unsigned SetLoopClosureMode( short us );
long unsigned SetReferenceMode( short us);
void ResetSpeedController(void) ;
void SwitchMotionProfile (void);
float  RunBiquads(float CandR, float cursat);
float PosPrefilterMotorOn(float y , float *yf );
void PosPrefilterMotorOff(float y);
void DecodeBhCmdValue(float f );
void DecodeBhCW(long unsigned data);
void ResetRefGens(void);

// DMA
void StartDmaRecorder(void ) ;
void SetupClaRecDma(void);
void StopDmaRecorder(void) ;
void StopDmaUpdate(void);
short unsigned GetDMALastValid(void);
short unsigned GetRecorderTotalLength(void )  ;

// FlashDrv
void   SetupFlash(void);
void Sample_Error() ;
short PrepFlash4Burn(void);
short EraseSector(unsigned long SecAddress );
short ProgramPageAutoECC( unsigned short * , long unsigned, long unsigned buflen);



// Homing.c
long HomeProfiler(void);
long unsigned SetAbsPosition( float pos);
long unsigned InitHomingProc( void );
long ImmediateHoming(void);
long HomingHere(float f );

// MainApp
void InitAppData(void);
short SetSystemMode(short  x);
short InitControlParams(void) ;
short DealCalibration (short unsigned rd);
short ReadCalibFromFlash ( long unsigned *Dest , long unsigned Src_in   );
short CheckAlign ( short unsigned * ptr , short unsigned pw );
short SetProjectSpecificData( short unsigned proj );
void CfgBlockTransport(void);
void InitPosPrefilter(void);
short ApplyIdentity(union UIdentity * pId, union UNVParams *pPars);
void SetProjectId(void);
void FlushCanQueues(void);
short  SetMotionCommandLimits(void) ;



// ObjectDict
short unsigned GetOdSize( void ) ;
short GetObjIndex(short unsigned TargetIndex , struct CObjDictionaryItem **pObject, const struct CObjDictionaryItem *Dict);
short IsInRange( float *x , float xmax , float xmin );
long unsigned GetManufacturerSpecificCode (long code);
void ResetConfigPars(void) ;
short TestCfgProgramming(void);
short IsBufferUsedForProgramming(void);
long unsigned TestCfgPar( const struct CFloatConfigParRecord *pPar , long rawvalue );



// LowLevel.c
void GrantCpu2ItsDuePeripherals(void) ;
void GrantCpu2ItsMemories(void) ;
void InitPeripherals(void);

// PrjMCAN
void setupMCAN(void);
void RtCanService(void);
short SetMsg2HW(struct CCanMsg  *pMsg );
void SetBootUpMessage( void );
void SetExtendedBootUpMessage( void );
void SetLLCBootUpMessage( void );
void RTDealBlockUpload(void);
void DealBlockDloadRt();
void BlockUploadConfirmService( struct CCanMsg *pMsg) ;
short PutCanSlaveQueue( struct CCanMsg * pMsg);

// PWM drive
void KillMotor(void) ;
void SetupPWM(uint32_t base,unsigned short pwmPeriod_usec );
void SetupPwmPacer(uint32_t base,unsigned short pwmPeriod_usec );
void setupPwmParams(void);
void ClearTrip(void) ;
void SetGateDriveEable(short in);

// PT Driver
void InitPVT(void);
short StayInPlaceDriver();
void PVNewMessageDriver( float PosRef  ) ;
short PVTRunTimeDriver(long unsigned tUsec);
void PVResetTraj(void) ;
short PTRunTimeDriver(void);

// Recorder
short unsigned GetRecorderStat(void) ;
float *  GetFSignalPtr( short si );
void SnapIt( short unsigned * pSnap ) ;

// SelfTest
void IdleCbit(void);
long unsigned LogException (   short fatality , long unsigned exp );
short IsResetBlocked(void) ;


// SpeedProfiler
short SpeedProfiler( void ) ;

// SysCtrl.c
void InitSysCtrlCpu1(void) ;
void PrepCpu2Work(void);



inline
float CenterDiffPu( float x, float y )
{
    return ( __fracf32 ( __fracf32 ( x - y + 0.5f ) + 1 ) - 0.5f ) ;
}

// Testing
void RefGen(struct  CRefGenPars *pPars , struct CRefGenState *pState , float dt );
void GetSinCorrelation(void);

// Macros

/*
 * Translate an angle that may be in the range [-1 to 1] to short integer report of 1/2^15 rotation
 */
inline
unsigned short Angle2Short( float f_in)
{
    union
    {
        long l ;
        unsigned short us[2] ;
    }u;
    float f ;
    f = f_in * 0.318309886183791f ; // 1/pi
    u.l = (long) ( __fmax( __fmin( f , 0.999938964843750f ) , -0.999938964843750f ) * 32768.0f ) ;
    return u.us[0] ;
}

/*
 * Translate position that may be in the range [-3m to 3m] to short integer report of 1/2^14 m
 */
inline
unsigned short Distance2Short (float f)
{
    union
    {
        long l ;
        unsigned short us[2] ;
    }u;
    u.l = (long) ( __fmax( __fmin( f ,2.5f ) , -2.5f ) * 13000.0f ) ;
    return u.us[0] ;
}

#endif /* APPLICATION_FUNCTIONS_H_ */
