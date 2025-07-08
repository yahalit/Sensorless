#ifndef APPLICATION_REVISIONS_H_
#define APPLICATION_REVISIONS_H_

#include "CalibStrDef.h"

#define nUserCfgPars 128

//Identity structures
#define ParametersSetRevision 1.0 // The revision of the parameters set. Need be updated whenever parameters structure is changed
#define HwConfigRevision 1.0 // The revision of the hardware configuration parameters set. Need be updated whenever parameters structure is changed
#define IdentityParametersRevision (1U<<8)


//Param structures

struct CFloatConfigParRecord
{
    short Flags ;
    short unsigned ind ;
    float * ptr ;
    float lower ;
    float upper ;
    float defaultVal ;
} ;


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
    float CurrentCommandDir    ; // Current command direction
    float I2tCurLevel          ; // I2t current level
    float I2tCurTime          ; // I2t current time
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



struct CCalibProg
{
    unsigned long PassWord ;
    struct CCalib Calib ;
};


union UCalibProg
{
    struct CCalibProg C  ;
    short  unsigned us[64] ;
};


struct CIdentity
{
    long  PassWord ; // A password replica
    long  HardwareRevision ; // Hardware revision (bytes)
    long  ProductionDate   ; // (YYYY-2000 ) , MM , DD Each a byte
    long  RevisionDate   ; // (YYYY-2000 ) , MM , DD Each a byte
    long  HardwareType        ; // Hardware Project identifier
    long  SerialNumber  ;
    long  ProductionBatchCode  ;
    long  IdentitySpare[7] ;
    long  IdentityRevision ;
    long  cs ; // !< Long checksum
};

struct CIdentityProg
{
    struct CIdentity Identity ;
    unsigned long PassWord ;
};

union UIdentity
{
    struct CIdentityProg C  ;
    long   unsigned Buf[16] ;
    short  unsigned us[32] ;
};


#endif
