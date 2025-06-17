//###########################################################################
//
// FILE:   dma_ex1_shared_peripheral_cpu1.c
//
// TITLE:  DMA Transfer for Shared Peripheral Example
//
//! \addtogroup dual_example_list
//! <h1> DMA Transfer Shared Peripheral </h1>
//!
//! This example shows how to initiate a DMA transfer on CPU1 from a shared
//! peripheral which is owned by CPU2.  In this specific example, a timer ISR
//! is used on CPU2 to initiate a SPI transfer which will trigger the CPU1 DMA.
//! CPU1's DMA will then in turn update the EPWM1 CMPA value for the PWM which
//! it owns.  The PWM output can be observed on the GPIO pins configured in
//! the InitEPwm1Gpio() function.
//!
//! \b Watch \b Pins
//!   - GPIO0 and GPIO1 - ePWM output can be viewed with oscilloscope
//!
//
//###########################################################################
// 
// C2000Ware v5.04.00.00
//
// Copyright (C) 2024 Texas Instruments Incorporated - http://www.ti.com
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions 
// are met:
// 
//   Redistributions of source code must retain the above copyright 
//   notice, this list of conditions and the following disclaimer.
// 
//   Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the 
//   documentation and/or other materials provided with the   
//   distribution.
// 
//   Neither the name of Texas Instruments Incorporated nor the names of
//   its contributors may be used to endorse or promote products derived
//   from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// $
//###########################################################################

//
// Included Files
//

#define VARS_OWNER
#define CLA_VAR_OWNER
#define CONFIG_OWNER

#include "StructDef.h"

//
// Function Prototypes
//
void ExampleInitSysCtrl(void);
void InitEPwm1(void);
void SetupDMA(void);

void CfgBlockTransport(void)
{
    SysState.BlockUpload.InBlockMsg.cobId = (0xb<<7)+CanId ;
    SysState.BlockUpload.InBlockMsg.dLen  = 8 ;

    SysState.BlockUpload.StartBlockMsg.cobId = (0xb<<7)+CanId  ;
    SysState.BlockUpload.StartBlockMsg.dLen  = 8 ;
    SysState.BlockUpload.StartBlockMsg.data[0] = 0x64 + (0x2006L<<8) + (1L<<24);

    SysState.BlockUpload.EndBlockMsg.cobId = (0xb<<7)+CanId  ;
    SysState.BlockUpload.EndBlockMsg.dLen  = 8 ;

    SysState.BlockUpload.AbortBlockMsg.cobId = (0xb<<7)+CanId  ;
    SysState.BlockUpload.AbortBlockMsg.dLen  = 8 ;
    SysState.BlockUpload.AbortBlockMsg.data[0] = (4L<<5) + ( (long unsigned)02006 ) + ( (long unsigned)1 << 24 );
    SysState.BlockUpload.AbortBlockMsg.data[1] = Invalid_sequence_number ;
}



/**
 * \brief Initiate the time outs of the system
 */
void InitTimeOuts ( void )
{
    short unsigned cnt ;

    // All the timers are initially elapsed
    for ( cnt = 0 ; cnt < NSYS_TIMER_CMP_ARRAY ; cnt++)
    {
        SetSysTimerTargetSec(cnt, 0.1f, &SysTimerStr);
    }
    SetSysTimerTargetSec ( TIMER_MCAN_BUSOFF , BUS_OFF_RECOVERY_TIME ,  &SysTimerStr  );
    SetSysTimerTargetSec ( TIMER_AUTO_MOTOROFF , 0.3f ,  &SysTimerStr  );
    SetSysTimerTargetSec ( TIMER_AUTO_MIN_MOTORON , 3.0 , &SysTimerStr ) ;
//    SetSysTimerTargetSec (TIMER_GYRO_PROG , 0.005f  , &SysTimerStr);
}



