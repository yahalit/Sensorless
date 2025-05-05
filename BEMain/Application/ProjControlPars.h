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
      .UseCase = 0
     } , // PROJ_UNDEFINED

     {
      .ProjIndex = PROJ_TYPE_WHEEL_R ,// PROJ_TYPE_WHEEL_R
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
      .UseCase = (PDO3_CONFIG_WHEEL | UC_POS_MODULO | UC_SUPPORT_BRAKE | US_SUPPORT_AUTOBRAKE)
     } , // PROJ_NAME_WHEEL

     {
      .ProjIndex = PROJ_TYPE_STEERING_R ,
      .qf0PBw   = 400.0f,
      .qf0PXi   = 0.55f,
      .qf0ZBw   = 1.0e5f,
      .qf0ZXi   = 1.0f ,
      .qf1PBw   = 600.0f,
      .qf1PXi   = 0.55f,
      .qf1ZBw   = 1.0e5f,
      .qf1ZXi   = 1.0f,
      .qf0Cfg   = 17 ,
      .qf1Cfg   = 17 ,
      .SpeedKp   = 50.0f ,
      .SpeedKi   = 8000.0f ,
      .PosKp   = 58.03392625f,
      .MaxAcc   = 20.0f,
      .MinPositionCmd = -2.0f, // Minimum position command
      .MaxPositionCmd = 2.0f , // Maximum position command
      .MinPositionFb = -2.15f,  // Minimum position feedback
      .MaxPositionFb = 2.15f ,  // Maximum position feedback
      .MaxSpeedCmd   = 1.0f ,
      .OuterMergeCst = 0.1f ,
      .MaxSupportedClosure = E_LC_Dual_Pos_Mode,
      .MotionConvergeWindow = 0.002f ,
      .Profiler_vmax = 1.0f,
      .Profiler_accel = 20.0f  ,
      .Profiler_decel = 20.0f ,
      .SpeedProfileAcceleration= 20.0f ,
      .HomingSpeed = 0.1f ,
      .HomingExitUserPos = 0.01f ,
      .HomingDirection = EHM_HomingReverse ,
      .HomingMethod    = EHM_Immediate ,
      .HomingSwInUse   = EHM_HomingSwitchD0 ,
      .UserPosOnHomingFW = 0 ,
      .UserPosOnHomingRev = 0 ,
      .HighDeadBandThold = 6.0e-3 ,
      .LowDeadBandThold = 3.0e-3 ,
      .HiAutoMotorOffThold = 0.009 ,
      .LowAutoMotorOffThold = 0.007 ,
      .UseCase = (UC_USE_POT1 | US_SUPPORT_HOMING | PDO3_CONFIG_ROTARY_POT | US_LIMIT_POS_FB | US_SUPPORT_AUTOBRAKE)
     } , // PROJ_NAME_STEER_R

     {
      .ProjIndex = PROJ_TYPE_WHEEL_L ,
      .qf0PBw   = 400.0f,
      .qf0PXi   = 0.55f,
      .qf0ZBw   = 1.0e5f,
      .qf0ZXi   = 1.0f ,
      .qf1PBw   = 600.0f,
      .qf1PXi   = 0.55f,
      .qf1ZBw   = 1.0e5f,
      .qf1ZXi   = 1.0f,
      .qf0Cfg   = 17 ,
      .qf1Cfg   = 17 ,
      .SpeedKp   = 4.00f ,
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
      .HomingSpeed = 0.1f,
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
      .UseCase = (PDO3_CONFIG_WHEEL | UC_POS_MODULO |UC_SUPPORT_BRAKE | US_SUPPORT_AUTOBRAKE)
     } , // PROJ_NAME_WHEEL_L

     {
      .ProjIndex = PROJ_TYPE_STEERING_L ,
      .qf0PBw   = 400.0f,
      .qf0PXi   = 0.55f,
      .qf0ZBw   = 1.0e5f,
      .qf0ZXi   = 1.0f ,
      .qf1PBw   = 600.0f,
      .qf1PXi   = 0.55f,
      .qf1ZBw   = 1.0e5f,
      .qf1ZXi   = 1.0f,
      .qf0Cfg   = 17 ,
      .qf1Cfg   = 17 ,
      .SpeedKp   = 50.0f ,
      .SpeedKi   = 8000.0f ,
      .PosKp   = 58.03392625f,
      .MaxAcc   = 20.0f,
      .MinPositionCmd = -2.0f, // Minimum position command
      .MaxPositionCmd = 2.0f , // Maximum position command
      .MinPositionFb = -2.15f,  // Minimum position feedback
      .MaxPositionFb = 2.15f ,  // Maximum position feedback
      .MaxSpeedCmd   = 1.0f ,
      .OuterMergeCst = 0.1f ,
      .MaxSupportedClosure = E_LC_Dual_Pos_Mode,
      .MotionConvergeWindow = 0.002f ,
      .Profiler_vmax = 1.0f,
      .Profiler_accel = 20.0f  ,
      .Profiler_decel = 20.0f ,
      .SpeedProfileAcceleration= 20.0f ,
     .HomingSpeed = 0.1f ,
     .HomingExitUserPos = 0.01f ,
      .HomingDirection = EHM_HomingReverse ,
      .HomingMethod    = EHM_Immediate ,
      .HomingSwInUse   = EHM_HomingSwitchD0 ,
      .UserPosOnHomingFW = 0 ,
      .UserPosOnHomingRev = 0 ,
      .HighDeadBandThold = 6.0e-3 ,
      .LowDeadBandThold = 3.0e-3 ,
      .HiAutoMotorOffThold = 0.009 ,
      .LowAutoMotorOffThold = 0.007 ,
      .UseCase = (UC_USE_POT1 | US_SUPPORT_HOMING | PDO3_CONFIG_ROTARY_POT |US_LIMIT_POS_FB | US_SUPPORT_AUTOBRAKE)
     } , // PROJ_NAME_STEER_L

     {
      .ProjIndex = PROJ_TYPE_NECK ,
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
      .SpeedKp   = 18.06f ,
      .SpeedKi   = 1010.3f ,
      .PosKp   = 5.0f,
      .MaxAcc   = 10.0f,
      .MinPositionCmd = -1.65f, // Minimum position command
      .MaxPositionCmd = 1.65f , // Maximum position command
      .MinPositionFb = -1.8,  // Minimum position feedback
      .MaxPositionFb = 1.8f ,  // Maximum position feedback
      .MaxSpeedCmd   = 1.0f ,
      .OuterMergeCst = 0.1f ,
      .MaxSupportedClosure = E_LC_EXTDual_Pos_Mode ,
      .MotionConvergeWindow = 0.01f ,
      .Profiler_vmax = 1.0f,
      .Profiler_accel = 6.0f  ,
      .Profiler_decel = 6.0f ,
      .SpeedProfileAcceleration= 6.0f ,
      .HomingSpeed = 0.1f ,
      .HomingExitUserPos = 0.01f ,
      .HomingDirection = EHM_HomingReverse ,
      .HomingMethod    = EHM_Immediate ,
      .HomingSwInUse   = EHM_HomingSwitchD0 ,
      .UserPosOnHomingFW = 0 ,
      .UserPosOnHomingRev = 0 ,
      .HighDeadBandThold = 0.006 ,
      .LowDeadBandThold = 0.003 ,
      .HiAutoMotorOffThold = 0.009 ,
      .LowAutoMotorOffThold = 0.007 ,
     .UseCase = (UC_USE_POT1|UC_USE_POT2|US_SUPPORT_HOMING | PDO3_CONFIG_2_ROTARY_POT | UC_SUPPORT_BRAKE | US_SUPPORT_AUTOBRAKE)
     } ,  // PROJ_NAME_NECK

     {
      .ProjIndex = PROJ_TYPE_NECK2 ,// PROJ_UNDEFINED
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
      .MaxSupportedClosure = E_LC_Dual_Pos_Mode,
      .MotionConvergeWindow = 0.01f ,
      .Profiler_vmax = 1.0f,
      .Profiler_accel = 20.0f  ,
      .Profiler_decel = 20.0f ,
      .SpeedProfileAcceleration= 20.0f ,
      .HomingSpeed = 0.1f ,
      .HomingExitUserPos = 0.01f ,
      .HomingDirection = EHM_HomingReverse ,
      .HomingMethod    = EHM_Immediate ,
      .HomingSwInUse   = EHM_HomingSwitchD0 ,
      .UserPosOnHomingFW = 0 ,
      .UserPosOnHomingRev = 0 ,
      .HighDeadBandThold = 0 ,
      .LowDeadBandThold = 0 ,
      .HiAutoMotorOffThold = 0.009 ,
      .LowAutoMotorOffThold = 0.007 ,
       .UseCase = (UC_USE_POT1|UC_USE_POT2|US_SUPPORT_HOMING| PDO3_CONFIG_2_ROTARY_POT | UC_SUPPORT_BRAKE)
     },   // PROJ_TYPE_NECK2

     {
      .ProjIndex = PROJ_TYPE_NECK3 ,// PROJ_UNDEFINED
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
      .PosKp   = 24.0f,
      .MaxAcc   = 95.0f,
      .MinPositionCmd = -1.4f, // Minimum position command
      .MaxPositionCmd = 1.4f , // Maximum position command
      .MinPositionFb = -1.48f,  // Minimum position feedback
      .MaxPositionFb = 1.48f ,  // Maximum position feedback
      .MaxSpeedCmd   = 1.0f ,
      .OuterMergeCst = 0.1f ,
      .MaxSupportedClosure = E_LC_Dual_Pos_Mode,
      .MotionConvergeWindow = 0.01f ,
      .Profiler_vmax = 1.0f,
      .Profiler_accel = 20.0f  ,
      .Profiler_decel = 20.0f ,
      .SpeedProfileAcceleration= 20.0f ,
      .HomingSpeed = 0.1f ,
      .HomingExitUserPos = 0.01f ,
      .HomingDirection = EHM_HomingReverse ,
      .HomingMethod    = EHM_Immediate ,
      .HomingSwInUse   = EHM_HomingSwitchD0 ,
      .UserPosOnHomingFW = 0 ,
      .UserPosOnHomingRev = 0 ,
      .HighDeadBandThold = 0 ,
      .LowDeadBandThold = 0 ,
      .HiAutoMotorOffThold = 0.009 ,
      .LowAutoMotorOffThold = 0.007 ,
       .UseCase = (UC_USE_POT1|UC_USE_POT2|US_SUPPORT_HOMING| PDO3_CONFIG_2_ROTARY_POT| UC_SUPPORT_BRAKE)
     },   // PROJ_TYPE_NECK3

     {
      .ProjIndex = PROJ_TYPE_TRAY_ROTATOR ,// PROJ_UNDEFINED
      .qf0PBw   = 250.0f,
      .qf0PXi   = 0.9f,
      .qf0ZBw   = 1.0e5f,
      .qf0ZXi   = 1.0f ,
      .qf1PBw   = 250.0f,
      .qf1PXi   = 0.55f,
      .qf1ZBw   = 1.0e5f,
      .qf1ZXi   = 1.0f,
      .qf0Cfg   = 17 ,
      .qf1Cfg   = 0 ,
      .SpeedKp   = 7.95f ,
      .SpeedKi   = 300.0f ,
      .PosKp   = 5.3f,
      .MaxAcc   = 8.0f,
      .MinPositionCmd = -1.65f, // Minimum position command
      .MaxPositionCmd = 1.65f , // Maximum position command
      .MinPositionFb = -1.85f,  // Minimum position feedback
      .MaxPositionFb = 1.85f ,  // Maximum position feedback
      .MaxSpeedCmd   = 1.0f ,
      .OuterMergeCst = 0.1f , // For merging potentiometer data
      .MaxSupportedClosure = E_LC_Dual_Pos_Mode,
      .MotionConvergeWindow = 0.005f ,
      .Profiler_vmax = 1.0f,
      .Profiler_accel = 5.0f  ,
      .Profiler_decel = 5.0f ,
      .SpeedProfileAcceleration= 5.0f ,
      .HomingSpeed = 0.1f ,
      .HomingExitUserPos = 0.01f ,
      .HomingDirection = EHM_HomingReverse ,
      .HomingMethod    = EHM_Immediate ,
      .HomingSwInUse   = EHM_HomingSwitchD0 ,
      .UserPosOnHomingFW = 0 ,
      .UserPosOnHomingRev = 0 ,
      .HighDeadBandThold = 0 ,
      .LowDeadBandThold = 0 ,
      .HiAutoMotorOffThold = 0.009 ,
      .LowAutoMotorOffThold = 0.007 ,
      .UseCase = (UC_USE_POT1 | US_LIMIT_POS_FB |US_SUPPORT_HOMING| PDO3_CONFIG_ROTARY_POT| UC_SUPPORT_BRAKE | US_SUPPORT_AUTOBRAKE)// (UC_USE_POT1|UC_USE_POT2)
      } ,  //  PROJ_TYPE_TRAY_ROTATOR : Tray rotation motor 42BLS80-2166-MBM-CD 42JX49G1022B

     {
      .ProjIndex = PROJ_TYPE_TRAY_SHIFTER ,
      .qf0PBw   = 200.0f,
      .qf0PXi   = 0.9f,
      .qf0ZBw   = 1.0e5f,
      .qf0ZXi   = 1.0f ,
      .qf1PBw   = 120.0f,
      .qf1PXi   = 0.55f,
      .qf1ZBw   = 1.0e5f,
      .qf1ZXi   = 1.0f,
      .qf0Cfg   = 17 ,
      .qf1Cfg   = 0 ,
      .SpeedKp   = 16.0f ,
      .SpeedKi   = 1200.0f ,
      .PosKp   = 10.0f,
      .MaxAcc   = 40.0f,
      .MinPositionCmd = -1.4f, // Minimum position command
      .MaxPositionCmd = 1.4f , // Maximum position command
      .MinPositionFb = -1.48f,  // Minimum position feedback
      .MaxPositionFb = 1.48f ,  // Maximum position feedback
      .MaxSpeedCmd   = 0.08f ,
      .OuterMergeCst = 0.1f , // For merging potentiometer data
      .MaxSupportedClosure = E_LC_Pos_Mode,
      .MotionConvergeWindow = 0.001f ,
      .Profiler_vmax = 0.08f ,
      .Profiler_accel = 10.0f ,
      .Profiler_decel = 10.0f ,
      .SpeedProfileAcceleration= 10.0f ,
      .HomingSpeed = 0.1f ,
       .HomingExitUserPos = 0.01f ,
      .HomingDirection = EHM_HomingReverse ,
      .HomingMethod    = EHM_CollideLimit ,
      .HomingSwInUse   = EHM_HomingSwitchD0 ,
      .UserPosOnHomingFW = 0.139f,
      .UserPosOnHomingRev = 0 ,
      .HighDeadBandThold = 0 ,
      .LowDeadBandThold = 0 ,
      .HiAutoMotorOffThold = 0.009f ,
      .LowAutoMotorOffThold = 0.007f ,
        .UseCase = (US_SUPPORT_HOMING | PDO3_CONFIG_LINEAR | US_SUPPORT_AUTOBRAKE )  // (UC_USE_POT1|UC_USE_POT2)
     } ,  //  PROJ_TYPE_TRAY_SHIFTER : Tray rotation motor 33ZWN2485(0DZ.3433.005)

     {
      .ProjIndex = PROJ_TYPE_TAPE_MOTOR ,// PROJ_UNDEFINED
      .qf0PBw   = 200.0f,
      .qf0PXi   = 0.9f,
      .qf0ZBw   = 1.0e5f,
      .qf0ZXi   = 1.0f ,
      .qf1PBw   = 130.0f,
      .qf1PXi   = 0.55f,
      .qf1ZBw   = 1.0e5f,
      .qf1ZXi   = 1.0f,
      .qf0Cfg   = 17 ,
      .qf1Cfg   = 0 ,
      .SpeedKp   = 10.0f ,
      .SpeedKi   = 700.0f ,
      .PosKp   = 8.0f,
      .MaxAcc   = 90.0f,
      .MinPositionCmd = -1.4f, // Minimum position command
      .MaxPositionCmd = 1.4f , // Maximum position command
      .MinPositionFb = -1.48f,  // Minimum position feedback
      .MaxPositionFb = 1.48f ,  // Maximum position feedback
      .MaxSpeedCmd   = 0.25f ,
      .OuterMergeCst = 0.1f , // For merging potentiometer data
      .MaxSupportedClosure = E_LC_Pos_Mode,
      .MotionConvergeWindow = 0.003f ,
      .Profiler_vmax = 0.25f,
      .Profiler_accel = 10.0f ,
      .Profiler_decel =10.0f ,
      .SpeedProfileAcceleration= 10.0f ,
      .HomingSpeed = 0.1f ,
      .HomingExitUserPos = 0.01f ,
      .HomingDirection = EHM_HomingReverse ,
      .HomingMethod    = EHM_SwitchLimit ,
      .HomingSwInUse   = EHM_HomingSwitchD1 ,
      .UserPosOnHomingFW = 0 ,
      .UserPosOnHomingRev = 0 ,
      .HighDeadBandThold = 0 ,
      .LowDeadBandThold = 0 ,
      .HiAutoMotorOffThold = 0.009 ,
      .LowAutoMotorOffThold = 0.007 ,
        .UseCase = ( UC_USE_SW1_HM | UC_USE_SW2_HM | US_SUPPORT_HOMING | PDO3_CONFIG_LINEAR| UC_SUPPORT_BRAKE | US_SUPPORT_AUTOBRAKE )
     }   //  PROJ_TYPE_TAPE_MOTOR : Tray rotation motor 42BLS80-2166-MBM-CD 42JX49G1022B


    };
    const short unsigned nProjSpecificCtl = sizeof(ProjSpecificCtl) / sizeof( struct CProjSpecificCtl) ;
#else
    extern const struct  CProjSpecificCtl ProjSpecificCtl[] ;
    extern const short unsigned nProjSpecificCtl ;
#endif

#endif /* APPLICATION_PROJCONTROLPARS_H_ */
