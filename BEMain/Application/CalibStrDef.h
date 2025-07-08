/*
 * CalibStrDef.h
 *
 *  Created on: 31 במאי 2025
 *      Author: Yahali
 */

#ifndef APPLICATION_CALIBSTRDEF_H_
#define APPLICATION_CALIBSTRDEF_H_


struct CCalib
{
    long  PassWord ; // A password replica
    float PhaseVoltGainU ; // Add this to the steering pot or right neck pot for calibration
    float PhaseVoltGainV ; // Add this to the left neck pot for calibration
    float PhaseVoltGainW ; // Add this to the steering pot  right neck pot gain for calibration
    float PhaseVoltOffsetU ; // Add this to the left neck pot gain for calibration
    float PhaseVoltOffsetV ; // Add this to the left neck pot gain for calibration
    float PhaseVoltOffsetW ; // Add this to the left neck pot gain for calibration
    float qImu2ZeroENUPos[4] ; // !< Quaternion from IMU installation to body frame
    float ACurGainCorr ; // !< Calibration of current measurement A
    float BCurGainCorr ; // !< Calibration of current measurement B
    float CCurGainCorr ; // !< Calibration of current measurement C
    float ACurGainCorrAmc ; // !< Calibration of current measurement A
    float BCurGainCorrAmc ; // !< Calibration of current measurement B
    float CCurGainCorrAmc ; // !< Calibration of current measurement C
    float VdcGain ;
    float VdcOffset ;
    float Pot2CalibP0 ;
    float CalibSpareFloat[5] ;
    float CalibSpareLong    ;
    long  CalibDate       ; // !< Calibration revision date
    long  CalibData       ; // !< Calibration additional revision data
    long  Password0x12345678 ; // !< Must be 0x12345678
    long  cs ; // !< Long checksum
};



#endif /* APPLICATION_CALIBSTRDEF_H_ */
