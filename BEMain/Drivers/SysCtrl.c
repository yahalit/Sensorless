/*
 * SysCtrl.c
 *
 *  Created on: May 3, 2025
 *      Author: user
 */
#include "..\Application\StructDef.h"

void InitPeripheralClocksCpu1(void);

//
// InitSysCtrl - Initialization of system resources.
//
void InitSysCtrlCpu1(void)
{
    //
    // Disable the watch dog
    //
    DisableDog();

    //
    // Copy time critical code and Flash setup code to RAM. This includes the
    // following functions: InitFlash()
    //
    // The  RamfuncsLoadStart, RamfuncsLoadSize, and RamfuncsRunStart
    // symbols are created by the linker. Refer to the device .cmd file.
    //
    memcpy(&RamfuncsRunStart, &RamfuncsLoadStart, (size_t)&RamfuncsLoadSize);

    //
    // Call Flash Initialization to setup flash waitstates. This function must
    // reside in RAM.
    //
    InitFlash();


// This is a work around for CPU erratum. ADC clock must be briefly turned on, them off
    EALLOW;

    CpuSysRegs.PCLKCR13.bit.ADC_A = 1;
    CpuSysRegs.PCLKCR13.bit.ADC_B = 1;
    CpuSysRegs.PCLKCR13.bit.ADC_C = 1;


    CpuSysRegs.PCLKCR13.bit.ADC_A = 0;
    CpuSysRegs.PCLKCR13.bit.ADC_B = 0;
    CpuSysRegs.PCLKCR13.bit.ADC_C = 0;
    EDIS;


    //
    // Initialize the SYSPLL control  to generate a 200Mhz clock
    //
    // Defined options to be passed as arguments to this function are defined
    // in f28p65x_examples.h.
    //
    // Note: The internal oscillator CANNOT be used as the PLL source if the
    // PLLSYSCLK is configured to frequencies above 194 MHz.
    //
    //  PLLSYSCLK = (XTAL_OSC) * (IMULT) /(REFDIV) * (ODIV) * (PLLSYSCLKDIV)
    //
    InitSysPll(XTAL_OSC, IMULT_32, REFDIV_2, ODIV_2, PLLCLK_BY_1, SYSCTL_DCC_BASE0);


    //
    // Call Device_cal function when run using debugger
    // This function is called as part of the Boot code. The function is called
    // in the InitSysCtrl function since during debug time resets, the boot code
    // will not be executed and the gel script will reinitialize all the
    // registers and the calibrated values will be lost.
    //
    Device_cal();

    //
    // Turn on all peripherals
    //
    InitPeripheralClocksCpu1();
}

