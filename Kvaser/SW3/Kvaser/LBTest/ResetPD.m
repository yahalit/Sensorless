% Reset the PS + Dynamixel on the PD 
global DataType

JustPowerCycle = 1 ; 

if (JustPowerCycle ) 
    SendObj( [hex2dec('2207'),80] , 1 , DataType.long , 'Reset PD power supply' ) ;
    return 
end

% RESET the PD 
% Joker
ObjectJokerMap = zeros(1,5);
SendObj( [hex2dec('2301'),1] , hex2dec('12345678') , DataType.long , 'PD Flash enable' ,@Com2PdThroughLp) ;
SendObj( [hex2dec('2301'),244] , 0 , DataType.long , 'PD Reset' ,@Com2PdThroughLp) ;
% FetchObj( [hex2dec('2204'),7] , DataType.float , '24V from PD' , @Com2PdThroughLp) 
% 2204,1 is 24V voltage 

V24 = FetchObj( [hex2dec('2204'),1] , DataType.float , '24V from PD' , @Com2PdThroughLp)  %#ok<*NOPTS>
VServo = FetchObj( [hex2dec('2204'),2] , DataType.float , 'VServo from PD' , @Com2PdThroughLp) 
V36 = FetchObj( [hex2dec('2204'),7] , DataType.float , '36V from PD' , @Com2PdThroughLp) 
VBat54 = FetchObj( [hex2dec('2204'),8] , DataType.float , '54VBat from PD' , @Com2PdThroughLp) 
V12 = FetchObj( [hex2dec('2204'),10] , DataType.float , '12V from PD' , @Com2PdThroughLp) 


SendObj( [hex2dec('2004'),3] , 0 , DataType.short , 'Cut 54V' ,@Com2PdThroughLp)  % Cut 54V 
SendObj( [hex2dec('2004'),3] , 1 , DataType.short , 'Cut 54V' ,@Com2PdThroughLp)  % Set 54V 