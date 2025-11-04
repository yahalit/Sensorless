/*
 * HwConfig.h
 *
 *  Created on: Aug 12, 2023
 *      Author: yahali
 */

#ifndef APPLICATION_HWCONFIG_H_
#define APPLICATION_HWCONFIG_H_


#define BESENSORLESSCARD 105


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



    #define PROJ_TYPE 0x9700UL
    #define BootCanId  38

    //#define ON_BOARD_TEMPSENSOR_LINEAR
    //#define ON_BOARD_POT
    //#define ON_BOARD_BRAKE
    //#define ON_BOARD_GYRO
    //#define ON_BOARD_IDENTITY

    #define ON_BOARD_ENCODER
    #define ON_BOARD_HALL
    #define ON_BOARD_CAN
    #define PWM_SYNCSEL 7 // 1msec
    #define PWM_FASTSYNCSEL 9
    #define PWM_CPU_PACER EPWM6_BASE
    #define PWM_LMEAS_PACER EPWM9_BASE
    #define PWM_SCD_BASE EPWM4_BASE
    #define PWM_A_BASE EPWM8_BASE
    //#define PWM_A_LUTBASE EPWM8MINDBLUT_BASE
    #define PWM_B_BASE EPWM2_BASE
    //#define PWM_B_LUTBASE EPWM2MINDBLUT_BASE
    #define PWM_C_BASE EPWM1_BASE
    //#define PWM_C_LUTBASE EPWM1MINDBLUT_BASE
    #define PWM_OVERSAMP  EPWM10_BASE

    //#define PWM_PACER_BASE EPWM1_BASE
    //#define CUR_SAMP_PACER_MULT 1
    #define DEAD_TIME_USEC 0.28f



#ifdef ON_BOARD_ENCODER
#define ENCODER_BASE EQEP1_BASE
#endif

#define ADC_READ_CUR1_H1  (4096-HWREGH(ADCBRESULT_BASE+ADC_O_RESULT0))
#define ADC_READ_CUR1_H2  (4096-HWREGH(ADCBRESULT_BASE+ADC_O_RESULT3))
#define ADC_READ_CUR2_H1  (4096-HWREGH(ADCCRESULT_BASE+ADC_O_RESULT0))
#define ADC_READ_CUR2_H2  (4096-HWREGH(ADCCRESULT_BASE+ADC_O_RESULT3))
#define ADC_READ_CUR3_H1  (4096-HWREGH(ADCARESULT_BASE+ADC_O_RESULT0))
#define ADC_READ_CUR3_H2  (4096-HWREGH(ADCARESULT_BASE+ADC_O_RESULT3))


//#define ADC_READ_CUR2_H1  (4096-HWREGH(ADCARESULT_BASE+ADC_O_RESULT0))
//#define ADC_READ_CUR2_H2  (4096-HWREGH(ADCARESULT_BASE+ADC_O_RESULT3))
//#define ADC_READ_CUR3_H1  (4096-HWREGH(ADCCRESULT_BASE+ADC_O_RESULT0))
//#define ADC_READ_CUR3_H2  (4096-HWREGH(ADCCRESULT_BASE+ADC_O_RESULT3))



#define ADC_READ_CUR1_A  (4096-HWREGH(ADCBRESULT_BASE+ADC_O_RESULT1))
#define ADC_READ_CUR2_A  (4096-HWREGH(ADCCRESULT_BASE+ADC_O_RESULT1))
#define ADC_READ_CUR3_A  (4096-HWREGH(ADCARESULT_BASE+ADC_O_RESULT1))


#define ADC_READ_VOLT1  HWREGH(ADCBRESULT_BASE+ADC_O_RESULT2)
#define ADC_READ_VOLT2  HWREGH(ADCCRESULT_BASE+ADC_O_RESULT2)
#define ADC_READ_VOLT3  HWREGH(ADCARESULT_BASE+ADC_O_RESULT2)
#define ADC_READ_VOLTDC HWREGH(ADCARESULT_BASE+ADC_O_RESULT4)

#define ADC_READ_CURDC_AMC  (4096-HWREGH(ADCCRESULT_BASE+ADC_O_RESULT4))
#define ADC_READ_CURDC_HALL  (4096-HWREGH(ADCBRESULT_BASE+ADC_O_RESULT4))

