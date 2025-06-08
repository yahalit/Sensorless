global DataType 


% Below 'Sim' is standard actions as was 
actions = struct('None', 0 , 'Standby' , 1 , 'Repush' , 2 , 'GetRetry' , 3 , 'Laser' , 4 , 'ResetManipPower' , 8 ,'Sim',14,'RstCmd' , 15 ) ; 
sides   = struct('Right', 2 , 'Left' , 1 ) ; 
styles  = struct('Object', 1 , 'SPI' , 2 ) ; 

Geo = struct ( 'XDistWheelShoulderPivot', 0.24, 'YDistWheelShoulderPivot' , 0.28  ) ;

Style   = styles.SPI ; 


% Task description struct 
% Get: 0 for Put pack, 1 for set pack 
% PackDir: 1 for left, 2 for right
% IncidenceRad: Tail incidence while accessing the package 

SimPack = struct('Action', actions.GetRetry , 'Get', 1, 'Side' ,  sides.Right , 'IncidenceDeg' , 0 , ...
    'PackageXOffset', -(Geo.XDistWheelShoulderPivot+0.335) ,...
    'PackageDepth', 0.3 ) ; % 0.44-Geo.YDistWheelShoulderPivot ) ; 

% SimPack.EncRes = GetFloatPar('Geom.NeckMotCntRad');
% SimPack.EncRef = FetchObj( [hex2dec('2206'),5] , DataType.long , 'Get enc ref' ) ;

% Get the present position command of shelf
%	enc =  FetchObj( [hex2dec('2204'),42] , DataType.float , 'Get enc' ) ;  


% SendObj( [hex2dec('2103'),101] , 0 , DataType.long , 'Make laser invalid' ) ;
% SendObj( [hex2dec('2103'),102] , -335 - Geo.XDistWheelShoulderPivot * 1000 , DataType.long , 'X position' ) ;
% SendObj( [hex2dec('2103'),103] , dir * ( 440 - Geo.YDistWheelShoulderPivot * 1000 ) , DataType.long , 'Y package' ) ;

if ( Style   == styles.Object) 
    SendObj( [hex2dec('2207'),51] , SimPack.Get , DataType.long ,'Package get') ;
    SendObj( [hex2dec('2207'),52] , SimPack.Side , DataType.long ,'Package side') ;
    SendObj( [hex2dec('2207'),53] , SimPack.IncidenceDeg * pi / 180  , DataType.float ,'Incidence Radians') ;
    SendObj( [hex2dec('2207'),54] , SimPack.PackageXOffset , DataType.float ,'X position') ;
    SendObj( [hex2dec('2207'),55] , SimPack.PackageDepth , DataType.float ,'Y position') ;
    SendObj( [hex2dec('2207'),56] , SimPack.Action , DataType.long ,'Action') ;
    % return 
    SendObj( [hex2dec('2207'),60] , 1 , DataType.long ,'Activate package action') ;
else % SPI (Gangnam) style 
    SpiEmcyPack(  SimPack , 2 ) ; 
end

return
% StdbySide = 2; % 1 left 2 right 
% SendObj( [hex2dec('2207'),61] , StdbySide , DataType.long ,'Activate standby action') ;
