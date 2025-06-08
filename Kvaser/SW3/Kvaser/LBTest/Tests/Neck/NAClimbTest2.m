global SimTime ;  %#ok<*NUSED>
global RxCtr ; 
global TxCtr ; 

global DataType
global RecStruct ; 
global TargetCanId 
global DatType 

% RecTime = 5; 
ReadQR = 0 ; 
bExetndedWidth = 1 ; % 1 ; 
JustClimb = 0 ; 
IgnoreJunction = 1; 
ShelfHeight = 2.08 ; % 1.58 ; % 1.093 ; % 1.093 ; 
PoleDist = 1.0 ; 
% RecTime = 40 ;  
% MaxRecLen = 1400 ; 
ClimbDir = 1 ; % 1 for right , L for left 
ShelfRun = 0.35 * ClimbDir ; 
DoShelfTravel = 0 ; 
NavDesc = GetNavDesc([] ) ;
if ReadQR
    SendObj( [hex2dec('2220'),17] , 6790 , DataType.long , 'ShutUpOlivier' ) ;
else
    SendObj( [hex2dec('2220'),17] , 1234 , DataType.long , 'ShutUpOlivier' ) ; %#ok<UNRCH>
end

% Abort any previous mission 
SendObj( [hex2dec('2220'),94] , hex2dec('717b') , DataType.long , 'Abort exp_intetional_fault_sim' ) ;
SendObj( [hex2dec('2220'),97] , 1 , DataType.long, 'Set to ground' ) ;
SendObj( [hex2dec('2220'),99] , 1 , DataType.long, 'Define new protocol' ) ;

if ~ReadQR
    try 
        if ClimbDir >= 0 
            SendObj( [hex2dec('2222'),28] , 0.05 , DataType.float , 'Set crawl right' ) ;
        else
            SendObj( [hex2dec('2222'),29] , 0.05 , DataType.float , 'Set crawl left' ) ;
        end
    catch 
        uiwait(msgbox({'Fail transit to crabbed state','Steering is not set correctly?'})) ; 
        return
    end 
end

SendObj( [hex2dec('2222'),18] , 0 , DataType.long , 'Set debug variables to wheel arm') ; 
% SetFloatPar('SysState.TrackWidthCtl.GlideMaxOverShoot',0.09) ; 
%AnaWheelArm ; % Program recorder
CalcGeomData


% Mission configuratio
vvvmode = struct ( 'DoClimb' , 1 , 'DoRotateDisc' , DoShelfTravel, 'DoShelfTravel' , DoShelfTravel , 'DoPackage' , 1 ) ; 

if ReadQR
% Robot heads to X 
    xTarget = NavDesc.QrY ; 
    yStart = NavDesc.QrX ;
    Heading = NavDesc.Heading ;
    yTarget = yStart - ClimbDir * PoleDist;  
else
    xTarget = 1 ;  %#ok<UNRCH>
    yTarget = 0.0 ; % 0.290 at Yahali
    Heading = 0 ; 
end
% packTarget = xTarget - 0.58 ; 
% PackageDepth = 0.06 ; 
% PackageTiltDeg = 6; 
% PackageGet = 2 ; % 1 for Get , 2 for PUT
RetractedTrackWidth = Geom.TrackWidthCtl.RetractedWidth ;   
ExtendedTrackWidth  = Geom.TrackWidthCtl.ExtendedWidth24 ; 

if bExetndedWidth
    TrackWidth = ExtendedTrackWidth ;  %#ok<UNRCH>
else
    TrackWidth = RetractedTrackWidth ; 
end

% DO NOT CHANGE BELOW THIS 
%%%%%%%%%%%%%%%%%%%%%%%%%%

Qindex = 1 ; 
SpiDoTx = 2 ; 
TsBase = 4.096e-3 ; 

RxCtr = 0 ; 
TxCtr = 0 ; 
SimTime = 0 ;



% Robot initial position 
X = [xTarget ,yTarget,0] ;