//
// Uncomment to enable DMA ISR
//
//interrupt void dma_isr(void);
void InitAppData(void)
{
    struct CFloatParRecord *pPar ;
    short unsigned cnt ;
    //float PosRange;
    Cpu2HadWatchdogReset = 0 ;
    ClearMemRpt((short unsigned *) &Commutation,sizeof( Commutation) );
    ClearMemRpt((short unsigned *) &SysState,sizeof( SysState) );

    ClearMemRpt((short unsigned *) &CanSlaveInQueue,sizeof( CanSlaveInQueue) );
    ClearMemRpt((short unsigned *) &CanSlaveOutQueue,sizeof( CanSlaveOutQueue) );
    ClearMemRpt((short unsigned *) &SlaveSdo,sizeof( SlaveSdo) );
    ClearMemRpt((short unsigned *) &UartSwBuf,sizeof( UartSwBuf) );
    ClearMemRpt((short unsigned *) &MasterBlaster,sizeof( MasterBlaster) );
    ClearMemRpt((short unsigned *) &CfgDirty[0],sizeof( CfgDirty) );
    ClearMemRpt((short unsigned *) &Correlations,sizeof( Correlations) );
    ClearMemRpt((short unsigned *) &FlashProg,sizeof( FlashProg) );

    ClearMemRpt((short unsigned *) &ClaState,sizeof( ClaState) );
    ClearMemRpt((short unsigned *) &ClaMailIn,sizeof( ClaMailIn) );



    Correlations.fPtrs[0] = &ClaState.Encoder1.UserPos ;
    Correlations.fPtrs[1] = &ClaState.CurrentControl.ExtCurrentCommand ;
    Correlations.fPtrs[2] = &ClaState.CurrentControl.ExtIq ;
    Correlations.nCyclesInTake = 1 ;
    Correlations.nSamplesForFullTake = 10 ;
    Correlations.nWaitTakes = 1 ;
    Correlations.nSumTakes = 1 ;

    CanSlaveInQueue.nQueue = N_SLAVE_QUEUE ;
    CanSlaveOutQueue.nQueue = N_SLAVE_QUEUE ;

    SlaveSdo.SlaveBuf = (unsigned long* ) SlaveSdoBuf ;

    SysState.Timing.Ts = CUR_SAMPLE_TIME_USEC * 1e-6 ;
    SysState.Timing.TsTraj = SysState.Timing.Ts ;
    SysState.Timing.TsInTicks = (CPU_CLK_MHZ * CUR_SAMPLE_TIME_USEC  ) ;

    // Set configuration params
    ResetConfigPars() ;

    // Load the parameters
    for ( cnt = 0 ; cnt < (signed short)N_ParTable; cnt++ )
    {
        pPar = (struct CFloatParRecord  *) &ParTable[cnt];
        if ( pPar->ptr == (float*) 0 )
        {
            break ;
        }
        *pPar->ptr = pPar->dflt ;
    }

    ProjId = 105 ; // Ilegal
    InitControlParams();

    //InitLinService();


    FlashCalib =  Sector_AppCalib_start ;

    InitSystemTimer( &SysTimerStr);

    ClaState.SystemMode = E_SysMotionModeManual ; // Be optimistic



    // Just in case
    InitRecorder(FAST_INTS_IN_C, FAST_TS_USEC, SDO_BUF_LEN_LONGS);

    SysState.PT.Init = 0 ;

    DealCalibration (1) ; // Deal with calibration
    if  (ReadCalibFromFlash ( (long unsigned*) &CalibProg.C.Calib ,   FlashCalib   ) )
    {
        SysState.Mot.NoCalib = 1 ;

        LogException( EXP_FATAL , exp_missing_calib);
        SetSystemMode(E_SysMotionModeFault);

        ClearMemRpt( (short unsigned * ) &CalibProg.C.Calib , sizeof(struct CCalib)  ) ;

    }


    SysState.Mot.CurrentLimitFactor = 1 ;

    InitTimeOuts();

    ClaState.Timing.TsInTicks = CUR_SAMPLE_TIME_CLOCKS  ;
    ClaState.Timing.InvTsInTicks = (1.0f / CUR_SAMPLE_TIME_CLOCKS)   ;
    ClaState.Timing.InvMhz = 1.0f / (float) CPU_CLK_MHZ ;
    ClaState.Pwm6LimitForZeroing = (DAC_PWM_PERIOD_CLK*0.5f) ;


    InitControlParams() ;

    //ProgramProfiler(&SysState.Profiler[cnt] , ControlPars.MaxSpeedCmd , ControlPars.MaxAcc , ControlPars.MaxAcc , ControlPars.ProfileTau , 0 ) ;
    ResetProfiler ( &SysState.Profiler, SysState.PosControl.PosFeedBack , ClaState.Encoder1.UserSpeed , 1 ) ;

    SysState.Mot.LoopClosureMode = E_LC_OpenLoopField_Mode ; // Default
    //SysState.Mot.GyroNotReady = 1 ;


    SysState.Debug.GRef.Type  = E_S_Fixed ;
    SysState.Debug.TRef.Type  = E_S_Fixed  ;

    InitHallModule() ;

    InitPosPrefilter() ;

}

