global DataType 
side = 2 ; % Right 
Get = 1 ; 

switch side 
    case 1 
        dir = -1 ; 
    case 2
        dir = 1 ; 
    otherwise
        error( 'Undefined side') ; 
end 

% Inhibit commands from LP 
SendObj( [hex2dec('2103'),201] , 1 , DataType.long , 'Disable response to LP commands' ) ;


Geo = struct ( 'XDistWheelShoulderPivot', 0.24, 'YDistWheelShoulderPivot' , 0.28  ) ;
SendObj( [hex2dec('2103'),101] , 0 , DataType.long , 'Make laser invalid' ) ;
SendObj( [hex2dec('2103'),102] , -335 - Geo.XDistWheelShoulderPivot * 1000 , DataType.long , 'X position' ) ;
SendObj( [hex2dec('2103'),103] , dir * ( 440 - Geo.YDistWheelShoulderPivot * 1000 ) , DataType.long , 'Y package' ) ;
SendObj( [hex2dec('2103'),105] , 0 , DataType.long , 'Reset package state machine' ) ;

% SendObj( [hex2dec('2103'),106] , 1 , DataType.long , 'Suck bypass' ) ;

w = 11 + Get * 16 + 32 * side ; 
SendObj( [hex2dec('2103'),1] , w , DataType.long , 'Go pack' ) ;


% SendObj( [hex2dec('2103'),100] , 1000 , DataType.long , 'Laser reading' ) ;