% Right wheel is to the y , left to -y 
ey =[0 1 0] ; 
Rw = X + Geom.Center2WheelDist * ey ; 
Lw = X - Geom.Center2WheelDist * ey ; 

% Set navigation 
if ( ReadQR == 0 ) 
    [str,reply] = SpiSetPosRpt( X , 0  , 4 , SpiDoTx ) ; %#ok<*ASGLU>
end

% Must be done after set position to set the yaw correctly 
SendObj( [hex2dec('2222'),22] , 1 , DataType.long , 'Allow unfinished unclimb' ) ;


% Set a queue destination 
SpiClearQueue( Qindex , SpiDoTx); 
NextPt = 0 ; 
TravelDirUnit = [cos(Heading), sin(Heading) , 0]; 
if ReadQR

    % Set the yew and up we climb ...
    % Set the the command to 90 deg 
    Yew =   ClimbDir * pi/2 ; RotateCmd = 0 ; IsClimb = 0 ; 
    [str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );
    NextPt = NextPt + 1 ; 
    
    % Travel init
    [str,~] = SpiSetPathPt( Qindex , NextPt , [xTarget,yStart,0] , TravelDirUnit , SpiDoTx );
    NextPt = NextPt + 1 ; 

    % Travel few CM to the post
    [str,~] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,0] , TravelDirUnit , SpiDoTx );
    NextPt = NextPt + 1 ; 
    
    
end
    % Change the mode to climb 
    Yew = ClimbDir * pi/2 ; RotateCmd = 0 ; IsClimb = 1 ; 
    [str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

    % Do the climb itself
    NextPt = NextPt + 1 ; 
    [str,~] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,ShelfHeight,TrackWidth,IgnoreJunction] , TravelDirUnit , SpiDoTx );


    if ( vvvmode.DoRotateDisc ) 
        % Rotate the disc 
        NextPt = NextPt + 1 ; 
        Yew = 0 ; RotateCmd = 1 ; IsClimb = 1 ; 
        [str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

        % Go somewhere in the med 
        if ( vvvmode.DoShelfTravel ) 
            NextPt = NextPt + 1 ; 
            [str,~] = SpiSetPathPt( Qindex , NextPt , [ShelfRun+xTarget,yTarget,ShelfHeight,TrackWidth] , TravelDirUnit , SpiDoTx );

            % Put our precious package to place ...

%             packcmd = struct ('ActionLoad', PackageGet, 'Side' , 2 , 'PackageDepth' , ...
%                 PackageDepth  ,'PackageXOffset' , -0.57000 , ...
%                 'Incidence' ,  PackageTiltDeg / 180 * pi  ) ; 
% 
%                 if ( vvvmode.DoPackage ) 
%                     NextPt = NextPt + 1 ; 
%                     [str,~] = SpiDealPack( Qindex , NextPt , packcmd , SpiDoTx );
%                 end 

            % Return to post 
            NextPt = NextPt + 1 ; 
            [str,~] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,ShelfHeight,TrackWidth] , TravelDirUnit , SpiDoTx );
        end                                                                                                                 

        % Unrotate the disc 
        NextPt = NextPt + 1 ; 
        Yew = ClimbDir * pi/2 ; RotateCmd = -1 ; IsClimb = 1 ; 
        [str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

    end
    % Unclimb 
    
    if ( JustClimb == 0 ) 
        NextPt = NextPt + 1 ; 
        [str,~] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,0,RetractedTrackWidth,IgnoreJunction] , TravelDirUnit , SpiDoTx );

        % Change the mode to unclimbed 
        NextPt = NextPt + 1 ; 
        Yew = ClimbDir * pi/2 ; RotateCmd = 0 ; IsClimb = 0 ; 
        [str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );
    end
% end


% 
% End the queue
NextPt = NextPt + 1 ; 
[str,reply] = SpiSetPathWait( Qindex , NextPt , inf , SpiDoTx ) ;


% and execute it 
%AnaClimb ; % Program recorder
AnaClimbInArc ; % Program recorder
[str,reply] = SpiQueueExec( Qindex , 0 , 1 , SpiDoTx ) ; 

