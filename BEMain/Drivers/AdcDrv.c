/*
 * AdcDrv.h
 *
 *  Created on: 23 במרץ 2025
 *      Author: Yahali
 */
#include "..\Application\StructDef.h"



void SetAdcMux(void);
//
// ConfigureADC - Write ADC configurations and power up the ADC for both
//                ADC A and ADC B
//
void ConfigureADC(void)
{

    ADC_setVREF(ADCA_BASE, ADC_REFERENCE_INTERNAL, ADC_REFERENCE_3_3V);
    ADC_setVREF(ADCB_BASE, ADC_REFERENCE_INTERNAL, ADC_REFERENCE_3_3V);
    ADC_setVREF(ADCC_BASE, ADC_REFERENCE_INTERNAL, ADC_REFERENCE_3_3V);


    EALLOW;
    //
    // Write configurations
    //
    AdcaRegs.ADCCTL2.bit.PRESCALE = 6; //set ADCCLK divider to /4
    AdcSetMode(ADC_ADCA, ADC_RESOLUTION_12BIT, ADC_SIGNALMODE_SINGLE);
    AdcbRegs.ADCCTL2.bit.PRESCALE = 6; //set ADCCLK divider to /4
    AdcSetMode(ADC_ADCB, ADC_RESOLUTION_12BIT, ADC_SIGNALMODE_SINGLE);
    AdccRegs.ADCCTL2.bit.PRESCALE = 6; //set ADCCLK divider to /4
    AdcSetMode(ADC_ADCC, ADC_RESOLUTION_12BIT, ADC_SIGNALMODE_SINGLE);

    //
    // Set pulse positions to late
    //
    AdcaRegs.ADCCTL1.bit.INTPULSEPOS = 1;
    AdcbRegs.ADCCTL1.bit.INTPULSEPOS = 1;
    AdccRegs.ADCCTL1.bit.INTPULSEPOS = 1;

    //
    // Power up the ADC
    //
    AdcaRegs.ADCCTL1.bit.ADCPWDNZ = 1;
    AdcbRegs.ADCCTL1.bit.ADCPWDNZ = 1;
    AdccRegs.ADCCTL1.bit.ADCPWDNZ = 1;

    // set priority of SOCs
    ADC_setSOCPriority(ADCA_BASE, ADC_PRI_ALL_HIPRI);
    ADC_setSOCPriority(ADCB_BASE, ADC_PRI_ALL_HIPRI);
    ADC_setSOCPriority(ADCC_BASE, ADC_PRI_ALL_HIPRI);
    //
    // Delay for 1ms to allow ADC time to power up
    //
    DELAY_US(1000);

    EDIS;
    SetAdcMux() ;
}


void MyADC_setupSOC(uint32_t base, ADC_SOCNumber socNumber, ADC_Trigger trigger, ADC_Channel channel)
{
    Uint16 sampleWindow;
    uint32_t ctlRegAddr ;
    if ( (HWREGH(base+ADC_O_CTL2) & (1<<6)) == 0 )
    { //12 bit
        sampleWindow = 14; //75ns
    }
    else //resolution is 16-bit
    {
        sampleWindow = 63; //320ns
    }

    //
    // Calculate address for the SOC control register.
    //
    ctlRegAddr = base + ADC_SOCxCTL_OFFSET_BASE + ((uint32_t)socNumber * 2U);

    //
    // Set the configuration of the specified SOC.
    //
    EALLOW;
    HWREG(ctlRegAddr) = ((uint32_t)channel << ADC_SOC0CTL_CHSEL_S) |
                        ((uint32_t)trigger << ADC_SOC0CTL_TRIGSEL_S) |
                        (sampleWindow - 1U);
    EDIS;
}



void SetAdcMux(void)
{

    // DC link voltage
    MyADC_setupSOC(ADCA_BASE, ADC_SOC_NUMBER0, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN4);
    // AMC current , DC link
    MyADC_setupSOC(ADCC_BASE, ADC_SOC_NUMBER1, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN1);
    // Hall current ,DC link
    MyADC_setupSOC(ADCB_BASE, ADC_SOC_NUMBER1, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN7);


    // Phase A voltage
    MyADC_setupSOC(ADCB_BASE, ADC_SOC_NUMBER0, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN0);
    // Phase A Hall current
    MyADC_setupSOC(ADCB_BASE, ADC_SOC_NUMBER0, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN6);
    // Phase A AMC current
    MyADC_setupSOC(ADCB_BASE, ADC_SOC_NUMBER0, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN4);


    // Phase B voltage
    MyADC_setupSOC(ADCC_BASE, ADC_SOC_NUMBER0, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN0);
    // Phase B Hall current
    MyADC_setupSOC(ADCC_BASE, ADC_SOC_NUMBER0, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN6);
    // Phase B AMC current
    MyADC_setupSOC(ADCC_BASE, ADC_SOC_NUMBER0, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN7);


    // Phase C voltage
    MyADC_setupSOC(ADCA_BASE, ADC_SOC_NUMBER0, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN5);
    // Phase C Hall current
    MyADC_setupSOC(ADCA_BASE, ADC_SOC_NUMBER0, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN15);
    // Phase C AMC current
    MyADC_setupSOC(ADCA_BASE, ADC_SOC_NUMBER0, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN10);

}


//
// SetupADCEpwm - Setup ADC EPWM acquisition window
//
void SetupADCEpwm(Uint16 channel)
{
    Uint16 acqps;

    //
    // Determine minimum acquisition window (in SYSCLKS) based on resolution
    //
    if(ADC_RESOLUTION_12BIT == AdcaRegs.ADCCTL2.bit.RESOLUTION)
    {
        acqps = 14; //75ns
    }
    else //resolution is 16-bit
    {
        acqps = 63; //320ns
    }

    //
    // Select the channels to convert and end of conversion flag
    //
    EALLOW;
    AdcaRegs.ADCSOC0CTL.bit.CHSEL = channel;  //SOC0 will convert pin A0
    AdcaRegs.ADCSOC0CTL.bit.ACQPS = acqps; //sample window is 100 SYSCLK cycles
    AdcaRegs.ADCSOC0CTL.bit.TRIGSEL = 5; //trigger on ePWM1 SOCA/C
    AdcaRegs.ADCINTSEL1N2.bit.INT1SEL = 0; //end of SOC0 will set INT1 flag
    AdcaRegs.ADCINTSEL1N2.bit.INT1E = 1;   //enable INT1 flag
    AdcaRegs.ADCINTFLGCLR.bit.ADCINT1 = 1; //make sure INT1 flag is cleared
    EDIS;
}
