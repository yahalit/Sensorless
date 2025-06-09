#include "..\Application\StructDef.h"


// Linker Defined variables



void ResetHardwareSysTimer(void)
{
    HWREG(CPUTIMER0_BASE + CPUTIMER_O_TIM) = 0 ;
}

// MCP9700 from MicroChip
float GetTemperatureFromAdc(float volts)
{
    return ( volts - 0.5f ) * 100.0f ;
}



void PauseInts(void)
{
//    Interrupt_disable(INT_ADCA1);
//    Interrupt_disable(INT_TIMER0);
    SysCtl_disableWatchdog();
}

void UnpauseInts(void)
{
//    Interrupt_enable(INT_ADCA1);
//    Interrupt_enable(INT_TIMER0);
    Interrupt_clearACKGroup(INTERRUPT_ACK_GROUP1);
}


void SetClaAllSw(void)
{
    KillMotor() ;

    EALLOW ;
    HWREGH(CLA1_BASE + CLA_O_MIER) = 0 ;
    CLA_setTriggerSource(CLA_TASK_1, CLA_TRIGGER_SOFTWARE); //CLA_TRIGGER_EPWM1INT
    CLA_setTriggerSource(CLA_TASK_2, CLA_TRIGGER_SOFTWARE); //CLA_TRIGGER_EPWM1INT
    CLA_setTriggerSource(CLA_TASK_3, CLA_TRIGGER_SOFTWARE); //CLA_TRIGGER_EPWM1INT

    EALLOW ;
    HWREGH(CLA1_BASE + CLA_O_MICLR) = 0xff ;
    while ( HWREGH(CLA1_BASE + CLA_O_MIRUN  ) | HWREGH(CLA1_BASE + CLA_O_MIFR  ) )
    {
        HWREGH(CLA1_BASE + CLA_O_MICLR) = 0xff ;
    }

    CLA_setTriggerSource(CLA_TASK_8, CLA_TRIGGER_SOFTWARE);
}


void InitPeripherals(void)
{


    //
    // Initialize the PIE control registers to their default state.
    // The default state is all PIE interrupts disabled and flags
    // are cleared.
    //
    InitPieCtrl();

    //
    // Step 7. Disable CPU interrupts and clear all CPU interrupt flags:
    //
    IER = 0x0000;
    IFR = 0x0000;

    //
    // Initialize the PIE vector table with pointers to the
    // default Interrupt Service Routines (ISR).
    // The default ISR routines are found in f28p65x_defaultisr.c.
    // This function is found in f28p65x_pievect.c.
    //
    InitPieVectTable();


    ConfigureADC() ;

    // If identity is specified by user data, take it
    SetProjectId()  ;


    //
    // Step 3. Configure the CLA memory spaces first followed by
    // the CLA task vectors
    //
    CLA_configClaMemory();
    CLA_initCpu1Cla1();

    setupMCAN();

//
// Freeze TBCTR of EPWMs, setup EPWM1 and DMA
//
    EALLOW;
    CpuSysRegs.PCLKCR0.bit.TBCLKSYNC = 0;
    EDIS;


    /*
     * Setup PWM5 as master-mind counter. It just ticks. Not connected to ant external pins
     * PWM 1,2,8 are trasnsistor drives
     * PWM 3 is DAC2 ena
     * PWM 4 is DAC1 enable
     */
    SysCtl_setEPWMClockDivider(SYSCTL_EPWMCLK_DIV_1);
    InitEPwm7AsMasterCounetr();    // Setup EPWM7 as master counter, 1msec cycle
    //InitEPwm1();    // Setup EPWM1

    // Brifge PWMs
    SetupPWM( PWM_A_BASE,CUR_SAMPLE_TIME_USEC);
    SetupPWM( PWM_B_BASE,CUR_SAMPLE_TIME_USEC);
    SetupPWM( PWM_C_BASE,CUR_SAMPLE_TIME_USEC);

    // DAC PWM
    setupPWMForDacEna(EPWM4_BASE,DAC_SET_NSEC,DAC_DISABLE_PERIOD_NSEC,DAC_PWM_PERIOD_NSEC) ;
    setupPWMForDacEna(EPWM5_BASE,DAC_SET_NSEC,DAC_DISABLE_PERIOD_NSEC,DAC_PWM_PERIOD_NSEC) ;

    // Just for main CPU interrupt
    setupPWMForDacEna(EPWM6_BASE,DAC_SET_NSEC,DAC_DISABLE_PERIOD_NSEC,CONTROL_PERIOD_NSEC) ;

    setupDAC(); // Setup the DACs


    SetupDMA();     // Setup DMA to be triggered on SPI-A


    setupGpio() ;

//
// Allow EPWM TBCTRs to count
//
    EALLOW;
    CpuSysRegs.PCLKCR0.bit.TBCLKSYNC = 1;
    EDIS;

}


