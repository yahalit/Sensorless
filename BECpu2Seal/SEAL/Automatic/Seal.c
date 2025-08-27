/*
 * File: Seal.c
 *
 * Code generated for Simulink model 'Seal'.
 *
 * Model version                  : 11.111
 * Simulink Coder version         : 25.1 (R2025a) 21-Nov-2024
 * C/C++ source code generated on : Tue Aug 26 22:22:24 2025
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

#include "Seal.h"
#include "rtwtypes.h"
#include <math.h>
#include "mod_CTxUEiaB.h"
#include "rt_roundd.h"
#include "div_nde_s16_floor.h"

/* Exported block parameters */
PosProfilerData_T PosProfilerData_init = {
  0.0F,
  1.0F,
  1.0F,
  1.0F,

  { 1.0, -0.874052257056399, 0.280840263500717, -0.024477523271653 },
  0.382310483172666,
  0U,
  0.0F
} ;                                    /* Variable: PosProfilerData_init
                                        * Referenced by: '<Root>/Data Store Memory2'
                                        */

PosProfilerState_T PosProfilerState_init = {
  0.0,
  0.0,

  { 0.0, 0.0, 0.0, 0.0 }
} ;                                    /* Variable: PosProfilerState_init
                                        * Referenced by: '<Root>/Data Store Memory5'
                                        */

SEALVerControl_T SEALVerControl_init = {
  1U,
  1U,
  0UL
} ;                                    /* Variable: SEALVerControl_init
                                        * Referenced by: '<Root>/Data Store Memory6'
                                        */

real_T KiSpeed = 5.0;                  /* Variable: KiSpeed
                                        * Referenced by: '<S1>/Gain2'
                                        */
real_T Kp = 5.0;                       /* Variable: Kp
                                        * Referenced by: '<S1>/Gain'
                                        */
real_T KpSpeed = 5.0;                  /* Variable: KpSpeed
                                        * Referenced by: '<S1>/Gain1'
                                        */

/* Exported block states */
UserInfo_T G_UserInfo;                 /* '<Root>/Data Store Memory4' */
SEALVerControl_T G_SEALVerControl;     /* '<Root>/Data Store Memory6' */

/* Block signals and states (default storage) */
DW rtDW;

/* External inputs (root inport signals with default storage) */
ExtU rtU;

/* External outputs (root outports fed by signals with default storage) */
ExtY rtY;

/* Model step function */
void CanGetTxMsg(void)
{
  int16_T tmp;
  uint16_T next;
  uint16_T qY;

  /* RootInportFunctionCallGenerator generated from: '<Root>/CanGetTxMsg' incorporates:
   *  SubSystem: '<Root>/Get CAN Msg to transmit'
   */
  /* Outport: '<Root>/y' incorporates:
   *  DataStoreRead: '<S10>/Data Store Read'
   *  MATLAB Function: '<S10>/MATLAB Function'
   */
  rtY.y = rtDW.CANMessage_Init;

  /* MATLAB Function: '<S10>/MATLAB Function' incorporates:
   *  Outport: '<Root>/y'
   */
  if (G_CANCyclicBuf_out.PutCounter != G_CANCyclicBuf_out.FetchCounter) {
    next = (G_CANCyclicBuf_out.FetchCounter & 255U) + 1U;
    rtY.y.CANID = G_CANCyclicBuf_out.CANID[(int16_T)next - 1];
    rtY.y.DataLen = G_CANCyclicBuf_out.DLenAndAttrib[(int16_T)next - 1];
    tmp = (int16_T)(next << 1U);
    rtY.y.MsgData[0] = G_CANCyclicBuf_out.CANQueue[tmp - 2];
    rtY.y.MsgData[1] = G_CANCyclicBuf_out.CANQueue[tmp - 1];
    qY = G_CANCyclicBuf_out.FetchCounter - G_CANCyclicBuf_out.PutCounter;
    if (qY > G_CANCyclicBuf_out.FetchCounter) {
      qY = 0U;
    }

    rtY.y.CANTxCnt = qY - ((qY >> 6U) << 6U);
    G_CANCyclicBuf_out.FetchCounter = next;
  }

  /* End of Outputs for RootInportFunctionCallGenerator generated from: '<Root>/CanGetTxMsg' */
}

