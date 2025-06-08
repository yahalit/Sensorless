global SimTime ;  %#ok<*NUSED>
global RxCtr ; 
global TxCtr ; 

global DataType
global RecStruct ; 
global TargetCanId 
global DatType 

SetFloatPar( 'ControlPars.CurvatureCorrectGain', 1) ; % 165  ) ;
SetFloatPar( 'ControlPars.RouteLookAheadDist', 0.6 ) ;
SetFloatPar( 'SysPars.Nav.SegPosCorrectionFac', 0.1 ) ;

RecTime = 3.5; 
%XStart  = 4.6 ; 
XStart  = 1.5300 ; 

% Mission configuratio
RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1  ) ; 

d = -1.21 ; 
xTargetVec = [0 , d,d,d ] + XStart ; 
yTargetVec = [0 , 0    0  0.6] ; 
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

SendObj( [hex2dec('2203'),100] , 1 , DataType.short ,'Chakalaka 0n') ;

% Robot initial position 
X = [xTarget(1) ,0,0] ;

% Right wheel is to the y , left to -y 
ex =[1 0 0] ; 
ey =[0 1 0] ; 

% Set a queue destination 
SpiClearQueue( Qindex , SpiDoTx); 
NextPt = 0 ; 
[~,~] = SpiSetPathPt( Qindex , NextPt , [xTargetVec(NextPt+1),yTargetVec(NextPt+1),0] , -ex , SpiDoTx) ; 
NextPt = NextPt + 1  ; 
[~,~] = SpiSetPathPt( Qindex , NextPt , [xTargetVec(NextPt+1),yTargetVec(NextPt+1),0] , -ex , SpiDoTx) ; 

NextPt = NextPt + 1  ; 
[~,~] = SpiSetPathPt( Qindex , NextPt , [xTargetVec(NextPt+1),yTargetVec(NextPt+1),0] , ey , SpiDoTx) ; 

NextPt = NextPt + 1  ; 
[~,~] = SpiSetPathPt( Qindex , NextPt , [xTargetVec(NextPt+1),yTargetVec(NextPt+1),0] , ey , SpiDoTx) ; 


% End the queue
NextPt = NextPt + 1 ; 
[~,~] = SpiSetPathWait( Qindex , NextPt , inf , SpiDoTx ) ;

% Program recoder 
RecStruct.Sync2C = 1 ; 
RecNames = {'iPos0','iPos1','RawSEst','RouteLocation0','CurveCorrection','RwSteerTarget','LineCurvature','EulerYaw',...
    'CorrectByLineStatistics1','CorrectByLineStatistics2'} ;
[~,RecStruct] = Recorder(RecNames , RecStruct , RecInitAction   );

% and execute it 
[str,reply] = SpiQueueExec( Qindex , 0 , 1 , SpiDoTx ) ; 

return 

[~,~,Recs] = Recorder(RecNames , RecStruct , RecBringAction   );
t = Recs.t ; 
figure(10) ; clf ; 
subplot( 3,1,1); 
plot( t, Recs.iPos0) ; 
subplot( 3,1,2) 
plot( t, Recs.iPos1) ;
subplot( 3,1,3) 
plot( t, Recs.EulerYaw) ;


