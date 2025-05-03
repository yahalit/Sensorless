/*
 * StructDef.h
 *
 *  Created on: 22 במרץ 2025
 *      Author: Yahali
 */

#ifndef DRIVERS_APPLICATION_STRUCTDEF_H_
#define DRIVERS_APPLICATION_STRUCTDEF_H_


#include <Application/ClaVarDefs.h>
#include "f28x_project.h"
#include "..\device_support\f28p65x\common\include\driverlib.h"
#include "..\device_support\f28p65x\common\include\device.h"
#ifdef VARS_OWNER
#define EXTERN_TAG extern
#else
#define EXTERN_TAG
#endif

#include "Functions.h"

#endif /* DRIVERS_APPLICATION_STRUCTDEF_H_ */
