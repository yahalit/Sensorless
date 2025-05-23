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



    //
    // Step 3. Configure the CLA memory spaces first followed by
    // the CLA task vectors
    //
    CLA_configClaMemory();
    CLA_initCpu1Cla1();

//
// Freeze TBCTR of EPWMs, setup EPWM1 and DMA
//
    EALLOW;
    CpuSysRegs.PCLKCR0.bit.TBCLKSYNC = 0;
    EDIS;

    InitEPwm1();    // Setup EPWM1
    SetupDMA();     // Setup DMA to be triggered on SPI-A


    setupGpio() ;

//
// Allow EPWM TBCTRs to count
//
    EALLOW;
    CpuSysRegs.PCLKCR0.bit.TBCLKSYNC = 1;
    EDIS;

}



__interrupt void AdcIsr(void);
void SetupIsr(void)
{


    // setup the Event Trigger Selection Register (ETSEL)
    //EPWM_setInterruptSource(PWM_A_BASE, EPWM_INT_TBCTR_PERIOD);
    DINT ;
    EALLOW ;
    HWREGH(ADCA_BASE+ADC_O_INTSEL1N2) |= ( (1<<6) | (1 << 5) )  ; // Enable interrupt , Make the interrupt continuous, no need to reset ADC interrupt source
    HWREGH(ADCB_BASE+ADC_O_INTSEL1N2) |= ( (1<<6) | (1 << 5) )  ; // Enable interrupt , Make the interrupt continuous, no need to reset ADC interrupt source

    Interrupt_register(INT_ADCA1, &AdcIsr);

    EPWM_disableInterrupt(PWM_A_BASE);

    EPWM_setADCTriggerSource(PWM_A_BASE,EPWM_SOC_A, EPWM_SOC_TBCTR_D_CMPC);

    EPWM_enableADCTrigger(PWM_A_BASE, EPWM_SOC_A);

    EPWM_setInterruptEventCount(PWM_A_BASE, 1);
    EPWM_setADCTriggerEventPrescale(PWM_A_BASE, EPWM_SOC_A,1);

    // setup the Event Trigger Clear Register (ETCLR)
    EPWM_clearEventTriggerInterruptFlag(PWM_A_BASE);
    EPWM_clearADCTriggerFlag(PWM_A_BASE, EPWM_SOC_A);

    // write the PWM data value  for ADC trigger
    EPWM_setCounterCompareValue(PWM_A_BASE, EPWM_COUNTER_COMPARE_C, (short unsigned)(ADC_START_BEFORE_CYC_USEC * CPU_CLK_MHZ) );


    Interrupt_enable(INT_ADCA1);
    Interrupt_clearACKGroup(INTERRUPT_ACK_GROUP1);


    CLA_forceTasks(CLA1_BASE, CLA_TASKFLAG_7); // Initialize current filter
    CLA_forceTasks(CLA1_BASE, CLA_TASKFLAG_8); // Initialize CLA counters

    CLA_setTriggerSource(CLA_TASK_1, CLA_TRIGGER_ADCB1); // Thats immediately upon getting current samples
    CLA_setTriggerSource(CLA_TASK_2, CLA_TRIGGER_ADCA1); // And that is later after all ADC is complete

    // enable the ePWM module time base clock sync signal
    SysCtl_enablePeripheral(SYSCTL_PERIPH_CLK_TBCLKSYNC);
}




void GrantCpu2ItsMemories(void)
{
    MemCfgRegs.GSxMSEL.bit.MSEL_GS1 = 1;    // Give CPU2 control of GS1
}


void GrantCpu2ItsDuePeripherals(void)
{
    EALLOW;
    DevCfgRegs.CPUSEL6.bit.SPI_A = 1;       // Give CPU2 control to SPIA
    EDIS;
}


