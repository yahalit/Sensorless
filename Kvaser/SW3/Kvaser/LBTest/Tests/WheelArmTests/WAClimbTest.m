global SimTime ;  %#ok<*NUSED>
global RxCtr ; 
global TxCtr ; 

global DataType
global RecStruct ; 
global TargetCanId 
global DatType 

RecTime = 5; 

% Mission configuratio
vvvmode = struct ( 'DoClimb' , 1 , 'DoRotateDisc' , 0, 'DoShelfTravel' , 1, 'DoPackage' , 1 ) ; 



xTarget = 1 ; 
yTarget = 0.05 ; % 0.290 at Yahali
packTarget = xTarget - 0.58 ; 
PackageDepth = 0.06 ; 
PackageTiltDeg = 6; 
PackageGet = 2 ; % 1 for Get , 2 for PUT

% disp('Reduced shelf height, dont attempt disc') ; 
ShelfHeight = 1.25 ; % Dont find 1.1 ; %// 1.33 at Yahali ; 

% DO NOT CHANGE BELOW THIS 
%%%%%%%%%%%%%%%%%%%%%%%%%%

Qindex = 1 ; 
SpiDoTx = 2 ; 
TsBase = 4.096e-3 ; 

RxCtr = 0 ; 
TxCtr = 0 ; 
SimTime = 0 ;

Geom = struct ('Center2WheelDist', GetFloatPar('Geom.Center2WheelDist')  ) ;


% Robot initial position 
X = [xTarget ,0,0] ;

% Right wheel is to the y , left to -y 
ey =[0 1 0] ; 
Rw = X + Geom.Center2WheelDist * ey ; 
Lw = X - Geom.Center2WheelDist * ey ; 

% Set navigation 
[str,reply] = SpiSetPosRpt( X , 0  , 4 , SpiDoTx ) ; %#ok<*ASGLU>

% Set a queue destination 
SpiClearQueue( Qindex , SpiDoTx); 
NextPt = 0 ; 
% [str,reply] = SpiSetPathPt( Qindex , NextPt , X , [1,0,0] , SpiDoTx) ; 
% 
% NextPt = NextPt + 1 ; 

[str,reply] = SpiSetPathPt( Qindex , NextPt , [xTarget,0,0] , [1,0,0] , SpiDoTx) ; 

% Set the yew and up we climb ...
% Set the the command to 90 deg 
NextPt = NextPt + 1 ; 
Yew = pi/2 ; RotateCmd = 0 ; IsClimb = 0 ; 
[str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

% Travel few CM to the post
NextPt = NextPt + 1 ; 
[str,reply] = SpiSetPathPt( Qindex , NextPt , [xTarget,0,0] , [1,0,0] , SpiDoTx) ; 

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
    [str,~] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,0] , [1 , 0, 0] , SpiDoTx );

    NextPt = NextPt + 1 ; 
    [str,~] = SpiSetPathPt( Qindex , NextPt , [xTarget,0.0,0] , [1 , 0, 0] , SpiDoTx );

    % Uncrab 
    NextPt = NextPt + 1 ; 
    Yew = 0 ; RotateCmd = 0 ; IsClimb = 0 ; 
    [str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

    % Normal drive 
    NextPt = NextPt + 1 ; 
    [str,~] = SpiSetPathPt( Qindex , NextPt , [xTarget,0.0,0] , [1 , 0, 0] , SpiDoTx );
%     [str,~] = SpiSetPathPt( Qindex , NextPt , [xTarget+0.15,0.0,0] , [1 , 0, 0] , SpiDoTx );

end


% 
% End the queue
NextPt = NextPt + 1 ; 
[str,reply] = SpiSetPathWait( Qindex , NextPt , inf , SpiDoTx ) ;


% and execute it 
[str,reply] = SpiQueueExec( Qindex , 0 , 1 , SpiDoTx ) ; 

