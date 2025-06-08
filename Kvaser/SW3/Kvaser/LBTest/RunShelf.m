global SimTime ;  %#ok<*NUSED>
global RxCtr ; 
global TxCtr ; 

global DataType
global RecStruct ; 


AtpStart ; 

RxCtr = 0 ; 
TxCtr = 0 ; 
SimTime = 0 ;

SpiDoTx = 2 ; 
Qindex = 1 ; 

cmd = struct ( 'ActionLoad', 2 , 'Side' , 2 , 'PackageDepth' , 0.2 ,'PackageXOffset' , -0.54 , ...
    'Incidence' , 0.05 ) ; % Just get a status report

SetFloatPar( 'Geom.LeaderMeetsSwitchM' , 0.2 ) ; 
SetFloatPar( 'Geom.ArcDist4SecondSwitchM' , 0.2 ) ; 
SetFloatPar( 'SimPars.SimAnalogEnableThold', 0.31) ; 
SetFloatPar( 'GyroInt.OdometryDvGain' , 1.0 ); 
SetFloatPar( 'ControlPars.CurvatureCorrectGain' , 0 ); 

SendObj( [hex2dec('1F00'),3] , 1 , DataType.short , 'Enable stop by analog') ; %  ,CanCom) ;


% Robot initial position 

X = [0.8800,0,0] ;
[str,~] = SpiSetPosRpt( X , 0  , 1  ,SpiDoTx ) ; %#ok<*ASGLU>

% Set a queue destination 
SpiClearQueue( 1 , SpiDoTx  ); 
NextPt = 0 ; 

% Travel few CM to the start
[str,~] = SpiSetPathPt( Qindex , NextPt , X , [1, 0, 0] , SpiDoTx );
 NextPt = NextPt + 1 ; 
[str,~] = SpiSetPathPt( Qindex , NextPt , X+[0.66,0,0] , [1, 0, 0] , SpiDoTx );

% Set the the command to 90 deg 
NextPt = NextPt + 1 ; 
Yew = pi/2 ; RotateCmd = 0 ; IsClimb = 0 ; 
[str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

% Travel few CM to the post
NextPt = NextPt + 1 ; 
[str,~] = SpiSetPathPt( Qindex , NextPt , [0.2,0.2,0] , [1, 0, 0] , SpiDoTx );


% % Change the mode to climb 
% NextPt = NextPt + 1 ; 
% Yew = pi/2 ; RotateCmd = 0 ; IsClimb = 1 ; 
% [str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );
% 
% 
% % Climb the post 
% NextPt = NextPt + 1 ; 
% [str,~] = SpiSetPathPt( Qindex , NextPt , [0,0 ,1.5] , [1, 0, 0] , SpiDoTx );
% 
% % Rotate the junction
% NextPt = NextPt + 1 ; 
% Yew = pi/2 ; RotateCmd = 1 ; IsClimb = 1 ; 
% [str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );
% 
% % Go straight to pack 
% NextPt = NextPt + 1 ; 
% [str,~] = SpiSetPathPt( Qindex , NextPt , [-1.0,0 ,0] , [1, 0, 0] , SpiDoTx );
% 
% % Handle the package 
% % NextPt = NextPt + 1 ; 
% % [str,reply] = SpiDealPack( 1 , NextPt , cmd ,SpiDoTx ) ; 
% 
% % Return home to junction 
% NextPt = NextPt + 1 ; 
% [str,~] = SpiSetPathPt( Qindex , NextPt , [1.0,0 ,0] , [1, 0, 0] , SpiDoTx );
% 
% % Back rotate junction 
% NextPt = NextPt + 1 ; 
% Yew = pi/2 ; RotateCmd = 1 ; IsClimb = 1 ; 
% [str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );
% 
% % Down we go 
% NextPt = NextPt + 1 ; 
% [str,~] = SpiSetPathPt( Qindex , NextPt , [0,0 ,-1.5] , [1, 0, 0] , SpiDoTx );
% 
% % Back from climb
% NextPt = NextPt + 1 ; 
% Yew = pi/2 ; RotateCmd = 0 ; IsClimb = 0 ; 
% [str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );
% 
% % Back to the ally 
% NextPt = NextPt + 1 ; 
% [str,~] = SpiSetPathPt( Qindex , NextPt , [0,-0.2,0] , [1, 0, 0] , SpiDoTx );
% 
% % Un crab 
% NextPt = NextPt + 1 ; 
% Yew = 0 ; RotateCmd = 0 ; IsClimb = 0 ; 
% [str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

% End the queue
NextPt = NextPt + 1 ; 
[str,~] = SpiSetPathWait( 1 , NextPt , inf ,SpiDoTx  ) ;

% and execute it 
[str,~] = SpiQueueExec( 1 , 0 , 1 , SpiDoTx  ) ; 


return ;

% Report for arrival 
X = [0.2,0,0] ;
[str,~] = SpiSetPosRpt( X , 0  , 1  ,SpiDoTx ) ; %#ok<*ASGLU>

% Report for zaimuth fix 
X = [0.2,0,0] ;
[str,~] = SpiSetPosRpt( X , 0  , 1  ,SpiDoTx ) ; %#ok<*ASGLU>

% Report for tangential fix 
X = [0.2,0,0] ;
[str,~] = SpiSetPosRpt( X , 0  , 1  ,SpiDoTx ) ; %#ok<*ASGLU>

% Report for last fix after the crab
X = [0.2,0,0] ;
[str,~] = SpiSetPosRpt( X , 0  , 1  ,SpiDoTx ) ; %#ok<*ASGLU>



% % Run kzat
% RecNames = {'PackageState'}; 
% 
% [pStat, RecStruct ] = ProgramRecorder(RecNames , RecStruct , @Comm2MatIntfc  ); 
% 
% TsRec = RecStruct.Gap * 4.096e-3 ; 
% Recs =  RecorderWaitGet( 40 ,RecStruct, @Comm2MatIntfc) ;
% t = Recs.Time ; 
% 
% figure(1) ; clf 
