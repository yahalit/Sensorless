global SimTime ;  %#ok<*NUSED>
global RxCtr ; 
global TxCtr ; 

global DataType
global RecStruct ; 
global TargetCanId 
global DatType 

RecTime = 5; 

% Mission configuratio
vvvmode = struct ( 'DoClimb' , 1 , 'DoRotateDisc' , 1, 'DoShelfTravel' , 1, 'DoPackage' , 1 ) ; 



InterShelfDist = 0.487 ; 
xTarget = 1.513 - 0.045 ; 
yTarget = 0.35 ; % 0.290 at Yahali
packTarget = xTarget - 0.58 ; 
PackageDepth = 0.06 ; 
DistFromStart2Target = 0.60 ; % 0.66 at Yahali's porch 
PackageTiltDeg = 3; 
PackageGet = 2 ; % 1 for Get , 2 for PUT

% disp('Reduced shelf height, dont attempt disc') ; 
ShelfHeight = 1.32 ; %// 1.33 at Yahali ; 

% DO NOT CHANGE BELOW THIS 
%%%%%%%%%%%%%%%%%%%%%%%%%%

Qindex = 1 ; 
SpiDoTx = 2 ; 
TsBase = 4.096e-3 ; 

RxCtr = 0 ; 
TxCtr = 0 ; 
SimTime = 0 ;

RGeom = struct ('YellowLineRect',[0.3,-0.2,0.6,0.25],'YellowLineMaxAz',0.15,'YellowLineProcDelay',0.75,'QrCodeRect',[-0.1,-0.2,0.35,0.25],'QrCodeMaxAz',0.15,'QrCodeProcDelay',0.75) ; 
Geom = struct ('Center2WheelDist', 0.33068 ) ;
Constraint = struct( 'vmax', 1.2 , 'DiffRotS' , 0.5  );  
Setup = struct( 'ErrorCatch' , 0 ) ; 
Pars = struct ( 'Constraint' , Constraint , 'Setup' , Setup ,'RobotGeom', RGeom  ) ;


QrCodes = {[xTarget, 0,0 ,1.60, 0.02, 0], [xTarget , 0.25 , 0 ]};  

% Start the go 
% Clear way correction 
% SetFloatPar( 'ControlPars.CurvatureCorrectGain' , 0.3 ) ; % Was 2.5
% SetFloatPar( 'GyroInt.OdometryDvGain' , 0.0  ) ; 
% SetFloatPar( 'Geom.SteerColumn2WheelDist' , 0.075   ) ; 
% SetFloatPar( 'ControlPars.RouteLookAheadDist', 1.0 ) ; 
% SetFloatPar( 'SysPars.Nav.SegPosCorrectionFac', 0.4  ) ;
% SetFloatPar( 'Constraint.amax',0.6) ; 
% SetFloatPar( 'Constraint.dmax',0.6) ; 
SetFloatPar( 'ControlPars.LateralPoleAccessTol', 0.023 ) ; % 165  ) ;
SetFloatPar( 'ControlPars.GyroXFiltBwRadSec' , 20 ) ; % Was 1.5 
% SetFloatPar( 'ControlPars.AngularPoleAccessTol', 0.09   ) ;

SetFloatPar( 'AutomaticRunPars.IntershelfDist', InterShelfDist  ) ; % 0.502 at Yahali 

% SetFloatPar( 'ControlPars.HorizontalRailYewOffset', -0.035 ) ; 
% SetFloatPar( 'ControlPars.ArcSpeed', 0.1 ) ; % Auto mode, tHe speed on the arc
% SetFloatPar( 'ControlPars.PoleSpeed', 0.1 ) ; % Auto mode , The speed on the pole

% SetFloatPar( 'ControlPars.GyroXFiltBwRadSec', 100 ) ;
%SetFloatPar( 'ControlPars.NeckAccSlaveGain', 5  ) ;
% SetFloatPar( 'ManRouteCmdImage.LineAcc',0.45) ; 

% Program to work with manual disabler
% SendObj( [hex2dec('1f00'),3] , 1 , DataType.short , 'Set analog stop control' ) ;



% Robot initial position 
X = [xTarget - DistFromStart2Target ,0,0] ;

% Right wheel is to the y , left to -y 
ey =[0 1 0] ; 
Rw = X + Geom.Center2WheelDist * ey ; 
Lw = X - Geom.Center2WheelDist * ey ; 

% Set navigation 
[str,reply] = SpiSetPosRpt( X , 0  , 4 , SpiDoTx ) ; %#ok<*ASGLU>

% Set a queue destination 
SpiClearQueue( Qindex , SpiDoTx); 
NextPt = 0 ; 
[str,reply] = SpiSetPathPt( Qindex , NextPt , X , [1,0,0] , SpiDoTx) ; 

