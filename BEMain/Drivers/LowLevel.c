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


