DataType = GetDataType();
% User parameters
vmaxdeg = 90 ; % Max angular speed (reachable only for large enough steps) 
angdeg  = 90 ; % Angular rotation 
amaxdeg = 30  ; % Angular acceleration 
% End user parameters 

deg2rad = pi / 180 ; 
dang = angdeg * deg2rad ; 
vmax = vmaxdeg * deg2rad ;
amax = amaxdeg  * deg2rad; % Max 3 
SetFloatPar('AutomaticRunPars.DiffModeAcc',amax,[]) ; % Default 1.3
SetFloatPar('AutomaticRunPars.DiffModeSpeed',vmax,[]) ; % Default 1.75

s = abs(dang) ; 
if s <= vmax^2/amax 
    % triangular profile 
    dt = 2 * sqrt ( s / amax ) ; 
    vmaxact = amax * s ;
else
    % Trapezoidal 
    dt = 2 * vmax / amax + ( s - 2 * vmax/amax) / vmax ;  
    vmaxact = vmax ; 
end 


er0 = GetSignal('RWheelEncPos');
el0 = GetSignal('LWheelEncPos');
wheelcnt2m = GetFloatPar('Geom.rg') / GetFloatPar('Geom.WheelCntRad') ; 
wheeldist = 2 * ( GetFloatPar('Geom.SteerColumn2WheelDist') + GetFloatPar('Geom.Center2WheelDist')) ;

SendObj( [hex2dec('2220'),33] , dang , DataType.float , 'Set diff drive angle' ) ;
pause(dt + 2 ) ;
er1 = GetSignal('RWheelEncPos');
el1 = GetSignal('LWheelEncPos');
TurnAngle = FetchObj( [hex2dec('2204'),119] , DataType.float , 'Turn angle' ); 
disp(['Actual max speed (deg/sec): ',num2str(vmaxact / deg2rad ) ]) ; 
disp(['Actual turn rad: ',num2str(round(TurnAngle*100)/100), ' deg: ' ,num2str( round(TurnAngle*10/deg2rad)/10) ]) ; 

% Uncomment if you wish to see odometry data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% expturn = -((er1-er0) - (el1-el0)) *  wheelcnt2m / wheeldist ;  
% 
% disp(['Expected turn by wheels rad: ',num2str(round(expturn*100)/100), ' deg: ' ,num2str( round(expturn*10/deg2rad)/10) ]) ; 

