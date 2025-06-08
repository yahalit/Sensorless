
global DataType


AtpStart ; 
stat = SendObj( [hex2dec('2220'),3] , hex2dec('5678') , DataType.short ,'Shut CAN activity') ;  

