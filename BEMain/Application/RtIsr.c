/*
 * AdcIsr.c
 *
 *  Created on: May 14, 2023
 *      Author: Gal Lior
 */
#include "StructDef.h"





inline
void LogI2t(void)
{
    SysState.RtBit.I2tInt += ClaState.Analogs.PhaseCur[0] * ClaState.Analogs.PhaseCur[0] + ClaState.Analogs.PhaseCur[1] * ClaState.Analogs.PhaseCur[1]  + ClaState.Analogs.PhaseCur[2] * ClaState.Analogs.PhaseCur[2];
    SysState.RtBit.I2tIntegrationCount += 1 ;

    if ( SysState.RtBit.I2tIntegrationCount & 0x100 )
    {
        SysState.RtBit.I2tState = SysState.RtBit.I2tState + ControlPars.I2tPoleS  * ( SysState.RtBit.I2tInt * ( 0.00390625f * 0.6666666f ) - SysState.RtBit.I2tState ) ;
        SysState.RtBit.I2tInt = 0 ;
        SysState.RtBit.I2tIntegrationCount = 0 ;
    }
}


void ResetRefGens(void)
{
    SysState.Debug.GRef.On = 0 ;
    SysState.Debug.GRef.Time = 0 ;
    SysState.Debug.GRef.Out = 0 ;
    SysState.Debug.GRef.dOut = 0 ;
    SysState.Debug.GRef.State = 0 ;
    SysState.Debug.TRef.On = 0 ;
    SysState.Debug.TRef.Time = 0 ;
    SysState.Debug.TRef.Out = 0 ;
    SysState.Debug.TRef.dOut = 0 ;
    SysState.Debug.TRef.State = 0 ;
}


typedef struct
{
    short Current[3] ;
    short PhaseVolt[3] ;
    short DcBusVolt ;
    short CurrentIn    ;
} CHSCanLogger_T ;

typedef union
{
    CHSCanLogger_T LoggerData ;
    short unsigned us[8] ;
    long unsigned  ul[4] ;
} UHSCanLogger ;
UHSCanLogger HSLogger ;

// Thats 16bytes (full FIFO) : 160 bit in 2M its 80usec. So that we can transmit every 2nd interrupt. No need to count, just look if FIFO is free
// All  the data is 11bit so a leading 1 marks new batch
// Current range is 64Amp (bidir) ,  bit =  0.00390625A
// Voltage range is 1024V (unidir),  bit =  0.03125V


void inline FillLoggerStruct(void)
{
    if (( HWREG(UARTA_BASE + UART_O_FR) & UART_FR_TXFE)== UART_FR_TXFE)
    {
        HSLogger.LoggerData.Current[0] = (short)(ClaState.Analogs.PhaseCur[0] * 128.0f) ;
        HSLogger.LoggerData.Current[1] = (short)(ClaState.Analogs.PhaseCur[1] * 128.0f) ;
        HSLogger.LoggerData.Current[2] = (short)(ClaState.Analogs.PhaseCur[2] * 128.0f) ;
        HSLogger.LoggerData.PhaseVolt[0] = (short)(ClaState.Analogs.PhaseVoltMeas[0] * 16.0f ) ;
        HSLogger.LoggerData.PhaseVolt[1] = (short)(ClaState.Analogs.PhaseVoltMeas[1] * 16.0f ) ;
        HSLogger.LoggerData.PhaseVolt[2] = (short)(ClaState.Analogs.PhaseVoltMeas[2] * 16.0f ) ;
        HSLogger.LoggerData.DcBusVolt = (short)(ClaState.Analogs.Vdc * 16.0f ) ;
        HSLogger.LoggerData.CurrentIn = (short)(ClaState.Analogs.DcCur * 128.0f ) ;

        // Put it all to the UART
        HWREG(UARTA_BASE + UART_O_DR) = HSLogger.us[0] | 0x80;
        HWREG(UARTA_BASE + UART_O_DR) = ((HSLogger.us[0] >> 7   ) & 0x7f )  ;
        HWREG(UARTA_BASE + UART_O_DR) = (HSLogger.us[1] & 0x7f );
        HWREG(UARTA_BASE + UART_O_DR) = ((HSLogger.us[1] >> 7   ) & 0x7f );
        HWREG(UARTA_BASE + UART_O_DR) = (HSLogger.us[2] & 0x7f );
        HWREG(UARTA_BASE + UART_O_DR) = ((HSLogger.us[2] >> 7   ) & 0x7f );
        HWREG(UARTA_BASE + UART_O_DR) = (HSLogger.us[3] & 0x7f );
        HWREG(UARTA_BASE + UART_O_DR) = ((HSLogger.us[3] >> 7   ) & 0x7f );
        HWREG(UARTA_BASE + UART_O_DR) = (HSLogger.us[4] & 0x7f );
        HWREG(UARTA_BASE + UART_O_DR) = ((HSLogger.us[4] >> 7   ) & 0x7f );
        HWREG(UARTA_BASE + UART_O_DR) = (HSLogger.us[5] & 0x7f );
        HWREG(UARTA_BASE + UART_O_DR) = ((HSLogger.us[5] >> 7   ) & 0x7f );
        HWREG(UARTA_BASE + UART_O_DR) = (HSLogger.us[6] & 0x7f );
        HWREG(UARTA_BASE + UART_O_DR) = ((HSLogger.us[6] >> 7   ) & 0x7f );
        HWREG(UARTA_BASE + UART_O_DR) = (HSLogger.us[7] & 0x7f );
        HWREG(UARTA_BASE + UART_O_DR) = ((HSLogger.us[7] >> 7   ) & 0x7f );
    }
}

