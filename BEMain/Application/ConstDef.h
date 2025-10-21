/*
 * ConstDef.h
 *
 *  Created on: Mar 30, 2025
 *      Author: user
 */

#ifndef APPLICATION_CONSTDEF_H_
#define APPLICATION_CONSTDEF_H_


#define SRV_FIRM_YR 2024UL
#define SRV_FIRM_MONTH 10UL
#define SRV_FIRM_DAY 12UL

#define SRV_FIRM_VER 2UL
#define SRV_FIRM_SUBVER 2UL
#define SRV_FIRM_PATCH 17

//#define FIRM_VER (( (long unsigned)FIRM_YR << 20 ) + ((long unsigned)FIRM_MONTH<<16) + ((long unsigned)FIRM_DAY <<8) + (long unsigned) FIRM_SUBVER ) ;
#define SubverPatch ( ((SRV_FIRM_YR-2000) << 24 ) + (SRV_FIRM_MONTH<<20) + (SRV_FIRM_DAY <<15)  +(SRV_FIRM_VER << 8) + (SRV_FIRM_SUBVER<<4) + SRV_FIRM_PATCH )

#define PROJ_TYPE_UNDEFINED 0
#define PROJ_TYPE_BESENSORLESS 1
#define PROJ_TYPE_ZOOZ_S 2
#define PROJ_TYPE_LAST 3 // Must be 1 over the biggest

#define PROJ_TYPE_ERROR 0xff


#define ADC_Hall2Amp 0.006112469437653f
#define LMeasTsampUsec 5


#define CPU_CLK_MHZ      200
#define CPU_CLK_NSEC     (1000/CPU_CLK_MHZ)

#define INV_CPU_CLK_MHZ (1.0f/CPU_CLK_MHZ)
#define CPU_CLK_HZ (CPU_CLK_MHZ*1.0e6f)
#define INV_CPU_CLK_HZ (1.0f/CPU_CLK_HZ)
#define CUR_SAMPLE_TIME_USEC 50
#define CUR_SAMPLE_TIME_CLOCKS (CUR_SAMPLE_TIME_USEC*CPU_CLK_MHZ)
#define MAX_TIME_FOR_ZERO_SPEED (6.4e-3f)

#define CONTROL_PERIOD_NSEC (CUR_SAMPLE_TIME_USEC*1000UL)
#define DAC_SET_NSEC    2000UL
#define DAC_DISABLE_PERIOD_NSEC (DAC_SET_NSEC+2000UL)
#define DAC_PWM_PERIOD_NSEC (CUR_SAMPLE_TIME_USEC * 250UL)
#define DAC_PWM_PERIOD_CLK  ((unsigned short)(0.001f * DAC_PWM_PERIOD_NSEC * CPU_CLK_MHZ  ))
#define ADC_BEFORE_PWM0_nsec 600UL
#define ADC_BEFORE_ControlIsr_nsec 2000

#define UART_BAUD_RATE 2000000UL


#define FSI_OVER_CONTROL 0.5f // Rate of FSI cycles over control cycles
#define MAX_BRAKE_VOLTAGE 26.0f

#define BUS_OFF_RECOVERY_TIME 0.1f

// ADC SH Window is 14 clocks. Note that the ADC clock is in SYSCLOCK, and that hold terminates one SYSCLK before the window time
#define ADC_SAMPLE_WINDOW 14
#define ADC_SAMP_WIN ((ADC_SAMPLE_WINDOW+1)/ (float)CPU_CLK_MHZ)
#define CURRENT_SAMP_TC 0.3
#define FALL_AND_QCC_TIME 0.3
#define CURSAMPWINDOW_TIME_USEC (DEAD_TIME_USEC+FALL_AND_QCC_TIME+CURRENT_SAMP_TC*7 + ADC_SAMPLE_WINDOW * INV_CPU_CLK_MHZ )  //   CURSAMPWINDOW_TIME_USEC 1.77f

#define FAST_INTS_IN_C 1
#define FAST_TS_USEC CUR_SAMPLE_TIME_USEC
#define VLOOP_SAMPLE_TIME_USEC 3.125


#define CALIB_SECT_LENGTH (1UL<<10)
#define PARAMS_SECT_LENGTH (1UL<<12)
#define IDENTITY_SECT_LENGTH (1UL<<10)