/* Model step function */
void CanSetRxMsg(void)
{
  uint16_T b;
  uint16_T next;

  /* RootInportFunctionCallGenerator generated from: '<Root>/CanSetRxMsg' incorporates:
   *  SubSystem: '<Root>/CanSetRcvMsg'
   */
  /* MATLAB Function: '<S4>/MATLAB Function' incorporates:
   *  Inport: '<Root>/RxMsg'
   */
  next = (G_CANCyclicBuf_in.PutCounter & 63U) + 1U;
  if (next != G_CANCyclicBuf_in.FetchCounter) {
    G_CANCyclicBuf_in.CANID[(int16_T)next - 1] = rtU.RxMsg.CANID;
    b = next << 1U;
    G_CANCyclicBuf_in.CANQueue[(int16_T)b - 2] = rtU.RxMsg.MsgData[0];
    G_CANCyclicBuf_in.CANQueue[(int16_T)b - 1] = rtU.RxMsg.MsgData[1];
    G_CANCyclicBuf_in.DLenAndAttrib[(int16_T)next - 1] = rtU.RxMsg.DataLen;
    G_CANCyclicBuf_in.PutCounter = next;
  }

  /* End of MATLAB Function: '<S4>/MATLAB Function' */
  /* End of Outputs for RootInportFunctionCallGenerator generated from: '<Root>/CanSetRxMsg' */
}

/* Model step function */
void EnvSet(void)
{
  /* RootInportFunctionCallGenerator generated from: '<Root>/EnvSet' incorporates:
   *  SubSystem: '<Root>/Function-Call Subsystem1'
   */
  /* DataStoreWrite: '<S8>/Data Store Write' incorporates:
   *  Inport: '<Root>/DrvSetup'
   */
  G_SetupReportBuf = rtU.DrvSetup;

  /* RootInportFunctionCallGenerator generated from: '<Root>/EnvSet' incorporates:
   *  SubSystem: '<Root>/Function-Call Subsystem'
   */
  /* DataStoreWrite: '<S7>/Driver feedback interface' incorporates:
   *  Inport: '<Root>/DrvFeedback'
   */
  G_FeedbackBuf = rtU.DrvFeedback;

  /* RootInportFunctionCallGenerator generated from: '<Root>/EnvSet' incorporates:
   *  SubSystem: '<Root>/Function-Call Subsystem2'
   */
  /* Outport: '<Root>/DrvCommand' incorporates:
   *  DataStoreRead: '<S9>/Driver command interface'
   */
  rtY.DrvCommand = G_DrvCommandBuf;

  /* End of Outputs for RootInportFunctionCallGenerator generated from: '<Root>/EnvSet' */
}

/* Model step function */
void ISR100uController(void)
{
  real_T rtb_Saturation;

  /* RootInportFunctionCallGenerator generated from: '<Root>/ISR100uController' incorporates:
   *  SubSystem: '<Root>/100 usec Periodic controller'
   */
  /* Sum: '<S1>/Sum1' incorporates:
   *  DataStoreRead: '<S1>/Data Store Read1'
   *  DataStoreRead: '<S1>/Data Store Read2'
   *  Gain: '<S1>/Gain'
   *  Sum: '<S1>/Sum'
   */
  rtb_Saturation = ((G_DrvCommandBuf.PositionCommand - (real_T)
                     G_FeedbackBuf.EncoderMain) * Kp +
                    G_DrvCommandBuf.SpeedCommand) -
    G_FeedbackBuf.EncoderMainSpeed;

  /* DiscreteFilter: '<S1>/Discrete Filter' incorporates:
   *  Gain: '<S1>/Gain2'
   */
  rtDW.DiscreteFilter_states = KiSpeed * rtb_Saturation -
    (-rtDW.DiscreteFilter_states);

  /* Sum: '<S1>/Sum2' incorporates:
   *  DiscreteFilter: '<S1>/Discrete Filter'
   *  Gain: '<S1>/Gain1'
   */
  rtb_Saturation = KpSpeed * rtb_Saturation + rtDW.DiscreteFilter_states;

  /* Saturate: '<S1>/Saturation' */
  if (rtb_Saturation > 0.5) {
    /* BusAssignment: '<S1>/Bus Assignment' incorporates:
     *  DataStoreWrite: '<S1>/Data Store Write1'
     */
    G_DrvCommandBuf.CurrentCommand = 0.5;
  } else if (rtb_Saturation < -0.5) {
    /* BusAssignment: '<S1>/Bus Assignment' incorporates:
     *  DataStoreWrite: '<S1>/Data Store Write1'
     */
    G_DrvCommandBuf.CurrentCommand = -0.5;
  } else {
    /* BusAssignment: '<S1>/Bus Assignment' incorporates:
     *  DataStoreWrite: '<S1>/Data Store Write1'
     */
    G_DrvCommandBuf.CurrentCommand = rtb_Saturation;
  }

  /* End of Saturate: '<S1>/Saturation' */
  /* End of Outputs for RootInportFunctionCallGenerator generated from: '<Root>/ISR100uController' */
}

