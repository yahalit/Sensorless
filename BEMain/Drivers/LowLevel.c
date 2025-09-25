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

    CLA_setTriggerSource(CLA_TASK_4, CLA_TRIGGER_SOFTWARE);
    CLA_setTriggerSource(CLA_TASK_8, CLA_TRIGGER_SOFTWARE);
}



inline
void SetupTimers()
{
    //CPUTimer_setPreScaler(CPUTIMER0_BASE, 0);
    CPUTimer_stopTimer(CPUTIMER0_BASE) ;
    CPUTimer_stopTimer(CPUTIMER1_BASE) ;

    CPUTimer_setPeriod(CPUTIMER0_BASE, 0xffffffff);
    CPUTimer_setPeriod(CPUTIMER1_BASE, 0xffffffff);

    HWREG(CPUTIMER0_BASE + CPUTIMER_O_TIM) = 0xffffffff ;
    HWREG(CPUTIMER1_BASE + CPUTIMER_O_TIM) = 0xffffffff ;

    HWREGH(CPUTIMER0_BASE + CPUTIMER_O_TPR) = 0;
    HWREGH(CPUTIMER1_BASE + CPUTIMER_O_TPR) = CPU_CLK_MHZ-1;

    CPUTimer_setEmulationMode(CPUTIMER0_BASE,CPUTIMER_EMULATIONMODE_STOPAFTERNEXTDECREMENT);
    CPUTimer_setEmulationMode(CPUTIMER1_BASE,CPUTIMER_EMULATIONMODE_STOPAFTERNEXTDECREMENT);

    CPUTimer_startTimer(CPUTIMER0_BASE) ;
    CPUTimer_startTimer(CPUTIMER1_BASE) ;

    //myCPUTIMER2 initialization
    CPUTimer_setEmulationMode(CPUTIMER2_BASE, CPUTIMER_EMULATIONMODE_STOPAFTERNEXTDECREMENT);
    CPUTimer_setPreScaler(CPUTIMER2_BASE, CPU_CLK_MHZ-1);
    CPUTimer_setPeriod(CPUTIMER2_BASE, 4294967295U);
    CPUTimer_disableInterrupt(CPUTIMER2_BASE);
    CPUTimer_resumeTimer(CPUTIMER2_BASE);

    return;
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

    SetupTimers();

    ConfigureADC() ;

    // If identity is specified by user data, take it
    SetProjectId()  ;


    //
    // Step 3. Configure the CLA memory spaces first followed by
    // the CLA task vectors
    //
    CLA_configClaMemory();
    CLA_initCpu1Cla1();

    InitUart(UARTA_BASE) ;

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
    InitEPwm7AsMasterCounter();    // Setup EPWM7 as master counter, 1msec cycle
    InitEPwm9AsFastCounter();    // Setup EPWM9 as fast sampling counter, 4usec
    //InitEPwm1();    // Setup EPWM1

    // Brifge PWMs
    SetupPWM_Phase(PWM_A_BASE,CUR_SAMPLE_TIME_USEC * 1000UL) ;
    SetupPWM_Phase(PWM_B_BASE,CUR_SAMPLE_TIME_USEC * 1000UL) ;
    SetupPWM_Phase(PWM_C_BASE,CUR_SAMPLE_TIME_USEC * 1000UL) ;

    // DAC PWM
    setupPWMForDacEna(EPWM4_BASE,DAC_SET_NSEC,DAC_DISABLE_PERIOD_NSEC,DAC_PWM_PERIOD_NSEC) ;
    setupPWMForDacEna(EPWM5_BASE,DAC_SET_NSEC,DAC_DISABLE_PERIOD_NSEC,DAC_PWM_PERIOD_NSEC) ;

    // Just for main CPU interrupt
    setupPWMForDacEna(EPWM6_BASE,DAC_SET_NSEC,DAC_DISABLE_PERIOD_NSEC,CONTROL_PERIOD_NSEC) ;

    setupDAC(); // Setup the DACs

    setupEcap(); // Setup ECAPs as timers

    SetupDMA();     // Setup DMA to be triggered on SPI-A

    setupGpio() ;

//
// Allow EPWM TBCTRs to count
//
    EALLOW;
    CpuSysRegs.PCLKCR0.bit.TBCLKSYNC = 1;
    EDIS;

}

