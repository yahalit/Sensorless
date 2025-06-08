
global DataType


stat = SendObj( [hex2dec('2304'),1] , 1234 , DataType.long ,'Weite value') ;  
TestRead = FetchObj( [hex2dec('2304'),1] , DataType.long ,'Read value') ;
