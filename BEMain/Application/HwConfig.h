/*
 * HwConfig.h
 *
 *  Created on: Aug 12, 2023
 *      Author: yahali
 */

#ifndef APPLICATION_HWCONFIG_H_
#define APPLICATION_HWCONFIG_H_


#define INTERFACECARD 99
#define NECKCARD 100
#define WHEELCARD 101



// Modes
enum E_LoopClosureMode
{
    E_LC_Voltage_Mode = 0 ,
    E_LC_OpenLoopField_Mode = 1 ,
    E_LC_Torque_Mode = 2 ,
    E_LC_Speed_Mode = 3 ,
    E_LC_Pos_Mode = 4 ,
    E_LC_Dual_Pos_Mode = 5,
    E_LC_EXTDual_Pos_Mode = 6
} ;



    #define PROJ_TYPE 0x9300UL
    #define BootCanId  38

    //#define ON_BOARD_POT
    #define ON_BOARD_BRAKE
    //#define ON_BOARD_GYRO
    #define ON_BOARD_ENCODER
    #define ON_BOARD_HALL
    #define ON_BOARD_CAN
    #define PWM_SYNCSEL 1
    #define PWM_A_BASE EPWM2_BASE
    #define PWM_B_BASE EPWM3_BASE
    #define PWM_C_BASE EPWM4_BASE

    #define PWM_PACER_BASE EPWM1_BASE
    #define CUR_SAMP_PACER_MULT 1
    #define DEAD_TIME_USEC 0.28f



#ifdef ON_BOARD_ENCODER
#define ENCODER_BASE EQEP1_BASE
#endif

#define ADC_READ_CUR1  (4096-HWREGH(ADCARESULT_BASE+ADC_O_RESULT0))
#define ADC_READ_CUR2  (4096-HWREGH(ADCBRESULT_BASE+ADC_O_RESULT0))
#define ADC_READ_CUR3  (4096-HWREGH(ADCCRESULT_BASE+ADC_O_RESULT0))

#define CMPSS_VBUS_BASE   CMPSS2_BASE
#define CMPSS_BUSCUR_BASE CMPSS3_BASE

#define VB_CMPHP_MUX 1
#define VB_CMPLP_MUX 1
#define ISC_CMPHP_MUX 2
#define ISC_CMPLP_MUX 2

#define VDC_2_BIT_VOLTS_R1 0.02498f
#define VDC_2_BIT_VOLTS_R2 0.0185302f


#define ASYSCTL_CMPHPMUX_SELECT_VB ASYSCTL_CMPHPMUX_SELECT_2
#define ASYSCTL_CMPLPMUX_SELECT_VB ASYSCTL_CMPLPMUX_SELECT_2
#define ASYSCTL_CMPHPMUX_SELECT_ISC ASYSCTL_CMPHPMUX_SELECT_3
#define ASYSCTL_CMPLPMUX_SELECT_ISC ASYSCTL_CMPLPMUX_SELECT_3

#define FSI_TAG_FOR_WHEEL 1
#define FSI_TAG_FOR_STEER 2


#define VOLT_2_ADC (4096.0f/3.3f)
#define SC_DC_CMP_VOLTS 2.75f // With 40mV/A at input it is about 40Amp
#define SC_UNDERVOLTAGE_VOLTS 19.0f
#define ABS_OVERVOLTAGE_VOLTS 60.0f

#define PHASE_OVERCURRENT_AMP 35

#define TRUE 1
#define FALSE 0



#define HALL_BAD_VALUE 0xffff

