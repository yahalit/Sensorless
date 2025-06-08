global DataType 

for hhh = 1:50 

handles.actions = struct('None', [0,-1] , 'Standby' , [1,-1] , 'Repush' , [2,0] , 'GetRetry' , [3,1] , ...
    'Laser' , [4,-1] , 'ResetManipPower' , [8,-1] ,'Push',[14,0],'Get',[14,1],'RstCmd' , [15,-1] ) ; 
handles.sides   = struct('Right', 2 , 'Left' , 1 ) ; 
handles.styles  = struct('Object', 1 , 'SPI' , 2 ) ; 
handles.Geo = struct ( 'XDistWheelShoulderPivot', 0.24, 'YDistWheelShoulderPivot' , 0.28  ) ;
handles.PackageDepth = 0.170 ; 

dirstr = {'Right','Left'} ;
tic
if iseven(hhh) 
ActInstruct = handles.actions.('Push') ;
else
ActInstruct = handles.actions.('Get') ;
end

SimPack = struct('Action', ActInstruct(1) , 'Get', ActInstruct(2), 'Side' ,  handles.sides.('Right') , 'IncidenceDeg' , 6  , ...
    'PackageXOffset', -(handles.Geo.XDistWheelShoulderPivot+0.335) ,...
    'PackageDepth', handles.PackageDepth ) ; % 0.44-Geo.YDistWheelShoulderPivot ) ; 
    
    if ( SimPack.Get >= 0 ) 
        SendObj( [hex2dec('2207'),51] , SimPack.Get , DataType.long ,'Package get') ;
    end 
    
    ypos = SimPack.PackageDepth; 
    if SimPack.Side == 1
    %    ypos = -ypos ;
    end
    
    SendObj( [hex2dec('2207'),52] , SimPack.Side , DataType.long ,'Package side') ;
    SendObj( [hex2dec('2207'),53] , SimPack.IncidenceDeg * pi / 180  , DataType.float ,'Incidence Radians') ;
    SendObj( [hex2dec('2207'),54] , SimPack.PackageXOffset , DataType.float ,'X position') ;
    SendObj( [hex2dec('2207'),55] , ypos , DataType.float ,'Y position') ;
    SendObj( [hex2dec('2207'),56] , SimPack.Action , DataType.long ,'Action') ;
    % return 
    SendObj( [hex2dec('2207'),60] , 1 , DataType.long ,'Activate package action') ;

pause( 27.0) ; 

nDMoff = FetchObj( [hex2dec('2222'),116] , DataType.long ,'Get door opener motor off counter'); 
hopctr = hopctr+ 1 ; 
disp( [ '(',num2str(hopctr),') Number of door opener involuntary motor offs:  [',num2str(nDMoff),']'] ) 

end