/*
 * File: Seal.h
 *
 * Code generated for Simulink model 'Seal'.
 *
 * Model version                  : 11.71
 * Simulink Coder version         : 25.1 (R2025a) 21-Nov-2024
 * C/C++ source code generated on : Thu Aug 21 09:41:15 2025
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Texas Instruments->C2000
 * Code generation objectives:
 *    1. Execution efficiency
 *    2. Traceability
 *    3. Safety precaution
 *    4. RAM efficiency
 * Validation result: Not run
 */

#ifndef Seal_h_
#define Seal_h_
#ifndef Seal_COMMON_INCLUDES_
#define Seal_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                                 /* Seal_COMMON_INCLUDES_ */

/* user code (top of header file) */
#include ".\ExternalCode\CANServer.h"
#ifndef DEFINED_TYPEDEF_FOR_FeedbackBuf_T_
#define DEFINED_TYPEDEF_FOR_FeedbackBuf_T_

typedef struct {
  /* The main encoder sensor */
  int32_T EncoderMain;

  /* The secondary encoder sensor */
  int32_T EncoderSecondary;

  /* Speed of main encoder sensor */
  real32_T EncoderMainSpeed;

  /* Speed of secondary encoder sensor */
  real32_T EncoderSecondarySpeed;

  /* Q-channel current Amp */
  real32_T Iq;

  /* Q-channel current Amp */
  real32_T Id;

  /* DC bus voltage V */
  real32_T DcBusVoltage;

  /* Power stage temperature C */
  real32_T PowerStageTemperature;

  /* Motor electrical field angle */
  real32_T FieldAngle;

  /* Spare : 10 */
  int32_T Spare_10;

  /* Spare : 11 */
  int32_T Spare_11;

  /* Spare : 12 */
  int32_T Spare_12;

  /* Control loop configuration */
  int16_T LoopConfiguration;

  /* ReferenceMode */
  int16_T ReferenceMode;

  /* Motor on report */
  int16_T MotorOn;

  /* Code of Hall sensors */
  int16_T HallCode;

  /* 1 if disabled by STO */
  int16_T STODisable;

  /* Status bit field */
  int16_T StatusBitField;

  /* Motor failure report */
  uint32_T ErrorCode;

  /* Spare : 20 */
  int32_T Spare_20;

  /* Spare : 21 */
  int32_T Spare_21;

  /* Spare : 22 */
  int32_T Spare_22;

  /* Spare : 23 */
  int32_T Spare_23;

  /* Spare : 24 */
  int32_T Spare_24;
} FeedbackBuf_T;

#endif

#ifndef DEFINED_TYPEDEF_FOR_SetupReportBuf_T_
#define DEFINED_TYPEDEF_FOR_SetupReportBuf_T_

typedef struct {
  /* Maximum position referece */
  real_T MaximumPositionReference;

  /* Minimum position reference */
  real_T MinimumPositionReference;

  /* High position value that causes an exception  */
  real_T HighPositionException;

  /* Low position value that causes an exception  */
  real_T LowPositionException;

  /* Absolute speed limit */
  real32_T AbsoluteSpeedLimit;

  /* Modulo count for position sensor #1 */
  real_T PositionModulo1;

  /* Modulo count for position sensor #2 */
  real_T PositionModulo2;

  /* Speed for overspeed exception */
  real32_T OverSpeed;

  /* Absolute acceleration limit */
  real32_T AbsoluteAccelerationLimit;

  /* Continuous current limit */
  real32_T ContinuousCurrentLimit;

  /* Peak current limit */
  real32_T PeakCurrentLimit;

  /* Peak current duration */
  real32_T PeakCurrentDuration;

  /* Over current that causes an exception */
  real32_T OverCurrent;

  /* Baud rate of UART */
  uint32_T UARTBaudRate;

  /* Baud rate of CAN */
  uint32_T CANBaudRate;

  /* Is Sensor modulo: 1 */
  uint16_T IsPosSensorModulo1;

  /* Is Sensor modulo: 2 */
  uint16_T IsPosSensorModulo2;

  /* CAN ID 11bit */
  uint16_T CANId11bit;

  /* Profiler sampling time  */
  real32_T Ts;

  /* Spare : 20 */
  int32_T Spare_20;

  /* Spare : 21 */
  int32_T Spare_21;

  /* Spare : 22 */
  int32_T Spare_22;

  /* Spare : 23 */
  int32_T Spare_23;

  /* Spare : 24 */
  int32_T Spare_24;
} SetupReportBuf_T;

#endif

#ifndef DEFINED_TYPEDEF_FOR_PosProfilerData_T_
#define DEFINED_TYPEDEF_FOR_PosProfilerData_T_

