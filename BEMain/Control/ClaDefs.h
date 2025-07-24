
#ifndef CONTROL_CLADEFS_H_
#define CONTROL_CLADEFS_H_

#include "..\SelfTest\ErrorCodes.h"
#include "..\Application\HwConfig.h"
//#include "..\Application\Revisions.h"

enum E_SysMode
{
    E_SysMotionModeNothing = 1 ,
    E_SysMotionModeManual = 2 ,
    E_SysMotionModeAutomatic  = 3 ,
    E_SysMotionModeFault       = -1, // Reported as 7
    E_SysMotionModeSafeFault = -2    // Reported as 6
};


struct CClaConst
{
    float piOver32 ;
    float Halfsqrt3 ;
    float sqrt3 ;
    float OneOver3GoodBehavior ;
    float TwoThirds ;
    float OneOverTwoPi ;
    float TwoPi ;
    float Num2048  ;
    float Num2732 ;
    float Num3072  ;
    float Num4096  ;
    float Num1p65 ;
    float Vres2Vphase ;
    float Adc2Volt ;
    float Volt2Adc ;
    float Amc2Amp  ;
    float Hall2Amp  ;
    long UnsignedLong1 ;
    long UnsignedLong2 ;
    long UnsignedLong3 ;
    long UnsignedLong4 ;
};

struct CClaMailIn
{
    float arg ;
    float ThetaElect ;
    float IaOffset ;
    float IbOffset ;
    float IcOffset ;
    float IaOffsetAmc ;
    float IbOffsetAmc ;
    float IcOffsetAmc ;
    float v_dbg_angle;
    float v_dbg_amp;
    float Ts ;
    float Tref ; // Output of T reference generator   To NECK
    float Gref ; // Output of G reference generator
    float IdMode ; // Current loop identification mode if 1
    float CurPrefiltA1;
    float CurPrefiltB ;
    float bNoCurrentPrefilter ; // Non zero to inhibit current prefilter
    float StoTholdScale ; // Scaes the threshold voltage of STO
    float ExperimentCurrentThold ;
    float ExperimentMode ;
#ifndef SIMULATION_MODE
    float vOpenLoopTestA ;
    float vOpenLoopTestB ;
    float vOpenLoopTestC ;
#endif
    short PhaseIndexIn   ;
    short PhaseIndexOut  ;
};


struct CClaMailOut
{
    float UnderVoltage ;
    float OverVoltage  ;
    long  AbortReason  ;
    long  NotReadyReason ; // !< Reason why servo is not ready
    long  AbortCounter ;
    //float MotorReady ;
    float StoEvent   ;
    float PwmA ;
    float PwmB ;
    float PwmC ;
    float vq_and_d  ;
};

struct CClaControlPars
{
    float SpeedFilterCst ;
    float Rev2Pos  ; // !< Scale revolutions to position units
    float Pos2Rev  ; // !< Scale position units to revolutions
    float InvEncoderCountsFullRev ; // !< Inverse Encoder Resolution count/rev
    float Vdc2Bit2Volt ; // !< Scale ADC to bus voltage
    float Adc2BusAmps ; // !< Scale ADC to bus Amperes
    float MaxCurCmdDdt ; //  !< Maximum permissible rate for current command
    float KeHz ; // !< Speed to required motor voltage
    float KpCur ; // !< Kp for current control
    float KiCur ;  // !< Ki for current control
    float KAWUCur ; // !< Anti windup for current control
    float VectorSatFac ; // !< Vector saturation factor
    float nPolePairs ; // Number of pole pairs
    float OneOverPP     ;
    float VDcMax ; // !< Maximum for VDC
    float VDcMin ; // !< Minimum for VDC
    float StoWarnThold ; // !< Warning threshold for STO
    float StoFatalThold ; // !< Fatal threshold for STO
    float PhaseOverCurrent ; // !< Over current level for a phase current
    float CurrentRefFiltA1 ;
    float CurrentRefFiltB ;
    float MaxThetaPuDelta; // !< Max change in PU field angle per cycle
    short bEncoderInvert ; // !< Inversion of encoder direction
    short Stam ;
    float MinPotRef ; // !< Minimum legal value for potentiometer reference
    float PotFilterCst ; // !< Potentiometer 1st order filter constant
    float CurrentCommandDir   ; // !< Direction of command to the current controller composed of Reference and of speed corrections
    float DInjectionDelta ; // Injection delta (One Ts) for the D axis
    float DInjectionLevel ; // Injection level for the D axis
    float ExtCutCst ; // Filtering constant for reported current on PDO
    float VoltageDacGain ; // DAC gain for integrating phase voltage
    float DcCurrentDacGain ;  // DAC gain for integrating DC current
};



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