/* Model step function */
void ISR100uProfiler(void)
{
  real_T NewFiltState1;
  real_T NewFiltState2;
  real_T NewFiltState3;
  real_T speed;
  real_T tmp;
  real32_T Delta;
  real32_T ex;
  real32_T pos;
  int16_T b;

  /* RootInportFunctionCallGenerator generated from: '<Root>/ISR100uProfiler' incorporates:
   *  SubSystem: '<Root>/100 usec Periodic profiler'
   */
  /* MATLAB Function: '<S2>/MATLAB Function' */
  if (rtDW.G_PosProfilerData.ProfileDataOk == 0U) {
    Delta = (real32_T)fabs(rtDW.G_PosProfilerState.Speed) -
      rtDW.G_PosProfilerData.Ts * G_SetupReportBuf.AbsoluteAccelerationLimit;
    if (Delta < 0.0F) {
      Delta = 0.0F;
    }

    if (rtDW.G_PosProfilerState.Speed < 0.0) {
      b = -1;
    } else {
      b = (rtDW.G_PosProfilerState.Speed > 0.0);
    }

    Delta *= (real32_T)b;
    pos = (Delta + (real32_T)rtDW.G_PosProfilerState.Speed) *
      rtDW.G_PosProfilerData.Ts * 0.5F + (real32_T)
      rtDW.G_PosProfilerState.Position;
    speed = pos;
    NewFiltState3 = pos;
    NewFiltState2 = pos;
    NewFiltState1 = pos;
  } else {
    Delta = (rtDW.G_PosProfilerData.PositionTarget - (real32_T)
             rtDW.G_PosProfilerState.Position) - (real32_T)
      (rtDW.G_PosProfilerState.Speed * rtDW.G_PosProfilerData.Ts * 0.5);
    b = 1;
    if (Delta < 0.0F) {
      b = -1;
      Delta = -Delta;
      speed = -rtDW.G_PosProfilerState.Speed;
    } else {
      speed = rtDW.G_PosProfilerState.Speed;
    }

    Delta = (real32_T)sqrt(Delta * 2.0F *
      rtDW.G_PosProfilerData.ProfileDeceleration);
    if (speed < Delta) {
      pos = rtDW.G_PosProfilerData.Ts *
        rtDW.G_PosProfilerData.ProfileDeceleration;
      ex = (real32_T)speed;
      if ((real32_T)speed > pos) {
        ex = pos;
      }

      if (ex > rtDW.G_PosProfilerData.ProfileSpeed) {
        ex = rtDW.G_PosProfilerData.ProfileSpeed;
      }

      if (ex > Delta) {
        ex = Delta;
      }
    } else {
      ex = (real32_T)speed - rtDW.G_PosProfilerData.Ts *
        rtDW.G_PosProfilerData.ProfileDeceleration * 1.02F;
      if (Delta >= ex) {
        ex = Delta;
      }
    }

    Delta = ex * (real32_T)b;
    pos = (Delta + (real32_T)rtDW.G_PosProfilerState.Speed) *
      rtDW.G_PosProfilerData.Ts * 0.5F + (real32_T)
      rtDW.G_PosProfilerState.Position;
    speed = rtDW.G_PosProfilerState.FiltState[2];
    NewFiltState3 = rtDW.G_PosProfilerState.FiltState[1];
    NewFiltState2 = rtDW.G_PosProfilerState.FiltState[0];
    NewFiltState1 = -((rtDW.G_PosProfilerState.FiltState[0] *
                       rtDW.G_PosProfilerData.ProfileFilterDen[1] +
                       rtDW.G_PosProfilerState.FiltState[1] *
                       rtDW.G_PosProfilerData.ProfileFilterDen[2]) +
                      rtDW.G_PosProfilerState.FiltState[2] *
                      rtDW.G_PosProfilerData.ProfileFilterDen[3]) + pos *
      rtDW.G_PosProfilerData.ProfileFilterNum;
  }

  rtDW.G_PosProfilerState.Position = pos;
  rtDW.G_PosProfilerState.Speed = Delta;
  if (rtDW.G_PosProfilerData.Ts >= 1.0E-5) {
    tmp = rtDW.G_PosProfilerData.Ts;
  } else {
    tmp = 1.0E-5;
  }

  /* BusAssignment: '<S2>/Bus Assignment' incorporates:
   *  DataStoreWrite: '<S2>/Data Store Write1'
   *  MATLAB Function: '<S2>/MATLAB Function'
   */
  G_DrvCommandBuf.SpeedCommand = (NewFiltState1 -
    rtDW.G_PosProfilerState.FiltState[0]) / tmp;

  /* MATLAB Function: '<S2>/MATLAB Function' */
  rtDW.G_PosProfilerState.FiltState[0] = NewFiltState1;
  rtDW.G_PosProfilerState.FiltState[1] = NewFiltState2;
  rtDW.G_PosProfilerState.FiltState[2] = NewFiltState3;
  rtDW.G_PosProfilerState.FiltState[3] = speed;

  /* BusAssignment: '<S2>/Bus Assignment' incorporates:
   *  DataStoreWrite: '<S2>/Data Store Write1'
   *  MATLAB Function: '<S2>/MATLAB Function'
   */
  G_DrvCommandBuf.PositionCommand = NewFiltState1;
  G_DrvCommandBuf.CurrentCommand = 0.0;

  /* End of Outputs for RootInportFunctionCallGenerator generated from: '<Root>/ISR100uProfiler' */
}

