/*
 * AdcDrv.h
 *
 *  Created on: 23 במרץ 2025
 *      Author: Yahali
 */
#include "..\Application\StructDef.h"



void ADC_init(uint32_t base){
    //
    // ADC Initialization: Write ADC configurations and power up the ADC
    //
    // Set the analog voltage reference selection and ADC module's offset trims.
    // This function sets the analog voltage reference to internal (with the reference voltage of 1.65V or 2.5V) or external for ADC
    // which is same as ASysCtl APIs.
    //
    ADC_setVREF(base, ADC_REFERENCE_INTERNAL, ADC_REFERENCE_3_3V);
    //ADC_setVREF(base, ADC_REFERENCE_EXTERNAL, ADC_REFERENCE_VREFHI);
        //
    // Configures the analog-to-digital converter module prescaler.
    //
    ADC_setPrescaler(base, ADC_CLK_DIV_4_0);
    //
    // Configures the analog-to-digital converter resolution and signal mode.
    //
    ADC_setMode(base, _ADC_RESOLUTION_12BIT, ADC_MODE_SINGLE_ENDED);
    //
    // Sets the timing of the end-of-conversion pulse
    //
    ADC_setInterruptPulseMode(base, ADC_PULSE_END_OF_CONV);
    //
    // Powers up the analog-to-digital converter core.
    //
    ADC_enableConverter(base);
    //
    // Delay for 1ms to allow ADC time to power up
    //
    DEVICE_DELAY_US(5000);
    //
    // Enable alternate timings for DMA trigger
    //
    ADC_enableAltDMATiming(base);
    //
    // SOC Configuration: Setup ADC EPWM channel and trigger settings
    //
    // Disables SOC burst mode.
    //
    ADC_disableBurstMode(base);
    //
    // Sets the priority mode of the SOCs.
    //
    ADC_setSOCPriority(base, ADC_PRI_ALL_HIPRI);
    //
    // ADC Interrupt 1 Configuration
    //      Source  : ADC_INT_TRIGGER_EOC1
    //      Interrupt Source: enabled
    //      Continuous Mode : disabled
    //
    //
    ADC_setInterruptSource(base, ADC_INT_NUMBER1, ADC_INT_TRIGGER_EOC4);
    ADC_clearInterruptStatus(base, ADC_INT_NUMBER1);
    ADC_enableContinuousMode(base, ADC_INT_NUMBER1);
    ADC_disableInterrupt(base, ADC_INT_NUMBER1);
}