void InitPosPrefilter(void)
{
    ClearMemRpt((short unsigned *) &PosPrefilter,sizeof( PosPrefilter) );
    PosPrefilter.b01 = 131453 ;
    PosPrefilter.b02 = 189276 ;

    PosPrefilter.a21 = 2114678849 ;
    PosPrefilter.a22 = 2114346702 ;
}


volatile short unsigned kuku ;
//
// Main
//
void main(void)
{
//
//
// Disable CPU interrupts
//
    kuku = 0 ;
    DINT ;


    //
    // Initialize System Control:
    // PLL, WatchDog, enable Peripheral Clocks
    // This example function is found in the f28p65x_sysctrl.c file.
    //ExampleInitSysCtrl();
    InitSysCtrlCpu1() ;

    //
    // Assign RAMs and Flash banks to CPU2.
    // In the default CPU2 linker cmd files, GS4, FLASH_BANK3 and FLASH_BANK4
    // are used for allocating various CPU2 sections.
    // In case CPU2 needs additional RAM or Flash regions, CPU1 needs to assign
    // its ownership to CPU2 using the following functions :
    //

    //
    // Write the controller select setting into the appropriate field.
    //
    EALLOW;
        MemCfgRegs.GSxMSEL.all |= 0x1fU  ; // Abduct all GS memories
        DevCfgRegs.MCUCNF1.all |= 0x3c ; // D2 to D5 go to CPU2

        //DevCfgRegs.BANKMUXSEL.bit.BANK3 = 3U;
        //DevCfgRegs.BANKMUXSEL.bit.BANK4 = 3U;
    EDIS;

    SetupFlash(1 , CPU_CLK_MHZ) ;

    InitAppData() ;
//
// Initialize GPIO pins for EPWM-1
//
    InitPeripherals() ;
    // InitEPwm1Gpio();
    CfgBlockTransport(); // Only after CAN ID is known


    PrepCpu2Work() ;
//
//  Uncomment to enable DMA ISR
//
//    EALLOW;
//    PieCtrlRegs.PIEIER7.bit.INTx5 = 1 ;
//    PieVectTable.DMA_CH5_INT= &dma_isr;
//    IER |= M_INT7;
//    EDIS;
    setupPwmParams() ;

    SetupIsr();
//
// Enable global Interrupts and higher priority real-time debug
// events:
//
    EINT;  // Enable Global interrupt INTM
    ERTM;  // Enable Global realtime interrupt DBGM




//
// IDLE loop. Just sit and loop forever (optional):
//
    for(;;)
    {
        IdleLoop() ;
        SysCtl_serviceWatchdog() ;
    }
}



