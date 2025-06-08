global SimTime ;  %#ok<*NUSED>
global RxCtr ; 
global TxCtr ; 

global DataType
global RecStruct ; 
global TargetCanId 
global DatType 

ClimbDirOpt = struct('Right',1,'Left',-1 ) ;
bExetndedWidth = 1 ; % 1 ; 
JustClimb = 0 ; 
IgnoreJunction = 0; 
ShelfHeight = 1.093  ; % 2.075 ; % 1.58 ; % 1.093 ; 

RecTime = 20 ;  
MaxRecLen = 1400 ; 
ShelfRun = 0.0 ; 
DoShelfTravel = 0 ; 
ClimbDir = ClimbDirOpt.Right ; 

% Abort any previous mission 
SendObj( [hex2dec('2220'),94] , hex2dec('717b') , DataType.long , 'Abort exp_intetional_fault_sim' ) ;
SendObj( [hex2dec('2220'),97] , 1 , DataType.long, 'Set to ground' ) ;
SendObj( [hex2dec('2220'),99] , 1 , DataType.long, 'Define new protocol' ) ;

SendObj( [hex2dec('2220'),17] , 1234 , DataType.long , 'ShutUpOlivier' ) ;

if ClimbDir >= 0 
    stat = SendObj( [hex2dec('2222'),28] , 0.05 , DataType.float , 'Set crawl right' ) ;
else
    stat = SendObj( [hex2dec('2222'),29] , 0.05 , DataType.float , 'Set crawl left' ) ;
end

if stat   
    uiwait(msgbox({'Use the gorund vav menu','to crab the robot brfore start'}));
end
SendObj( [hex2dec('2222'),18] , 0 , DataType.long , 'Set debug variables to wheel arm') ; 
% SendObj( [hex2dec('2222'),23] , 1 , DataType.long , 'Allow user waits') ; 

% SetFloatPar('Geom.PinMotorCurrentAmp',1.2) ; 
% SetFloatPar('SysState.TrackWidthCtl.GlideMaxOverShoot',0.09) ; 
%AnaWheelArm ; % Program recorder
CalcGeomData

Anakuku ;
%AnaClimb ; % Program recorder
% AnaNeckInArc ; % Program recorder
% ProgAnaWheelArm ; 

% Mission configuratio
vvvmode = struct ( 'DoClimb' , 1 , 'DoRotateDisc' , DoShelfTravel, 'DoShelfTravel' , DoShelfTravel , 'DoPackage' , 1 ) ; 

xTarget = 1 ; 
yTarget = 0.0 ; % 0.290 at Yahali
% packTarget = xTarget - 0.58 ; 
% PackageDepth = 0.06 ; 
% PackageTiltDeg = 6; 
% PackageGet = 2 ; % 1 for Get , 2 for PUT
RetractedTrackWidth = Geom.TrackWidthCtl.RetractedWidth ;   
ExtendedTrackWidth  = Geom.TrackWidthCtl.ExtendedWidth24 ; 

if bExetndedWidth
    TrackWidth = ExtendedTrackWidth ; 
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
X = [xTarget ,0,0] ;

% Right wheel is to the y , left to -y 
ey =[0 1 0] ; 
Rw = X + Geom.Center2WheelDist * ey ; 
Lw = X - Geom.Center2WheelDist * ey ; 

% Set navigation 
[str,reply] = SpiSetPosRpt( X , 0  , 4 , SpiDoTx ) ; %#ok<*ASGLU>

% Must be done after set position to set the yaw correctly 
SendObj( [hex2dec('2222'),22] , 1 , DataType.long , 'Allow unfinished unclimb' ) ;


% Set a queue destination 
SpiClearQueue( Qindex , SpiDoTx); 
NextPt = 0 ; 

    % Change the mode to climb 
    Yew = ClimbDir * pi/2 ; RotateCmd = 0 ; IsClimb = 1 ; 
    [str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

    % Do the climb itself
    NextPt = NextPt + 1 ; 
    [str,~] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,ShelfHeight,TrackWidth,IgnoreJunction] , [1 , 0, 0] , SpiDoTx );


    if ( vvvmode.DoRotateDisc ) 
        % Rotate the disc 
        NextPt = NextPt + 1 ; 
        Yew = 0 ; RotateCmd = 1 ; IsClimb = 1 ; 
        [str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

        % Go somewhere in the med 
        if ( vvvmode.DoShelfTravel ) 
            NextPt = NextPt + 1 ; 
            [str,~] = SpiSetPathPt( Qindex , NextPt , [ShelfRun+xTarget,yTarget,ShelfHeight,TrackWidth] , [1, 0, 0] , SpiDoTx );

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
            [str,~] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,ShelfHeight,TrackWidth] , [1, 0, 0] , SpiDoTx );
        end                                                                                                                 

        % Unrotate the disc 
        NextPt = NextPt + 1 ; 
        Yew = ClimbDir * pi/2 ; RotateCmd = -1 ; IsClimb = 1 ; 
        [str,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

    end
    % Unclimb 
    
    if ( JustClimb == 0 ) 
        NextPt = NextPt + 1 ; 
        [str,~] = SpiSetPathPt( Qindex , NextPt , [xTarget,yTarget,0,RetractedTrackWidth,IgnoreJunction] , [1 , 0, 0] , SpiDoTx );

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
[str,reply] = SpiQueueExec( Qindex , 0 , 1 , SpiDoTx ) ; 