struct CClaRecs
{
    float kuku[8] ;
};

EXTERN_CLA struct CClaRecs ClaRecs ;

EXTERN_CLA struct CClaMailIn ClaMailIn ;
EXTERN_CLA struct CClaMailOut ClaMailOut ;
EXTERN_CLA struct CClaControlPars ClaControlPars ;
/*
struct CCalib
{
    long  PassWord ; // A password replica
    float RNeckPotCenter ; // Add this to the right neck pot for calibration
    float LNeckPotCenter ; // Add this to the left neck pot for calibration
    float RNeckPotGainFac ; // Add this to the right neck pot gain for calibration
    float LNeckPotGainFac ; // Add this to the left neck pot gain for calibration
    float qImu2ZeroENUPos[4] ; // !< Quaternion from IMU installation to body frame
    float ACurGainCorr ; // !< Calibration of current measurement A
    float BCurGainCorr ; // !< Calibration of current measurement B
    float CCurGainCorr ; // !< Calibration of current measurement C
    float CalibSpareFloat[9] ;
    float CalibSpareLong[5]   ;
    long  CalibDate       ; // !< Calibration revision date
    long  CalibData       ; // !< Calibration additional revision data
    long  Password0x12345678 ; // !< Must be 0x12345678
    long  cs ; // !< Long checksum
};
*/
#include "..\Application\CalibStrDef.h"

EXTERN_CLA struct CCalib Calib ;



struct CAnalogs
{
    float PhaseCurAmc[3] ;
    float PhaseCur[3] ;
    float PhaseVoltUnCalib[3] ;
    float PhaseVoltUnCalibSum[3] ;
    float PhaseVoltMeas[3] ;
    float DcUnCalibSum ;
    float DcCurUncalib ;
    float DcCurUncalibSum ;
    float DcCur        ;
    float Vdc ;
    float BusCurrentAMC ;
};

struct CAdcRaw
{
    short unsigned PhaseCurAdc[3] ;
    short unsigned Temperature ;
};


struct CClaCurrentControl
{
    float CurrentReference ; // !< Reference to the current controller
    float ExtCurrentCommand   ; // !< External Command to the current controller composed of Reference and of speed corrections
    float CurrentCommand      ; // !< Direction of command to the current controller composed of Reference and of speed corrections
    float CurrentCommandSlopeLimited   ; // !< Command to the current controller after slope limiting
    float CurrentCmdFilterState0 ;
    float CurrentCmdFilterState1 ;
    float CurrentCommandFiltered  ; // !< Command to the current controller after slope limiting and filtering
    float CurrentCommandDInjection  ; // !< Command to the current controller d as injection
    float ExtCurrentCommandFiltered  ; // !< Command to the current controller after slope limiting and filtering
    float Int_q ; // Integrals of the Q and the D axes
    float Int_d ;
    float Iq  ;   // Q currents
    float Id  ;   // D currents
    float Error_q    ; // Error for current controls
    float Error_d    ;
    float vpre_q ; // Preparation of voltage commands to the next cycle
    float vpre_d ;
    float ExtIq  ;     // Q currents with direction correction
    float ExtIqFilt  ; // Q currents with direction correction  ExtIqFilt
} ;



struct CEncoder
{
    long  Pos ;
    float MotSpeedHz ;
    float MotSpeedHzFilt ;
    long  unsigned TimeLat   ;
    long  unsigned SpeedTime ;
    long  EncoderOnHome ;
    float  UserPosOnHome ;
    float MinMotSpeedHz ;
    float UserSpeed ;
    float MotorPos ; // !< Floating point position in per-unit motor revolutions
    float UserPos ; // !< Floating point position in User Units
    float UserPosDelta ;
    float Bit2Rev ;
    float Rev2Pos ;
    float DeltaT ;
    long Rev2Bit ;
    long MotorPosCnt ; // Modulo counter: motor angle
    long  now ;
    short unsigned Stat ;
    short InvertEncoder ;
};

struct CClaTiming
{
    float InvMhz ;
    float TsInTicks ;
    float InvTsInTicks ;
};

