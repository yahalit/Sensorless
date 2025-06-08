global DataType 
% Test the split brake wiring
% Brake = [0,1] ; 

Brake = [0,1] ; 

ksks = SendObj( [hex2dec('0x2220'),117] , Brake(1) , DataType.long , 'Release Brake only right' ) ;
ksks = SendObj( [hex2dec('0x2220'),118] , Brake(2) , DataType.long , 'Release Brake only Left' ) ;
% SetFloatPar('Geom.PinMotorCurrentAmp',0.1);
% SetFloatPar('Geom.PinMotorCurrentAmpIbit',0.00);