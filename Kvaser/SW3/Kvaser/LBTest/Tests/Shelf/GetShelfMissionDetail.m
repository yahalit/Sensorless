% GetShelfMissionDetail
global DataType 
xbase  = FetchObj( [hex2dec('2221'),20] , DataType.float , 'xbase' ) ;
ybase  = FetchObj( [hex2dec('2221'),21] , DataType.float , 'ybase' ) ;
height = FetchObj( [hex2dec('2221'),22] , DataType.float , 'ybase' ) ;
DestinationX  = FetchObj( [hex2dec('220b'),20] , DataType.float , 'DestinationX' ) ;
DestinationY  = FetchObj( [hex2dec('220b'),21] , DataType.float , 'DestinationY' ) ;
DestinationZ  = FetchObj( [hex2dec('220b'),22] , DataType.float , 'DestinationZ' ) ;

EncoderPosTarget0 = GetSignal('EncoderPosTarget0') ; 
EncoderPosTarget1 = GetSignal('EncoderPosTarget1') ; 

WheelProfile0Pos = GetSignal('WheelProfile0Pos') ; 
WheelProfile1Pos = GetSignal('WheelProfile1Pos') ; 
WheelEncoderNow0 = GetSignal('WheelEncoderNow0') ; 
LeftWheelEncoder = GetSignal('LeftWheelEncoder') ; 

RightWheelEncoder = GetSignal('RightWheelEncoder') ; 
WheelProfile0Speed = GetSignal('WheelProfile0Speed') ; 
WheelProfile1Speed = GetSignal('WheelProfile1Speed') ; 
WheelProfile0Pos = GetSignal('WheelProfile0Pos') ; 
WheelProfile1Pos = GetSignal('WheelProfile1Pos') ; 

WheelProfiler0Target = GetSignal('WheelProfiler0Target') ; 

Robotxc0 = GetSignal('Robotxc0') ; 
Robotxc1 = GetSignal('Robotxc1') ; 
Robotxc2 = GetSignal('Robotxc2') ; 

[MQ,nGet,nPut,UsrQ] = GetMotionQueue();