//
// InitPeripheralClocks - Initializes the clocks for the peripherals.
//
// Note: In order to reduce power consumption, turn off the clocks to any
// peripheral that is not specified for your part-number or is not used in the
// application
//
void InitPeripheralClocksCpu1(void)
{
    EALLOW;

    CpuSysRegs.PCLKCR0.bit.DMA = 1;
    CpuSysRegs.PCLKCR0.bit.CPUTIMER0 = 1;
    CpuSysRegs.PCLKCR0.bit.CPUTIMER1 = 1;
    CpuSysRegs.PCLKCR0.bit.CPUTIMER2 = 1;
    CpuSysRegs.PCLKCR0.bit.CPUBGCRC = 1;
    CpuSysRegs.PCLKCR0.bit.TBCLKSYNC = 1;
    CpuSysRegs.PCLKCR0.bit.ERAD = 1;


    CpuSysRegs.PCLKCR0.bit.CLA1 = 1;
    CpuSysRegs.PCLKCR0.bit.CLA1BGCRC = 1;
    CpuSysRegs.PCLKCR0.bit.GTBCLKSYNC = 1;
    //CpuSysRegs.PCLKCR1.bit.EMIF1 = 1;

    CpuSysRegs.PCLKCR2.bit.EPWM1 = 1;
    CpuSysRegs.PCLKCR2.bit.EPWM2 = 1;
    CpuSysRegs.PCLKCR2.bit.EPWM3 = 1;
    CpuSysRegs.PCLKCR2.bit.EPWM4 = 1;
    CpuSysRegs.PCLKCR2.bit.EPWM5 = 1;
    CpuSysRegs.PCLKCR2.bit.EPWM6 = 1;
    CpuSysRegs.PCLKCR2.bit.EPWM7 = 1;
    CpuSysRegs.PCLKCR2.bit.EPWM8 = 1;
    CpuSysRegs.PCLKCR2.bit.EPWM9 = 1;
    CpuSysRegs.PCLKCR2.bit.EPWM10 = 1;
    CpuSysRegs.PCLKCR2.bit.EPWM11 = 1;
    CpuSysRegs.PCLKCR2.bit.EPWM12 = 1;
    CpuSysRegs.PCLKCR2.bit.EPWM13 = 1;
    CpuSysRegs.PCLKCR2.bit.EPWM14 = 1;
    CpuSysRegs.PCLKCR2.bit.EPWM15 = 1;
    CpuSysRegs.PCLKCR2.bit.EPWM16 = 1;
    CpuSysRegs.PCLKCR2.bit.EPWM17 = 1;
    CpuSysRegs.PCLKCR2.bit.EPWM18 = 1;

    CpuSysRegs.PCLKCR3.bit.ECAP1 = 1;
    CpuSysRegs.PCLKCR3.bit.ECAP2 = 1;
    CpuSysRegs.PCLKCR3.bit.ECAP3 = 1;
    CpuSysRegs.PCLKCR3.bit.ECAP4 = 1;
    CpuSysRegs.PCLKCR3.bit.ECAP5 = 1;
    CpuSysRegs.PCLKCR3.bit.ECAP6 = 1;
    CpuSysRegs.PCLKCR3.bit.ECAP7 = 1;

/*
    CpuSysRegs.PCLKCR4.bit.EQEP1 = 1;
    CpuSysRegs.PCLKCR4.bit.EQEP2 = 1;
    CpuSysRegs.PCLKCR4.bit.EQEP3 = 1;
    CpuSysRegs.PCLKCR4.bit.EQEP4 = 1;
    CpuSysRegs.PCLKCR4.bit.EQEP5 = 1;
    CpuSysRegs.PCLKCR4.bit.EQEP6 = 1;
*/
    CpuSysRegs.PCLKCR6.bit.SD1 = 1;
    CpuSysRegs.PCLKCR6.bit.SD2 = 1;
    CpuSysRegs.PCLKCR6.bit.SD3 = 1;
    CpuSysRegs.PCLKCR6.bit.SD4 = 1;

    CpuSysRegs.PCLKCR7.bit.SCI_A = 1;
    CpuSysRegs.PCLKCR7.bit.SCI_B = 1;
    CpuSysRegs.PCLKCR7.bit.UART_A = 1;
    CpuSysRegs.PCLKCR7.bit.UART_B = 1;

    CpuSysRegs.PCLKCR8.bit.SPI_A = 1;
    CpuSysRegs.PCLKCR8.bit.SPI_B = 1;
    CpuSysRegs.PCLKCR8.bit.SPI_C = 1;
    CpuSysRegs.PCLKCR8.bit.SPI_D = 1;

    CpuSysRegs.PCLKCR9.bit.I2C_A = 1;
    CpuSysRegs.PCLKCR9.bit.I2C_B = 1;
    CpuSysRegs.PCLKCR9.bit.PMBUS_A = 1;

    CpuSysRegs.PCLKCR10.bit.CAN_A = 1;
    CpuSysRegs.PCLKCR10.bit.MCAN_A = 1;
    CpuSysRegs.PCLKCR10.bit.MCAN_B = 1;

    CpuSysRegs.PCLKCR11.bit.USB_A = 1;

    CpuSysRegs.PCLKCR13.bit.ADC_A = 1;
    CpuSysRegs.PCLKCR13.bit.ADC_B = 1;
    CpuSysRegs.PCLKCR13.bit.ADC_C = 1;

    CpuSysRegs.PCLKCR14.bit.CMPSS1 = 1;
    CpuSysRegs.PCLKCR14.bit.CMPSS2 = 1;
    CpuSysRegs.PCLKCR14.bit.CMPSS3 = 1;
    CpuSysRegs.PCLKCR14.bit.CMPSS4 = 1;
    CpuSysRegs.PCLKCR14.bit.CMPSS5 = 1;
    CpuSysRegs.PCLKCR14.bit.CMPSS6 = 1;
    CpuSysRegs.PCLKCR14.bit.CMPSS7 = 1;
    CpuSysRegs.PCLKCR14.bit.CMPSS8 = 1;
    CpuSysRegs.PCLKCR14.bit.CMPSS9 = 1;
    CpuSysRegs.PCLKCR14.bit.CMPSS10 = 1;
    CpuSysRegs.PCLKCR14.bit.CMPSS11 = 1;

    CpuSysRegs.PCLKCR16.bit.DAC_A = 1;
    CpuSysRegs.PCLKCR16.bit.DAC_C = 1;

    CpuSysRegs.PCLKCR17.bit.CLB1 = 1;
    CpuSysRegs.PCLKCR17.bit.CLB2 = 1;
    CpuSysRegs.PCLKCR17.bit.CLB3 = 1;
    CpuSysRegs.PCLKCR17.bit.CLB4 = 1;
    CpuSysRegs.PCLKCR17.bit.CLB5 = 1;
    CpuSysRegs.PCLKCR17.bit.CLB6 = 1;

    /*
    CpuSysRegs.PCLKCR18.bit.FSITX_A = 1;
    CpuSysRegs.PCLKCR18.bit.FSITX_B = 1;
    CpuSysRegs.PCLKCR18.bit.FSIRX_A = 1;
    CpuSysRegs.PCLKCR18.bit.FSIRX_B = 1;
    CpuSysRegs.PCLKCR18.bit.FSIRX_C = 1;
    CpuSysRegs.PCLKCR18.bit.FSIRX_D = 1;
    */

    CpuSysRegs.PCLKCR19.bit.LIN_A = 1;
    CpuSysRegs.PCLKCR19.bit.LIN_B = 1;

    CpuSysRegs.PCLKCR21.bit.DCC0 = 1;
    CpuSysRegs.PCLKCR21.bit.DCC1 = 1;
    CpuSysRegs.PCLKCR21.bit.DCC2 = 1;

    //CpuSysRegs.PCLKCR23.bit.ETHERCAT = 1;

    CpuSysRegs.PCLKCR25.bit.HRCAL0 = 1;
    CpuSysRegs.PCLKCR25.bit.HRCAL1 = 1;
    CpuSysRegs.PCLKCR25.bit.HRCAL2 = 1;

    CpuSysRegs.PCLKCR26.bit.AESA = 1;

    CpuSysRegs.PCLKCR27.bit.EPG1 = 1;

    /*
    CpuSysRegs.PCLKCR28.bit.ADCCHECKER1 = 1;
    CpuSysRegs.PCLKCR28.bit.ADCCHECKER2 = 1;
    CpuSysRegs.PCLKCR28.bit.ADCCHECKER3 = 1;
    CpuSysRegs.PCLKCR28.bit.ADCCHECKER4 = 1;
    CpuSysRegs.PCLKCR28.bit.ADCCHECKER5 = 1;
    CpuSysRegs.PCLKCR28.bit.ADCCHECKER6 = 1;
    CpuSysRegs.PCLKCR28.bit.ADCCHECKER7 = 1;
    CpuSysRegs.PCLKCR28.bit.ADCCHECKER8 = 1;

    CpuSysRegs.PCLKCR28.bit.ADCSEAGGRCPU1 = 1;
     */
    EDIS;
}

