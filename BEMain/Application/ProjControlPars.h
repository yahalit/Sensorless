/*
 * ProjControlPars.h
 *
 *  Created on: Oct 12, 2023
 *      Author: yahal
 */

#ifndef APPLICATION_PROJCONTROLPARS_H_
#define APPLICATION_PROJCONTROLPARS_H_

#define UC_USE_POT1 1
#define UC_USE_POT2 2
#define UC_USE_SW1_HM 4
#define UC_USE_SW2_HM 8
#define US_SUPPORT_HOMING 16
#define US_LIMIT_POS_FB 32
#define PDO3_CONFIG_ROTARY_POT ( 64* 0 )
#define PDO3_CONFIG_LINEAR     ( 64 * 1)
#define PDO3_CONFIG_WHEEL      ( 64 * 2)
#define PDO3_CONFIG_2_ROTARY_POT ( 64 * 3 ) // Neck with 2 rotary potentiometers
#define PROH_CONFIG_APPTYPES   (64*7) // [64 128 256] are reserved for TX PDO configuration
#define UC_POS_MODULO           512
#define UC_SUPPORT_BRAKE           1024
#define US_SUPPORT_AUTOBRAKE    2048


struct  CProjSpecificCtl
{
    float qf0PBw ;
    float qf0PXi ;
    float qf0ZBw ;
    float qf0ZXi ;
    float qf1PBw ;
    float qf1PXi ;
    float qf1ZBw ;
    float qf1ZXi ;
    long  qf0Cfg ;
    long  qf1Cfg ;
    float SpeedKp ;
    float SpeedKi ;
    float PosKp ;
    float MaxAcc ;
    float MinPositionCmd ; // Minimum position command
    float MaxPositionCmd ; // Maximum position command
    float MinPositionFb ;  // Minimum position feedback
    float MaxPositionFb ;  // Maximum position feedback
    float MaxSpeedCmd   ; // The maximum permitted speed command
    float Profiler_vmax ; // Maximum speed command for profiler
    float Profiler_accel; // Maximum acceleration command for profiler
    float Profiler_decel; // Maximum deceleration command for profiler
    float SpeedProfileAcceleration; // Standard acceleration in speed control
    float OuterMergeCst ;
    float MotionConvergeWindow ; // If position reaches this position tolerance. correction stops
    float HighDeadBandThold ; // High side dead band hysteresis for position error
    float LowDeadBandThold  ; // Low side dead band hysteresis for position error;
    long  MaxSupportedClosure ;
    float LowAutoMotorOffThold  ; // Low side dead band hysteresis for automatic shutdown;
    float HiAutoMotorOffThold  ; // Low side dead band hysteresis for automatic shutdown;
    long  UseCase ;
    short ProjIndex   ;
    float HomingSpeed ; // Speed Of homing
    //float UserPosOnHome ; // Use position on finding home
    float HomingExitUserPos ; // Relative exit after homing event
    float UserPosOnHomingFW ; // User position on completion of forward homing
    float UserPosOnHomingRev ;// User position on completion of reverse homing
    short HomingDirection ;
    short HomingMethod ;
    short HomingSwInUse ;
    float PhiM ;
    float Lq0 ;
    float LqCorner2 ;
    float Ld0 ;
    float LdSlope;
    float R ;
    float KiTheta ;
    float KpTheta ;
    float KiFlux ;
    float KpFlux ;
    float CyclesForConvergenceApproval ;
    float ObserverConvergenceToleranceFrac ;
    float MaximumSteadyStateFieldRetard ;
    float MinimumSteadyStateFieldRetard ;
    float FOMTakingStartSpeed ;
    float OpenLoopAcceleration ;
    float FOMConvergenceTimeout ;
    float OmegaCommutationLoss ;
    float WorkAcceleration ;
    float WorkSpeed ;
    float InitiallStabilizationTime ;
    float DCurrentMaxDiDt ;
};




#ifdef CONFIG_OWNER

