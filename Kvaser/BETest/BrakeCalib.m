% Calibrate the brakes 
DataType = GetDataType() ; 
% Set motor off 
SendObj([hex2dec('2220'),4],0,DataType.long,'Set motor disable') ;
% Set brake over ride 
SendObj([hex2dec('2220'),23],1,DataType.long,'Set motor disable') ;

% Set brake to working voltage 
BrakeOn = 1 ; 
SendObj([hex2dec('2220'),20],BrakeOn,DataType.long,'Set motor disable') ;