void setupEcap(void)
{
    // ECAP2 is just a free running counter
    HWREGH(ECAP2_BASE + ECAP_O_ECCTL1) = 0x0 ; // Stop in emulation don't capture
    HWREG (ECAP2_BASE + ECAP_O_TSCTR ) = 0 ;
    HWREGH(ECAP2_BASE + ECAP_O_ECCTL2) = 0x10  ; // Just run


    // ECAP 3 is just a free runner
    HWREG(ECAP3_BASE + ECAP_O_TSCTR) = 0 ;
    HWREGH(ECAP3_BASE + ECAP_O_ECCTL2) = (1<<4) ;
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
__interrupt void AdcIsrLMeas(void);
void SetupIsr(void)
{

    SetGateDriveEnable(0) ;
    GPIO_setControllerCore(99,GPIO_CORE_CPU1_CLA1) ; // And give it to the CLA

    // setup the Event Trigger Selection Register (ETSEL)
    //EPWM_setInterruptSource(PWM_SCD_BASE, EPWM_INT_TBCTR_PERIOD);
    DINT ;

    // Select PWM source
    Interrupt_disable(INT_EPWM6); // Sets IER
    Interrupt_disable(INT_ADCA1); // Sets IER
    SetPwmSyncSource(PWM_SYNCSEL );
    SetAdcMux(ADC_SOC_EVENT) ;

    EALLOW ;


    // Channel 4 EOC will trigger interrupt
    HWREGH(ADCA_BASE+ADC_O_INTSEL1N2) = ( (1<<6) | (1 << 5) | 4 )  ; // Enable interrupt , Make the interrupt continuous, no need to reset ADC interrupt source
    // Channel 5 EOC will trigger interrupt
    HWREGH(ADCC_BASE+ADC_O_INTSEL1N2) = ( (1<<6) | (1 << 5) | 5 )  ; // Enable interrupt , Make the interrupt continuous, no need to reset ADC interrupt source

    Interrupt_register(INT_EPWM6, &AdcIsr);

    EPWM_disableInterrupt(PWM_CPU_PACER);
    EPWM_disableInterrupt(PWM_LMEAS_PACER);
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


void SetupIsrLMeas(void)
{

    SetGateDriveEnable(0) ;
    GPIO_setControllerCore(99,GPIO_CORE_CPU1) ; // And give it to the CLA
    SetGateDriveEnable(0) ;

    // setup the Event Trigger Selection Register (ETSEL)
    //EPWM_setInterruptSource(PWM_SCD_BASE, EPWM_INT_TBCTR_PERIOD);
    DINT ;
    Interrupt_disable(INT_EPWM6); // Sets IER
    Interrupt_disable(INT_ADCA1); // Sets IER

    // Kill CLA auto activity
    CLA_setTriggerSource(CLA_TASK_1, CLA_TRIGGER_SOFTWARE); // Thats immediately upon getting current samples
    KillMotor();

    // Select PWM source
    SetPwmSyncSource(PWM_FASTSYNCSEL );
    SetAdcMux(ADC_SOC_LMEAS_EVENT) ;
    //ADC_enableContinuousMode(ADCA_BASE,ADC_INT_NUMBER1) ;

    EALLOW ;
    // Channel 4 EOC will trigger interrupt
    HWREGH(ADCA_BASE+ADC_O_INTSEL1N2) = ( (1<<6) | (1 << 5) | 4 )  ; // Enable interrupt , Make the interrupt continuous, no need to reset ADC interrupt source
    // Channel 5 EOC will trigger interrupt
    HWREGH(ADCC_BASE+ADC_O_INTSEL1N2) = ( (1<<6) | (1 << 5) | 5 )  ; // Enable interrupt , Make the interrupt continuous, no need to reset ADC interrupt source

    Interrupt_register(INT_ADCA1, &AdcIsrLMeas);

    EPWM_disableInterrupt(PWM_CPU_PACER);
    EPWM_disableInterrupt(PWM_LMEAS_PACER);
    EALLOW ;
    //HWREGH(PWM_LMEAS_PACER + EPWM_O_ETPS) = 1 ; // Each event
    //HWREGH(PWM_LMEAS_PACER + EPWM_O_ETSEL) = 0xc ; // CMPA on increment, interrupt enabled
    Interrupt_enable(INT_ADCA1); // Sets IER
    Interrupt_clearACKGroup(INTERRUPT_ACK_GROUP1);
    HWREGH(PWM_LMEAS_PACER + EPWM_O_CMPA+1) = 1000 / CPU_CLK_NSEC ; // Stam

    // write the PWM data value  for ADC trigger
    HWREGH(PWM_LMEAS_PACER+EPWM_O_CMPC) = HWREGH(PWM_LMEAS_PACER+EPWM_O_TBPRD)  - 1 - 1000 / CPU_CLK_NSEC ;

    EPWM_setADCTriggerSource(PWM_LMEAS_PACER,EPWM_SOC_A, EPWM_SOC_TBCTR_U_CMPC);
    EPWM_enableADCTrigger(PWM_LMEAS_PACER, EPWM_SOC_A);
    EPWM_setInterruptEventCount(PWM_LMEAS_PACER, 1);
    EPWM_setADCTriggerEventPrescale(PWM_LMEAS_PACER, EPWM_SOC_A,1);

    // setup the Event Trigger Clear Register (ETCLR)
    EPWM_clearEventTriggerInterruptFlag(PWM_LMEAS_PACER);
    EPWM_clearADCTriggerFlag(PWM_LMEAS_PACER, EPWM_SOC_A);

    //CLA_forceTasks(CLA1_BASE, CLA_TASKFLAG_7); // Initialize current filter
    //CLA_forceTasks(CLA1_BASE, CLA_TASKFLAG_8); // Initialize CLA counters
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
    DevCfgRegs.CPUSEL8.bit.MCAN_B = 1 ;   // Give MCAN_B to CPU2
    EDIS;
}