/*
struct CProjSpecificData
{
    float ProjSpecificDataRevision  ;
    float FullAdcRangeCurrent ;  // !< Current when ADC reads 4096
    float EncoderCountsFullRev ; // !< #encoder counts in full revolution
    float Rev2Pos ; // !< 1/gear ratio, multiplier of motor revolutions to get output position
    float KiCur ; // !< Kp for current control
    float KpCur ; // !< Ki for current control
    float HallAngleOffset ;      // !< Per unit offset of the Hall sensor
    float MaxCurCmd          ;  // Maximum current command per project
    float PhaseOverCurrent ;    // !< Phase over-current for exception
    float DcShortCitcuitTripVolts ;    // !< DC Over current comparison threshold
    float MaxCurCmdDdt ; // Maximum current command slope
    float CurrentFilterBWHz ; // Bandwidth (Hz) of current prefilter
    float BrakeReleaseVolts ; // Volts for releasing the brake, or 0 if brake is not in use
    float Pot1RatRad        ; // Potentiometer ratio to radians, Pot1
    float Pot2RatRad        ; // Potentiometer ratio to radians, Pot2
    float Pot1CenterRat        ; // Potentiometer ratio at position 0, Pot1
    float Pot2CenterRat        ; // Potentiometer ratio at position 0, Pot1
    short nPolePairs ;           // !< Number of motor pole pairs
    short InvertEncoder ;        // !< Non-zero to invert encoder reading direction
    short HallVal0 ;             // !< Hall number associated to reading 0 (HALL_BAD_VALUE or error)
    short HallVal1 ;             // !< Hall number associated to reading 1
    short HallVal2 ;             // !< Hall number associated to reading 2
    short HallVal3 ;             // !< Hall number associated to reading 3
    short HallVal4 ;             // !< Hall number associated to reading 4
    short HallVal5 ;             // !< Hall number associated to reading 5
    short HallVal6 ;             // !< Hall number associated to reading 6
    short HallVal7 ;             // !< Hall number associated to reading 7 (HALL_BAD_VALUE or error)
    short ProjIndex ;       // !< Index for project
    short CanId     ;       // !< CAN ID for project
};
*/




// Generic defaults, to be over-ridden
#define N_POLE_PAIRS 4

#define FULL_ADC_RANGE_CURRENT_R1 44
#define FULL_ADC_RANGE_CURRENT_R2 44
#define FULL_ADC_RANGE_WH_CURRENT_R2 95.4800f
#define STEERING_CUR_ADC_RANGE 10.2852f

#define FULL_ADC_RANGE_CURRENT_NECK 32.19f

#define HALL_VAL_1 3
#define HALL_VAL_2 1
#define HALL_VAL_3 2
#define HALL_VAL_4 5
#define HALL_VAL_5 4
#define HALL_VAL_6 0

#define ENC_COUNTS_PER_REV 1440

#define HALL_SENSORS_OFFSET 0.0f

// Old wheels , transmission ratio 40:44 , new is 28:44 (difference : 1.571 factor)
#ifdef OLD_WHEELS
{.ProjIndex = 1 ,// PROJ_TYPE_WHEEL_R
 .ProjSpecificDataRevision = HwConfigRevision,
    .FullAdcRangeCurrent = FULL_ADC_RANGE_WH_CURRENT_R2 , .EncoderCountsFullRev = 65536 ,  .Rev2Pos = 0.6559f , .HallAngleOffset = 0 , .nPolePairs=5, .InvertEncoder=1 ,
    .KpCur = 3.0f , .KiCur = 8000 , .PhaseOverCurrent = 35 , .DcShortCitcuitTripVolts = 2.7f, .MaxCurCmd = 30.0f ,
    .MaxCurCmdDdt = 9000.0f , .CurrentFilterBWHz = 8000.0f ,
   .HallVal0 = HALL_BAD_VALUE , .HallVal1 = 2 , .HallVal2 = 0 , .HallVal3 = 1 , .HallVal4 = 4 , .HallVal5 = 3 , .HallVal6 = 5  , .HallVal7 = HALL_BAD_VALUE,
   .BrakeReleaseVolts = 23.0f,
   .Pot1RatRad  = 3.1415926f  ,
   .Pot2RatRad  = 3.1415926f  ,
   .Pot1CenterRat = 0.5f,
   .Pot2CenterRat = 0.5f,
   .I2tCurLevel  = 24.0f ,
   .I2tCurTime   = 24.0f ,
   .CurrentCommandDir = 1.0f ,
   .CanId = 22
} ,

