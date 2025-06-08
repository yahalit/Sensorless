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
xTargetVec = [0 , 2.0 , 2.0 , 0 , 0] ; 
yTargetVec = [0 , 0 , 2.0 , 2.0 , 0] ; 
xTarget =xTargetVec(1) ;
yTarget =yTargetVec(1) ;

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

nQrCodes = length(xTargetVec)-1 ; 
QrCodes = cell( 1 , nQrCodes) ; 
for cnt = 1: nQrCodes 
    QrCodes{(cnt-1)*4+1} = [xTargetVec(cnt)  , yTargetVec(cnt) , 0 ];
    QrCodes{(cnt-1)*4+2} = [xTargetVec(cnt)  , yTargetVec(cnt) , pi/2 ];
    QrCodes{(cnt-1)*4+3} = [xTargetVec(cnt)  , yTargetVec(cnt) , pi   ];
    QrCodes{(cnt-1)*4+4} = [xTargetVec(cnt)  , yTargetVec(cnt) , 2*pi/2 ];
end 


% Start the go 
% Clear way correction 
% SetFloatPar( 'ControlPars.CurvatureCorrectGain' , 0.3 ) ; % Was 2.5
% SetFloatPar( 'GyroInt.OdometryDvGain' , 0.0  ) ; 
% SetFloatPar( 'Geom.SteerColumn2WheelDist' , 0.075   ) ; 
% SetFloatPar( 'ControlPars.RouteLookAheadDist', 1.0 ) ; 
% SetFloatPar( 'SysPars.Nav.SegPosCorrectionFac', 0.4  ) ;
% SetFloatPar( 'Constraint.amax',0.6) ; 
% SetFloatPar( 'Constraint.dmax',0.6) ; 
% SetFloatPar( 'ControlPars.LateralPoleAccessTol', 0.023 ) ; % 165  ) ;
% SetFloatPar( 'ControlPars.GyroXFiltBwRadSec' , 20 ) ; % Was 1.5 
% SetFloatPar( 'ControlPars.AngularPoleAccessTol', 0.09   ) ;

% SetFloatPar( 'AutomaticRunPars.IntershelfDist', InterShelfDist  ) ; % 0.502 at Yahali 

% SetFloatPar( 'ControlPars.HorizontalRailYewOffset', -0.035 ) ; 
% SetFloatPar( 'ControlPars.ArcSpeed', 0.1 ) ; % Auto mode, tHe speed on the arc
% SetFloatPar( 'ControlPars.PoleSpeed', 0.1 ) ; % Auto mode , The speed on the pole

% SetFloatPar( 'ControlPars.GyroXFiltBwRadSec', 100 ) ;
%SetFloatPar( 'ControlPars.NeckAccSlaveGain', 5  ) ;
% SetFloatPar( 'ManRouteCmdImage.LineAcc',0.45) ; 

% Program to work with manual disabler
% SendObj( [hex2dec('1f00'),3] , 1 , DataType.short , 'Set analog stop control' ) ;



% Robot initial position 
X = [xTarget(1) ,0,0] ;

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

for cnt = 1:nQrCodes 
    NextPt = NextPt + 1 ; 
    [str,reply] = SpiSetPathPt( Qindex , NextPt , [xTargetVec(cnt+1),yTargetVec(cnt),0] , [1,0,0] , SpiDoTx) ; 
end 

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