// Cofiguration:
//int unsigned IsInUse: 2  ;
//int unsigned IsSimplePole : 2 ;
//int unsigned IsSimpleZero : 2 ;
//0: Bypass filter
//5: Simple pole, complex zero
//17: simple zero, complex pole
//21: simple pole, simple zero

    const struct CProjSpecificCtl ProjSpecificCtl[] =
    {
     {
       .ProjIndex = PROJ_TYPE_UNDEFINED ,// PROJ_UNDEFINED
      .qf0PBw   = 400.0f,
      .qf0PXi   = 0.55f,
      .qf0ZBw   = 1.0e5f,
      .qf0ZXi   = 1.0f ,
      .qf1PBw   = 250.0f,
      .qf1PXi   = 0.55f,
      .qf1ZBw   = 1.0e5f,
      .qf1ZXi   = 1.0f,
      .qf0Cfg   = 17 ,
      .qf1Cfg   = 17 ,
      .SpeedKp   = 5.706f ,
      .SpeedKi   = 215.3f ,
      .PosKp   = 58.03392625f,
      .MaxAcc   = 1000.0f,
      .MinPositionCmd = -1.4f, // Minimum position command
      .MaxPositionCmd = 1.4f , // Maximum position command
      .MinPositionFb = -1.48f,  // Minimum position feedback
      .MaxPositionFb = 1.48f ,  // Maximum position feedback
      .MaxSpeedCmd   = 1.0f ,
      .OuterMergeCst = 0.1f ,
      .MaxSupportedClosure = E_LC_Speed_Mode,
      .MotionConvergeWindow = 0.008f ,
      .Profiler_vmax = 0.1f,
      .Profiler_accel = 2.50f  ,
      .Profiler_decel = 2.50f ,
      .SpeedProfileAcceleration= 2.50f ,
      .HomingSpeed = 0.1f ,
      .HomingExitUserPos = 0.01f ,
      .HomingDirection = EHM_HomingReverse ,
      .HomingMethod    = EHM_Immediate ,
      .HomingSwInUse   = EHM_HomingSwitchD0 ,
      .UserPosOnHomingFW = 0 ,
      .UserPosOnHomingRev = 0 ,
      .HighDeadBandThold = 0 ,
      .LowDeadBandThold = 0 ,
      .LowAutoMotorOffThold = 0 ,
      .HiAutoMotorOffThold = 0 ,
      .UseCase = 0,
      .PhiM  = 0.130f,
      .Lq0 = 5.0e-4f ,
      .LqCorner2 =  0,
      .Ld0 = 5.0e-4f ,
      .LdSlope = 0 ,
      .R  =0.13f ,
      .KiTheta = 7.8026e+03f,
      .KpTheta = 149.0188f,
      .KiFlux = 10.0f,
      .KpFlux = 100.0f,
      .CyclesForConvergenceApproval = 3.0f,
      .ObserverConvergenceToleranceFrac = 0.22f,
      .MaximumSteadyStateFieldRetard = 0.5f,
      .MinimumSteadyStateFieldRetard = -0.2f,
      .FOMTakingStartSpeed = 5.0f,
      .OpenLoopAcceleration = 1.0f,
      .FOMConvergenceTimeout = 8.0f,
      .OmegaCommutationLoss = 3.0f,
      .WorkAcceleration = 3.0f,
      .WorkSpeed = 6.0f,
      .InitiallStabilizationTime = 3.0f ,
      .DCurrentMaxDiDt = 200.0f
     } , // PROJ_UNDEFINED

     {
      .ProjIndex = PROJ_TYPE_BESENSORLESS ,// PROJ_TYPE_WHEEL_R
      .qf0PBw   = 400.0f,
      .qf0PXi   = 0.55f,
      .qf0ZBw   = 1.0e5f,
      .qf0ZXi   = 1.0f ,
      .qf1PBw   = 6000.0f,
      .qf1PXi   = 0.55f,
      .qf1ZBw   = 1.0e5f,
      .qf1ZXi   = 1.0f,
      .qf0Cfg   = 17 ,
      .qf1Cfg   = 17 ,
      .SpeedKp   = 4.0f ,
      .SpeedKi   = 400.0f ,
      .PosKp   = 58.03392625f,
      .MaxAcc   = 100.0f,
      .MinPositionCmd = -1.4e6f, // Minimum position command
      .MaxPositionCmd = 1.4e6f , // Maximum position command
      .MinPositionFb = -1.48f,  // Minimum position feedback
      .MaxPositionFb = 1.48f ,  // Maximum position feedback
      .MaxSpeedCmd   = 25.0f ,
      .OuterMergeCst = 0.1f ,
      .MaxSupportedClosure = E_LC_Speed_Mode,
      .MotionConvergeWindow = 0.008f ,
      .Profiler_vmax = 20.0f,
      .Profiler_accel = 20.000f  ,
      .Profiler_decel = 20.000f ,
      .SpeedProfileAcceleration= 60.0f ,
      .HomingSpeed = 0.1f ,
      .HomingExitUserPos = 0.01f ,
      .HomingDirection = EHM_HomingReverse ,
      .HomingMethod    = EHM_Immediate ,
      .HomingSwInUse   = EHM_HomingSwitchD0 ,
      .UserPosOnHomingFW = 0 ,
      .UserPosOnHomingRev = 0 ,
      .HighDeadBandThold = 0 ,
      .LowDeadBandThold = 0 ,
      .HiAutoMotorOffThold = 0.01 ,
      .LowAutoMotorOffThold = 0.005 ,
      .UseCase = (PDO3_CONFIG_WHEEL | UC_POS_MODULO | UC_SUPPORT_BRAKE | US_SUPPORT_AUTOBRAKE),
      .PhiM  = 0.130f,
      .Lq0 = 5.0e-4f ,
      .LqCorner2 =  0,
      .Ld0 = 5.0e-4f ,
      .LdSlope = 0 ,
      .R  =0.13f ,
      .KiTheta = 7.8026e+03f,
      .KpTheta = 149.0188f,
      .KiFlux = 10.0f,
      .KpFlux = 100.0f,
      .CyclesForConvergenceApproval = 3.0f,
      .ObserverConvergenceToleranceFrac = 0.22f,
      .MaximumSteadyStateFieldRetard = 0.5f,
      .MinimumSteadyStateFieldRetard = -0.2f,
      .FOMTakingStartSpeed = 5.0f,
      .OpenLoopAcceleration = 1.0f,
      .FOMConvergenceTimeout = 8.0f,
      .OmegaCommutationLoss = 3.0f,
      .WorkAcceleration = 3.0f,
      .WorkSpeed = 6.0f,
      .InitiallStabilizationTime = 3.0f ,
      .DCurrentMaxDiDt = 200.0f
     } , // PROJ_TYPE_BESENSORLESS

     {
      .ProjIndex = PROJ_TYPE_ZOOZ_S ,// PROJ_TYPE_WHEEL_R
      .qf0PBw   = 400.0f,
      .qf0PXi   = 0.55f,
      .qf0ZBw   = 1.0e5f,
      .qf0ZXi   = 1.0f ,
      .qf1PBw   = 6000.0f,
      .qf1PXi   = 0.55f,
      .qf1ZBw   = 1.0e5f,
      .qf1ZXi   = 1.0f,
      .qf0Cfg   = 17 ,
      .qf1Cfg   = 17 ,
      .SpeedKp   = 5.0f ,
      .SpeedKi   = 100.0f ,
      .PosKp   = 58.03392625f,
      .MaxAcc   = 100.0f,
      .MinPositionCmd = -1.4e6f, // Minimum position command
      .MaxPositionCmd = 1.4e6f , // Maximum position command
      .MinPositionFb = -1.48f,  // Minimum position feedback
      .MaxPositionFb = 1.48f ,  // Maximum position feedback
      .MaxSpeedCmd   = 25.0f ,
      .OuterMergeCst = 0.1f ,
      .MaxSupportedClosure = E_LC_Speed_Mode,
      .MotionConvergeWindow = 0.008f ,
      .Profiler_vmax = 20.0f,
      .Profiler_accel = 20.000f  ,
      .Profiler_decel = 20.000f ,
      .SpeedProfileAcceleration= 60.0f ,
      .HomingSpeed = 0.1f ,
      .HomingExitUserPos = 0.01f ,
      .HomingDirection = EHM_HomingReverse ,
      .HomingMethod    = EHM_Immediate ,
      .HomingSwInUse   = EHM_HomingSwitchD0 ,
      .UserPosOnHomingFW = 0 ,
      .UserPosOnHomingRev = 0 ,
      .HighDeadBandThold = 0 ,
      .LowDeadBandThold = 0 ,
      .HiAutoMotorOffThold = 0.01 ,
      .LowAutoMotorOffThold = 0.005 ,
      .UseCase = (PDO3_CONFIG_WHEEL | UC_POS_MODULO | UC_SUPPORT_BRAKE | US_SUPPORT_AUTOBRAKE),
      .PhiM  = 0.130f,
      .Lq0 = 5.0e-4f ,
      .LqCorner2 =  0,
      .Ld0 = 5.0e-4f ,
      .LdSlope = 0 ,
      .R  =0.13f ,
      .KiTheta = 7.8026e+03f,
      .KpTheta = 149.0188f,
      .KiFlux = 10.0f,
      .KpFlux = 100.0f,
      .CyclesForConvergenceApproval = 3.0f,
      .ObserverConvergenceToleranceFrac = 0.22f,
      .MaximumSteadyStateFieldRetard = 0.5f,
      .MinimumSteadyStateFieldRetard = -0.2f,
      .FOMTakingStartSpeed = 5.0f,
      .OpenLoopAcceleration = 1.0f,
      .FOMConvergenceTimeout = 8.0f,
      .OmegaCommutationLoss = 3.0f,
      .WorkAcceleration = 3.0f,
      .WorkSpeed = 6.0f,
      .InitiallStabilizationTime = 3.0f ,
      .DCurrentMaxDiDt = 200.0f
     } , // PROJ_TYPE_ZOOZ_S


    };
    const short unsigned nProjSpecificCtl = sizeof(ProjSpecificCtl) / sizeof( struct CProjSpecificCtl) ;
#else
    extern const struct  CProjSpecificCtl ProjSpecificCtl[] ;
    extern const short unsigned nProjSpecificCtl ;
#endif

#endif /* APPLICATION_PROJCONTROLPARS_H_ */