short SetProjectSpecificData( short unsigned proj )
{
    struct CProjSpecificData * pProjData ;
    struct CProjSpecificCtl * pProjCtl ;
    if ( proj <= PROJ_TYPE_UNDEFINED || proj >= PROJ_TYPE_LAST  )
    {
        return -1 ;
    }

    if ( (proj >= nProjSpecificData)  || (proj >= nProjSpecificCtl) )
    {
        return -1 ;
    }

    pProjData = (struct CProjSpecificData *) & ProjSpecificData[proj] ;

    pProjCtl  = (struct CProjSpecificCtl *)  &ProjSpecificCtl[proj] ;

    if (( pProjData->ProjIndex != proj ) || (pProjCtl)->ProjIndex != proj )
    {
        return -1 ;
    }

    ControlPars.I2tCurLevel  = pProjData->I2tCurLevel ;
    ControlPars.I2tCurTime   = pProjData->I2tCurTime  ;

    ControlPars.FullAdcRangeCurrent = pProjData->FullAdcRangeCurrent ;
    ControlPars.EncoderCountsFullRev = pProjData->EncoderCountsFullRev ;
    ClaControlPars.Rev2Pos = pProjData->Rev2Pos ;
    HallDecode.HallAngleOffset = pProjData->HallAngleOffset ;
    ClaControlPars.nPolePairs = pProjData->nPolePairs ;
    ClaControlPars.PhaseOverCurrent = pProjData->PhaseOverCurrent ;
    ControlPars.DcShortCitcuitTripVolts = pProjData->DcShortCitcuitTripVolts ;
    ControlPars.MaxCurCmd = pProjData->MaxCurCmd ;
    ClaControlPars.KpCur = pProjData->KpCur ;
    ClaControlPars.KiCur = pProjData->KiCur ;

    ClaControlPars.MaxCurCmdDdt   = pProjData->MaxCurCmdDdt ; // Maximum current command slope
    ControlPars.CurrentFilterBWHz = pProjData->CurrentFilterBWHz ; // Bandwidth (Hz) of current prefilter
    ControlPars.BrakeReleaseVolts = pProjData->BrakeReleaseVolts ;

    ClaControlPars.CurrentCommandDir = pProjData->CurrentCommandDir ;


    HallTable[0] = pProjData->HallVal0 ;
    HallTable[1] = pProjData->HallVal1 ;
    HallTable[2] = pProjData->HallVal2 ;
    HallTable[3] = pProjData->HallVal3 ;
    HallTable[4] = pProjData->HallVal4 ;
    HallTable[5] = pProjData->HallVal5 ;
    HallTable[6] = pProjData->HallVal6 ;
    HallTable[7] = pProjData->HallVal7 ;
    ClaState.Encoder1.InvertEncoder = pProjData->InvertEncoder ;

    ControlPars.qf0.PBw = pProjCtl->qf0PBw ;
    ControlPars.qf0.PXi = pProjCtl->qf0PXi ;
    ControlPars.qf0.ZBw = pProjCtl->qf0ZBw ;
    ControlPars.qf0.ZXi = pProjCtl->qf0ZXi ;
    ControlPars.qf0.Cfg.ul = pProjCtl->qf0Cfg ;
    ControlPars.qf1.PBw = pProjCtl->qf1PBw ;
    ControlPars.qf1.PXi = pProjCtl->qf1PXi ;
    ControlPars.qf1.ZBw = pProjCtl->qf1ZBw ;
    ControlPars.qf1.ZXi = pProjCtl->qf1ZXi ;
    ControlPars.qf1.Cfg.ul = pProjCtl->qf1Cfg ;
    ControlPars.SpeedKp = pProjCtl->SpeedKp ;
    ControlPars.SpeedKi = pProjCtl->SpeedKi ;
    ControlPars.PosKp = pProjCtl->PosKp ;
    ControlPars.MaxAcc = pProjCtl->MaxAcc ;
    ControlPars.MinPositionCmd = pProjCtl->MinPositionCmd ;
    ControlPars.MaxPositionCmd = pProjCtl->MaxPositionCmd ;
    ControlPars.MinPositionFb = pProjCtl->MinPositionFb ;
    ControlPars.MaxPositionFb = pProjCtl->MaxPositionFb ;
    ControlPars.MotionConvergeWindow = pProjCtl->MotionConvergeWindow  ;
    ControlPars.MaxSupportedClosure = pProjCtl->MaxSupportedClosure ;
    ControlPars.MaxSpeedCmd   = pProjCtl->MaxSpeedCmd;
    SysState.Homing.HomingSpeed = __fmin(pProjCtl->HomingSpeed,ControlPars.MaxSpeedCmd)  ;
    //ClaState.Encoder1.UserPosOnHome = pProjCtl->UserPosOnHome ;
    SysState.UserPosOnHomingFW = pProjCtl->UserPosOnHomingFW ;
    SysState.UserPosOnHomingRev = pProjCtl->UserPosOnHomingRev ;

    SysState.Homing.HomingExitUserPos = pProjCtl->HomingExitUserPos ;

    SysState.Homing.Direction = pProjCtl->HomingDirection ;
    SysState.Homing.Method = pProjCtl->HomingMethod ;
    SysState.Homing.SwInUse = pProjCtl->HomingSwInUse ;


    ControlPars.HighDeadBandThold = pProjCtl->HighDeadBandThold ; // High side dead band hysteresis for position error
    ControlPars.LowDeadBandThold  = pProjCtl->LowDeadBandThold ; // Low side dead band hysteresis for position error;


    SysState.Profiler.vmax = __fmin( ControlPars.MaxSpeedCmd , pProjCtl->Profiler_vmax ) ;
    SysState.Profiler.slowvmax = SysState.Profiler.vmax * 0.5f  ;//If someone needs it someday, let him make better access to variable

    SysState.Profiler.accel = __fmin( ControlPars.MaxAcc , pProjCtl->Profiler_accel ) ;
    SysState.Profiler.dec = __fmin( ControlPars.MaxAcc , pProjCtl->Profiler_decel ) ;

    SysState.SpeedControl.ProfileAcceleration = __fmin(ControlPars.MaxAcc, pProjCtl->SpeedProfileAcceleration) ;

    SysState.OuterSensor.OuterMergeCst = pProjCtl->OuterMergeCst ;
    ControlPars.UseCase = pProjCtl->UseCase ;

    return 0 ;
}


