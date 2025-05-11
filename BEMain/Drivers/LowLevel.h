/*
 * LowLevel.h
 *
 *  Created on: May 12, 2023
 *      Author: Gal Lior
 */

#ifndef DRIVERS_LOWLEVEL_H_
#define DRIVERS_LOWLEVEL_H_

#include "..\device_support\f28p65x\common\include\inc\hw_types.h"

#include "..\device_support\f28p65x\common\include\eqep.h"
#include "..\device_support\f28p65x\common\include\epwm.h"
#include "..\device_support\f28p65x\common\include\cputimer.h"
#include "..\device_support\f28p65x\common\include\gpio.h"
#include "..\device_support\f28p65x\common\include\adc.h"
#include "..\device_support\f28p65x\common\include\cmpss.h"
#include "..\device_support\f28p65x\common\include\dma.h"
#include "..\device_support\f28p65x\common\include\mcan.h"
#include "..\device_support\f28p65x\common\include\lin.h"
#include "..\device_support\f28p65x\common\include\pin_map.h"
#include "..\device_support\f28p65x\common\include\asysctl.h"
#include "..\device_support\f28p65x\common\include\flash.h"
#include "..\device_support\f28p65x\common\include\memcfg.h"
#include "..\device_support\f28p65x\common\include\cla.h"
#include "..\device_support\f28p65x\common\include\ecap.h"
#include "..\device_support\f28p65x\common\include\dac.h"
#include "..\device_support\f28p65x\common\include\spi.h"
#include "..\device_support\f28p65x\common\include\fsi.h"

#include "..\device_support\f28p65x\common\include\device.h"

#ifndef CLA_FILETYPE
#include "..\Ti\libraries\flash_api\f28003x\include\FlashAPI\F021_F28003x_C28x.h"
#include "..\Ti\flash_programming_f28003x.h"
#endif

//
// Function Prototypes
//
__attribute__((interrupt))  void Cla1Task1();
__attribute__((interrupt))  void Cla1Task2();
__attribute__((interrupt))  void Cla1Task3();
__attribute__((interrupt))  void Cla1Task4();
__attribute__((interrupt))  void Cla1Task5();
__attribute__((interrupt))  void Cla1Task6();
__attribute__((interrupt))  void Cla1Task7();
__attribute__((interrupt))  void Cla1Task8();



#define MCAN0_BASE MCANA_MSG_RAM_BASE

#endif /* DRIVERS_LOWLEVEL_H_ */