/* Model step function */
void IdleLoopCAN(void)
{
  int16_T cnt;
  uint16_T nextput;
  uint16_T nfetch;
  uint16_T nmsgGet;
  uint16_T nmsgPut;
  uint16_T nput;
  boolean_T exitg1;

  /* RootInportFunctionCallGenerator generated from: '<Root>/IdleLoopCAN' incorporates:
   *  SubSystem: '<Root>/Idle process CAN interpreter'
   */
  /* MATLAB Function: '<S11>/CAN message response' */
  if (G_CANCyclicBuf_in.PutCounter != G_CANCyclicBuf_in.FetchCounter) {
    cnt = 0;
    exitg1 = false;
    while ((!exitg1) && (cnt < 3)) {
      nfetch = (G_CANCyclicBuf_in.FetchCounter & 63U) + 1U;
      nput = (G_CANCyclicBuf_out.PutCounter & 63U) + 1U;
      nextput = (nput + 1U) & 63U;
      if (nextput == G_CANCyclicBuf_out.FetchCounter) {
        exitg1 = true;
      } else {
        nmsgGet = (nfetch << 1U) - 1U;
        nmsgPut = (nput << 1U) - 1U;
        G_CANCyclicBuf_out.CANID[(int16_T)nput - 1] = G_CANCyclicBuf_in.CANID
          [(int16_T)nfetch - 1];
        G_CANCyclicBuf_out.DLenAndAttrib[(int16_T)nput - 1] =
          G_CANCyclicBuf_in.DLenAndAttrib[(int16_T)nfetch - 1];
        G_CANCyclicBuf_out.CANQueue[(int16_T)nmsgPut - 1] =
          G_CANCyclicBuf_in.CANQueue[(int16_T)nmsgGet - 1];
        G_CANCyclicBuf_out.CANQueue[(int16_T)nmsgPut] =
          G_CANCyclicBuf_in.CANQueue[(int16_T)nmsgGet];
        G_CANCyclicBuf_out.PutCounter = nextput;
        G_CANCyclicBuf_in.FetchCounter = (nfetch + 1U) & 63U;
        if (G_CANCyclicBuf_in.PutCounter == G_CANCyclicBuf_in.FetchCounter) {
          exitg1 = true;
        } else {
          cnt++;
        }
      }
    }
  }

  /* End of MATLAB Function: '<S11>/CAN message response' */
  /* End of Outputs for RootInportFunctionCallGenerator generated from: '<Root>/IdleLoopCAN' */
}