void SetProjectId(void)
{
    //if ( DBaseConf.IsValidDatabase  )
    {
        ProjId =   PROJ_TYPE_BESENSORLESS ;
    }

    CanId = ProjSpecificData[ProjId].CanId ;

    if ( SetProjectSpecificData( ProjId) )
    {
        LogException(EXP_FATAL,err_undefined_proj_id) ;
        SysState.SeriousError = 1 ;
    }
    else
    {
        if ( InitControlParams() )
        {
            LogException(EXP_FATAL,err_bad_proj_pars) ;
            SysState.SeriousError = 1 ;
        }
    }
}





//
// InitEPwm1 - Function to Initialize EPWM1
//
void InitEPwm1(void)
{
    EPwm1Regs.TBPRD = 6000;                        // Set timer period
    EPwm1Regs.TBPHS.bit.TBPHS = 0x0000;            // Phase is 0
    EPwm1Regs.TBCTR = 0x0000;                      // Clear counter

    //
    // Setup TBCLK
    //
    EPwm1Regs.TBCTL.bit.CTRMODE = TB_COUNT_UPDOWN; // Count up
    EPwm1Regs.TBCTL.bit.PHSEN = TB_DISABLE;        // Disable phase loading
    EPwm1Regs.TBCTL.bit.HSPCLKDIV = TB_DIV4;       // Clock ratio to SYSCLKOUT
    EPwm1Regs.TBCTL.bit.CLKDIV = TB_DIV4;

    EPwm1Regs.CMPCTL.bit.SHDWAMODE = CC_SHADOW;    // Load registers every ZERO
    EPwm1Regs.CMPCTL.bit.SHDWBMODE = CC_SHADOW;
    EPwm1Regs.CMPCTL.bit.LOADAMODE = CC_CTR_ZERO;
    EPwm1Regs.CMPCTL.bit.LOADBMODE = CC_CTR_ZERO;

    //
    // Setup compare
    //
    EPwm1Regs.CMPA.bit.CMPA = 3000;

    //
    // Set actions
    //
    EPwm1Regs.AQCTLA.bit.CAU = AQ_SET;             // Set PWM1A on Zero
    EPwm1Regs.AQCTLA.bit.CAD = AQ_CLEAR;

    EPwm1Regs.AQCTLB.bit.CAU = AQ_CLEAR;           // Set PWM1A on Zero
    EPwm1Regs.AQCTLB.bit.CAD = AQ_SET;
}