extern volatile short unsigned kuku ;

// Bring CPU2 into action
void Bsp_bootCPU2(void) // uint32_t bootmode)
{
    //
    // Configure the CPU1TOCPU2IPCBOOTMODE register
    //
    //HWREG(IPC_CPUXTOCPUX_BASE+IPC_O_CPU1TOCPU2IPCBOOTMODE) = (BOOT_KEY | CPU2_BOOT_FREQ_200MHZ | bootmode);

    //
    // Set IPC Flag 0
    //
    EALLOW;
    HWREG(DEVCFG_BASE + SYSCTL_O_CPU2RESCTL)  = 0xa5a50001 ; // Reset

    SysCtl_disableWatchdog() ;
    //while( kuku ==0 );

    HWREG(IPC_CPUXTOCPUX_BASE+IPC_O_CPU1TOCPU2IPCSET) = IPC_FLAG0;

    //while( kuku ==1 );
    //
    // Bring CPU2 out of reset. Wait for CPU2 to go out of reset.
    //
    EALLOW;
    HWREG(DEVCFG_BASE + SYSCTL_O_CPU2RESCTL)  = 0xa5a50000  ; // Clear to go

    //while( kuku ==0 );

    // Wait till CPU 2 wakes up
    while(SysCtl_isCPU2Reset() == 0x1U);

    //while( kuku ==3 );

}

extern volatile short unsigned kuku ;
void PrepCpu2Work(void)
{
    long unsigned next ;
    // Give CPU2 its dues memories
    //GrantCpu2ItsMemories() ;

    Bsp_bootCPU2() ; // BOOTMODE_BOOT_TO_FLASH_SECTOR0) ; // IPCLtoRFlagSet(IPC_FLAG0);

    // Flag CPU2 its time to wakeup
    Cpu1toCpu2IpcRegs.CPU1TOCPU2IPCSET.all |= 0x10 ;

    // Initialize CAN B clock divider
    SysCtl_setMCANClk(SYSCTL_MCANB,SYSCTL_MCANCLK_DIV_5);

    //
    //Give CPU2 its due peripherals
    //
    GrantCpu2ItsDuePeripherals() ;

    //
    // Send IPC flag to CPU2 signaling the completion of system initialization
    //
    IPCLtoRFlagSet(IPC_FLAG31);

    // Wait 1 second
    HWREG( CPUTIMER1_BASE+CPUTIMER_O_TIM) = 1000000UL ;
    while ( IPCLtoRFlagBusy(IPC_FLAG31))
    {
        next = HWREG( CPUTIMER1_BASE+CPUTIMER_O_TIM) ;

        if ( next & 0x80000000 )
        {
            // Timeout
            ESTOP1 ;
            SysState.bCore2IsDead = 1 ;
        }

    }
    HWREG( CPUTIMER1_BASE+CPUTIMER_O_TIM) = 0 ;

}




