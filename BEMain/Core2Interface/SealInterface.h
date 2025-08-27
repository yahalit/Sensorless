/*
 * SealInterface.h
 *
 *  Created on: 18 баев„ 2025
 *      Author: Yahali
 */

#ifndef SEALINTERFACE_H_
#define SEALINTERFACE_H_


#define N_FUNC_DESCRIPTORS 16

#include "rtwtypes.h"
#include "SealTypedefs.h"


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


#ifndef DEFINED_TYPEDEF_FOR_CANMessage_T_
#define DEFINED_TYPEDEF_FOR_CANMessage_T_

typedef struct {
  /* ID of the CAN message */
  uint32_T CANID;

  /* Data length of the CAN message */
  uint16_T DataLen;

  /* Data for incoming CAN messages */
  uint32_T MsgData[2];

  /* Number TX requests including this message */
  uint16_T CANTxCnt;
} CANMessage_T;

#endif

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

  /* Oblige the drive from SEAL control */
  int16_T bSetSealControl;

  /* Flag that the SEAL uses the UART and the drive should not interpret UART communication */
  int16_T bControlUART;

  /* Seal 11 bit CAN ID */
  int16_T SealCanID_11;

  /* Seal 29 bit CAN ID */
  int16_T SealCanID_29;

  /* Spare : 12 */
  int16_T Spare_12;

  /* Spare : 13 */
  int16_T Spare_13;

  /* Spare : 14 */
  int16_T Spare_14;

  /* Spare : 15 */
  int16_T Spare_15;

  /* Spare : 16 */
  int16_T Spare_16;

  /* Spare : 17 */
  int16_T Spare_17;

  /* Spare : 18 */
  int16_T Spare_18;

  /* Spare : 19 */
  int16_T Spare_19;

  /* Spare : 20 */
  int16_T Spare_20;

  /* Spare : 21 */
  int16_T Spare_21;

  /* Spare : 22 */
  int16_T Spare_22;

  /* Spare : 23 */
  int16_T Spare_23;

  /* Spare : 24 */
  int16_T Spare_24;
} DrvCommandBuf_T;


#ifndef DEFINED_TYPEDEF_FOR_FeedbackBuf_T_
#define DEFINED_TYPEDEF_FOR_FeedbackBuf_T_

typedef struct {
  /* Time counted from process start */
  real_T SystemTime;

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

  /* Spare : 8 */
  int16_T Spare_8;

  /* DC bus voltage V */
  real32_T DcBusVoltage;

  /* Power stage temperature C */
  real32_T PowerStageTemperature;

  /* Motor electrical field angle */
  real32_T FieldAngle;

  /* Motor failure report */
  uint32_T ErrorCode;

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

  /* Confirm Release the drive from SEAL control */
  int16_T ConfirmRelinquishControl;

  /* Spare : 20 */
  int16_T Spare_20;

  /* Spare : 21 */
  int16_T Spare_21;

  /* Spare : 22 */
  int16_T Spare_22;

  /* Spare : 23 */
  int16_T Spare_23;

  /* Spare : 24 */
  int16_T Spare_24;
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

  /* Confirms that the SEAL uses the UART and the drive should not interpret UART communication */
  int16_T bConfirmControlUART;

  /* Spare : 21 */
  int16_T Spare_21;

  /* Spare : 22 */
  int16_T Spare_22;

  /* Spare : 23 */
  int16_T Spare_23;

  /* Spare : 24 */
  int16_T Spare_24;
} SetupReportBuf_T;

#endif


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




#endif /* SEALINTERFACE_H_ */