#define PiHalf 1.570796326794897f
#define Pi     3.141592653589793f
#define Pi2 6.283185307179586f
#define OneOverPi2 0.159154943091895f
#define Log2OfE 1.442695040888963f

#define HallFac 0.166666666666667f

#define MAX_PDO_AGE_FOR_AUTOMATIC 0.1f

#define UART_SW_INP_BUF_SIZE 128
#define SDO_BUF_LEN_LONGS 128
#define EXCEPTION_TAB_LENGTH 8

//#define SIG_TABLE_SIZE SIG_TABLE_SIZE_BASIC
#define N_RECS_MAX  16 // Maximum amount of recorded signals
#define REC_BUF_LEN  16384 // Number of bins in recorder
#define N_FDEBUG 8
#define N_LDEBUG 8

#define CAN_NMT  (0<<7)
#define CAN_SYNC  (1<<7)
#define CAN_EMCY  CAN_SYNC
#define CAN_TSTAMP (2<<7)

#define PDO1_TX (3<<7)
#define PDO2_TX (5<<7)
#define PDO3_TX (7<<7)
#define PDO4_TX (9<<7)

#define PDO1_RX (4<<7)
#define PDO2_RX (6<<7)
#define PDO3_RX (8<<7)
#define PDO4_RX (0xa<<7)

#define SDO_TX (0xb<<7)
#define SDO_RX (0xc<<7)

#define CAN_NMT_ERROR_CONTROL  (0xe<<7)

#define MAX_ADC_CUR_OFFSET 200

#define UNSIGNED_MINUS1 0xffffffffUL
#define UNSIGNED_MINUS1_S 0xffff


#define MODE_OF_OPERATION_PROFILED_POSITION 1
#define MODE_OF_OPERATION_PROFILED_VELOCITY 3
#define MODE_OF_OPERATION_PROFILED_TORQUE 4
#define MODE_OF_OPERATION_HOMING 6
#define MODE_OF_OPERATION_PROFILED_CSP 8
#define MODE_OF_OPERATION_PROFILED_CSV 9


#define Pi2 6.283185307179586f

#define NSYS_TIMER_CMP_ARRAY 16

#define EXP_FATAL (short)(-1)   // Fatal - dead duck
#define EXP_WARN  (short)(-2)   // For warning
#define EXP_ABORT  (short)(-3)  // Abort auto actions
#define EXP_RESET  (short)(0)  // Clear
//#define EXP_ABORT_PACKON  (short)(-4)  // Abort auto actions, leave pack handling on the work
#define EXP_SAFE_FATAL (short)(-5)   // Fatal - with safe brake application

// Flags for configuration parameters
#define CFG_FLOAT 2
#define CFG_MUST_INIT 4
//#define CFG_MUST_AUTO 8
#define CFG_KILLS_CFG  16
#define CFG_RECALC  32
#define CFG_REVISION 0x4000



#define MODE_OF_OPERATION_PROFILED_POSITION 1
#define MODE_OF_OPERATION_PROFILED_VELOCITY 3
#define MODE_OF_OPERATION_PROFILED_TORQUE 4
#define MODE_OF_OPERATION_HOMING 6
#define MODE_OF_OPERATION_PROFILED_CSP 8
#define MODE_OF_OPERATION_PROFILED_CSV 9

#define IsBadFloat(x) ((( *((short unsigned *)&x + 1 ) & 0x7f80 ) == 0x7f80 ) ? 1 : 0 )

// Depends in number of transmitters!
// #define MCAN_TX_MASK_OTHER  0b1110000

#define ADC_SOC_EVENT ADC_TRIGGER_EPWM4_SOCA
#define ADC_SOC_EVENT_THIRD ADC_TRIGGER_EPWM10_SOCA
#define ADC_SOC_EVENT_2THIRD ADC_TRIGGER_EPWM10_SOCB


#define ADC_SOC_LMEAS_EVENT ADC_TRIGGER_EPWM9_SOCA

enum E_CLA_TASK_MODES
{
    MODE_FIND_COMM_START = 1
};