//short unsigned junkk =0;

void ReadEncPosition1( void);

short unsigned PwmAtInt ;
#pragma FUNCTION_OPTIONS ( AdcIsr, "--opt_level=3" );
__interrupt void AdcIsr(void)
{
    float Vn ;
    SysState.EcapOnInt = HWREG (ECAP3_BASE + ECAP_O_TSCTR );
    GpioDataRegs.GPASET.bit.GPIO18 = 1 ;

    // Interrupt CPU2
    HWREG(IPC_CPUXTOCPUX_BASE+IPC_O_CPU1TOCPU2IPCSET) = IPC_FLAG3;

    //long unsigned port ;
    //short unsigned potcase ;

//    junkk = (junkk + 1 ) & 4095 ;
//    HWREGH(DACA_BASE + DAC_O_VALS) = junkk ;
    //(short unsigned) (c.Num2048 +
    //        __mmaxf32 (__mminf32 (ClaControlPars.VoltageDacGain * ClaState.Analogs.PhaseVoltUnCalib[1] , 2000 ) , -2000 )) ;
//    HWREGH(DACC_BASE + DAC_O_VALS) = ( junkk+ 1048 ) & 4095 ;

    // Acknowledge interrupt
    HWREGH(PIECTRL_BASE + PIE_O_ACK) = INTERRUPT_ACK_GROUP3 ;
    HWREGH(PWM_CPU_PACER+EPWM_O_ETCLR) = 0xd ;

    // Take time
    PwmAtInt = HWREGH(PWM_CPU_PACER+EPWM_O_TBCTR) ;
    SysState.Timing.UsecTimer = ~HWREG( CPUTIMER1_BASE+CPUTIMER_O_TIM) - ( long) (PwmAtInt * INV_CPU_CLK_MHZ) ;

    //SysState.Timing.UsecTimer = -HWREG(CPUTIMER1_BASE + CPUTIMER_O_TIM);
    SysState.Timing.IntCntr   += 1 ;

    // Doing the flash , all services cut
    if ( SysState.Mot.DisablePeriodicService )
    {
        if ( ClaState.MotorOnRequest )
        {
            LogException(EXP_SAFE_FATAL, exp_periodc_service_cut_while_on) ;
        }
        GpioDataRegs.GPACLEAR.bit.GPIO18 = 1 ;
        return ;
    }

    // Process analog readout
    //ProcAnalogSamples() ;

#ifdef ON_BOARD_ENCODER
    // Read the encoder
    ReadEncPosition1() ;
#endif



    Commutation.Status = GetCommAnglePu(ClaState.Encoder1.Pos ) ;

    FillLoggerStruct();

#define N1 2
#define N2 1

    // Run sensorless estimator
    SLessData.I[0] = ClaState.Analogs.PhaseCur[0];
    SLessData.I[1] = ClaState.Analogs.PhaseCur[N1];
    SLessData.I[2] = ClaState.Analogs.PhaseCur[N2];

    Vn = ( ClaState.Analogs.PhaseVoltMeas[0] + ClaState.Analogs.PhaseVoltMeas[1] + ClaState.Analogs.PhaseVoltMeas[2]) * 0.333333333333333f;

    SLessData.V[0] = (float)ClaState.Analogs.PhaseVoltMeas[0] - Vn ;
    SLessData.V[1] = (float)ClaState.Analogs.PhaseVoltMeas[N1] - Vn ;
    SLessData.V[2] = (float)ClaState.Analogs.PhaseVoltMeas[N2] - Vn ;

    if (SLessState.On)
    {
        SLessState.ThetaEst = SLessState.ThetaHat;
    }
    else
    {
        if (SysState.Mot.LoopClosureMode==E_LC_OpenLoopField_Mode)
        {
            SLessState.ThetaEst = __fracf32( SysState.StepperCurrent.StepperAngle  ) ; //  (float)(*ThtM)* SysPars.npp; //  FieldFilter.ThetaHat;
        }
        else
        {
            SLessState.ThetaEst = __fracf32( ClaState.QThetaElect - 0.25f ) ; //  (float)(*ThtM)* SysPars.npp; //  FieldFilter.ThetaHat;        }
        }
    }
    PaicuPU();


    if ( SysState.Mot.ReferenceMode == E_PosModeDebugGen)
    {
        RefGen( &GRefGenPars , & SysState.Debug.GRef , SysState.Timing.Ts );
        RefGen( &TRefGenPars , & SysState.Debug.TRef , SysState.Timing.Ts );
        if ( SysState.AlignRefGen )
        { // Lock times for coherence in current loop identification
            SysState.Debug.GRef.Time = SysState.Debug.TRef.Time ;
        }
#ifdef UNIT_TEST_TEST_BQUADS
        if (SysState.Debug.bTestBiquads)
        {
            SysState.Debug.fDebug[0] = RunBiquads(SysState.Debug.TRef.Out , SysState.Debug.fDebug[1]) ;
        }
#endif
    }
    else
    {
        ResetRefGens() ;
    }

    ClaMailIn.Tref  = SysState.Debug.TRef.Out ;
    ClaMailIn.Gref  = SysState.Debug.GRef.Out ;

    // Select correct feedback
    // By use case make position feedback
    SysState.OuterSensor.OuterPos = ClaState.Encoder1.UserPos ;

    // If the axis is modulo,there is no meaning to outer position, and the below "MergeState" calculation will yield nonesense, especially when numbers grow big
    if ( ControlPars.UseCase & UC_POS_MODULO )
    {
        SysState.OuterSensor.OuterMergeState = 0 ;
    }
    else
    {
        SysState.OuterSensor.OuterMergeState = SysState.OuterSensor.OuterMergeState +
                SysState.OuterSensor.OuterMergeCst * (SysState.OuterSensor.OuterPos - ClaState.Encoder1.UserPos - SysState.OuterSensor.OuterMergeState ) ;
    }
    SysState.OuterSensor.OuterMerge = ClaState.Encoder1.UserPos + SysState.OuterSensor.OuterMergeState ;

// Hazard: That is specific for a robot when this EXT mode applies to neck only, which has outer loop anyway
    if ( SysState.Mot.LoopClosureMode >= E_LC_Dual_Pos_Mode )
    {
        SysState.PosControl.PosFeedBack = SysState.OuterSensor.OuterMerge  ;
    }
    else
    {
        SysState.PosControl.PosFeedBack = ClaState.Encoder1.UserPos ;
    }


    if (ControlPars.UseCase & US_LIMIT_POS_FB)
    {
        if ( ClaState.MotorOn && (__fmax(__fmin(SysState.PosControl.PosFeedBack,ControlPars.MaxPositionFb),ControlPars.MinPositionFb) != SysState.PosControl.PosFeedBack ) )
        {
            LogException(EXP_FATAL, exp_deviation_from_feedback_limit) ;
        }
    }

#ifdef REF_FILT_UNIT_TEST
    SysState.Debug.lDebug[0] = ( SysState.Debug.lDebug[0]+1) & 127 ;
    if (  SysState.Debug.lDebug[0] == 0 )
    {
        SysState.Debug.fDebug[0] = -SysState.Debug.fDebug[0] ;
    }
    SysState.Debug.fDebug[2] = PosPrefilterMotorOn( SysState.Debug.fDebug[0] , &SysState.Debug.fDebug[1] ) ;
#else

    // Either motor on or motor off
    if ( ClaState.MotorOn)
    {
        if ( ( Commutation.CommutationMode == COM_ENCODER_SENSORLESS) && ( SysState.Mot.LoopClosureMode == E_LC_Speed_Mode) )
        {
            MotorOnSeqAsSensorless() ;
        }
        else
        {
            MotorOnSeq() ;
        }
    }
    if ( ClaState.MotorOn == 0 )
    {
        if ( SysState.Mot.InAutoBrakeEngage)
        {
            MotorHoldSeq();
        }
        else
        {
            MotorOffSeq() ;
        }
    }
    GetSinCorrelation();

#endif
    // I2t log
    LogI2t() ;

    // RT CAN server
    RtCanService() ;


    // Recorder
    RtRecorder() ;
    if ( Snap.SnapCmd)
    {
        SnapIt( & Snap.SnapBuffer[0].us[0] );
        Snap.UsecTimer = SysState.Timing.UsecTimer ;
        Snap.SnapCmd = 0 ;
    }

    SysState.Status.Statistics = ( (ClaState.MotorOn) ? 1 : 0 ) +  ((SysState.Mot.LoopClosureMode & 0xf) << 1 ) +
            ((SysState.Mot.ReferenceMode& 0xf) << 5 ) ;

    SysState.Timing.ClocksOfInt =  HWREG (ECAP3_BASE + ECAP_O_TSCTR ) - SysState.EcapOnInt ;

    GpioDataRegs.GPACLEAR.bit.GPIO18 = 1 ;
}


