/*
 * GpioDrv.c
 *
 *  Created on: 3 במאי 2025
 *      Author: Yahali
 */

#include "..\Application\StructDef.h"




#define NGP
void setupGpioCAN(void)
{

#undef NGP
#define NGP 5
    GPIO_setPinConfig(GPIO_5_MCANA_RX);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_6SAMPLE);

#undef NGP
#define NGP 4
    GPIO_setPinConfig(GPIO_4_MCANA_TX );
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_6SAMPLE);
}