enum SdoAbortErrorCode
{
    Toggle_bit_not_alternated = 0x05030000,
    SDO_protocol_timed_out = 0x5040000 ,
    Client_server_command_specifier_not_valid_or_unknown = 0x5040001 ,
    Object_does_not_exist_in_the_object_dictionary = 0x06020000,
    Unsupported_access_to_an_object = 0x6010000,
    General_parameter_incompatibility_reason = 0x6040043,
    length_of_service_parameter_does_not_match=0x6070010,
    Sub_index_does_not_exist = 0x6090011,
    Out_of_memory = 0x5040005,
    Invalid_block_size = 0x5040002,
    Invalid_sequence_number = 0x5040003,
    crc_error = 0x5040004,
    Manufacturer_error_detail = 0x9000000UL,
    ReturnNotExpected = 0x7fffffffUL
};


enum E_ReferenceModes
{
    E_PosModeNothing = 0 ,
    E_PosModeDebugGen = 1 ,
    E_PosModeStayInPlace = 2 ,
    E_PosModePTP = 3 , // Build automatic trajectory towards target s.t. speed & acceleration constraints
    E_PosModePT = 4 , // Position-time: Each command includes an immediate position reference
    E_RefModeSpeed = 5, // Set to speed s.t. acceleration limit
    E_RefModeSpeed2Home = 6 // Homing, by pre-defined method
};


enum E_SigRefType
{
    E_S_Nothing = 0 ,
    E_S_Fixed   = 1 ,
    E_S_Sine    = 2 ,
    E_S_Square  = 3 ,
    E_S_Triangle = 4
};

enum E_CommutationModes
{
    COM_OPEN_LOOP = 0 ,
    COM_HALLS_ONLY = 1 ,
    COM_ENCODER = 2 ,
    COM_ENCODER_RESET= 3,
    COM_ENCODER_SENSORLESS= 4
};

enum CF_CorrelationState
{
    ECF_Inactive = 0 ,
    ECF_StartTime = 1 ,
    ECF_WaitStabilize = 2 ,
    ECF_sumCorr = 3 ,
    ECF_sumCorr2 = 4 ,
    ECF_Done = 5
};


enum INBD_BrakeEngageState
{
    INBD_EngageNothing = 0 ,
    INBD_EngageInit = 1 ,
    INBD_WaitZeroSpeedRef = 2 ,
    INBD_WaitBrakeEngage = 3
} ;

enum EHT_HomeState
{
    EHS_Init = 0 ,
    EMS_LogEvent = 1 ,
    EMS_Stop = 2 ,
    EMS_ExitHome = 3 ,
    EMS_Final_Stop = 4 ,
    EMS_Done = 5 ,
    EMS_Decelerate2Fail = 6 ,
    EMS_Failure = 7
};

enum EHM_HomeMethod
{
    EHM_CollideLimit = 0 ,
    EHM_SwitchLimit = 1 ,
    EHM_Immediate = 2
 };


enum EHM_SwInUse
{
    EHM_HomingSwitchD0 = 0 ,
    EHM_HomingSwitchD1 = 1
};

enum EHM_Direction
{
    EHM_HomingForward = 1,
    EHM_HomingReverse = -1
};


enum E_MotorOffType
{
    E_OffForFinal  = 0 ,
    E_OffForAutoEngage = 1
};


enum E_LMeasState
{
    ELM_Nothing   = 0 ,
    ELM_Init_cond = 1 ,
    ELM_FirstRise = 2 ,
    ELM_FirstFall = 3 ,
    ELM_FirstPause = 4 ,
    ELM_FirstFallFull = 5 ,
    ELM_NegPause = 6 ,
    ELM_SecondRise = 7 ,
    ELM_SecondPause = 8 ,
    ELM_SecondRiseFull = 9 ,
    ELM_FinalReduction = 10 ,
    ELM_WaitEnd = 11 ,
    ELM_Done = 12 ,
    ELM_Fault = 15
};


#define DMA_USE_LEN REC_BUF_LEN
#define CLA_DMA_TRANSFER_SIZE_LONGS 8

#define Sector_AppCalib_start 0xddc00
#define Sector_AppParams_start 0xde000

#define Sector_AppIdentity_start 0xdf000

#define Sector_AppVerify_start 0xdf400

/*
FLASH_CALIB      : origin = 0xddc00, length = 0x400
FLASH_PARAMS     : origin = 0xde000, length = 0x1000
FLASH_IDENTITY  : origin = 0xdf000, length = 0x400
FLASH_STATISTIC  : origin = 0xdf400, length = 0x400
*/

#endif /* APPLICATION_CONSTDEF_H_ */
