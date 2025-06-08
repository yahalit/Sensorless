global DataType %#ok<*GVMIS> 
global TargetCanId 
global TargetCanId2 
global SimTime  
global RxCtr  
global TxCtr 
if exist('RecStruct','var') 
    clear RecStruct ; 
end 
global RecStruct 
global AtpCfg 
global UdpHandle 
global ProjectRoot2 

global LsTimer 
global CalibTable 
global CalibTable2 
global BitKillTime 
global DispT
global TmMgrT
global UdpStr   
global UseUdp 
global GuiTimerPeriod 
global TunnelCodes ; 
global TargetCanId 
global TargetCanId2 

BitKillTime = clock ; %#ok<CLOCK>

if ( ~isa(LsTimer,'timer') ) 
    LsTimer =  timer(...
    'ExecutionMode', 'fixedSpacing', ...       % Run timer repeatedly.
    'Period', 10e-2  ) ; 
end

if ~isdeployed %change by OBB to determine if run compiled on not.
    addpath('..\LBTest');  
    addpath('..\LBTest\Tests\WheelArmTests') ; 
    addpath('..\LBTest\Tests\Shelf') ; 
    addpath('..\LBTest\Tests\Neck') ; 
    addpath('..\LBTest\Tests\Manip') ; 
    addpath('..\LBTest\Tests\SciTest') ; 
    addpath('..\LBTest\Tests\Program') ; 
    addpath('..\LBTest\Tests\LineTrackTest') ; 
    addpath('..\LBTest\Tests\Regev') ; 
    addpath('..\LBTest\ATP');  
    addpath('..\LBTest\Geom');  
    addpath('..\DownloadFW');  
    addpath('..\SpiSim');  
    addpath('..\KvaserCom');  
    addpath('..\Recorder');  
    addpath('..\Tunnel');  
    addpath('..\Util');  
    addpath('..\Common');
    addpath('..\..\Matlab\JavaTreeWrapper' ) ; % Add path for tree GUI
    addpath('..\..\Matlab\jsonlab-1.5') ; % Add path for JSON 
    addpath('..\..\Matlab\Rgb') ; % Add path for JSON 
    addpath('..\..\..\Drivers\Kvaser\WhTest');  
end
CreateStruct =  struct('Interpreter','tex','WindowStyle' , 'modal') ; 



% if isempty(GuiTimerPeriod) || ~isnumeric(GuiTimerPeriod) || GuiTimerPeriod < 0.1 || GuiTimerPeriod > 10 
%     GuiTimerPeriod = 0.4 ; 
% end 

AtpStartCom ;

% global GoRouteTimer ; 
% GoRouteTimer = timer('ExecutionMode', 'fixedSpacing','Period', 0.3,'TimerFcn', @yobt, 'UserData' , 'GoRouteTimer');

if ~exist('DispT','var') || ~isa(DispT,'DlgTimerObj')
    DispT = DlgTimerObj ; % Generate an object that owns a timer 
    TmMgrT = TimerManagerObj(); % This time mahager object issues timing events for all the dialogs
    TmMgrT.listenToTimer(DispT) ; 
end 

DataType=struct( 'long' , 0 , 'float', 1 , 'short' , 2 , 'char' , 3 ,'string', 9 ,'lvec' , 10 ,'fvec' , 11 , 'ulvec' , 20 ) ; 

if ~isdeployed()
    EntityDir = '..\..\Entity\'; 
else
    EntityDir = '..\..\LP files\Entity\'; 
end

% Having established communication, get the version 
SwVer = FetchObj([hex2dec('2301'),7],DataType.long,'GetVersion') ;
if ( SwVer < 0 ), SwVer = SwVer + 2^32 ; end
EntFName = [EntityDir,'LpEntity_',num2str(SwVer)]  ;
try 
    Ent = load( EntFName ) ; 
    RecStruct = Ent.RecStruct; 
catch
    MyErrDlg({'No database found for the SW version in the robot','You will only be able to download new SW'},'Attention') ; 
    return ;
end
RecStruct.TargetCanId = TargetCanId  ; 
RecStruct.TargetCanId2 = TargetCanId2  ; 


CalibTable = Ent.SupplementStr.CalibTable;
CalibTable2= Ent.SupplementStr.CalibTable2;
TunnelCodes= Ent.SupplementStr.TunnelCodes;

% Ask the revisions of the axes 

if ~isdeployed()
    DriveEntityDir = '..\..\..\Drivers\Entity\';