typedef struct {
  /* Final position to arrive */
  real32_T PositionTarget;

  /* Maximum speed */
  real32_T ProfileSpeed;

  /* Maximum Profile acceleration */
  real32_T ProfileAcceleration;

  /* Maximum Profile deceleration */
  real32_T ProfileDeceleration;

  /* Filter monic polynomial for profile filtering */
  real_T ProfileFilterDen[4];

  /* Filter numerator for profile filtering */
  real_T ProfileFilterNum;

  /* Flag that profiler data is consistent */
  uint16_T ProfileDataOk;

  /* Profiler sampling time  */
  real32_T Ts;
} PosProfilerData_T;

#endif

#ifndef DEFINED_TYPEDEF_FOR_DrvCommandBuf_T_
#define DEFINED_TYPEDEF_FOR_DrvCommandBuf_T_

typedef struct {
  /* Command to position controller */
  real_T PositionCommand;

  /* Command to speed controller */
  real_T SpeedCommand;

  /* Command to current controller */
  real_T CurrentCommand;

  /* Control loop configuration */
  int16_T LoopConfiguration;

  /* ReferenceMode */
  int16_T ReferenceMode;

  /* Motor on request */
  int16_T MotorOn;

  /* Failure Reset Request */
  int16_T FailureReset;

  /* Spare : 8 */
  int32_T Spare_8;

  /* Spare : 9 */
  int32_T Spare_9;

  /* Spare : 10 */
  int32_T Spare_10;

  /* Spare : 11 */
  int32_T Spare_11;

  /* Spare : 12 */
  int32_T Spare_12;

  /* Spare : 13 */
  int32_T Spare_13;

  /* Spare : 14 */
  int32_T Spare_14;

  /* Spare : 15 */
  int32_T Spare_15;

  /* Spare : 16 */
  int32_T Spare_16;

  /* Spare : 17 */
  int32_T Spare_17;

  /* Spare : 18 */
  int32_T Spare_18;

  /* Spare : 19 */
  int32_T Spare_19;

  /* Spare : 20 */
  int32_T Spare_20;

  /* Spare : 21 */
  int32_T Spare_21;

  /* Spare : 22 */
  int32_T Spare_22;

  /* Spare : 23 */
  int32_T Spare_23;

  /* Spare : 24 */
  int32_T Spare_24;
} DrvCommandBuf_T;

#endif

#ifndef DEFINED_TYPEDEF_FOR_UserInfo_T_
#define DEFINED_TYPEDEF_FOR_UserInfo_T_

typedef struct {
  /* Version control number */
  int32_T VersionNumber;

  /* Stam zbala */
  real32_T junk1;

  /* Stam vector zbala */
  int32_T junk2[4];
} UserInfo_T;

#endif

#ifndef DEFINED_TYPEDEF_FOR_PosProfilerState_T_
#define DEFINED_TYPEDEF_FOR_PosProfilerState_T_

typedef struct {
  /* Position state of profiler */
  real_T Position;

  /* Speed state of profiler */
  real_T Speed;

  /* State of profiling filter */
  real_T FiltState[4];
} PosProfilerState_T;

#endif

#ifndef DEFINED_TYPEDEF_FOR_SEALVerControl_T_
#define DEFINED_TYPEDEF_FOR_SEALVerControl_T_

typedef struct {
  /* SEAL database version */
  uint16_T Version;

  /* SEAL database sub version */
  uint16_T SubVersion;

  /* SEAL database support data */
  uint32_T UserData;
} SEALVerControl_T;

#endif

#ifndef DEFINED_TYPEDEF_FOR_CANCyclicBuf_T_
#define DEFINED_TYPEDEF_FOR_CANCyclicBuf_T_

typedef struct {
  /* The place in the CANQueue where the next message is to be put */
  uint16_T PutCounter;

  /* The location in the CANQueue of the next message to read */
  uint16_T FetchCounter;

  /* CAN error */
  uint16_T CANError;

  /* Software Queue for incoming CAN messages */
  uint32_T CANQueue[256];

  /* The location in the CANQueue of the next message to transmit */
  uint16_T TxFetchCounter;

  /* Can ID, 11 or 29bit */
  uint32_T CANID[64];

  /* Data length and attributes */
  uint16_T DLenAndAttrib[64];
} CANCyclicBuf_T;

#endif

#ifndef DEFINED_TYPEDEF_FOR_MicroInterp_T_
#define DEFINED_TYPEDEF_FOR_MicroInterp_T_

typedef struct {
  /* 1 if this is a get function */
  uint16_T IsGetFunc;

  /* Temporary string to hold characters extracted from the cyclical buffer */
  uint16_T TempString[64];

  /* String formatting error */
  uint16_T InterpretError;

  /* In string counter */
  uint16_T cnt;

  /* Argument of a set function */
  real_T Argument;

  /* State of the interpreting process */
  uint16_T State;

  /* Indicate a new string is available */
  uint16_T NewString;

  /* Mnemonic index */
  uint16_T MnemonicIndex;

  /* Array index */
  uint16_T ArrayIndex;
} MicroInterp_T;

#endif

#ifndef DEFINED_TYPEDEF_FOR_UartCyclicBuf_T_
#define DEFINED_TYPEDEF_FOR_UartCyclicBuf_T_