NextPt = NextPt + 1 ; 
[str,reply] = SpiSetPathPt( Qindex , NextPt , [xTarget,0,0] , [1,0,0] , SpiDoTx) ; 

% Set the yew and up we climb ...
% Set the the command to 90 deg 
NextPt = NextPt + 1 ; 
Yew = pi/2 ; RotateCmd = 0 ; IsClimb = 0 ; 
[str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

% Travel few CM to the post
NextPt = NextPt + 1 ; 
[str,~] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,0] , [1, 0, 0] , SpiDoTx );

if ( vvvmode.DoClimb ) 

    % Change the mode to climb 
    NextPt = NextPt + 1 ; 
    Yew = pi/2 ; RotateCmd = 0 ; IsClimb = 1 ; 
    [str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

    % Do the climb itself
    NextPt = NextPt + 1 ; 
    [str,~] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,-ShelfHeight] , [1 , 0, 0] , SpiDoTx );


    if ( vvvmode.DoRotateDisc ) 
        % Rotate the disc 
        NextPt = NextPt + 1 ; 
        Yew = pi/2 ; RotateCmd = 1 ; IsClimb = 1 ; 
        [str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

        % Go somewhere in the med 
        if ( vvvmode.DoShelfTravel ) 
            NextPt = NextPt + 1 ; 
            [str,~] = SpiSetPathPt( Qindex , NextPt , [packTarget,yTarget,-ShelfHeight] , [1, 0, 0] , SpiDoTx );

            % Put our precious package to place ...

            packcmd = struct ('ActionLoad', PackageGet, 'Side' , 2 , 'PackageDepth' , ...
                PackageDepth  ,'PackageXOffset' , -0.57000 , ...
                'Incidence' ,  PackageTiltDeg / 180 * pi  ) ; 

                if ( vvvmode.DoPackage ) 
                    NextPt = NextPt + 1 ; 
                    [str,~] = SpiDealPack( Qindex , NextPt , packcmd , SpiDoTx );
                end 

            % Return to post 
            NextPt = NextPt + 1 ; 
            [str,~] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,-ShelfHeight] , [1, 0, 0] , SpiDoTx );
        end 

        % Unrotate the disc 
        NextPt = NextPt + 1 ; 
        Yew = pi/2 ; RotateCmd = -1 ; IsClimb = 1 ; 
        [str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

    end
    % Unclimb 
    NextPt = NextPt + 1 ; 
    [str,~] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,0] , [1 , 0, 0] , SpiDoTx );

    % Change the mode to unclimbed 
    NextPt = NextPt + 1 ; 
    Yew = pi/2 ; RotateCmd = 0 ; IsClimb = 0 ; 
    [str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );
    % Return to course 
    NextPt = NextPt + 1 ; 
    [str,~] = SpiSetPathPt( Qindex , NextPt , [xTarget,0.0,0] , [1 , 0, 0] , SpiDoTx );

    % Uncrab 
    NextPt = NextPt + 1 ; 
    Yew = 0 ; RotateCmd = 0 ; IsClimb = 0 ; 
    [str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

    % Normal drive 
    NextPt = NextPt + 1 ; 
    [str,~] = SpiSetPathPt( Qindex , NextPt , [xTarget+0.15,0.0,0] , [1 , 0, 0] , SpiDoTx );

end


% 
% End the queue
NextPt = NextPt + 1 ; 
[str,reply] = SpiSetPathWait( Qindex , NextPt , inf , SpiDoTx ) ;


% and execute it 
[str,reply] = SpiQueueExec( Qindex , 0 , 1 , SpiDoTx ) ; 

% Run kzat
% RecNames = {'fDebug0','fDebug1','EulerRoll','HeadRollFilt'} ; 
%     
%     %'RobotPostX1','RobotPostX2'} ; 
%     
%     % 'SegIndex','ImuAcc0','ImuAcc1','BodyQuat3'}; 
% 
% 
% 
% [pStat, RecStruct ] = ProgramRecorder(RecNames , RecStruct   ); 
% 
% TsRec = RecStruct.Gap * TsBase ; 


% Recs =  RecorderWaitGet( RecTime * 1.1 + 1.0 ,RecStruct) ; % Was 40 
% t = Recs.Time ; 
% 
% figure(1) ; plot( t , Recs.RobotTilt , t , Recs.RobotHeadRoll);
% figure(2) ; plot( t , Recs.RightWheelEncoder ) ;
% figure(3) ; plot( t , Recs.ShelfMode );
% figure(4) ; plot( t , Recs.ShelfSubMode );