else
    DriveEntityDir = '..\..\Drivers Files\Entity\';
end

try 
    RWSwVer = FetchObj([hex2dec('2206'),21],DataType.long,'Axis version 1') ;
    LWSwVer = FetchObj([hex2dec('2206'),22],DataType.long,'Axis version 2') ;
    RSSwVer = FetchObj([hex2dec('2206'),23],DataType.long,'Axis version 3') ;
    LSSwVer = FetchObj([hex2dec('2206'),24],DataType.long,'Axis version 4') ;
    NKSwVer = FetchObj([hex2dec('2206'),25],DataType.long,'Axis version 5') ;
    RISwVer = FetchObj([hex2dec('2206'),30],DataType.long,'Axis version 6') ;
    LISwVer = FetchObj([hex2dec('2206'),31],DataType.long,'Axis version 7') ;
    AxVerVec  =   [RWSwVer,LWSwVer,RSSwVer,LSSwVer,NKSwVer] ; 
    load([DriveEntityDir, 'RecentVer.mat']); %OBB: added to get the recent version for BHErrorCodes in case there are no axes on CAN1
	%TODO: change to get tray axes version
    u =unique(AxVerVec) ;
    AxisSwVer = max(u) ; 
catch
    AxisSwVer = 0 ; 
    u = 0; %OBB - added line
	uiwait( errordlg('The LP cannot communicate with one of the drivers. Use WhoIsThere app to diagnose.') ); %OBB - added for debugging
end

% if length(u) > 1 
%     h = errordlg({'Servo units has different SW versions','Only the latest shall be considered','Reading from older axes may present a problem'},'Porblem') ; 
%     while( isvalid(h) )
%         set(h,'WindowStyle','modal');
%         pause(0.2) ; 
%     end
% end
RecStruct.RWEntity = GetEntity(dir([DriveEntityDir,'\WheelEntity_',num2str(RWSwVer),'.mat']) ) ; 
RecStruct.LWEntity = GetEntity(dir([DriveEntityDir,'\WheelEntity_',num2str(LWSwVer),'.mat']) ) ; 
RecStruct.RSEntity = GetEntity(dir([DriveEntityDir,'\WheelEntity_',num2str(RSSwVer),'.mat']) ) ; 
RecStruct.LSEntity = GetEntity(dir([DriveEntityDir,'\WheelEntity_',num2str(LSSwVer),'.mat']) ) ; 
RecStruct.NKEntity = GetEntity(dir([DriveEntityDir,'\NeckEntity_',num2str(NKSwVer),'.mat']) ) ; 
RecStruct.RIEntity = GetEntity(dir([DriveEntityDir,'\IntfcEntity_',num2str(RISwVer),'.mat']) ) ; 
RecStruct.LIEntity = GetEntity(dir([DriveEntityDir,'\IntfcEntity_',num2str(LISwVer),'.mat']) ) ; 
RecStruct.RecentVerNeckEntity = GetEntity(dir([DriveEntityDir,'\NeckEntity_',num2str(neck_srcver),'.mat']) ) ; %OBB: added to get the recent version for BHErrorCodes in case there are no axes on CAN1


%added for compiled version debugging - don't delete
try 
    RecStruct.SigList; 
catch ME 
    uiwait( errordlg({'AtpStart, chekcing RecStruct.SigList, ';ME.message}) ); %added for debugging
end 

% if ( AxisSwVer == 0)
%     h = errordlg({'Drive does not answer or','Could not locate drive version in the repo','We will use the latest servo revision data','Reading states of axes may be a problem'},'Porblem') ; 
%     while( isvalid(h) )
%         set(h,'WindowStyle','modal');
%         pause(0.2) ; 
%     end
%     junk = dir([DriveEntityDir,'\*.mat']) ;
%     vn = zeros(1,length(junk)  );
%     for cnt  = 1:length(junk)
%         mm = strsplit( junk(cnt).name(1:end-4),'_') ;
%         if length(mm) > 1
%             try
%                vn(cnt) = str2double( mm{2} );
%             catch
%             end
%         end
%     end
%     [mm,mind] = max(vn) ; 
%     vername = junk(mind(1)).name ; 
% end
if ~isempty(RecStruct.RWEntity) 
    RecStruct.BHErrCodes = RecStruct.RWEntity.ErrCodes ;
else
    RecStruct.BHErrCodes = RecStruct.RecentVerNeckEntity.ErrCodes ; 
end
