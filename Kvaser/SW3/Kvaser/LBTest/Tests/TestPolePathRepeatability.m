global SimTime ;  %#ok<*NUSED>
global RxCtr ; 
global TxCtr ; 

global DataType
global RecStruct ; 
global TargetCanId 
global DatType 


% SetFloatPar('Geom.LimitSw2DistPosOnArc',0.14 ) ;

xTarget = 4.5 ; 
yTarget = 0.35 ; % 0.290 at Yahali

% disp('Reduced shelf height, dont attempt disc') ; 
ShelfHeight = [2.5 1 2.5 1 2.5 1 2.5 1] ; %// 1.33 at Yahali ; 


% DO NOT CHANGE BELOW THIS 
%%%%%%%%%%%%%%%%%%%%%%%%%%

Qindex = 1 ; 
SpiDoTx = 2 ; % 1 for simulation, 2 for CAN , 3 for shorts text out , 4 for byte text out
TsBase = 4.096e-3 ; 

RxCtr = 0 ; 
TxCtr = 0 ; 
SimTime = 0 ;


% Robot initial position 
X = [xTarget ,0,0] ;

% Right wheel is to the y , left to -y 
Out = [] ; 

% Set navigation 
XStart = X - [0.6 0 0];
[str,reply] = SpiSetPosRpt( XStart  , 0  , 4 , SpiDoTx ) ; %#ok<*ASGLU>


% Set a queue destination 
SpiClearQueue( Qindex , SpiDoTx); 
NextPt = 0 ; 
nHeight = 0 ; 
[str,reply] = SpiSetPathPt( Qindex , NextPt , XStart , [1,0,0] , SpiDoTx) ; 
NextPt = NextPt + 1 ;
[str,reply] = SpiSetPathPt( Qindex , NextPt , X , [1,0,0] , SpiDoTx) ; 

% Set the yew and up we climb ...
% Set the the command to 90 deg 
NextPt = NextPt + 1 ; 
Yew = pi/2 ; RotateCmd = 0 ; IsClimb = 0 ; 
[str,reply] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

% Travel few CM to the post
NextPt = NextPt + 1 ; 
[str,reply] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,0] , [1, 0, 0] , SpiDoTx );

% Change the mode to climb 
NextPt = NextPt + 1 ; 
Yew = pi/2 ; RotateCmd = 0 ; IsClimb = 1 ; 
[str,reply] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

% Do the climb itself
for ptCnt = 1:length(ShelfHeight)
    NextPt = NextPt + 1 ; 
    nHeight = nHeight + 1 ; 
    [str,reply] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,-ShelfHeight(ptCnt) ] , [1 , 0, 0] , SpiDoTx );
end 
% 
% End the queue
NextPt = NextPt + 1 ; 
[str,reply] = SpiSetPathWait( Qindex , NextPt , inf , SpiDoTx ) ;
Out = [ Out ; double(reply) ] ; 


% and execute it 
[str,reply] = SpiQueueExec( Qindex , 0 , 1 , SpiDoTx ) ; 