/* Model step function */
void IdleLoopUART(void)
{
  real_T Mantissa;
  real_T n;
  real_T nafterPeriod;
  real_T tmp_0;
  int32_T exitg1;
  int32_T exitg2;
  uint32_T tmp;
  int16_T cnt;
  int16_T sgnExp;
  int16_T sgnMant;
  uint16_T PeriodPos;
  uint16_T WasPeriod;
  uint16_T b_c;
  uint16_T gotArrayIndex;
  uint16_T isExp;
  uint16_T nmsgGet;
  boolean_T exitg3;
  boolean_T guard1;
  boolean_T guard2;

  /* RootInportFunctionCallGenerator generated from: '<Root>/IdleLoopUART' incorporates:
   *  SubSystem: '<Root>/Idle process UART interpreter'
   */
  /* MATLAB Function: '<S12>/UART message response' */
  cnt = 0;
  while ((cnt < 10) && (G_UartCyclicBuf_in.PutCounter !=
                        G_UartCyclicBuf_in.FetchCounter)) {
    nmsgGet = G_UartCyclicBuf_in.FetchCounter & 255U;
    G_UartCyclicBuf_in.FetchCounter = (nmsgGet + 1U) & 255U;
    if (G_UartCyclicBuf_in.UartError != 0U) {
      G_UartCyclicBuf_in.UartError = 0U;
      G_MicroInterp.InterpretError = 3U;
    } else {
      nmsgGet = G_UartCyclicBuf_in.UARTQueue[(int16_T)nmsgGet];
      if (nmsgGet == 59U) {
        G_MicroInterp.NewString = G_MicroInterp.cnt;
      } else {
        if (G_MicroInterp.NewString != 0U) {
          G_MicroInterp.cnt = 0U;
          G_MicroInterp.InterpretError = 0U;
        }

        if (G_MicroInterp.InterpretError == 0U) {
          if ((nmsgGet <= 122U) && (nmsgGet >= 97U)) {
            nmsgGet -= 32U;
          }

          if (((nmsgGet < 9U) || (nmsgGet > 13U)) && (nmsgGet != 32U) &&
              (nmsgGet != 43U)) {
            if (G_MicroInterp.cnt >= 64U) {
              G_MicroInterp.InterpretError = 2U;
            }

            if (((nmsgGet <= 90U) && (nmsgGet >= 65U)) || ((nmsgGet <= 57U) &&
                 (nmsgGet >= 48U)) || (nmsgGet == 45U) || (nmsgGet == 61U)) {
              b_c = G_MicroInterp.cnt + 1U;
              if (G_MicroInterp.cnt + 1U < G_MicroInterp.cnt) {
                b_c = MAX_uint16_T;
              }

              G_MicroInterp.cnt = b_c;
            } else {
              G_MicroInterp.InterpretError = 1U;
            }
          }
        }
      }

      if (G_MicroInterp.NewString != 0U) {
        G_MicroInterp.NewString = 0U;
        if (G_MicroInterp.cnt >= 2U) {
          if ((G_MicroInterp.TempString[0] < 65U) || (G_MicroInterp.TempString[0]
               > 90U) || (G_MicroInterp.TempString[1] < 65U) ||
              (G_MicroInterp.TempString[1] > 90U)) {
            G_MicroInterp.InterpretError = 10U;
          } else {
            G_MicroInterp.IsGetFunc = 1U;
            G_MicroInterp.ArrayIndex = 1U;
            tmp = G_MicroInterp.TempString[0] * 26UL;
            if (tmp > 65535UL) {
              tmp = 65535UL;
            }

            b_c = (uint16_T)tmp + G_MicroInterp.TempString[1];
            if (b_c < (uint16_T)tmp) {
              b_c = MAX_uint16_T;
            }

            G_MicroInterp.MnemonicIndex = b_c;
            if (G_MicroInterp.cnt <= 2U) {
            } else {
              nmsgGet = 3U;
              guard1 = false;
              guard2 = false;
              if (G_MicroInterp.TempString[2] == 91U) {
                gotArrayIndex = 0U;
                G_MicroInterp.ArrayIndex = 0U;
                isExp = 4U;
                do {
                  exitg2 = 0L;
                  if (isExp <= G_MicroInterp.cnt) {
                    b_c = G_MicroInterp.TempString[(int16_T)isExp - 1];
                    if (b_c == 93U) {
                      if (G_MicroInterp.ArrayIndex == 0U) {
                        G_MicroInterp.InterpretError = 11U;
                        exitg2 = 1L;
                      } else {
                        nmsgGet = isExp + 1U;
                        if (isExp + 1U < isExp) {
                          nmsgGet = MAX_uint16_T;
                        }

                        gotArrayIndex = 1U;
                        isExp++;
                      }
                    } else {
                      b_c &= 255U;
                      if ((b_c < 48U) || (b_c > 57U)) {
                        G_MicroInterp.InterpretError = 12U;
                        exitg2 = 1L;
                      } else {
                        G_MicroInterp.ArrayIndex = ((G_MicroInterp.ArrayIndex &
                          31U) * 10U + b_c) - 48U;
                        isExp++;
                      }
                    }
                  } else {
                    exitg2 = 2L;
                  }
                } while (exitg2 == 0L);

                if (exitg2 == 1L) {
                } else if (gotArrayIndex == 0U) {
                  G_MicroInterp.InterpretError = 14U;
                } else {
                  guard2 = true;
                }
              } else {
                guard2 = true;
              }

              if (guard2) {
                if (G_MicroInterp.cnt < nmsgGet) {
                } else if (G_MicroInterp.TempString[(int16_T)nmsgGet - 1] != 61U)
                {
                  G_MicroInterp.InterpretError = 15U;
                } else {
                  b_c = nmsgGet + 1U;
                  if (nmsgGet + 1U < nmsgGet) {
                    b_c = MAX_uint16_T;
                  }

                  nmsgGet = b_c;
                  Mantissa = 0.0;
                  gotArrayIndex = 0U;
                  sgnMant = 1;
                  sgnExp = 1;
                  isExp = 0U;
                  if (G_MicroInterp.cnt < b_c) {
                    G_MicroInterp.InterpretError = 16U;
                  } else if (G_MicroInterp.TempString[(int16_T)b_c - 1] == 45U)
                  {
                    sgnMant = -1;
                    nmsgGet = b_c + 1U;
                    if (b_c + 1U < b_c) {
                      nmsgGet = MAX_uint16_T;
                    }

                    if (G_MicroInterp.cnt < nmsgGet) {
                      G_MicroInterp.InterpretError = 17U;
                    } else {
                      guard1 = true;
                    }
                  } else {
                    guard1 = true;
                  }
                }
              }

              if (guard1) {
                WasPeriod = 0U;
                PeriodPos = 0U;
                do {
                  exitg1 = 0L;
                  if (nmsgGet <= G_MicroInterp.cnt) {
                    b_c = G_MicroInterp.TempString[(int16_T)nmsgGet - 1] & 255U;
                    if (isExp == 0U) {
                      if ((b_c >= 48U) && (b_c <= 57U)) {
                        Mantissa = Mantissa * 10.0 + (real_T)b_c;
                        b_c = nmsgGet + 1U;
                        if (nmsgGet + 1U < nmsgGet) {
                          b_c = MAX_uint16_T;
                        }

                        nmsgGet = b_c;
                        if (WasPeriod != 0U) {
                          b_c = PeriodPos + 1U;
                          if (PeriodPos + 1U < PeriodPos) {
                            b_c = MAX_uint16_T;
                          }

                          PeriodPos = b_c;
                        }
                      } else if (b_c == 46U) {
                        WasPeriod = 1U;
                      } else if (b_c == 69U) {
                        b_c = nmsgGet + 1U;
                        if (nmsgGet + 1U < nmsgGet) {
                          b_c = MAX_uint16_T;
                        }

                        nmsgGet = b_c;
                        isExp = 1U;
                        if (b_c > G_MicroInterp.cnt) {
                          G_MicroInterp.InterpretError = 19U;
                          exitg1 = 1L;
                        } else if (G_MicroInterp.TempString[(int16_T)b_c - 1] ==
                                   45U) {
                          sgnExp = -1;
                          nmsgGet = b_c + 1U;
                          if (b_c + 1U < b_c) {
                            nmsgGet = MAX_uint16_T;
                          }

                          if (nmsgGet > G_MicroInterp.cnt) {
                            G_MicroInterp.InterpretError = 20U;
                            exitg1 = 1L;
                          }
                        }
                      } else {
                        G_MicroInterp.InterpretError = 18U;
                        exitg1 = 1L;
                      }
                    } else if ((b_c >= 48U) && (b_c <= 57U)) {
                      gotArrayIndex = (gotArrayIndex & 511U) * 10U + b_c;
                      b_c = nmsgGet + 1U;
                      if (nmsgGet + 1U < nmsgGet) {
                        b_c = MAX_uint16_T;
                      }

                      nmsgGet = b_c;
                    } else {
                      G_MicroInterp.InterpretError = 21U;
                      exitg1 = 1L;
                    }
                  } else {
                    if (WasPeriod != 0U) {
                      Mantissa /= (real32_T)pow(10.0, PeriodPos);
                    }

                    G_MicroInterp.Argument = Mantissa * (real_T)sgnMant;
                    if (isExp != 0U) {
                      G_MicroInterp.Argument *= (real32_T)pow(10.0, sgnExp *
                        (int16_T)gotArrayIndex);
                    }

                    exitg1 = 1L;
                  }
                } while (exitg1 == 0L);
              }
            }
          }
        }

        if (G_MicroInterp.InterpretError == 0U) {
          if (G_MicroInterp.MnemonicIndex == 390U) {
            if (G_MicroInterp.IsGetFunc != 0U) {
              G_MicroInterp.Argument = 0.0;
            } else {
              G_MicroInterp.InterpretError = 0U;
            }
          } else {
            G_MicroInterp.InterpretError = 22U;
            G_MicroInterp.TempString[0] = 69U;
            G_MicroInterp.TempString[1] = 82U;
            G_MicroInterp.TempString[2] = 82U;
            G_MicroInterp.TempString[3] = 79U;
            G_MicroInterp.TempString[4] = 82U;
            G_MicroInterp.TempString[5] = 58U;
            G_MicroInterp.cnt = 6U;
            nmsgGet = 22U;
            while (nmsgGet != 0U) {
              b_c = G_MicroInterp.cnt + 1U;
              if (G_MicroInterp.cnt + 1U < G_MicroInterp.cnt) {
                b_c = MAX_uint16_T;
              }

              G_MicroInterp.cnt = b_c;
              b_c = nmsgGet - nmsgGet / 10U * 10U;
              G_MicroInterp.TempString[(int16_T)G_MicroInterp.cnt - 1] = b_c +
                48U;
              if (b_c + 48U < b_c) {
                G_MicroInterp.TempString[(int16_T)G_MicroInterp.cnt - 1] =
                  MAX_uint16_T;
              }

              b_c = nmsgGet - b_c;
              if (b_c > nmsgGet) {
                b_c = 0U;
              }

              nmsgGet = b_c;
            }
          }

          if (G_MicroInterp.IsGetFunc != 0U) {
            Mantissa = log10(G_MicroInterp.Argument);
            if (Mantissa < 0.0) {
              n = ceil(Mantissa);
            } else {
              n = floor(Mantissa);
            }

            sgnMant = 0;
            sgnExp = 0;
            Mantissa = G_MicroInterp.Argument;
            if ((n > 8.0) || (n < -8.0)) {
              nafterPeriod = 8.0 - n;
            } else {
              nafterPeriod = 6.0;
              sgnExp = 1;
              if (n < 32768.0) {
                sgnMant = (int16_T)n;
              } else {
                sgnMant = MAX_int16_T;
              }

              Mantissa = G_MicroInterp.Argument * pow(10.0, -n);
            }

            if (Mantissa < 0.0) {
              n = ceil(Mantissa);
            } else {
              n = floor(Mantissa);
            }

            while (n != 0.0) {
              b_c = G_MicroInterp.cnt + 1U;
              if (G_MicroInterp.cnt + 1U < G_MicroInterp.cnt) {
                b_c = MAX_uint16_T;
              }

              G_MicroInterp.cnt = b_c;
              tmp_0 = rt_roundd(mod_CTxUEiaB(n));
              if (tmp_0 < 65536.0) {
                if (tmp_0 >= 0.0) {
                  nmsgGet = (uint16_T)tmp_0;
                } else {
                  nmsgGet = 0U;
                }
              } else {
                nmsgGet = MAX_uint16_T;
              }

              G_MicroInterp.TempString[(int16_T)G_MicroInterp.cnt - 1] = nmsgGet
                + 48U;
              if (nmsgGet + 48U < nmsgGet) {
                G_MicroInterp.TempString[(int16_T)G_MicroInterp.cnt - 1] =
                  MAX_uint16_T;
              }

              n -= (real_T)nmsgGet;
            }

            if (nafterPeriod > 0.0) {
              b_c = G_MicroInterp.cnt + 1U;
              if (G_MicroInterp.cnt + 1U < G_MicroInterp.cnt) {
                b_c = MAX_uint16_T;
              }

              G_MicroInterp.cnt = b_c;
              G_MicroInterp.TempString[(int16_T)G_MicroInterp.cnt - 1] = 46U;
              Mantissa *= pow(10.0, nafterPeriod);
              if (Mantissa < 0.0) {
                n = ceil(Mantissa);
              } else {
                n = floor(Mantissa);
              }

              while (n != 0.0) {
                b_c = G_MicroInterp.cnt + 1U;
                if (G_MicroInterp.cnt + 1U < G_MicroInterp.cnt) {
                  b_c = MAX_uint16_T;
                }

                G_MicroInterp.cnt = b_c;
                tmp_0 = rt_roundd(mod_CTxUEiaB(n));
                if (tmp_0 < 65536.0) {
                  if (tmp_0 >= 0.0) {
                    nmsgGet = (uint16_T)tmp_0;
                  } else {
                    nmsgGet = 0U;
                  }
                } else {
                  nmsgGet = MAX_uint16_T;
                }

                G_MicroInterp.TempString[(int16_T)G_MicroInterp.cnt - 1] =
                  nmsgGet + 48U;
                if (nmsgGet + 48U < nmsgGet) {
                  G_MicroInterp.TempString[(int16_T)G_MicroInterp.cnt - 1] =
                    MAX_uint16_T;
                }

                n -= (real_T)nmsgGet;
              }
            }

            if ((sgnExp != 0) && (sgnMant != 0)) {
              b_c = G_MicroInterp.cnt + 1U;
              if (G_MicroInterp.cnt + 1U < G_MicroInterp.cnt) {
                b_c = MAX_uint16_T;
              }

              G_MicroInterp.cnt = b_c;
              G_MicroInterp.TempString[(int16_T)G_MicroInterp.cnt - 1] = 69U;
              if (sgnMant < 0) {
                b_c = G_MicroInterp.cnt + 1U;
                if (G_MicroInterp.cnt + 1U < G_MicroInterp.cnt) {
                  b_c = MAX_uint16_T;
                }

                G_MicroInterp.cnt = b_c;
                G_MicroInterp.TempString[(int16_T)G_MicroInterp.cnt - 1] = 45U;
                sgnMant = -sgnMant;
              }

              while (sgnMant != 0) {
                b_c = G_MicroInterp.cnt + 1U;
                if (G_MicroInterp.cnt + 1U < G_MicroInterp.cnt) {
                  b_c = MAX_uint16_T;
                }

                G_MicroInterp.cnt = b_c;
                sgnExp = sgnMant - div_nde_s16_floor(sgnMant, 10) * 10;
                if (sgnExp < 0) {
                  sgnExp = 0;
                }

                G_MicroInterp.TempString[(int16_T)G_MicroInterp.cnt - 1] =
                  (uint16_T)sgnExp + 48U;
                if ((sgnMant >= 0) && (sgnExp < sgnMant - MAX_int16_T)) {
                  sgnMant = MAX_int16_T;
                } else if ((sgnMant < 0) && (sgnExp > sgnMant - MIN_int16_T)) {
                  sgnMant = MIN_int16_T;
                } else {
                  sgnMant -= sgnExp;
                }
              }
            }
          }

          sgnMant = 0;
          exitg3 = false;
          while ((!exitg3) && (sgnMant <= (int16_T)G_MicroInterp.cnt - 1)) {
            nmsgGet = G_UartCyclicBuf_out.PutCounter & 255U;
            b_c = (nmsgGet + 1U) & 255U;
            if (b_c == G_UartCyclicBuf_out.FetchCounter) {
              exitg3 = true;
            } else {
              G_UartCyclicBuf_out.UARTQueue[(int16_T)nmsgGet] =
                G_MicroInterp.TempString[sgnMant];
              G_UartCyclicBuf_out.PutCounter = b_c;
              sgnMant++;
            }
          }
        }
      }
    }

    cnt++;
  }

  /* End of MATLAB Function: '<S12>/UART message response' */
  /* End of Outputs for RootInportFunctionCallGenerator generated from: '<Root>/IdleLoopUART' */
}

