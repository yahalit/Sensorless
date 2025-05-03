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
void InitPeripherals(void) ;

// AdcDrv
void ConfigureADC(void);
void SetupADCEpwm(Uint16 channel);

// ClaDrv
void CLA_configClaMemory(void) ;
void CLA_initCpu1Cla1(void);

// DMA
void StartDmaRecorder(void ) ;
void SetupClaRecDma(void);
void StopDmaRecorder(void) ;
void StopDmaUpdate(void);
short unsigned GetDMALastValid(void);
short unsigned GetRecorderTotalLength(void )  ;


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

// SysCtrl.c
void InitSysCtrlCpu1(void) ;
void PrepCpu2Work(void);
#endif /* APPLICATION_FUNCTIONS_H_ */
