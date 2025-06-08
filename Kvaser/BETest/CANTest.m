global AtpCfg %#ok<GVMIS> 
AtpCfg.FetchRetry = 0 ; 

SendObj( [hex2dec('2220'),99,WhCanId] , 1 , DataType.long , 'CBIT 99' ) 