/* Model step function */
void SetupDrive(void)
{
  real_T b_value;
  int32_T retCode;

  /* RootInportFunctionCallGenerator generated from: '<Root>/SetupDrive' incorporates:
   *  SubSystem: '<Root>/Drive configuration'
   */
  /* MATLAB Function: '<S6>/MATLAB Function' */
  retCode = 0L;
  SetObject2Drive(24816U, 1U, 150000.0, T_uint32, &retCode);
  retCode = 0L;
  b_value = 0.0;
  GetObjectFromDrive(24816U, 1U, T_uint32, &b_value, &retCode);
  G_UserInfo.junk1 = (real32_T)b_value;

  /* End of Outputs for RootInportFunctionCallGenerator generated from: '<Root>/SetupDrive' */
}

/* Model step function */
void UartAddChar(void)
{
  uint16_T next;

  /* RootInportFunctionCallGenerator generated from: '<Root>/UartAddChar' incorporates:
   *  SubSystem: '<Root>/Add char to UART'
   */
  /* MATLAB Function: '<S3>/Accept character' incorporates:
   *  Inport: '<Root>/u'
   */
  next = (G_UartCyclicBuf_in.PutCounter & 255U) + 1U;
  if (next == G_UartCyclicBuf_in.FetchCounter) {
    G_UartCyclicBuf_in.UartError = 1U;
  } else {
    G_UartCyclicBuf_in.UARTQueue[(int16_T)G_UartCyclicBuf_in.PutCounter - 1] =
      rtU.u;
    G_UartCyclicBuf_in.PutCounter = next;
  }

  /* End of MATLAB Function: '<S3>/Accept character' */
  /* End of Outputs for RootInportFunctionCallGenerator generated from: '<Root>/UartAddChar' */
}

