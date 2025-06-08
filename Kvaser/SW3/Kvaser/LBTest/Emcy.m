function Emcy(x) 
% function Emcy(x) 
% x = 1 for pause 
% x = 2 for release
% any other value for emergency (kill mission) stop
global DataType 
SendObj( [hex2dec('2220'),115] , x , DataType.long , 'Emcy Stop' ) ;
end