//
// SetupDMA - Function to Setup DMA
//
void SetupDMA(void)
{
    volatile Uint16 *destination;
    volatile Uint16 *DMADest, *DMASource;

    //
    // Initialize the DMA
    //
    DMAInitialize();

    destination = (volatile Uint16 *)&EPwm1Regs.CMPA + 1 ;
    DMADest = (volatile Uint16 *)destination;
    DMASource = (volatile Uint16 *)0xE000;  // Location of CMPA value from CPU2

    //
    // Setup DMA to transfer a single 16-bit word.  The DMA is setup to run
    // continuously so that an interrupt is not required to restart the RUN
    // bit. The DMA trigger is SPIA-FFTX.
    // These functions are found in f28p65x_dma.c.
    //
    DMACH5AddrConfig(DMADest,DMASource);  // Config DMA source and dest address
    DMACH5BurstConfig(1,1,1);             // Setup burst registers
    DMACH5TransferConfig(1,1,1);          // Setup Transfer registers
    DMACH5WrapConfig(0xFFFF,0,0xFFFF,0);
    DMACH5ModeConfig(109, PERINT_ENABLE,ONESHOT_ENABLE,CONT_ENABLE,
                     SYNC_DISABLE,SYNC_SRC,OVRFLOW_DISABLE,SIXTEEN_BIT,
                     CHINT_END,CHINT_ENABLE);
    StartDMACH5();
}


/**
 * \brief Get calibration conversion factors
 * \param:
 *  0: Zero calibration 1: Read from flash and apply 2: From programmed calibration
 *
 */
struct CCalib CalibTmp ;
short DealCalibration (short unsigned rd)
{
    short unsigned mask ;
    //float m[3][3] ;
    short RetVal = 0 ;
    switch ( rd)
    {
    case 0:
        ClearMemRpt( (short unsigned * ) &CalibTmp , sizeof(Calib)  ) ;
        break ;
    case 1:
        if ( ReadCalibFromFlash ( (long unsigned*) &CalibTmp ,   FlashCalib   ) < 0 )
        {
            ClearMemRpt( (short unsigned * ) &CalibTmp , sizeof(Calib)  ) ;
            RetVal = -1 ;
        }
        break ;
    case 2:
        CalibTmp = CalibProg.C.Calib ;
        break ;
    }


    mask = BlockInts( ) ;
    Calib = CalibTmp ;
    RestoreInts(mask) ;
    return RetVal ;
}


short ReadCalibFromFlash ( long unsigned *Dest , long unsigned Src_in   )
{
    long unsigned cs ;
    short unsigned cnt ;
    long unsigned *Src ;
    long unsigned *uPtr ;
    short unsigned len = sizeof( struct CCalib ) ;

    Src  = (unsigned long *) Src_in ;
    uPtr = Src ;

    ClearMemRpt( (short unsigned * ) Dest , len ) ;

    if ( CheckAlign( (short unsigned *) Dest , 1 ) || CheckAlign( (short unsigned *) Src , 1 ) )
    { // Check both are on long boundary
        return -1 ;
    }

    len = ( len >> 1 ) ; // Because of shorts

    if ( uPtr[len-2] != 0x12345678)
    {
        return -1 ;
    }
    cs = 0 ;
    for ( cnt = 0 ; cnt < len ; cnt++)
    {
        cs -= *uPtr++  ;
    }
    if ( cs )
    {
        return -1 ;
    }
    for ( cnt = 0 ; cnt < len ; cnt++)
    {
        *Dest++ = *Src++  ;
    }
    return 0 ;
}



short CheckAlign ( short unsigned * ptr , short unsigned pw )
{
    short unsigned cnt ;
    long unsigned ul ;
    ul = ( long unsigned ) ptr ;
    for ( cnt = 0 ; cnt < pw ; cnt++ )
    {
        if ( ul & ( 1L << cnt ) )
        {
            return -1 ;
        }
    }
    return 0 ;
}





//
// dma_isr - DMA Interrupt Service Routine (Uncomment to enable DMA ISR)
//
//interrupt void dma_isr(void)     // DMA Channel 5
//{
//    PieCtrlRegs.PIEACK.all = PIEACK_GROUP7;
//}

//
// End of file
//