{.ProjIndex = 3 ,// PROJ_TYPE_WHEEL_L
  .ProjSpecificDataRevision = HwConfigRevision,
 .FullAdcRangeCurrent = FULL_ADC_RANGE_WH_CURRENT_R2 , .EncoderCountsFullRev = 65536 ,  .Rev2Pos = 0.6559f , .HallAngleOffset = 0 , .nPolePairs=5, .InvertEncoder=1 ,
     .KpCur = 3.0f , .KiCur = 8000 , .PhaseOverCurrent = 35 , .DcShortCitcuitTripVolts = 2.7f, .MaxCurCmd = 30.0f ,
     .MaxCurCmdDdt = 9000.0f , .CurrentFilterBWHz = 8000.0f ,
    .HallVal0 = HALL_BAD_VALUE , .HallVal1 = 2 , .HallVal2 = 0 , .HallVal3 = 1 , .HallVal4 = 4 , .HallVal5 = 3 , .HallVal6 = 5  , .HallVal7 = HALL_BAD_VALUE,
    .BrakeReleaseVolts = 23.0f,
    .Pot1RatRad  = 3.1415926f  ,
    .Pot2RatRad  = 3.1415926f  ,
    .Pot1CenterRat = 0.5f,
    .Pot2CenterRat = 0.5f,
    .I2tCurLevel  = 24.0f,
    .I2tCurTime   = 24.0f ,
    .CurrentCommandDir = 1.0f ,
    .CanId = 12
 } ,
#endif

#ifdef NEW_WHEELS
      {.ProjIndex = 1 ,// PROJ_TYPE_WHEEL_R
       .ProjSpecificDataRevision = HwConfigRevision,
          .FullAdcRangeCurrent = FULL_ADC_RANGE_WH_CURRENT_R2 , .EncoderCountsFullRev = 65536 ,  .Rev2Pos = 0.4174f  , .HallAngleOffset = 0 , .nPolePairs=5, .InvertEncoder=1 ,
          .KpCur = 3.0f , .KiCur = 8000 , .PhaseOverCurrent = 35 , .DcShortCitcuitTripVolts = 2.7f, .MaxCurCmd = 30.0f ,
          .MaxCurCmdDdt = 9000.0f , .CurrentFilterBWHz = 8000.0f ,
         .HallVal0 = HALL_BAD_VALUE , .HallVal1 = 2 , .HallVal2 = 0 , .HallVal3 = 1 , .HallVal4 = 4 , .HallVal5 = 3 , .HallVal6 = 5  , .HallVal7 = HALL_BAD_VALUE,
         .BrakeReleaseVolts = 23.0f,
         .Pot1RatRad  = 3.1415926f  ,
         .Pot2RatRad  = 3.1415926f  ,
         .Pot1CenterRat = 0.5f,
         .Pot2CenterRat = 0.5f,
         .I2tCurLevel  = 24.0f ,
         .I2tCurTime   = 24.0f ,
         .CurrentCommandDir = 1.0f ,
         .CanId = 22
      } ,

      {.ProjIndex = 3 ,// PROJ_TYPE_WHEEL_L
        .ProjSpecificDataRevision = HwConfigRevision,
       .FullAdcRangeCurrent = FULL_ADC_RANGE_WH_CURRENT_R2 , .EncoderCountsFullRev = 65536 ,  .Rev2Pos = 0.4174f  , .HallAngleOffset = 0 , .nPolePairs=5, .InvertEncoder=1 ,
           .KpCur = 3.0f , .KiCur = 8000 , .PhaseOverCurrent = 35 , .DcShortCitcuitTripVolts = 2.7f, .MaxCurCmd = 30.0f ,
           .MaxCurCmdDdt = 9000.0f , .CurrentFilterBWHz = 8000.0f ,
          .HallVal0 = HALL_BAD_VALUE , .HallVal1 = 2 , .HallVal2 = 0 , .HallVal3 = 1 , .HallVal4 = 4 , .HallVal5 = 3 , .HallVal6 = 5  , .HallVal7 = HALL_BAD_VALUE,
          .BrakeReleaseVolts = 23.0f,
          .Pot1RatRad  = 3.1415926f  ,
          .Pot2RatRad  = 3.1415926f  ,
          .Pot1CenterRat = 0.5f,
          .Pot2CenterRat = 0.5f,
          .I2tCurLevel  = 24.0f,
          .I2tCurTime   = 24.0f ,
          .CurrentCommandDir = 1.0f ,
          .CanId = 12
       } ,
     } ,
