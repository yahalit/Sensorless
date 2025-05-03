/*
 * ClaDefs.h
 *
 *  Created on: Jun 25, 2023
 *      Author: yahal
 */

#ifndef DRIVERS_CLADEFS_H_
#define DRIVERS_CLADEFS_H_
typedef float FLOAT;
#define RT_APP 1

#ifdef CLA_VAR_OWNER
#define EXTERN_CLA
#pragma DATA_SECTION(ClaMailIn, "CpuToCla1MsgRAM");
#pragma DATA_SECTION(ClaMailOut, "Cla1ToCpuMsgRAM");
#pragma DATA_SECTION(ClaState, "cla_shared");
#pragma DATA_SECTION(ClaControlPars, "cla_shared");
#pragma DATA_SECTION(Calib, "cla_shared");
#pragma DATA_SECTION(ClaRecs, "Cla1ToDmaMsgRAM");

#else
#define EXTERN_CLA extern
#endif

enum E_SysMode
{
    E_SysConvModeNothing = 1 , // Inactive
    E_SysConvModeManual = 2 , // Controlled directly over CAN by GUI
    E_SysConvModeAutomatic  = 3 , // Controlled by the PVS controller
    E_SysConvModeFault       = -1, // At fault
};




struct CClaControlPars
{
    FLOAT VdcMaxTrip ;
    FLOAT VdcMinTrip ;
    FLOAT VoutTrip ;
    FLOAT ISenseTrip;
    FLOAT VdcMax ;
    FLOAT VdcMin ;
    FLOAT VdcBit2Volt ;
    FLOAT VoutMax ;
    FLOAT TxCurrentBit2Volt ;
    FLOAT ISenseMax; // Unused parameter
    FLOAT ISenseBit2Amp;
    FLOAT ILoadBit2Amp;
    FLOAT TemperatureMax ;
    FLOAT VoltRefStepLimit ;
    FLOAT OpenDutyStepLimit ;
    FLOAT FILTc ;
    FLOAT LOverT ;
    FLOAT Imax ;
    FLOAT Imin ;
    FLOAT BuckInductance ;
    FLOAT PwmFrame ;
    FLOAT PwmFrameHalf ;
    FLOAT Ts ;
    FLOAT VdcStartShunt ;
    FLOAT ShuntDutyPerVolt ;
    FLOAT VoutBit2Volt ; // Conversion from Bit of output voltage to actual voltage
    FLOAT VLoadBit2Volt  ; // Conversion from Bit of input voltage to actual voltage
    FLOAT VGateDriveMin ; // Minimal voltage for safe gate drive
    FLOAT OneOverNsampInPWM ;
    float NsampInPWM ;
    FLOAT ShuntMaxWatts ;
    float One ;
};


EXTERN_CLA struct CClaControlPars ClaControlPars ;


struct CClaTiming
{
    FLOAT Ts ;
    long unsigned UsecTimer ;
    long unsigned IntCntr ;
    short unsigned PwmFrame ;
    FLOAT AutoCommandAge ;
    FLOAT InvMhz ;
};

struct CAnalogs
{
    FLOAT Vdc ;
    FLOAT ILoad ;
    FLOAT Isense ;
    FLOAT Vout ;
    FLOAT Vload ; // Input voltage (at the connector, of driving servo)
    FLOAT Voutdot ;
    FLOAT VoutdotRaw ;
    FLOAT V12Mon ;
    FLOAT V3p3Mon ;
    FLOAT VerIdVolt ;
    FLOAT Temperature ;
};


struct CVoltageControl
{
     FLOAT VoltCmdFiltered ;
     FLOAT PhaseVolt ;
     FLOAT Cur ;
     FLOAT InvBusVoltage;
     FLOAT d  ;
     FLOAT dr ;
     FLOAT dmax ;
     FLOAT dmin ;
     //FLOAT ConverterOnCnt ;
     short unsigned intwidth1 ;
     short unsigned intwidth2 ;
};


struct CCurrentControl
{
//    FLOAT CurrentDemand;
    FLOAT VoltageDemand;
};


