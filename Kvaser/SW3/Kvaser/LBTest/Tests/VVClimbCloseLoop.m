
% Interface (Olivier) global frame: Y is North, X is East, Z is UP 
% Robot global ataframe: X is north, Y is East, Z is down. (0 - north, 90deg - east).
% Robot local: X ahead
% Olivier: Y is left, Z is up 
% Robot  : Y is right, Z is down 


global SimTime ;  %#ok<*NUSED>
global RxCtr ; 
global TxCtr ; 

global DataType
global RecStruct ; 
global TargetCanId 
global DatType 

side = "right"; %"left"  OR "right"

% SetFloatPar('Geom.LimitSw2DistPosOnArc',0.14 ) ;

%xTarget = 4.49 ; 
xInit = 0.0 ; 
Xnew = 0.18 ;

if (side == "left")
    yTerminal = 0.35 ; % 0.290 at Yahali
else
    yTerminal = -0.35 ; % 0.290 at Yahali
end

% disp('Reduced shelf height, dont attempt disc') ; 
ShelfHeight = [1 ] ; %// 1.33 at Yahali ; 


% DO NOT CHANGE BELOW THIS 
%%%%%%%%%%%%%%%%%%%%%%%%%%

Qindex = 1 ; 
SpiDoTx = 2 ; % 1 for simulation, 2 for CAN , 3 for shorts text out , 4 for byte text out
TsBase = 4.096e-3 ; 

RxCtr = 0 ; 
TxCtr = 0 ; 
SimTime = 0 ;

% Robot initial position 
Xstart = [xInit ,0,0] ;
X = [Xnew ,0,0] ;

% Right wheel is to the y , left to -y 
Out = [] ; 

% Set navigation 
%XStart = X - [0.6 0 0]; %OBB3: [Y, X, Z] ??
%[str,reply] = SpiSetPosRpt( XStart  , 0  , 4 , SpiDoTx ) ; %#ok<*ASGLU> //OBB3: what is mode 4
% mode changed to 1 based on ICD (1 - Condition initializer on the ground. Any previous navigation data will be discarded).
[str,reply] = SpiSetPosRpt( Xstart  , 0  , 4 , SpiDoTx ) ; %#ok<*ASGLU>  //4 is mode force
%SpiSetPosRpt is equivalent ot seeing a QR code.

% Set a queue destination 
SpiClearQueue( Qindex , SpiDoTx); 
NextPt = 0 ; 
nHeight = 0 ; 
[str,reply] = SpiSetPathPt( Qindex , NextPt , Xstart , [1,0,0] , SpiDoTx) ;  %OBB3: [1,0,0] [Y, X, Z] ?? Cz = 0,1,0 (x y x robot)
%the projection on X axis (RC) is 1 --> robot fuselage is aligned with x
%(to the right of the robot).

% % Set a queue destination 
% NextPt = NextPt + 1 ;  
% % nHeight = 0 ; 
% [str,reply] = SpiSetPathPt( Qindex , NextPt , X , [1,0,0] , SpiDoTx) ;  %OBB3: [1,0,0] [Y, X, Z] ?? Cz = 0,1,0 (x y x robot)

% Set the yew and up we climb ...
% Set the the command to 90 deg 
NextPt = NextPt + 1 ; 
if (side == "left")
    Yew = -pi/2;
else
    Yew = pi/2;
end
RotateCmd = 0 ; IsClimb = 0 ;  %Yew = pi/2 - right climb   ;   Yew = -pi/2 - left climb
[str,reply] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );


NextPt = NextPt + 1 ;
[str,reply] = SpiSetPathPt( Qindex , NextPt , X , [1,0,0] , SpiDoTx) ; 

% Travel few CM to the post
NextPt = NextPt + 1 ; 
[str,reply] = SpiSetPathPt( Qindex , NextPt , [Xnew,yTerminal,0] , [1, 0, 0] , SpiDoTx );


% Change the mode to climb  - can be called only after crab was done. 
NextPt = NextPt + 1 ; 
if (side == "left")
    Yew = pi/2;
else
    Yew = -pi/2;
end
RotateCmd = 0 ; IsClimb = 1 ; 
[str,reply] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

% % End the queue
NextPt = NextPt + 1 ; 
[str,reply] = SpiSetPathWait( Qindex , NextPt , inf , SpiDoTx ) ;
Out = [ Out ; double(reply) ] ; 

% and execute it 
[str,reply] = SpiQueueExec( Qindex , 0 , 1 , SpiDoTx ) ; 
return 



% % Change the mode to climb 
% NextPt = NextPt + 1 ; 
% Yew = pi/2 ; RotateCmd = 0 ; IsClimb = 1 ; 
% [str,reply] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );
% 
% % Do the climb itself
% for ptCnt = 1:length(ShelfHeight)
%     NextPt = NextPt + 1 ; 
%     nHeight = nHeight + 1 ; 
%     [str,reply] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,-ShelfHeight(ptCnt) ] , [1 , 0, 0] , SpiDoTx );
% end 
% 
% NextPt = NextPt + 1 ; 
% [str,reply] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,0] , [1 , 0, 0] , SpiDoTx );
% 
% % Change the mode to unclimbed 
% NextPt = NextPt + 1 ; 
% Yew = pi/2 ; RotateCmd = 0 ; IsClimb = 0 ; 
% [str,reply] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );
% 
% NextPt = NextPt + 1 ; 
% [str,reply] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,0] , [1 , 0, 0] , SpiDoTx );
% 
% % Return to course 
% NextPt = NextPt + 1 ; 
% [str,reply] = SpiSetPathPt( Qindex , NextPt , [xTarget,0.0,0] , [1 , 0, 0] , SpiDoTx );
% 
% % Uncrab 
% NextPt = NextPt + 1 ; 
% Yew = 0 ; RotateCmd = 0 ; IsClimb = 0 ; 
% [str,reply] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );
% 
% % Normal drive 
% NextPt = NextPt + 1 ; 
% [str,reply] = SpiSetPathPt( Qindex , NextPt , [xTarget+0.15,0.0,0] , [1 , 0, 0] , SpiDoTx );
% 
% 
% % 
% % End the queue
% NextPt = NextPt + 1 ; 
% [str,reply] = SpiSetPathWait( Qindex , NextPt , inf , SpiDoTx ) ;
% Out = [ Out ; double(reply) ] ; 
% 
% 
% % and execute it 
% [str,reply] = SpiQueueExec( Qindex , 0 , 1 , SpiDoTx ) ; 

