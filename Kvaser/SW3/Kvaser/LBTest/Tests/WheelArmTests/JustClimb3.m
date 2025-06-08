global RecStruct ; 
global TargetCanId 
% Ignore Jetson !
DataType  = GetDataType();
SendObj( [hex2dec('2220'),17] , 1234 , DataType.long , 'ShutUpOlivier' ) ;

CreateStruct =  struct('Interpreter','tex','WindowStyle' , 'modal') ; 

ClimbDirOpt = struct('Right',1,'Left',-1 ) ;
% RecTime = 5; 
bExetndedWidth = 0 ; % 1 ; 
JustClimb = 0 ; % if 1 it will just climb but not unclimb
IgnoreJunction = 1;  % If 1 not expecting any junction
ShelfHeight = 1.093  ; % 2.075 ; % 1.58 ; % 1.093 ; 
% RecTime = 40 ;  
% MaxRecLen = 1400 ; 
ClimbDir = ClimbDirOpt.Right ; 
ShelfRun = -0.35 ; % (meter) If making junction and shelf, it will run this distance on the shelf and return
DoShelfTravel = 0 ; 
SetFloatPar('AutomaticRunPars.PoleSpeed',0.1) ; % m/sec on the climb Auto mode , The speed on the pole, changed to 0.30 for robot-actuated junctions

% ///////////////////////////////////////
% End of setting
% Here starts automated code to run according to above settings
% ///////////////////////////////////////
CrabIt(ClimbDir) ; % Start by crabbing to correct direction 

% Record switch variables  
SendObj( [hex2dec('2222'),2] , 1 , DataType.long , 'Record switch debug' ) ;
% Record gyro variables  
SendObj( [hex2dec('2222'),17] , 1 , DataType.long , 'Record gyro climb debug' ) ;

% Abort any previous mission 
SendObj( [hex2dec('2220'),94] , hex2dec('717b') , DataType.long , 'Abort exp_intetional_fault_sim' ) ;
SendObj( [hex2dec('2220'),97] , 1 , DataType.long, 'Set to ground' ) ;
SendObj( [hex2dec('2220'),99] , 1 , DataType.long, 'Define new protocol' ) ;

MyErrDlg({'Please approve all the junctions are aligned','Speed to slow for auto alignment'},'Attention')


if ClimbDir >= 0 
    stat = SendObj( [hex2dec('2222'),28] , 0.05 , DataType.float , 'Set crawl right' ) ;
    if ( stat )
        CrabIt(1) ; 
    end
    stat = SendObj( [hex2dec('2222'),28] , 0.05 , DataType.float , 'Set crawl right' ) ;
else
    stat = SendObj( [hex2dec('2222'),29] , 0.05 , DataType.float , 'Set crawl left' ) ;
    if ( stat )
        CrabIt(-1) ; 
    end
    stat = SendObj( [hex2dec('2222'),29] , 0.05 , DataType.float , 'Set crawl left' ) ;
end

if stat   
    msgbox({'\fontsize{14}Could not','Crab the robot brfore start'},CreateStruct) ;
    return
end
% SendObj( [hex2dec('2222'),18] , 0 , DataType.long , 'Set debug variables to wheel arm') ; 

% SetFloatPar('Geom.PinMotorCurrentAmp',1.2) ; 
% SetFloatPar('SysState.TrackWidthCtl.GlideMaxOverShoot',0.09) ; 
%AnaWheelArm ; % Program recorder
CalcGeomData


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
    TrackWidth = ExtendedTrackWidth ; %#ok<UNRCH> 
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

% Allow unfinished unclimb and set NomRouteTangent equal to yaw
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

% Activate recorder 
recorder4JustClimb3 ; % Program recorder

% and execute it 
[str,reply] = SpiQueueExec( Qindex , 0 , 1 , SpiDoTx ) ; 

