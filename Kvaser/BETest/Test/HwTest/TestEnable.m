function TestEnable( ena) 
DataType = GetDataType() ; 
SendObj( [hex2dec('2220'),27] , ena , DataType.long , 'Enable' ) 
end