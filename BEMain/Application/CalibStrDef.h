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
    float PotCenter1Obsolete ; // Add this to the steering pot or right neck pot for calibration
    float PotCenter2Obsolete ; // Add this to the left neck pot for calibration
    float PotGainFac1Obsolete ; // Add this to the steering pot  right neck pot gain for calibration
    float PotGainFac2Obsolete ; // Add this to the left neck pot gain for calibration
    float qImu2ZeroENUPos[4] ; // !< Quaternion from IMU installation to body frame
    float ACurGainCorr ; // !< Calibration of current measurement A
    float BCurGainCorr ; // !< Calibration of current measurement B
    float CCurGainCorr ; // !< Calibration of current measurement C
    float Pot1CalibP3 ;
    float Pot1CalibP2 ;
    float Pot1CalibP1 ;
    float Pot1CalibP0 ;
    float Pot2CalibP3 ;
    float Pot2CalibP2 ;
    float Pot2CalibP1 ;
    float Pot2CalibP0 ;
    float CalibSpareFloat[5] ;
    float CalibSpareLong    ;
    long  CalibDate       ; // !< Calibration revision date
    long  CalibData       ; // !< Calibration additional revision data
    long  Password0x12345678 ; // !< Must be 0x12345678
    long  cs ; // !< Long checksum
};



#endif /* APPLICATION_CALIBSTRDEF_H_ */
