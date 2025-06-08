% global DataType  
MCTL  =  FetchObj( [hex2dec('2220'),1] , DataType.long , 'CBIT 99' )   %#ok<*NOPTS> 
    MIER  =  FetchObj( [hex2dec('2220'),3] , DataType.long , 'CBIT 99' )    
    MIFR  =  FetchObj( [hex2dec('2220'),4] , DataType.long , 'CBIT 99' )    
    MIRUN  =  FetchObj( [hex2dec('2220'),5] , DataType.long , 'CBIT 99' )      
    MIOVF  =  FetchObj( [hex2dec('2220'),6] , DataType.long , 'CBIT 99' )    