/* Model step function */
void UartGetChar(void)
{
  uint16_T next;

  /* RootInportFunctionCallGenerator generated from: '<Root>/UartGetChar' incorporates:
   *  SubSystem: '<Root>/Remove UART char for Tx'
   */
  /* Outport: '<Root>/Out1' incorporates:
   *  MATLAB Function: '<S13>/MATLAB Function'
   */
  rtY.Out1 = 0U;

  /* MATLAB Function: '<S13>/MATLAB Function' */
  if (G_UartCyclicBuf_out.PutCounter != G_UartCyclicBuf_out.FetchCounter) {
    next = (G_UartCyclicBuf_out.FetchCounter & 255U) + 1U;

    /* Outport: '<Root>/Out1' */
    rtY.Out1 = G_UartCyclicBuf_out.UARTQueue[(int16_T)next - 1];
    G_UartCyclicBuf_out.FetchCounter = next;
  }

  /* End of Outputs for RootInportFunctionCallGenerator generated from: '<Root>/UartGetChar' */
}

/* Model initialize function */
void Seal_initialize(void)
{
  /* Start for DataStoreMemory: '<Root>/Data Store Memory6' */
  G_SEALVerControl = SEALVerControl_init;

  /* Start for DataStoreMemory: '<Root>/Data Store Memory2' */
  rtDW.G_PosProfilerData = PosProfilerData_init;

  /* Start for DataStoreMemory: '<Root>/Data Store Memory5' */
  rtDW.G_PosProfilerState = PosProfilerState_init;
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