typedef struct {
  /* The place in the UARTQueue where next character is to be put */
  uint16_T PutCounter;

  /* The location in the UARTQueue of the next character to read */
  uint16_T FetchCounter;

  /* UART error */
  uint16_T UartError;

  /* The location in the TX UARTQueue of the next character to read */
  uint16_T TxFetchCounter;

  /* Software Queue for incoming UART characters */
  uint16_T UARTQueue[256];
} UartCyclicBuf_T;

#endif

#ifndef DEFINED_TYPEDEF_FOR_VarDataTypes_
#define DEFINED_TYPEDEF_FOR_VarDataTypes_

typedef uint16_T VarDataTypes;

/* enum VarDataTypes */
#define T_int32                        (0U)                      /* Default value */
#define T_single                       (2U)
#define T_int16                        (4U)
#define T_uint32                       (8U)
#define T_uint16                       (12U)
#define T_double                       (16U)
#endif

/* Block signals and states (default storage) for system '<Root>' */
typedef struct {
  PosProfilerData_T G_PosProfilerData; /* '<Root>/Data Store Memory2' */
  PosProfilerState_T G_PosProfilerState;/* '<Root>/Data Store Memory5' */
  real_T DiscreteFilter_states;        /* '<S1>/Discrete Filter' */
} DW;

/* Imported (extern) states */
extern CANCyclicBuf_T G_CANCyclicBuf_in;/* '<S5>/G_CANCyclicBuf_in' */
extern CANCyclicBuf_T G_CANCyclicBuf_out;/* '<S5>/G_CANCyclicBuf_out' */
extern UartCyclicBuf_T G_UartCyclicBuf_in;/* '<S6>/G_UartCyclicBuf_in' */
extern UartCyclicBuf_T G_UartCyclicBuf_out;/* '<S6>/G_UartCyclicBuf_out' */
extern MicroInterp_T G_MicroInterp;    /* '<S6>/G_MicroInterp' */
extern SetupReportBuf_T G_SetupReportBuf;/* '<Root>/Data Store Memory1' */
extern DrvCommandBuf_T G_DrvCommandBuf;/* '<Root>/Data Store Memory3' */
extern FeedbackBuf_T G_FeedbackBuf;    /* '<Root>/Data Store Memory' */

/* Block signals and states (default storage) */
extern DW rtDW;

/*
 * Exported Global Parameters
 *
 * Note: Exported global parameters are tunable parameters with an exported
 * global storage class designation.  Code generation will declare the memory for
 * these parameters and exports their symbols.
 *
 */
extern PosProfilerData_T PosProfilerData_init;/* Variable: PosProfilerData_init
                                               * Referenced by: '<Root>/Data Store Memory2'
                                               */
extern PosProfilerState_T PosProfilerState_init;/* Variable: PosProfilerState_init
                                                 * Referenced by: '<Root>/Data Store Memory5'
                                                 */
extern SEALVerControl_T SEALVerControl_init;/* Variable: SEALVerControl_init
                                             * Referenced by: '<Root>/Data Store Memory6'
                                             */
extern real_T KiSpeed;                 /* Variable: KiSpeed
                                        * Referenced by: '<S1>/Gain2'
                                        */
extern real_T Kp;                      /* Variable: Kp
                                        * Referenced by: '<S1>/Gain'
                                        */
extern real_T KpSpeed;                 /* Variable: KpSpeed
                                        * Referenced by: '<S1>/Gain1'
                                        */

/*
 * Exported States
 *
 * Note: Exported states are block states with an exported global
 * storage class designation.  Code generation will declare the memory for these
 * states and exports their symbols.
 *
 */
extern UserInfo_T G_UserInfo;          /* '<Root>/Data Store Memory4' */
extern SEALVerControl_T G_SEALVerControl;/* '<Root>/Data Store Memory6' */

/* Model entry point functions */
extern void Seal_initialize(void);

/* Exported entry point function */
extern void ISR100uController(void);

/* Exported entry point function */
extern void ISR100uProfiler(void);

/* Exported entry point function */
extern void IdleLoopCAN(void);

/* Exported entry point function */
extern void IdleLoopUART(void);

/* Exported entry point function */
extern void SetupDrive(void);

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'Seal'
 * '<S1>'   : 'Seal/100 usec Periodic controller'
 * '<S2>'   : 'Seal/100 usec Periodic profiler'
 * '<S3>'   : 'Seal/DocBlock'
 * '<S4>'   : 'Seal/Drive configuration'
 * '<S5>'   : 'Seal/Idle process CAN interpreter'
 * '<S6>'   : 'Seal/Idle process UART interpreter'
 * '<S7>'   : 'Seal/100 usec Periodic profiler/MATLAB Function'
 * '<S8>'   : 'Seal/Drive configuration/MATLAB Function'
 * '<S9>'   : 'Seal/Idle process CAN interpreter/CAN message response'
 * '<S10>'  : 'Seal/Idle process UART interpreter/UART message response'
 */

/*-
 * Requirements for '<Root>': Seal


 */
#endif                                 /* Seal_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