void SetAdcMux(ADC_Trigger trigger);
//
// ConfigureADC - Write ADC configurations and power up the ADC for both
//                ADC A and ADC B
//
void ConfigureADC(void)
{
    //
    // Disables the temperature sensor output to the ADC.
    //
    ASysCtl_disableTemperatureSensor();
    //
    // Set the analog voltage reference selection to internal.
    //
    ASysCtl_setAnalogReferenceInternal( ASYSCTL_VREFHIA | ASYSCTL_VREFHIB | ASYSCTL_VREFHIC );
    //
    // Set the internal analog voltage reference selection to 1.65V.
    //
    ASysCtl_setAnalogReference1P65( ASYSCTL_VREFHIA | ASYSCTL_VREFHIB | ASYSCTL_VREFHIC );

    ADC_init(ADCA_BASE) ;
    ADC_init(ADCB_BASE) ;
    ADC_init(ADCC_BASE) ;

/*
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
*/

    SetAdcMux(ADC_SOC_EVENT) ;
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



void SetAdcMux(ADC_Trigger trigger)
{
    // Each sample will take about 280nsec, so interrupt will be 1.4usec after sampling starts
    // Next CLA interrupt will be at about 1.7u
// ADCA
////////////////////
    // ok Phase C Hall current
    MyADC_setupSOC(ADCA_BASE, ADC_SOC_NUMBER0, trigger,
                 ADC_CH_ADCIN15);

    // ok Phase C AMC current
    MyADC_setupSOC(ADCA_BASE, ADC_SOC_NUMBER1, trigger,
                 ADC_CH_ADCIN10);

    // ok Phase C voltage
    MyADC_setupSOC(ADCA_BASE, ADC_SOC_NUMBER2, trigger,
                 ADC_CH_ADCIN5);

    // ok again Phase C Hall current
    MyADC_setupSOC(ADCA_BASE, ADC_SOC_NUMBER3, trigger,
                 ADC_CH_ADCIN15);

    // ok DC link voltage
    MyADC_setupSOC(ADCA_BASE, ADC_SOC_NUMBER4, trigger,
                 ADC_CH_ADCIN4);

// ADCB
////////////////////
    // ok Phase A Hall current
    MyADC_setupSOC(ADCB_BASE, ADC_SOC_NUMBER0, trigger,
                 ADC_CH_ADCIN6);

    // ok Phase A AMC current
    MyADC_setupSOC(ADCB_BASE, ADC_SOC_NUMBER1, trigger,
                 ADC_CH_ADCIN4);
    // ok Phase A voltage
    MyADC_setupSOC(ADCB_BASE, ADC_SOC_NUMBER2, trigger,
                 ADC_CH_ADCIN0);

    // Again Phase A Hall current
    MyADC_setupSOC(ADCB_BASE, ADC_SOC_NUMBER3, trigger,
                 ADC_CH_ADCIN6);

    // Hall current ,DC link
    MyADC_setupSOC(ADCB_BASE, ADC_SOC_NUMBER4, trigger,
                 ADC_CH_ADCIN7);


// ADCC
////////////////////

    // Phase B Hall current
    MyADC_setupSOC(ADCC_BASE, ADC_SOC_NUMBER0, trigger,
                 ADC_CH_ADCIN6);

    // ok Phase B AMC current
    MyADC_setupSOC(ADCC_BASE, ADC_SOC_NUMBER1, trigger,
                 ADC_CH_ADCIN7);

    // ok Phase B voltage
    MyADC_setupSOC(ADCC_BASE, ADC_SOC_NUMBER2, trigger,
                 ADC_CH_ADCIN0);

    // Again Phase B Hall current
    MyADC_setupSOC(ADCC_BASE, ADC_SOC_NUMBER3, trigger,
                 ADC_CH_ADCIN6);

    // AMC current , DC link
    MyADC_setupSOC(ADCC_BASE, ADC_SOC_NUMBER4, trigger,
                 ADC_CH_ADCIN1);

    // ok NTC temperature
    MyADC_setupSOC(ADCC_BASE, ADC_SOC_NUMBER5, trigger,
                 ADC_CH_ADCIN4);

    //EALLOW ;
    //HWREG((ANALOGSUBSYS_BASE + ASYSCTL_O_AGPIOCTRLG) = 0x0fffffc0 ;


    // Analog PinMux for A0/DACA_OUT
    GPIO_setPinConfig(GPIO_198_GPIO198);
    GPIO_setPinConfig(GPIO_199_GPIO199);
    GPIO_setPinConfig(GPIO_200_GPIO200);
    GPIO_setPinConfig(GPIO_201_GPIO201);
    GPIO_setPinConfig(GPIO_202_GPIO202);
    GPIO_setPinConfig(GPIO_203_GPIO203);
    GPIO_setPinConfig(GPIO_204_GPIO204);
    GPIO_setPinConfig(GPIO_205_GPIO205);
    GPIO_setPinConfig(GPIO_206_GPIO206);
    GPIO_setPinConfig(GPIO_207_GPIO207);
    GPIO_setPinConfig(GPIO_208_GPIO208);
    GPIO_setPinConfig(GPIO_209_GPIO209);
    GPIO_setPinConfig(GPIO_210_GPIO210);
    GPIO_setPinConfig(GPIO_211_GPIO211);
    GPIO_setPinConfig(GPIO_212_GPIO212);
    GPIO_setPinConfig(GPIO_213_GPIO213);
    GPIO_setPinConfig(GPIO_214_GPIO214);
    GPIO_setPinConfig(GPIO_215_GPIO215);
    GPIO_setPinConfig(GPIO_216_GPIO216);


    GPIO_setAnalogMode( 198 , GPIO_ANALOG_ENABLED) ; // C7
    GPIO_setAnalogMode( 199 , GPIO_ANALOG_ENABLED) ; // C0
    GPIO_setAnalogMode( 200 , GPIO_ANALOG_ENABLED) ; // C1
    GPIO_setAnalogMode( 201 , GPIO_ANALOG_ENABLED) ; // C9
    GPIO_setAnalogMode( 202 , GPIO_ANALOG_ENABLED) ; // C9
    GPIO_setAnalogMode( 203 , GPIO_ANALOG_ENABLED) ; // C6
    GPIO_setAnalogMode( 204 , GPIO_ANALOG_ENABLED) ; // C5
    GPIO_setAnalogMode( 205 , GPIO_ANALOG_ENABLED) ; // C4
    GPIO_setAnalogMode( 206 , GPIO_ANALOG_ENABLED) ; // C3

    GPIO_setAnalogMode( 207 , GPIO_ANALOG_ENABLED) ; // B6
    GPIO_setAnalogMode( 208 , GPIO_ANALOG_ENABLED) ; // B7
    GPIO_setAnalogMode( 209 , GPIO_ANALOG_ENABLED) ; // A6
    GPIO_setAnalogMode( 210 , GPIO_ANALOG_ENABLED) ; // A7
    GPIO_setAnalogMode( 211 , GPIO_ANALOG_ENABLED) ; // A8
    GPIO_setAnalogMode( 212 , GPIO_ANALOG_ENABLED) ; // A9
    GPIO_setAnalogMode( 213 , GPIO_ANALOG_ENABLED) ; // A10
    GPIO_setAnalogMode( 214 , GPIO_ANALOG_ENABLED) ; // A11
    GPIO_setAnalogMode( 215 , GPIO_ANALOG_ENABLED) ; // B4
    GPIO_setAnalogMode( 216 , GPIO_ANALOG_ENABLED) ; // B5
}


#define DAC_O_REV     0x0U   // DAC Revision Register
#define DAC_O_CTL     0x1U   // DAC Control Register
#define DAC_O_VALA    0x2U   // DAC Value Register - Active
#define DAC_O_VALS    0x3U   // DAC Value Register - Shadow
#define DAC_O_OUTEN   0x4U   // DAC Output Enable Register
#define DAC_O_LOCK    0x5U   // DAC Lock Register
#define DAC_O_TRIM    0x6U   // DAC Trim Register

void setupDAC(void)
{
    EALLOW ;
    HWREGH(DACA_BASE + DAC_O_CTL) = (0<<2) + 3 ; // Load immediate
    HWREGH(DACC_BASE + DAC_O_CTL) = (0<<2) + 3 ; // Load immediate
    HWREGH(DACA_BASE + DAC_O_OUTEN)= 1 ;
    HWREGH(DACC_BASE + DAC_O_OUTEN)= 1 ;
    //DAC_tuneOffsetTrim
}

//
// SetupADCEpwm - Setup ADC EPWM acquisition window
//
/*
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
*/