/*
 * Interrupts are 50usec
 * ADC cycle and CLA are 50usec.
 * It works as follows:
 * PWM5 is the master timer. It synchronizes all. It works 1msec
 * PWM1 , PWM2 and PWM8 are bridge drivers. They work 50usec
 * PWM3 is ENA / event driver for DAC1
 * PWM4 is ENA / event driver for DAC2
 *
 */
__interrupt void AdcIsr(void);
void SetupIsr(void)
{


    // setup the Event Trigger Selection Register (ETSEL)
    //EPWM_setInterruptSource(PWM_SCD_BASE, EPWM_INT_TBCTR_PERIOD);
    DINT ;
    EALLOW ;
    // Channel 4 EOC will trigger interrupt
    HWREGH(ADCA_BASE+ADC_O_INTSEL1N2) = ( (1<<6) | (1 << 5) | 4 )  ; // Enable interrupt , Make the interrupt continuous, no need to reset ADC interrupt source
    // Channel 5 EOC will trigger interrupt
    HWREGH(ADCC_BASE+ADC_O_INTSEL1N2) = ( (1<<6) | (1 << 5) | 5 )  ; // Enable interrupt , Make the interrupt continuous, no need to reset ADC interrupt source

    Interrupt_register(INT_EPWM6, &AdcIsr);

    EPWM_disableInterrupt(PWM_CPU_PACER);
    EALLOW ;
    HWREGH(PWM_CPU_PACER + EPWM_O_ETPS) = 1 ; // Each event
    HWREGH(PWM_CPU_PACER + EPWM_O_ETSEL) = 0xc ; // CMPA on increment, interrupt enabled
    Interrupt_enable(INT_EPWM6); // Sets IER
    Interrupt_clearACKGroup(INTERRUPT_ACK_GROUP3);
    HWREGH(PWM_CPU_PACER + EPWM_O_CMPA+1) = ADC_BEFORE_ControlIsr_nsec / CPU_CLK_NSEC ;

    // write the PWM data value  for ADC trigger
    HWREGH(PWM_SCD_BASE+EPWM_O_CMPC) = HWREGH(PWM_SCD_BASE+EPWM_O_TBPRD)  - 1 - ADC_BEFORE_PWM0_nsec / CPU_CLK_NSEC ;

    EPWM_setADCTriggerSource(PWM_SCD_BASE,EPWM_SOC_A, EPWM_SOC_TBCTR_U_CMPC);
    EPWM_enableADCTrigger(PWM_SCD_BASE, EPWM_SOC_A);
    EPWM_setInterruptEventCount(PWM_SCD_BASE, 1);
    EPWM_setADCTriggerEventPrescale(PWM_SCD_BASE, EPWM_SOC_A,1);

    // setup the Event Trigger Clear Register (ETCLR)
    EPWM_clearEventTriggerInterruptFlag(PWM_SCD_BASE);
    EPWM_clearADCTriggerFlag(PWM_SCD_BASE, EPWM_SOC_A);

    CLA_forceTasks(CLA1_BASE, CLA_TASKFLAG_7); // Initialize current filter
    CLA_forceTasks(CLA1_BASE, CLA_TASKFLAG_8); // Initialize CLA counters

    CLA_setTriggerSource(CLA_TASK_1, CLA_TRIGGER_ADCA1); // Thats immediately upon getting current samples
    //CLA_setTriggerSource(CLA_TASK_2, CLA_TRIGGER_ADCC1); // And that is later after all ADC is complete

    // enable the ePWM module time base clock sync signal
    SysCtl_enablePeripheral(SYSCTL_PERIPH_CLK_TBCLKSYNC);
}


uint32_t GetNmiFlag()
{
    return HWREGH(NMI_BASE + NMI_O_FLG);
}



void GrantCpu2ItsDuePeripherals(void)
{
    EALLOW;
    DevCfgRegs.CPUSEL6.bit.SPI_A = 1;       // Give CPU2 control to SPIA
    EDIS;
}


