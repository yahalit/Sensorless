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

% disp('Reduced shelf height, dont attempt disc') ; 
ShelfHeight = 1.32 ; %// 1.33 at Yahali ; 

% DO NOT CHANGE BELOW THIS 
%%%%%%%%%%%%%%%%%%%%%%%%%%

Qindex = 1 ; 
SpiDoTx = 4 ; % 1 for simulation, 2 for CAN , 3 for shorts text out , 4 for byte text out
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

Out = [] ; 

% Set navigation 
[str,reply] = SpiSetPosRpt( X , 0  , 4 , SpiDoTx ) ; %#ok<*ASGLU>
Out = [ Out ; double(reply) ] ; 

% Set a queue destination 
SpiClearQueue( Qindex , SpiDoTx); 
NextPt = 0 ; 
[str,reply] = SpiSetPathPt( Qindex , NextPt , X , [1,0,0] , SpiDoTx) ; 
Out = [ Out ; double(reply) ] ; 

NextPt = NextPt + 1 ; 
[str,reply] = SpiSetPathPt( Qindex , NextPt , [xTarget,0,0] , [1,0,0] , SpiDoTx) ; 
Out = [ Out ; double(reply) ] ; 

% Set the yew and up we climb ...
% Set the the command to 90 deg 
NextPt = NextPt + 1 ; 
Yew = pi/2 ; RotateCmd = 0 ; IsClimb = 0 ; 
[str,reply] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );
Out = [ Out ; double(reply) ] ; 

% Travel few CM to the post
NextPt = NextPt + 1 ; 
[str,reply] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,0] , [1, 0, 0] , SpiDoTx );
Out = [ Out ; double(reply) ] ; 

if ( vvvmode.DoClimb ) 

    % Change the mode to climb 
    NextPt = NextPt + 1 ; 
    Yew = pi/2 ; RotateCmd = 0 ; IsClimb = 1 ; 
    [str,reply] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );
Out = [ Out ; double(reply) ] ; 

    % Do the climb itself
    NextPt = NextPt + 1 ; 
    [str,reply] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,ShelfHeight] , [1 , 0, 0] , SpiDoTx );
Out = [ Out ; double(reply) ] ; 


    if ( vvvmode.DoRotateDisc ) 
        % Rotate the disc 
        NextPt = NextPt + 1 ; 
        Yew = pi/2 ; RotateCmd = 1 ; IsClimb = 1 ; 
        [str,reply] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );
Out = [ Out ; double(reply) ] ; 

        % Go somewhere in the med 
        if ( vvvmode.DoShelfTravel ) 
            NextPt = NextPt + 1 ; 
            [str,reply] = SpiSetPathPt( Qindex , NextPt , [packTarget,yTarget,0] , [1, 0, 0] , SpiDoTx );
Out = [ Out ; double(reply) ] ; 

            % Put our precious package to place ...

            packcmd = struct ('ActionLoad', 1 , 'Side' , 2 , 'PackageDepth' , ...
                PackageDepth  ,'PackageXOffset' , -0.57000 , ...
                'Incidence' ,  4 / 180 * pi  ) ; 

                if ( vvvmode.DoPackage ) 
                    NextPt = NextPt + 1 ; 
                    [str,reply] = SpiDealPack( Qindex , NextPt , packcmd , SpiDoTx );
Out = [ Out ; double(reply) ] ; 
                end 

            % Return to post 
            NextPt = NextPt + 1 ; 
            [str,reply] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,0] , [1, 0, 0] , SpiDoTx );
Out = [ Out ; double(reply) ] ; 
        end 

        % Unrotate the disc 
        NextPt = NextPt + 1 ; 
        Yew = pi/2 ; RotateCmd = -1 ; IsClimb = 1 ; 
        [str,reply] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );
Out = [ Out ; double(reply) ] ; 

    end
    % Unclimb 
    NextPt = NextPt + 1 ; 
    [str,reply] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,0] , [1 , 0, 0] , SpiDoTx );
Out = [ Out ; double(reply) ] ; 

    % Change the mode to unclimbed 
    NextPt = NextPt + 1 ; 
    Yew = pi/2 ; RotateCmd = 0 ; IsClimb = 0 ; 
    [str,reply] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );
Out = [ Out ; double(reply) ] ; 
    % Return to course 
    NextPt = NextPt + 1 ; 
    [str,reply] = SpiSetPathPt( Qindex , NextPt , [xTarget,0.0,0] , [1 , 0, 0] , SpiDoTx );
Out = [ Out ; double(reply) ] ; 

    % Uncrab 
    NextPt = NextPt + 1 ; 
    Yew = 0 ; RotateCmd = 0 ; IsClimb = 0 ; 
    [str,reply] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );
Out = [ Out ; double(reply) ] ; 

    % Normal drive 
    NextPt = NextPt + 1 ; 
    [str,reply] = SpiSetPathPt( Qindex , NextPt , [xTarget+0.15,0.0,0] , [1 , 0, 0] , SpiDoTx );
Out = [ Out ; double(reply) ] ; 

end


% 
% End the queue
NextPt = NextPt + 1 ; 
[str,reply] = SpiSetPathWait( Qindex , NextPt , inf , SpiDoTx ) ;
Out = [ Out ; double(reply) ] ; 


% and execute it 
[str,reply] = SpiQueueExec( Qindex , 0 , 1 , SpiDoTx ) ; 
Out = [ Out ; double(reply) ] ; 

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
