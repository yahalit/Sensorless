/*
 * Functions.h
 *
 *  Created on: 23 במרץ 2025
 *      Author: Yahali
 */

#ifndef APPLICATION_FUNCTIONS_H_
#define APPLICATION_FUNCTIONS_H_

// LowLevel
void InitPeripherals(void) ;

// AdcDrv
void ConfigureADC(void);
void SetupADCEpwm(Uint16 channel);

// ClaDrv
void CLA_configClaMemory(void) ;
void CLA_initCpu1Cla1(void);

// LowLevel.c
void GrantCpu2ItsDuePeripherals(void) ;
void GrantCpu2ItsMemories(void) ;
void InitPeripherals(void);


// SysCtrl.c
void InitSysCtrlCpu1(void) ;
void PrepCpu2Work(void);
#endif /* APPLICATION_FUNCTIONS_H_ */