const short LMeasVolt[] = { 0, 0 , 1 , -1 , 0 , -1 , 0 , 1 , 0 , 1 , -1, 0 , 0 , 0 , 0 ,0,0,0} ;

void AdvanceCLMeasState()
{
    SysState.CLMeas.TState[SysState.CLMeas.State] =  SysState.Timing.UsecTimer ;
    SysState.CLMeas.State  += 1  ;
}

void StopLmeasRecorder()
{
    if ( Recorder.Stopped == 0 )
    {
        Recorder.Stopped = 1 ;
        Recorder.EndRec  = Recorder.PutCntr ;
        Recorder.TotalRecLength = Recorder.EndRec ;
        Recorder.RecLength = Recorder.TotalRecLength /Recorder.RecorderListLen ;
    }
}



void SetCLMeasFault( short flt )
{
    if ( SysState.CLMeas.Fault == 0 )
    {
        SysState.CLMeas.Fault = flt  ;
    }
    ClaState.MotorOn = 0 ;
    KillMotor() ;
    SysState.CLMeas.State = ELM_Fault   ;
    StopLmeasRecorder() ;
    SetGateDriveEnable(0) ;
}


struct CC
{
        float Hall2Amp ;
        float Num4096  ;
        float Num2048  ;
};
const struct CC c1 = {.Hall2Amp = ADC_Hall2Amp, .Num4096 = 4096.0f, .Num2048 = 2048.0f } ;


