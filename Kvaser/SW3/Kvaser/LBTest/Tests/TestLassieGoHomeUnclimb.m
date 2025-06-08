global DataType
% TestLassieGoHomeUnclimb 

ShelfHeight = 1.0 ; 
yDist = 0.35 ;
GoDown = 0; 

% DO NOT CHANGE BELOW THIS 
%%%%%%%%%%%%%%%%%%%%%%%%%%

Qindex = 1 ; 
SpiDoTx = 2 ; 

SendObj( [hex2dec('2203'),100] , 1 , DataType.short ,'Chakalaka 0n') ;


% Set a queue destination 
SpiClearQueue( Qindex , SpiDoTx); 

NextPt = 0 ; 
[~,~] = SpiSetSpecials( 'Lassie' , struct('Dir',1,'Height',ShelfHeight)  , SpiDoTx ) ; 

if GoDown 
    % Unrotate the disc 
    NextPt = NextPt + 1 ; 
    Yew = pi/2 ; RotateCmd = -1 ; IsClimb = 1 ; 
    [~,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

    % Unclimb 
    NextPt = NextPt + 1 ; 
    xTarget = 0 ; yTarget = 0 ; 
    [~,~] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,-ShelfHeight] , [1 , 0, 0] , SpiDoTx );

    NextPt = NextPt + 1 ; 
    [~,~] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,0] , [1 , 0, 0] , SpiDoTx );

    % Change the mode to unclimbed 
    NextPt = NextPt + 1 ; 
    RotateCmd = 0 ; IsClimb = 0 ; 
    [~,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

    % Return to course 
    NextPt = NextPt + 1 ; 
    [~,~] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,0] , [1 , 0, 0] , SpiDoTx );

    NextPt = NextPt + 1 ; 
    [~,~] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget-yDist,0] , [1 , 0, 0] , SpiDoTx );

    % Uncrab 
    NextPt = NextPt + 1 ; 
    Yew = 0 ; RotateCmd = 0 ; IsClimb = 0 ; 
    [~,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

end 

% End the queue
NextPt = NextPt + 1 ; 
[~,~] = SpiSetPathWait( Qindex , NextPt , inf , SpiDoTx ) ;

% and execute it 
[~,~] = SpiQueueExec( Qindex , 0 , 1 , SpiDoTx ) ; 


return 