#define ADC_READ_TEMPERATURE  (4096-HWREGH(ADCCRESULT_BASE+ADC_O_RESULT5))


#define CMPSS_VBUS_BASE   CMPSS2_BASE
#define CMPSS_BUSCUR_BASE CMPSS3_BASE

#define VB_CMPHP_MUX 1
#define VB_CMPLP_MUX 1
#define ISC_CMPHP_MUX 2
#define ISC_CMPLP_MUX 2

#ifndef ZUZMOTOR
#define VDC_2_BIT_VOLTS_R2 0.4118f
#else
#define VDC_2_BIT_VOLTS_R2 0.079229629629630  // Vandal 0.4202f
#endif

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

#define PHASE_OVERCURRENT_AMP 22

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


#define WHEEL_REV2POS  0.4157f // was 0.4174

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

     {.ProjIndex = 1 ,// PROJ_TYPE_BESENSORLESS
      .ProjSpecificDataRevision = HwConfigRevision,
         .FullAdcRangeCurrent = FULL_ADC_RANGE_WH_CURRENT_R2 , .EncoderCountsFullRev = 65536 ,  .Rev2Pos = WHEEL_REV2POS  , .HallAngleOffset = 0 , .nPolePairs=5, .InvertEncoder=1 ,
         .KpCur = 30.0f , .KiCur = 40000 , .PhaseOverCurrent = 23 , .DcShortCitcuitTripVolts = 2.7f, .MaxCurCmd = 18.0f ,
         .MaxCurCmdDdt = 30000.0f , .CurrentFilterBWHz = 3000.0f ,
        .HallVal0 = HALL_BAD_VALUE , .HallVal1 = 2 , .HallVal2 = 0 , .HallVal3 = 1 , .HallVal4 = 4 , .HallVal5 = 3 , .HallVal6 = 5  , .HallVal7 = HALL_BAD_VALUE,
        .BrakeReleaseVolts = 23.0f,
        .Pot1RatRad  = 3.1415926f  ,
        .Pot2RatRad  = 3.1415926f  ,
        .Pot1CenterRat = 0.5f,
        .Pot2CenterRat = 0.5f,
        .I2tCurLevel  = 20.0f ,
        .I2tCurTime   = 24.0f ,
        .CurrentCommandDir = 1.0f ,
        .CanId = 44
     } ,

      {.ProjIndex = 2 ,// PROJ_TYPE_ZOOZ_S
       .ProjSpecificDataRevision = HwConfigRevision,
          .FullAdcRangeCurrent = FULL_ADC_RANGE_WH_CURRENT_R2 , .EncoderCountsFullRev = 65536 ,  .Rev2Pos = WHEEL_REV2POS  , .HallAngleOffset = 0 , .nPolePairs=5, .InvertEncoder=1 ,
          .KpCur = 4.0f , .KiCur = 8000 , .PhaseOverCurrent = 35 , .DcShortCitcuitTripVolts = 2.7f, .MaxCurCmd = 18.0f ,
          .MaxCurCmdDdt = 10000.0f , .CurrentFilterBWHz = 3000.0f ,
         .HallVal0 = HALL_BAD_VALUE , .HallVal1 = 2 , .HallVal2 = 0 , .HallVal3 = 1 , .HallVal4 = 4 , .HallVal5 = 3 , .HallVal6 = 5  , .HallVal7 = HALL_BAD_VALUE,
         .BrakeReleaseVolts = 23.0f,
         .Pot1RatRad  = 3.1415926f  ,
         .Pot2RatRad  = 3.1415926f  ,
         .Pot1CenterRat = 0.5f,
         .Pot2CenterRat = 0.5f,
         .I2tCurLevel  = 24.0f ,
         .I2tCurTime   = 24.0f ,
         .CurrentCommandDir = 1.0f ,
         .CanId = 44
      } ,

    };

    const unsigned short nProjSpecificData = sizeof(ProjSpecificData) / sizeof(struct CProjSpecificData) ;


    #else
    extern const struct  CProjSpecificData ProjSpecificData[] ;
    extern const unsigned short nProjSpecificData ;
#endif




#endif // APPLICATION_HWCONFIG_H_