struct CClaState
{
    struct CClaTiming Timing    ;
    struct CAnalogs Analogs  ;
    //struct CAnalogs Filt     ;
    struct CVoltageControl VoltageControl ;
    struct CCurrentControl CurrentControl ;
    FLOAT OpenDutyRef ; // Substitution for open loop PWM duty
    FLOAT OpenDutySet  ; // Substitution for open loop PWM duty
    FLOAT fDebug[8] ;
    FLOAT lDebug[8] ;
    //FLOAT MotFail ;
    FLOAT ConverterReady ;
    FLOAT ConverterOnRequest ; // !< Request to set the conversion ON
    FLOAT ConverterOnRequestOld ; // !< Old version of Request to set the conversion ON
    FLOAT DbgStop ;
    FLOAT DbgStop2 ;
    FLOAT ConverterOn ;
    FLOAT ShuntDuty ;
    FLOAT ShuntRawPower ;
    FLOAT ShuntFiltPower ;
    FLOAT CompareCode; // 1 for normal operation; 16.0 prevents accidental driver activation
    FLOAT IsenseOnTrip ;
    short unsigned Adc3V3 ;
    short unsigned Adc12V ;
    short unsigned AdcTemp;
    long unsigned TzFlag ;
    short unsigned NotRdy ;
    long  unsigned PwmAtEntrySamp ; // Sample the PWM at entry, just to know how much time ADC sampling takes
    long unsigned  IsrTicks  ; // Sample the PWM at entry, just to know how much time ADC sampling takes
    //long unsigned  IsrTicks1  ; // Sample the PWM at entry, just to know how much time ADC sampling takes
    long unsigned  IsrTicks2  ; // Sample the PWM at entry, just to know how much time ADC sampling takes
    //long unsigned  IsrTicks3  ; // Sample the PWM at entry, just to know how much time ADC sampling takes
    float  nSampler  ;
    //long unsigned    nCoarseSamplerInt   ;
    //long unsigned    nCoarseSamplerExt   ;
    //FLOAT ILoadAvg ;
    //FLOAT VLoadAvg ;
    //FLOAT ILoadAvg8 ;
    //FLOAT VLoadAvg8 ;
    FLOAT ILoadSum ;
    FLOAT VLoadSum ;
    //FLOAT ILoadSum8 ;
    //FLOAT VLoadSum8 ;
    FLOAT DacVal ;
    FLOAT ConverterMode ; // Flag to set open loop PWM control
    FLOAT ILoadOffset ;
    FLOAT ILoadBit2Amp ;
    FLOAT VOutOffset ;
    FLOAT VLoadOffset ;
    FLOAT VOutBit2Amp;
    FLOAT VLoadBit2Volt;
    FLOAT ISenseffset;
    FLOAT ISenseBit2Amp;
    FLOAT Kv ;
    FLOAT Kc ;
    FLOAT PwmFrameLimit;
    FLOAT dDebt;
    FLOAT Num2048;
    FLOAT DacTrackingCoeff;
    FLOAT Integrator2VloadGain ;
    float VRefInc ;
    float VRefIncCnt ;
    float VRef ;
    long  IntPwmFrame ;
    long  Num1L ;
} ;


EXTERN_CLA volatile struct CClaState ClaState ;

struct CClaMailIn
{
    float VRefInc ;
    float VRef ;
    FLOAT AutoShuntDisable ;
};
EXTERN_CLA struct CClaMailIn ClaMailIn ;


struct CSimSampIn
{
    FLOAT VLoad     ; // Un calibrated version
    FLOAT ILoad     ;
};

struct CClaMailOut
{
    //long AbortCounter ;
    //long unsigned SwUpdateFlag   ;
    long unsigned IntCntr ;
    FLOAT OverVoltage;
    FLOAT UnderVoltage ;
    //short unsigned AbortReason ;
    long  unsigned nCoarseSamplerExt ;
    struct CSimSampIn SimSampIn ;
};
EXTERN_CLA volatile struct CClaMailOut ClaMailOut ;

struct CCalib
{
    long  PassWord ; // A password replica
    FLOAT VoutGain ;
    FLOAT VoutOffset ;
    FLOAT ILoadGain ;
    FLOAT ILoadOffset ;
    FLOAT ISenseGain ;
    FLOAT ISenseOffset ;
    FLOAT VLoadGain ;
    FLOAT VLoadOffset ;
    FLOAT VdotGain ;
    FLOAT VdotOffset ;
    FLOAT CalibSpareFloat[9] ;
    FLOAT CalibSpareLong[5]   ;
    long  CalibDate       ; // !< Calibration revision date
    long  CalibData       ; // !< Calibration additional revision data
    long  Password0x12345678 ; // !< Must be 0x12345678
    long  cs ; // !< Long checksum
};


EXTERN_CLA struct CCalib Calib ;

// Struct for the ultrafast recorder
struct CClaRecs
{
    float Vload ;
    float Vout  ;
    float Isense ;
    float Iload  ;
    float Vdc  ;
    float d ;
    float Vref ;
    float CurrentDemand ;
};

EXTERN_CLA struct CClaRecs ClaRecs ;


#endif /* DRIVERS_CLADEFS_H_ */
