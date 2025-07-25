/*
 * GpioDrv.c
 *
 *  Created on: 3 ���� 2025
 *      Author: Yahali
 */

#include "..\Application\StructDef.h"



// GPIO14-15 shall be PWM8 to go for PWM3
// IO 4-5 are to be directed to CAN
// On the EV board 4 shall be connected to 14 and 5 to 15 (both 14 and 15 are NC on the BE board)
// S4 shall be connected 2 to 1 and 3 to 4 so that (4) is CAN TX and (5) is CAN RX
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


void setupGpioPWM(void)
{

#undef NGP
#define NGP 0
    GPIO_setPinConfig(GPIO_0_EPWM1_A);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_SYNC);


#undef NGP
#define NGP 1
    GPIO_setPinConfig(GPIO_1_EPWM1_B);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_SYNC);

#undef NGP
#define NGP 2
    GPIO_setPinConfig(GPIO_2_EPWM2_A);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_SYNC);


#undef NGP
#define NGP 3
    GPIO_setPinConfig(GPIO_3_EPWM2_B);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_SYNC);


#undef NGP
#define NGP 14
    GPIO_setPinConfig(GPIO_14_EPWM8_A);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_SYNC);


#undef NGP
#define NGP 15
    GPIO_setPinConfig(GPIO_15_EPWM8_B);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_SYNC);



}


void setupGpioSigmaDelta(void)
{
#undef NGP
#define NGP 10
    GPIO_setPinConfig(GPIO_10_SD4_C1);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_3SAMPLE);

#undef NGP
#define NGP 11
    GPIO_setPinConfig(GPIO_11_SD4_D1);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_3SAMPLE);

#undef NGP
#define NGP 16
    GPIO_setPinConfig(GPIO_16_SD1_D1);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_3SAMPLE);

#undef NGP
#define NGP 17
    GPIO_setPinConfig(GPIO_17_SD1_C1);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_3SAMPLE);


#undef NGP
#define NGP 25
    GPIO_setPinConfig(GPIO_25_SD2_C1);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_3SAMPLE);


#undef NGP
#define NGP 41
    GPIO_setPinConfig(GPIO_41_SD2_D1);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_3SAMPLE);

}


void setupGpioGpio(void)
{
#undef NGP
#define NGP 18 // MUX EN 2
    GPIO_setPinConfig(GPIO_18_GPIO18);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_OUT);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_ASYNC);

// Setup DAC control IO
#undef NGP
#define NGP 6 // MUX EN 2
    GPIO_setPinConfig(GPIO_6_EPWM4_A);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_OUT);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_ASYNC);

#undef NGP
#define NGP 7 //MUXA12
    GpioDataRegs.GPADAT.bit.GPIO7 = 1 ;
    GPIO_setPinConfig(GPIO_7_GPIO7);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_OUT);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_ASYNC);

#undef NGP
#define NGP 8 // MUX EN 1
    GPIO_setPinConfig(GPIO_8_EPWM5_A);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_OUT);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_ASYNC);

#undef NGP
#define NGP 9 // MUXA01
    GPIO_setPinConfig(GPIO_9_GPIO9);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_OUT);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_ASYNC);
    GPIO_setControllerCore(NGP,GPIO_CORE_CPU1_CLA1) ;

#undef NGP
#define NGP 20 // Hall A
    GPIO_setPinConfig(GPIO_20_GPIO20);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_PULLUP);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_6SAMPLE);

#undef NGP
#define NGP 21 // Hall B
    GPIO_setPinConfig(GPIO_21_GPIO21);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_PULLUP);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_6SAMPLE);
#undef NGP

    #define NGP 23 // Hall C
    GPIO_setPinConfig(GPIO_23_GPIO23);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_PULLUP);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_6SAMPLE);

#undef NGP
#define NGP 57 // MUXA11
    GpioDataRegs.GPBDAT.bit.GPIO57 = 0 ;
    GPIO_setPinConfig(GPIO_57_GPIO57);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_OUT);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_ASYNC);


#undef NGP
#define NGP 84 // MUX A02
    GPIO_setPinConfig(GPIO_84_GPIO84);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_OUT);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_ASYNC);
    GPIO_setControllerCore(NGP,GPIO_CORE_CPU1_CLA1) ;

// Setup diagnostic inputs
#undef NGP
#define NGP 93 // IA DIAG PHU
    GPIO_setPinConfig(GPIO_93_GPIO93);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_PULLUP);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_6SAMPLE);

#undef NGP
#define NGP 82 // UA DIAG PHU
    GPIO_setPinConfig(GPIO_82_GPIO82);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_PULLUP);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_6SAMPLE);

#undef NGP
#define NGP 35 // IA DIAG PHV
    GPIO_setPinConfig(GPIO_35_GPIO35);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_PULLUP);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_6SAMPLE);

#undef NGP
#define NGP 34 // UA DIAG PHV
    GPIO_setPinConfig(GPIO_34_GPIO34);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_PULLUP);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_6SAMPLE);


#undef NGP
#define NGP 75 // IA DIAG PHW
    GPIO_setPinConfig(GPIO_75_GPIO75);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_PULLUP);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_6SAMPLE);

#undef NGP
#define NGP 32 // UA DIAG PHW
    GPIO_setPinConfig(GPIO_32_GPIO32);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_PULLUP);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_6SAMPLE);


#undef NGP
#define NGP 37 // IA DIAG DC
    GPIO_setPinConfig(GPIO_37_GPIO37);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_PULLUP);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_6SAMPLE);

#undef NGP
#define NGP 36 // UA DIAG DC
    GPIO_setPinConfig(GPIO_36_GPIO36);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_PULLUP);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_6SAMPLE);



#undef NGP
#define NGP 79 // Fault input
    GPIO_setPinConfig(GPIO_79_GPIO79);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_IN);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_PULLUP);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_6SAMPLE);


#undef NGP
#define NGP 99 // Enable output
    SetGateDriveEnable(0) ;
    GPIO_setPinConfig(GPIO_99_GPIO99);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_OUT);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_PULLUP);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_6SAMPLE);
    GPIO_setControllerCore(NGP,GPIO_CORE_CPU1_CLA1) ; // And give it to the CLA

#undef NGP
#define NGP 103 // CLA timing diagnostic
    GPIO_setPinConfig(GPIO_103_GPIO103);
    GPIO_setDirectionMode(NGP, GPIO_DIR_MODE_OUT);
    GPIO_setPadConfig(NGP, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(NGP, GPIO_QUAL_ASYNC);
    GPIO_setControllerCore(NGP,GPIO_CORE_CPU1_CLA1) ;
}

void setupGpio(void)
{
    setupGpioGpio() ;
    setupGpioCAN() ;
    setupGpioSigmaDelta() ;
    setupGpioPWM() ;
}

