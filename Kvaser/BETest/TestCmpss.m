% global DataType 
% global TargetCanId 
% TestCmpss: Test the voltage trip limits 

SetFloatPar('ClaControlPars.VDcMax',75); 
SetFloatPar('ClaControlPars.VDcMin',17); 

SetFloatPar('ControlPars.AbsoluteUndervoltage',25); 
SetFloatPar('ControlPars.AbsoluteOvervoltage',34); 
% SetFloatPar('ControlPars.DcShortCitcuitTripVolts',1.9); 

RetCode = SendObj( [hex2dec('2220'),21] , 1 , DataType.long , 'Set voltage trip limits') ;