#pragma FUNCTION_OPTIONS ( AdcIsrLMeas, "--opt_level=3" );
__interrupt void AdcIsrLMeas(void)
{

    short PwmState ;
    long unsigned dt ;
    SysState.EcapOnInt = HWREG (ECAP3_BASE + ECAP_O_TSCTR );
    GpioDataRegs.GPASET.bit.GPIO18 = 1 ;
    //long unsigned port ;
    //short unsigned potcase ;

//    junkk = (junkk + 1 ) & 4095 ;
//    HWREGH(DACA_BASE + DAC_O_VALS) = junkk ;
    //(short unsigned) (c.Num2048 +
    //        __mmaxf32 (__mminf32 (ClaControlPars.VoltageDacGain * ClaState.Analogs.PhaseVoltUnCalib[1] , 2000 ) , -2000 )) ;
//    HWREGH(DACC_BASE + DAC_O_VALS) = ( junkk+ 1048 ) & 4095 ;

    // Acknowledge interrupt
    if ( SysState.CLMeas.State >= ELM_Done )
    {
        return ; // Do not acknowledge interrupt, so interrupt service will stop
    }

    HWREGH(PIECTRL_BASE + PIE_O_ACK) = INTERRUPT_ACK_GROUP1 ;
    //HWREGH(PWM_CPU_PACER+EPWM_O_ETCLR) = 0xd ;
    // Take time
    //PwmAtInt = HWREGH(PWM_CPU_PACER+EPWM_O_TBCTR) ;
    SysState.Timing.UsecTimer = ~HWREG( CPUTIMER1_BASE+CPUTIMER_O_TIM) ; // - ( long) (PwmAtInt * INV_CPU_CLK_MHZ) ;


    // Read currents and voltages
    ClaState.AdcRaw.PhaseCurAdc[0] = ADC_READ_CUR1_H1 + ADC_READ_CUR1_H2 ;
    ClaState.AdcRaw.PhaseCurAdc[1] = ADC_READ_CUR2_H1 + ADC_READ_CUR2_H2 ;
    ClaState.AdcRaw.PhaseCurAdc[2] = ADC_READ_CUR3_H1 + ADC_READ_CUR3_H2 ;

    ClaState.Analogs.PhaseCur[0] = ( ClaState.AdcRaw.PhaseCurAdc[0]  - c1.Num4096 - ClaMailIn.IaOffset ) * c1.Hall2Amp * ( 1.0f + Calib.ACurGainCorr ) ;
    ClaState.Analogs.PhaseCur[1] = ( ClaState.AdcRaw.PhaseCurAdc[1]  - c1.Num4096 - ClaMailIn.IbOffset ) * c1.Hall2Amp * ( 1.0f + Calib.BCurGainCorr ) ;
    ClaState.Analogs.PhaseCur[2] = ( ClaState.AdcRaw.PhaseCurAdc[2]  - c1.Num4096 - ClaMailIn.IcOffset ) * c1.Hall2Amp * ( 1.0f + Calib.CCurGainCorr ) ;

    ClaState.Analogs.Vdc = (( c1.Num2048 - ADC_READ_VOLTDC - Calib.VdcOffset) * ClaControlPars.Vdc2Bit2Volt) * ( 1 + Calib.VdcGain ) ;

    EALLOW ;
    //* SysState.CLMeas.pPwmFrc[2] = 0x5  ; // Force low
    SysState.CLMeas.CurIn   = *SysState.CLMeas.pCurIn ;
    SysState.CLMeas.CurOut  = *SysState.CLMeas.pCurOut;
    SysState.CLMeas.CurMean = ( SysState.CLMeas.CurIn - SysState.CLMeas.CurOut) * 0.5f ;
    SysState.CLMeas.Vdc     =  ClaState.Analogs.Vdc ;
    //* SysState.CLMeas.pPTripForce = 0x4 ; // Kill branch 2

    if ( SysState.CLMeas.State == ELM_Nothing )
    {
        SysState.CLMeas.SubState = 0 ;
        Recorder.BufferReady = 1 ;
        Recorder.TriggerActive = 1 ;

        Recorder.Ready4Trigger = 1 ;
        Recorder.Active = 1 ;

        Recorder.StartRec = 0 ;
        Recorder.EndRec   = 0  ;

        RecorderStartFlag = 1 ;
        SysState.CLMeas.State = ELM_Init_cond ;
        SysState.CLMeas.TState[0] = SysState.Timing.UsecTimer ;
    }

    SysState.CLMeas.ExtState = ( SysState.CLMeas.State & 0xf ) + (SysState.Timing.UsecTimer << 4 );


    // Test thresholds and state transitions
    switch ( SysState.CLMeas.State)
    {

    case ELM_Init_cond:
        SysState.CLMeas.SubState += 1 ;
        if ( SysState.CLMeas.SubState >= Recorder.RecorderGap * 16 )
        {
            AdvanceCLMeasState() ;
        }
        break ;
    case ELM_FirstRise:

        //if ( SysState.CLMeas.CurMean > SysState.CLMeas.TholdLow )
        //{
        //    SysState.CLMeas.bRecNow = 1  ;
        //}
        if ( SysState.CLMeas.CurMean > SysState.CLMeas.TholdHigh )
        {
            //SysState.CLMeas.bRecNow = 0  ;
            AdvanceCLMeasState() ;
        }
        break ;

    case ELM_FirstFall:
        //if ( -SysState.CLMeas.CurMean > SysState.CLMeas.TholdLow )
        //{
        //    SysState.CLMeas.bRecNow = 1  ;
        //}
        if ( SysState.CLMeas.CurMean < SysState.CLMeas.TholdZero )
        {
//            SysState.CLMeas.bRecNow = 0  ;
            AdvanceCLMeasState() ;
        }
        break;
    case ELM_FirstPause:
        dt = SysState.Timing.UsecTimer - SysState.CLMeas.TState[ELM_FirstFall] ;
        if ( dt >= ( (SysState.CLMeas.TState[2] - SysState.CLMeas.TState[0] ) >> 2 ) )
        {
            AdvanceCLMeasState() ;
        }
        break ;
    case ELM_FirstFallFull:
        if ( -SysState.CLMeas.CurMean > SysState.CLMeas.TholdHigh )
        {
            //SysState.CLMeas.bRecNow = 0  ;
            AdvanceCLMeasState() ;
        }
        break ;
    case ELM_NegPause:
        dt = SysState.Timing.UsecTimer - SysState.CLMeas.TState[ELM_FirstFallFull] ;
        if ( dt >= (( (SysState.CLMeas.TState[4] - SysState.CLMeas.TState[0] ) * 2 ) / 7 ) )
        {
            AdvanceCLMeasState() ;
        }
        break ;
    case ELM_SecondRise:
        if ( SysState.CLMeas.CurMean > -SysState.CLMeas.TholdZero )
        {
            //SysState.CLMeas.bRecNow = 0  ;
            AdvanceCLMeasState() ;
        }
        break ;
    case ELM_SecondPause:
        dt = SysState.Timing.UsecTimer - SysState.CLMeas.TState[ELM_SecondRise] ;
        if ( dt >= ( (SysState.CLMeas.TState[6] - SysState.CLMeas.TState[0])  / 11  ))
        {
            AdvanceCLMeasState() ;
        }
        break ;
    case ELM_SecondRiseFull:
        if ( SysState.CLMeas.CurMean > SysState.CLMeas.TholdHigh )
        {
            AdvanceCLMeasState() ;
        }
        break ;

    case ELM_FinalReduction:
        if ( SysState.CLMeas.CurMean < SysState.CLMeas.TholdZero )
        {
            ClaState.MotorOn = 0 ;
            KillMotor() ;
            SetGateDriveEnable(0) ;
            AdvanceCLMeasState() ;
        }
        break;
    case ELM_WaitEnd:
        dt = SysState.Timing.UsecTimer - SysState.CLMeas.TState[ELM_FinalReduction] ;
        if ( dt >= ( SysState.CLMeas.TState[ELM_FinalReduction] - SysState.CLMeas.TState[ELM_SecondRiseFull]  ))
        {
            StopLmeasRecorder() ;
            AdvanceCLMeasState() ;
        }
        break;
    default: // ELM_Done , ELM_Fault
        ClaState.MotorOn = 0 ;
        KillMotor() ;
        break ;
    }


    PwmState = LMeasVolt[SysState.CLMeas.State] ;
    switch ( PwmState)
    {
    case 1:
        * SysState.CLMeas.pPwmFrc[0] = 0x6 ; // Force low
        * SysState.CLMeas.pPwmFrc[1] = 0x5 ; // Force High
        * SysState.CLMeas.pPwmFrc[2] = 0x5 ; // Force low
        break ;
    case -1:
        * SysState.CLMeas.pPwmFrc[0] = 0x5 ; // Force High
        * SysState.CLMeas.pPwmFrc[1] = 0x6 ; // Force low
        * SysState.CLMeas.pPwmFrc[2] = 0x6 ; // Force high
        break ;
    default:
        * SysState.CLMeas.pPwmFrc[0] = 0x5 ; // Force low
        * SysState.CLMeas.pPwmFrc[1] = 0x5 ; // Force low
        * SysState.CLMeas.pPwmFrc[2] = 0x5 ; // Force low
        break ;
    }

    // Detect over current
    if  (__fmax( __fmax( fabsf(ClaState.Analogs.PhaseCur[0]),fabsf(ClaState.Analogs.PhaseCur[1])),fabsf(ClaState.Analogs.PhaseCur[2]) ) > SysState.CLMeas.TholdHigh * 1.5f )
    {
        SetCLMeasFault(-1) ;
    }

    // Timeout - stop all
    if ( ((long)SysState.Timing.UsecTimer - (long)SysState.CLMeas.TState[0])*1e-6f  >   SysState.CLMeas.Tout)
    {
        SetCLMeasFault(-2) ;
    }

    if ( Recorder.Stopped == 0 )
    {
        SampleRecordedSignals();
    }
    SysState.Timing.LmeasClocksOfInt =  __lmax( HWREG (ECAP3_BASE + ECAP_O_TSCTR ) - SysState.EcapOnInt , SysState.Timing.LmeasClocksOfInt) ;
    GpioDataRegs.GPACLEAR.bit.GPIO18 = 1 ;
}
