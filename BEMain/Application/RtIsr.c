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

void ReadEncPosition1( void);

short unsigned PwmAtInt ;
#pragma FUNCTION_OPTIONS ( AdcIsr, "--opt_level=3" );
__interrupt void AdcIsr(void)
{
    SysState.EcapOnInt = HWREG (ECAP3_BASE + ECAP_O_TSCTR );
    GpioDataRegs.GPASET.bit.GPIO18 = 1 ;
    //long unsigned port ;
    //short unsigned potcase ;

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
        MotorOnSeq() ;
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


