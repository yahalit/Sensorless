/*
 * AdcDrv.h
 *
 *  Created on: 23 במרץ 2025
 *      Author: Yahali
 */
#include "..\Application\StructDef.h"


//
// CalAdcINL - Loads INL trim values from OTP into the trim registers of the
//             specified ADC. Use only as part of AdcSetMode function, since
//             linearity trim correction is needed for some modes.
//
void CalAdcINL(Uint16 adc)
{
    volatile Uint32 *inlRegBaseAddr, *inlOTPBaseAddr;
    Uint32 i;

    switch(adc)
    {
        case ADC_ADCA:
            //
            // Pointer to ADCA trim address base
            //
            inlRegBaseAddr = &AdcaRegs.ADCINLTRIM1;
            break;
        case ADC_ADCB:
            //
            // Pointer to ADCB trim address
            //
            inlRegBaseAddr = &AdcbRegs.ADCINLTRIM1;
            break;
        case ADC_ADCC:
            //
            // Pointer to ADCC trim address
            //
            inlRegBaseAddr = &AdccRegs.ADCINLTRIM1;
            break;
    }

    //
    // OTP trim location for ADC
    //
    inlOTPBaseAddr = GetAdcINLTrimOTPLoc(adc);

    //
    // Populate INL Trim Codes 1 to 6 for respective ADC
    //
    if(TI_OTP_DEV_PRG_KEY_BF == TI_OTP_DEV_KEY_BF)
    {
        for(i = 0; i < 6; i++)
        {
            *inlRegBaseAddr++ = *inlOTPBaseAddr++;
        }
    }
}


//
// AdcSetMode - Set the resolution and signalmode for a given ADC. This will
//              ensure that the correct trim is loaded.
// resolution:
//#define ADC_RESOLUTION_12BIT 0
//#define ADC_RESOLUTION_16BIT 1
// signalmode:
//#define ADC_SIGNALMODE_SINGLE 0
//#define ADC_SIGNALMODE_DIFFERENTIAL 1
//
void AdcSetMode(Uint16 adc, Uint16 resolution, Uint16 signalmode)
{
    Uint16 adcOffsetTrim;         // temporary ADC offset trim

    //
    // Re-populate INL trim
    //
    EALLOW ;
    CalAdcINL(adc);

    //
    // select the individual offset trim wherein offset trim will be supplied
    // from individual registers already programmed by device_cal.
    //
    adcOffsetTrim = ADC_BITOFFSET_TRIM_INDIVIDUAL;

    //
    // Apply the resolution and signalmode to the specified ADC.
    // Also apply the offset trim and, if needed, linearity trim correction.
    //
    switch(adc)
    {
        case ADC_ADCA:
        {
            AdcaRegs.ADCCTL2.bit.SIGNALMODE = signalmode;
            AdcaRegs.ADCCTL2.bit.OFFTRIMMODE = adcOffsetTrim;
#ifndef _DUAL_HEADERS
            if(ADC_RESOLUTION_12BIT == resolution)
#else
            if(ADC_BITRESOLUTION_12BIT == resolution)
#endif
            {
                AdcaRegs.ADCCTL2.bit.RESOLUTION = 0;

                //
                // 12-bit linearity trim workaround
                //
                AdcaRegs.ADCINLTRIM1 &= 0xFFFF0000;
                AdcaRegs.ADCINLTRIM2 &= 0xFFFF0000;
                AdcaRegs.ADCINLTRIM4 &= 0xFFFF0000;
                AdcaRegs.ADCINLTRIM5 &= 0xFFFF0000;
            }
            else
            {
                AdcaRegs.ADCCTL2.bit.RESOLUTION = 1;
            }
            break;
        }
        case ADC_ADCB:
        {
            AdcbRegs.ADCCTL2.bit.SIGNALMODE = signalmode;
            AdcbRegs.ADCCTL2.bit.OFFTRIMMODE = adcOffsetTrim;
#ifndef _DUAL_HEADERS
            if(ADC_RESOLUTION_12BIT == resolution)
#else
            if(ADC_BITRESOLUTION_12BIT == resolution)
#endif
            {
                AdcbRegs.ADCCTL2.bit.RESOLUTION = 0;

                //
                // 12-bit linearity trim workaround
                //
                AdcbRegs.ADCINLTRIM1 &= 0xFFFF0000;
                AdcbRegs.ADCINLTRIM2 &= 0xFFFF0000;
                AdcbRegs.ADCINLTRIM4 &= 0xFFFF0000;
                AdcbRegs.ADCINLTRIM5 &= 0xFFFF0000;
            }
            else
            {
                AdcbRegs.ADCCTL2.bit.RESOLUTION = 1;
            }
            break;
        }
        case ADC_ADCC:
        {
            AdccRegs.ADCCTL2.bit.SIGNALMODE = signalmode;
            AdccRegs.ADCCTL2.bit.OFFTRIMMODE = adcOffsetTrim;
#ifndef _DUAL_HEADERS
            if(ADC_RESOLUTION_12BIT == resolution)
#else
            if(ADC_BITRESOLUTION_12BIT == resolution)
#endif
            {
                AdccRegs.ADCCTL2.bit.RESOLUTION = 0;

                //
                // 12-bit linearity trim workaround
                //
                AdccRegs.ADCINLTRIM1 &= 0xFFFF0000;
                AdccRegs.ADCINLTRIM2 &= 0xFFFF0000;
                AdccRegs.ADCINLTRIM4 &= 0xFFFF0000;
                AdccRegs.ADCINLTRIM5 &= 0xFFFF0000;
            }
            else
            {
                AdccRegs.ADCCTL2.bit.RESOLUTION = 1;
            }
            break;
        }
    }
}

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

void ADC_setupSOC(uint32_t base, ADC_SOCNumber socNumber, ADC_Trigger trigger, ADC_Channel channel)
{
    Uint16 sampleWindow;
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
    ADC_setupSOC(ADCA_BASE, ADC_SOC_NUMBER0, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN4);
    // AMC current , DC link
    ADC_setupSOC(ADCC_BASE, ADC_SOC_NUMBER1, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN1);
    // Hall current ,DC link
    ADC_setupSOC(ADCB_BASE, ADC_SOC_NUMBER1, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN7);


    // Phase A voltage
    ADC_setupSOC(ADCB_BASE, ADC_SOC_NUMBER0, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN0);
    // Phase A Hall current
    ADC_setupSOC(ADCB_BASE, ADC_SOC_NUMBER0, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN6);
    // Phase A AMC current
    ADC_setupSOC(ADCB_BASE, ADC_SOC_NUMBER0, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN4);


    // Phase B voltage
    ADC_setupSOC(ADCC_BASE, ADC_SOC_NUMBER0, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN0);
    // Phase B Hall current
    ADC_setupSOC(ADCC_BASE, ADC_SOC_NUMBER0, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN6);
    // Phase B AMC current
    ADC_setupSOC(ADCC_BASE, ADC_SOC_NUMBER0, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN7);


    // Phase C voltage
    ADC_setupSOC(ADCA_BASE, ADC_SOC_NUMBER0, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN5);
    // Phase C Hall current
    ADC_setupSOC(ADCA_BASE, ADC_SOC_NUMBER0, ADC_TRIGGER_EPWM2_SOCA,
                 ADC_CH_ADCIN15);
    // Phase C AMC current
    ADC_setupSOC(ADCA_BASE, ADC_SOC_NUMBER0, ADC_TRIGGER_EPWM2_SOCA,
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