struct CClaState
{
    float DbgStop ;
    float MotorOn ;
    float s ;
    float c ;
    float c120 ;
    float c240 ;
    float s120 ;
    float s240 ;
    float vqd  ; // Desired value for Vq
    float vdd  ; // Desired value for Vd
    float vqr  ; // Realised value for Vq
    float vdr  ; // Realised value for Vd
    float va ;
    float vb ;
    float vc ;
    float vn ;
    float Vsat ;
    float PwmFac ;
    float PwmOffset ;
    float PwmMin ;
    float PwmMinB ;
    float PwmMax ;// A value above the frame so the PWM will not switch and be identically zero
    float PwmFrame ;
    float InvPwmFrame ;
    float PwmFrame2 ; // Entire PWM frame
    float MaxWB ; //Max width for B comparator
    float MaxWA ;//Max width for A comparator
    float q2v1 ;
    float q2v2 ;
    float d2v1 ;
    float d2v2 ;
    float  tTask      ;
    float MotorOnRequestOld ; // !< Old version of Request to set the motor ON
    float MotorOnRequest ; // !< Request to set the motor ON
    float NotRdy ;
    float MotFail ;
    float ThetaPuInUse ; // The copy of the electrical angle used for actual calculation (the inmail value may not be time-synchronized to CLA)
    float PotRefFail ;
    float DacValU[3] ;
    float DacValDc  ;
    long DacPulseCntr ;
    long unsigned InterruptCtr  ;
    long  SystemMode ;
    float Pwm6LimitForZeroing ;
    float Pwm6OnStart ;
    struct CAnalogs Analogs ;
    struct CAdcRaw AdcRaw ; //!< Raw value of ADC
    struct CClaCurrentControl CurrentControl;
    struct CEncoder Encoder1 ;
    struct CClaTiming Timing ;
    long unsigned TzFlag ;
    long unsigned DacValDebug ;
    float ExperimentCtr;
    float ExperimentCtrMax;
    float ExperimentDir ;
};
EXTERN_CLA volatile struct CClaState ClaState ;



#ifdef CLA_VAR_OWNER_CLA

//#pragma DATA_ALIGN ( ClaState , 128 );



const float SinTable[48] = {
                            0.0f,     1.950903220161282e-01f,     3.826834323650898e-01f,
          5.555702330196022e-01f,     7.071067811865475e-01f,     8.314696123025452e-01f,
          9.238795325112867e-01f,     9.807852804032304e-01f,     1.000000000000000e+00f,
          9.807852804032304e-01f,     9.238795325112867e-01f,     8.314696123025453e-01f,
          7.071067811865476e-01f,     5.555702330196022e-01f,     3.826834323650899e-01f,
          1.950903220161286e-01f,     1.224646799147353e-16f,    -1.950903220161284e-01f,
         -3.826834323650897e-01f,    -5.555702330196020e-01f,    -7.071067811865475e-01f,
         -8.314696123025452e-01f,    -9.238795325112865e-01f,    -9.807852804032303e-01f,
         -1.000000000000000e+00f,    -9.807852804032304e-01f,    -9.238795325112866e-01f,
         -8.314696123025455e-01f,    -7.071067811865477e-01f,    -5.555702330196022e-01f,
         -3.826834323650904e-01f,    -1.950903220161287e-01f,    -2.449293598294706e-16f,
          1.950903220161282e-01f,     3.826834323650899e-01f,     5.555702330196018e-01f,
          7.071067811865474e-01f,     8.314696123025452e-01f,     9.238795325112865e-01f,
          9.807852804032303e-01f,     1.000000000000000e+00f,     9.807852804032307e-01f,
          9.238795325112867e-01f,     8.314696123025456e-01f,     7.071067811865483e-01f,
          5.555702330196023e-01f,     3.826834323650905e-01f,     1.950903220161280e-01f
} ;

const struct CClaConst  c = { .piOver32 = 9.817477042468103e-02f , .Halfsqrt3 = 8.660254037844386e-01f  ,
                              .sqrt3 = 1.732050807568877f , .OneOver3GoodBehavior = 3.333333333333333e-01f ,
                              .OneOverTwoPi = 1.591549430918953e-01f , .TwoPi = 6.283185307179586e+00f , .TwoThirds = 0.666666666666667f,
                              .Num2048 = 2048.0f  , .Num2732 = 2732.0f , .Num3072 = 3072.0f , .Num4096 = 4096.0f , .Num1p65 = 1.65f ,
                              .UnsignedLong1 = 1 , .UnsignedLong2 = 2,.UnsignedLong3 = 3 , .UnsignedLong4 = 4 ,
                              .Adc2Volt = 8.056640625000000e-04f, .Volt2Adc = 1.241212121212121e+03f , .Vres2Vphase = 1.04f,
                              .Amc2Amp  =  0.024485798237023f ,.Hall2Amp =  ADC_Hall2Amp
};
#endif


interrupt void Cla1Task1 ( void );
interrupt void Cla1Task2 ( void );
interrupt void Cla1Task3 ( void );
interrupt void Cla1Task4 ( void );
interrupt void Cla1Task5 ( void );
interrupt void Cla1Task6 ( void );
interrupt void Cla1Task7 ( void );
interrupt void Cla1Task8 ( void );




#endif /* CONTROL_CLADEFS_H_ */
