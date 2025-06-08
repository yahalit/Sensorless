global DataType 
MinSwitchLengthMeter=  FetchObj( [hex2dec('2226'),1] , DataType.float ,'MinSwitchLengthMeter') ;
MaxSwitchLengthMeter =  FetchObj( [hex2dec('2226'),2] , DataType.float ,'Right MaxSwitchLengthMeter') ;
Enc2MeterShelf =  FetchObj( [hex2dec('2226'),3] , DataType.float ,'Right Enc2MeterShelf') ;
LCaptEncoderH =  FetchObj( [hex2dec('2226'),6] , DataType.long ,'Left CaptEncoderL') ;
LCaptEncoderL =  FetchObj( [hex2dec('2226'),7] , DataType.long ,'Left CaptEncoderH') ;
LEncoder =  FetchObj( [hex2dec('2226'),9] , DataType.long ,'LEncoder') ;