#endif

#define NEW_WHEEL_GEAR_RATIO
#ifdef NEW_WHEEL_GEAR_RATIO
#define WHEEL_REV2POS  0.4157f // was 0.4174
#else
#define WHEEL_REV2POS  0.6559f
#endif

#define INVERT_ENCODER TRUE
// End generic defaults

#ifdef CONFIG_OWNER
// If you add new project: Dont forget to update also ProjSpecificCtl[Proj]

    const struct CProjSpecificData ProjSpecificData[] =
    {
     {.ProjIndex = 0 ,// PROJ_UNDEFINED
      .ProjSpecificDataRevision = HwConfigRevision,
      .FullAdcRangeCurrent = FULL_ADC_RANGE_CURRENT_R2 , .EncoderCountsFullRev = ENC_COUNTS_PER_REV , .Rev2Pos = 0.05f , .HallAngleOffset = HALL_SENSORS_OFFSET , .nPolePairs=N_POLE_PAIRS, .InvertEncoder=-1.0f ,
          .KpCur = 1.0f , .KiCur = 4000 , .PhaseOverCurrent = PHASE_OVERCURRENT_AMP , .DcShortCitcuitTripVolts = SC_DC_CMP_VOLTS, .MaxCurCmd = 20 ,
          .MaxCurCmdDdt = 8000.0f , .CurrentFilterBWHz = 2500.0f ,
         .HallVal0 = HALL_BAD_VALUE , .HallVal1 = HALL_VAL_1 , .HallVal2 = HALL_VAL_2 , .HallVal3 = HALL_VAL_3 , .HallVal4 = HALL_VAL_4 , .HallVal5 = HALL_VAL_5 , .HallVal6 = HALL_VAL_6  , .HallVal7 = HALL_BAD_VALUE,
         .BrakeReleaseVolts = 0,
         .Pot1RatRad  = 3.1415926f  ,
         .Pot2RatRad  = 3.1415926f  ,
         .Pot1CenterRat = 0.5f,
         .Pot2CenterRat = 0.5f,
         .I2tCurLevel  = 10.0f ,
         .I2tCurTime   = 24.0f ,
         .CurrentCommandDir = 1.0f ,
         .CanId = 1
     } ,


      {.ProjIndex = 1 ,// PROJ_TYPE_WHEEL_R
       .ProjSpecificDataRevision = HwConfigRevision,
          .FullAdcRangeCurrent = FULL_ADC_RANGE_WH_CURRENT_R2 , .EncoderCountsFullRev = 65536 ,  .Rev2Pos = WHEEL_REV2POS  , .HallAngleOffset = 0 , .nPolePairs=5, .InvertEncoder=1 ,
          .KpCur = 3.0f , .KiCur = 8000 , .PhaseOverCurrent = 35 , .DcShortCitcuitTripVolts = 2.7f, .MaxCurCmd = 30.0f ,
          .MaxCurCmdDdt = 9000.0f , .CurrentFilterBWHz = 8000.0f ,
         .HallVal0 = HALL_BAD_VALUE , .HallVal1 = 2 , .HallVal2 = 0 , .HallVal3 = 1 , .HallVal4 = 4 , .HallVal5 = 3 , .HallVal6 = 5  , .HallVal7 = HALL_BAD_VALUE,
         .BrakeReleaseVolts = 23.0f,
         .Pot1RatRad  = 3.1415926f  ,
         .Pot2RatRad  = 3.1415926f  ,
         .Pot1CenterRat = 0.5f,
         .Pot2CenterRat = 0.5f,
         .I2tCurLevel  = 24.0f ,
         .I2tCurTime   = 24.0f ,
         .CurrentCommandDir = 1.0f ,
         .CanId = 22
      } ,


     {.ProjIndex = 2 ,// PROJ_TYPE_STEERING_R
      .ProjSpecificDataRevision = HwConfigRevision,
          .FullAdcRangeCurrent = STEERING_CUR_ADC_RANGE , .EncoderCountsFullRev = 65536 ,  .Rev2Pos = 0.005561374054295f , .HallAngleOffset = 0.044214f , .nPolePairs=2, .InvertEncoder=1 ,
          .KpCur = 3.0f , .KiCur = 14000.0f , .PhaseOverCurrent = 15 ,.DcShortCitcuitTripVolts = 2.7f, .MaxCurCmd = 5.0f ,
          .MaxCurCmdDdt = 8000.0f , .CurrentFilterBWHz = 2500.0f ,
         .HallVal0 = HALL_BAD_VALUE , .HallVal1 = 1 , .HallVal2 = 5 , .HallVal3 = 0 , .HallVal4 = 3 , .HallVal5 = 2 , .HallVal6 = 4  , .HallVal7 = HALL_BAD_VALUE,
         .BrakeReleaseVolts = 0 ,
         .Pot1RatRad  = 3.1415926f  ,
         .Pot2RatRad  = 3.1415926f  ,
         .Pot1CenterRat = 0.5f,
         .Pot2CenterRat = 0.5f,
         .I2tCurLevel  = 5.0f ,
         .I2tCurTime   = 24.0f ,
        .CurrentCommandDir = 1.0f ,
         .CanId = 21
     } ,


     {.ProjIndex = 3 ,// PROJ_TYPE_WHEEL_L
      .ProjSpecificDataRevision = HwConfigRevision,
     .FullAdcRangeCurrent = FULL_ADC_RANGE_WH_CURRENT_R2 , .EncoderCountsFullRev = 65536 ,  .Rev2Pos = WHEEL_REV2POS  , .HallAngleOffset = 0 , .nPolePairs=5, .InvertEncoder=1 ,
         .KpCur = 3.0f , .KiCur = 8000 , .PhaseOverCurrent = 35 , .DcShortCitcuitTripVolts = 2.7f, .MaxCurCmd = 30.0f ,
         .MaxCurCmdDdt = 9000.0f , .CurrentFilterBWHz = 8000.0f ,
        .HallVal0 = HALL_BAD_VALUE , .HallVal1 = 2 , .HallVal2 = 0 , .HallVal3 = 1 , .HallVal4 = 4 , .HallVal5 = 3 , .HallVal6 = 5  , .HallVal7 = HALL_BAD_VALUE,
        .BrakeReleaseVolts = 23.0f,
        .Pot1RatRad  = 3.1415926f  ,
        .Pot2RatRad  = 3.1415926f  ,
        .Pot1CenterRat = 0.5f,
        .Pot2CenterRat = 0.5f,
        .I2tCurLevel  = 24.0f,
        .I2tCurTime   = 24.0f ,
        .CurrentCommandDir = 1.0f ,
        .CanId = 12
     } ,


    {.ProjIndex = 4 ,// PROJ_TYPE_STEERING_L
     .ProjSpecificDataRevision = HwConfigRevision,
         .FullAdcRangeCurrent = STEERING_CUR_ADC_RANGE , .EncoderCountsFullRev = 65536 ,  .Rev2Pos = 0.005561374054295f , .HallAngleOffset = 0.044214f , .nPolePairs=2, .InvertEncoder=1 ,
         .KpCur = 3.0f , .KiCur = 14000.0f , .PhaseOverCurrent = 15 ,.DcShortCitcuitTripVolts = 2.7f, .MaxCurCmd = 5.0f ,
         .MaxCurCmdDdt = 8000.0f , .CurrentFilterBWHz = 2500.0f ,
        .HallVal0 = HALL_BAD_VALUE , .HallVal1 = 1 , .HallVal2 = 5 , .HallVal3 = 0 , .HallVal4 = 3 , .HallVal5 = 2 , .HallVal6 = 4  , .HallVal7 = HALL_BAD_VALUE,
        .BrakeReleaseVolts = 0 ,
        .Pot1RatRad  = 3.1415926f  ,
        .Pot2RatRad  = 3.1415926f  ,
        .Pot1CenterRat = 0.5f,
        .Pot2CenterRat = 0.5f,
        .I2tCurLevel  = 5.0f ,
        .I2tCurTime   = 24.0f ,
        .CurrentCommandDir = 1.0f ,
        .CanId = 11
    } ,

    // The encoder and the motor are 1:1 ,  Cycloidal gear is 1:35 , spur#1 (internal) is 62/18  , spur#2 (external)is 60/18 so total gear is 401.852
    // Rev2Pos is 2 * pi / 401.852
    {.ProjIndex = 5 , // PROJ_TYPE_NECK
     .ProjSpecificDataRevision = HwConfigRevision,
          .FullAdcRangeCurrent = 44 , .EncoderCountsFullRev = 1440 ,  .Rev2Pos = 0.015635570576181f , .HallAngleOffset = 0 , .nPolePairs=4, .InvertEncoder=1 ,
          .KpCur = 1.5f , .KiCur = 6000 , .PhaseOverCurrent = 25 , .DcShortCitcuitTripVolts = 2.7f, .MaxCurCmd = 12.0f ,
          .MaxCurCmdDdt = 8000.0f , .CurrentFilterBWHz = 2500.0f ,
         .HallVal0 = HALL_BAD_VALUE , .HallVal1 = 3 , .HallVal2 = 1 , .HallVal3 = 2 , .HallVal4 = 5 , .HallVal5 = 4 , .HallVal6 = 0  , .HallVal7 = HALL_BAD_VALUE,
         .BrakeReleaseVolts = 24.5f,
         .Pot1RatRad  = 8.3776f  ,
         .Pot2RatRad  = 7.8540f  ,
         .Pot1CenterRat = 0.5f,
         .Pot2CenterRat = 0.5f,
         .I2tCurLevel  = 12.0f ,
         .I2tCurTime   = 24.0f,
         .CurrentCommandDir = 1.0f ,
         .CanId = 30
     } ,

     // Neck old motor with on-gear encoder
     {.ProjIndex = 6 ,// PROJ_TYPE_NECK2
      .ProjSpecificDataRevision = HwConfigRevision,
          .FullAdcRangeCurrent = 44 , .EncoderCountsFullRev = 1440 ,  .Rev2Pos = 0.05 , .HallAngleOffset = 0 , .nPolePairs=4, .InvertEncoder=1 ,
          .KpCur = 4.0f , .KiCur = 12000 , .PhaseOverCurrent = 25 , .DcShortCitcuitTripVolts = 2.7f, .MaxCurCmd = 15.0f ,
          .MaxCurCmdDdt = 8000.0f , .CurrentFilterBWHz = 2500.0f ,
         .HallVal0 = HALL_BAD_VALUE , .HallVal1 = 2 , .HallVal2 = 0 , .HallVal3 = 1 , .HallVal4 = 4 , .HallVal5 = 3 , .HallVal6 = 5  , .HallVal7 = HALL_BAD_VALUE,
         .BrakeReleaseVolts = 0,
         .Pot1RatRad  = 3.1415926f  ,
         .Pot2RatRad  = 3.1415926f  ,
         .Pot1CenterRat = 0.5f,
         .Pot2CenterRat = 0.5f,
         .I2tCurLevel  = 12.0f ,
         .I2tCurTime   = 24.0f ,
        .CurrentCommandDir = 1.0f ,
         .CanId = 30
     } ,

     // Neck old motor with on-board encoder
     {.ProjIndex = 7 ,// PROJ_TYPE_NECK3
      .ProjSpecificDataRevision = HwConfigRevision,
          .FullAdcRangeCurrent = 44 , .EncoderCountsFullRev = 10000 ,  .Rev2Pos = 0.05 ,  .HallAngleOffset = 0 , .nPolePairs=4, .InvertEncoder=0 ,
          .MaxCurCmdDdt = 8000.0f , .CurrentFilterBWHz = 2500.0f ,
          .KpCur = 4.0f , .KiCur = 12000 , .PhaseOverCurrent = 25 , .DcShortCitcuitTripVolts = 2.7f, .MaxCurCmd = 10.0f ,
         .HallVal0 = HALL_BAD_VALUE , .HallVal1 = 2 , .HallVal2 = 0 , .HallVal3 = 1 , .HallVal4 = 4 , .HallVal5 = 3 , .HallVal6 = 5  , .HallVal7 = HALL_BAD_VALUE,
         .BrakeReleaseVolts = 0,
         .Pot1RatRad  = 3.1415926f  ,
         .Pot2RatRad  = 3.1415926f  ,
         .Pot1CenterRat = 0.5f,
         .Pot2CenterRat = 0.5f,
         .I2tCurLevel  = 10.0f ,
         .I2tCurTime   = 24.0f ,
         .CurrentCommandDir = 1.0f ,
         .CanId = 30
     } ,

    // Tray rotation motor 42BLS80-2166-MBM-CD 42JX49G1022B
    {.ProjIndex = 8 , // PROJ_TYPE_TRAY_ROTATOR
     .ProjSpecificDataRevision = HwConfigRevision,
         .FullAdcRangeCurrent = FULL_ADC_RANGE_CURRENT_NECK , .EncoderCountsFullRev = 4000 ,  .Rev2Pos = 0.015810644f,  .HallAngleOffset = 0 , .nPolePairs=4, .InvertEncoder=0 ,
         .MaxCurCmdDdt = 18000.0f , .CurrentFilterBWHz = 7500.0f ,
         .KpCur = 3.3f , .KiCur = 13000 , .PhaseOverCurrent = 25 , .DcShortCitcuitTripVolts = 2.7f, .MaxCurCmd = 12.0f ,
        .HallVal0 = HALL_BAD_VALUE , .HallVal1 = 1 , .HallVal2 = 3 , .HallVal3 = 2 , .HallVal4 = 5 , .HallVal5 = 0 , .HallVal6 = 4  , .HallVal7 = HALL_BAD_VALUE,
        .BrakeReleaseVolts = 16.5f,
        .Pot1RatRad  = -3.1415926f  ,
        .Pot2RatRad  = 3.1415926f  ,
        .Pot1CenterRat = 0.5f,
        .Pot2CenterRat = 0.5f,
        .I2tCurLevel  = 12.0f ,
        .I2tCurTime   = 24.0f ,
        .CurrentCommandDir = 1.0f ,
        .CanId = 34
    },   // PROJ_TYPE_TRAY_ROTATOR

     // Tray rotation motor 42BLS80-2166-MBM-CD 42JX49G1022B
     {.ProjIndex = 9 , // PROJ_TYPE_TRAY_SHIFTER
      .ProjSpecificDataRevision = HwConfigRevision,
          .FullAdcRangeCurrent = FULL_ADC_RANGE_CURRENT_NECK , .EncoderCountsFullRev = 8000 ,  .Rev2Pos = 0.0095484f ,  .HallAngleOffset = 0 , .nPolePairs=4, .InvertEncoder=0 ,
          .MaxCurCmdDdt = 18000.0f , .CurrentFilterBWHz = 4500.0f ,
          .KpCur = 3.3f , .KiCur = 13000 , .PhaseOverCurrent = 10 , .DcShortCitcuitTripVolts = 2.7f, .MaxCurCmd = 4.5f ,
         .HallVal0 = HALL_BAD_VALUE , .HallVal1 = 5 , .HallVal2 = 3 , .HallVal3 = 4 , .HallVal4 = 1 , .HallVal5 = 0 , .HallVal6 = 2  , .HallVal7 = HALL_BAD_VALUE,
         .BrakeReleaseVolts = 0.0f,
         .Pot1RatRad  = 3.1415926f  ,
         .Pot2RatRad  = 3.1415926f  ,
         .Pot1CenterRat = 0.5f,
         .Pot2CenterRat = 0.5f,
         .I2tCurLevel  = 4.5f ,
         .I2tCurTime   = 24.0f ,
         .CurrentCommandDir = 1.0f ,
         .CanId = 36
     } ,  // PROJ_TYPE_TRAY_SHIFTER

     // Tape motor of tape arm 42BLS80-2166-MBM-CD 42JX49G1022B
     {.ProjIndex = 10 , // PROJ_TYPE_TAPE_MOTOR
      .ProjSpecificDataRevision = HwConfigRevision,
          .FullAdcRangeCurrent = FULL_ADC_RANGE_CURRENT_NECK , .EncoderCountsFullRev = 4000 ,  .Rev2Pos = 0.00667 ,  .HallAngleOffset = 0 , .nPolePairs=4, .InvertEncoder=0 ,
          .MaxCurCmdDdt = 18000.0f , .CurrentFilterBWHz = 7500.0f ,
          .KpCur = 3.3f , .KiCur = 13000 , .PhaseOverCurrent = 25 , .DcShortCitcuitTripVolts = 2.7f, .MaxCurCmd = 10.0f ,
         .HallVal0 = HALL_BAD_VALUE , .HallVal1 = 1 , .HallVal2 = 3 , .HallVal3 = 2 , .HallVal4 = 5 , .HallVal5 = 0 , .HallVal6 = 4  , .HallVal7 = HALL_BAD_VALUE,
         .BrakeReleaseVolts = 16.5f,
         .Pot1RatRad  = 3.1415926f  ,
         .Pot2RatRad  = 3.1415926f  ,
         .Pot1CenterRat = 0.5f,
         .Pot2CenterRat = 0.5f,
         .I2tCurLevel  = 10.0f ,
         .I2tCurTime   = 24.0f ,
         .CurrentCommandDir = 1.0f ,
         .CanId = 35
     }
    };

    const unsigned short nProjSpecificData = sizeof(ProjSpecificData) / sizeof(struct CProjSpecificData) ;


    #else
    extern const struct  CProjSpecificData ProjSpecificData[] ;
    extern const unsigned short nProjSpecificData ;
#endif



#ifdef SLAVE_DRIVER
#define FSI_FLUSH_START_TIME (CPU_CLK_MHZ*6)
#define FSI_FLUSH_TIME (CPU_CLK_MHZ*2)
#define FSI_TX_TIME (CPU_CLK_MHZ*18-FSI_FLUSH_TIME-FSI_FLUSH_START_TIME)

// The FSI clock is 60M so this is 6M
#define FSI_BAUD_DIVIDER 10
#endif

#endif // APPLICATION_HWCONFIG_H_
