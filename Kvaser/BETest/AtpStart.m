global DataType %#ok<*GVMIS> 
global TargetCanId 
if exist('RecStruct','var') 
    clear RecStruct ; 
end 
global RecStruct 
global AtpCfg 

global LsTimer 

global BitKillTime 
global DispT
global TmMgrTS
global GuiTimerPeriod 
global GetStateList
% global GetAnalogsList 
global CalibTable 

global EntityTableBESensorless 

global ActiveSetProj 


verbose = 0 ; 
% global ManipCalibFields

BitKillTime = clock ; %#ok<CLOCK> 

% ManipCalibFields = cell( 1,18) ; 
% for cnt = 1:18 
%     ManipCalibFields{cnt} = ['ParManipArr',num2str(cnt)] ; 
% end 
% ManipCalibFields(1:7) = {'RDoorCenter','RDoorGainFac','LDoorCenter','LDoorGainFac','ShoulderCenter','ElbowCenter','WristCenter'} ;

% CAN IDs of the robot: 
% BOOT of INTFC: 36 
% Boot of neck servo 38
% Boot of wheel servo 39 

if ( ~isa(LsTimer,'timer') ) 
    LsTimer =  timer(...
    'ExecutionMode', 'fixedSpacing', ...       % Run timer repeatedly.
    'Period', 10e-2  ) ; 
end

KvaserLibRoot = '..\SW3\Kvaser'; 

% addpath('..\NKTest');  
% addpath('..\NKTest\ATP');  

if ~isdeployed %change by OBB to determine if run compiled on not.
    addpath([KvaserLibRoot,'\KvaserCom']);  
    addpath([KvaserLibRoot,'\Recorder']);  
    addpath([KvaserLibRoot,'\Util']);  
    addpath([KvaserLibRoot,'\DownloadFW']);  

    addpath('..\SW3\Matlab\JavaTreeWrapper' ) ; % Add path for tree GUI
    addpath('..\SW3\Matlab\jsonlab-1.5') ; % Add path for JSON 
    addpath('..\SW3\Matlab\Rgb') ; % Add path for JSON 
    addpath('..\SW3\Kvaser\Common');
    addpath('..\ControlDes');  
    addpath('..\Control');  
    addpath('..\Emulation');  
    addpath('.\Test');  
    addpath('.\Test\HwTest');  
    addpath('.\HelpDoc');  
    addpath('..\Identification');  
    addpath('..\DownloadFW' );  
end

if ~isdeployed()
    EntityDir = '..\..\Entity\'; 
else
    EntityDir = '..\..\Drivers Files\Entity\'; 
end

CreateStruct =  struct('Interpreter','tex','WindowStyle' , 'modal') ; 

try 
load([EntityDir, 'RecentVer.mat']);
catch 
end 

MatDir   = '.\Mat\'; 

if isempty(GuiTimerPeriod) || ~isnumeric(GuiTimerPeriod) || GuiTimerPeriod < 0.1 || GuiTimerPeriod > 10 
    GuiTimerPeriod = 0.4 ; 
end 

AtpCfgTemp = struct ( 'FetchRetry' , 3 ,  'FetchRetryCnt' , 0 , 'DefaultCom', @NoneCom , 'GuiTimerPeriod' , GuiTimerPeriod ,'CanChannelAvailable',0 , 'CommType','None','Suspend',0) ; 


% global GoRouteTimer ; 
% GoRouteTimer = timer('ExecutionMode', 'fixedSpacing','Period', 0.3,'TimerFcn', @yobt, 'UserData' , 'GoRouteTimer');


if ~exist('DispT','var') || ~isa(DispT,'DlgTimerObj')
    DispT  = DlgTimerObj ; % Generate an object that owns a timer 
    TmMgrTS = TimerManagerObj('WHBIT'); % This time mahager object issues timing events for all the dialogs
    TmMgrTS.listenToTimer(DispT) ; 
end 

% [NeckRoot,WheelRoot,IntfcRoot,NeckDir,WheelDir,IntfcDir,~,ExeDir] = GetProjDirInfo();

DataType = GetDataType() ; % struct( 'long' , 0 , 'float', 1 , 'short' , 2 , 'char' , 3 ,'string', 9 ,'lvec' , 10 ,'fvec' , 11 , 'ulvec' , 20 ) ; 

% List of hardware projects

AtpCfgTemp.HwProjectsList = struct('BEDrvBootProjId',hex2dec('96f0'),...
    'BEDrvOpProjId',hex2dec('9700')) ;


% Get the list of implemented SW projects 
x = load([EntityDir, 'ProjcectsList']); %OOB - changed directory to entity
AtpCfgTemp.ProjList = x.ProjList ;  

if ~isfield(AtpCfg,'Done') || ~isequal( AtpCfg.Done , 1 ) 
    ActiveSetProj = 0 ;   
    try 
        pp = load([MatDir, 'ProjSelectOutput.mat']); %OBB
        pp = pp.data ; 
        proj = pp.Proj ; 
        card = pp.Card ;
        axis = pp.Axis ; 
        side = pp.Side ; 
    catch
        AtpCfg.Done = 0; 
        data = struct('Card','Neck','Axis','Neck','Proj','Single','Side','None','CanId',34,'ProjId',37632);
		%save ProjSelectOutput.mat data 
        save ([MatDir, 'ProjSelectOutput.mat'], 'data'); %OBB
        %pp = load('ProjSelectOutput.mat') ;
        pp = load([MatDir, 'ProjSelectOutput.mat']); %OBB
        pp = pp.data ; %OBB: added line
        proj = pp.Proj ; 
        card = pp.Card ; 
        axis = pp.Axis ;  
        side = pp.Side ; 
    end
else
%if isfield(AtpCfg,'Done')
    proj = RecStruct.Proj ; 
    card = RecStruct.Card ; 
    axis = RecStruct.Axis ; 
    side = RecStruct.Side ; 
end 


RecStruct = struct('Gap',1,'Len',300,'TrigSigName','UsecTimer','TrigSig',26,'TrigVal',2,'TrigType',0,'Signals',[1,2,3],...
    'Sync2C', 0 ,'PreTrigCnt', 150 , ...
    'Card',card,'Axis',axis,'Side',side,'Proj',proj) ; % , ... %'SigList' ,{SigTable}, 'SigNames' , {SigNames} , ...

% Get the card versions , just for now 
EntityTableBESensorless = GetEntityByVersion('BESensorless',besensorless_srcver,EntityDir,pwd) ; 

BERecStruct  = struct('Proj','Single','Card', 'Servo','Axis','Wheel','Side','Right')  ; 
[~,BERecStruct,BEGetStateList,BECalibTable] = SetCanComTarget(BERecStruct.Card,BERecStruct.Side,BERecStruct.Axis,BERecStruct.Proj,BERecStruct,44);

% Setup the communication adapter
KvaserPortsDescriptor = IdentifyMyKvaser() ; 
[nCan,~]  = size(KvaserPortsDescriptor) ; 
if nCan == 0 
    AtpCfgTemp.CanChannelAvailable = 0 ; 
    msgbox({'\fontsize{12}Can channel not available','Cannot find Kvaser CAN adapter',...
        'Use CommSetup to setup UDP'},CreateStruct) ; 
end
if nCan > 0 
    if ~isfield(AtpCfg,'Done') || ~isequal( AtpCfg.Done , 1 ) ||  ~isfield(AtpCfg,'Port') 
        port = SelectCanPort(KvaserPortsDescriptor) ; 
    else
        port = AtpCfg.Port ; 
    end 
    try
        KvaserCom(2); 
        success = KvaserCom(1,[500000,port]) ; 
        AtpCfgTemp.CanChannelAvailable = 1 ; 
        AtpCfgTemp.Port = port ;
    catch 
        AtpCfgTemp.CanChannelAvailable = 0 ; 
        uiwait( msgbox({'\fontsize{12}Can channel not available','Cannot find Kvaser CAN adapter'},CreateStruct) ) ; 
    end
end



% try
%     success = KvaserCom(1) ; 
%     AtpCfgTemp.CanChannelAvailable = 1 ; 
% catch 
%     AtpCfgTemp.CanChannelAvailable = 0 ; 
%     uiwait( msgbox({'\fontsize{12}Can channel not available','Cannot find Kvaser CAN adapter'},CreateStruct) ) ; 
% end

SlaveDetectComplete = [] ; 
AtpCfgTemp.IsBoot = 0 ; 
if AtpCfgTemp.CanChannelAvailable
    CommType = 'CAN' ; 
    AtpCfgTemp.DefaultCom = @KvaserCom ; 
    DetectedSlaves = KvaserCom(32) ; 
    
    if isempty(DetectedSlaves) 
        disp('No CAN slaves found, cannot configure communication') ; 
    else

        [DetectedSlaves,misfit] = GetDetectedSlavePars(DetectedSlaves) ; 
        if ~isempty(misfit) 
            msg = {'There is a problem in matching project ID and CAN ID';'This can be a result of mismatching Identities';'Of the wheel steering and interface';'In the same assembly'; ...
                'or be a transient after identity burn';'Roobt is not operational';'You need to power ON/Off the robot'};
            h  = errordlg(msg,'ProjId:CanId misfit') ; 
            while isvalid(h) 
                set(h,'WindowStyle' , 'modal') ;
                pause(0.2) ;
            end
        end

        slist = sort( DetectedSlaves(:,1)) ; 
        if ~isequal(slist,unique(slist)) 
            disp(slist) ; 
            error('Detected Slaves list has non unique IDs')  ; 
        end

        nSlaves = size(DetectedSlaves,1) ;
        
        for cnt = 1:nSlaves
            NextProjId = DetectedSlaves(cnt,2); 
            switch ( NextProjId)
                case hex2dec('9700')
                    AtpCfgTemp.IsBoot = 0 ; 
                case hex2dec('96f0') 
                    AtpCfgTemp.IsBoot = 1 ; 
                otherwise
                    error('A detected slave is out of range for the projects list') ;                     
            end 
        end

        ProjListWithBoot = strings(1,20+length(AtpCfgTemp.ProjList)); 
        nproj = length(AtpCfgTemp.ProjList) ; 
        ProjListWithBoot(1:nproj) = AtpCfgTemp.ProjList ; 

        for bc=1:length(AtpCfgTemp.ProjList) 
            ProjListWithBoot(bc+20) = AtpCfgTemp.ProjList(bc) + "_BOOT"; 
            if ( AtpCfgTemp.IsBoot == 0 ) 
                ActiveSetProj = 1 ; 
            else
                ActiveSetProj = 2 ;
            end
        end
        pp = struct ( 'Card' ,'BESensorless', 'Axis', 'Compressor', 'Proj', 'Single', 'Side', 'Right', 'ShortHand', 'BE',...
                'CanId', 44 , 'ProjId', hex2dec('9700') - AtpCfgTemp.IsBoot * 256 ,'SwVer', besensorless_srcver) ; 

% Setup the communications target    SetCanComTarget(entity,Side,servo,proj,RecStruct) 
        RecStruct.ProjId = pp.ProjId ; 
        RecStruct.Proj  = pp.Proj; 
        RecStruct.Card  = pp.Card; 
        RecStruct.Axis  = pp.Axis; 
        RecStruct.Side  = pp.Side; 
        RecStruct.TargetCanId = pp.CanId ; 
        RecStruct.SwVer = pp.SwVer ; 
        [TargetCanId,RecStruct,GetStateList,CalibTable] = SetCanComTarget(card,side,axis,proj,RecStruct,RecStruct.TargetCanId);
        SlaveDetectComplete = 1 ; 
    end
else
    CommType = 'None' ; 
    AtpCfgTemp.DefaultCom = @NoneCom ; 
    DetectedSlaves = [] ; 
end

% Store update entities 
%save Entities EntityTableWheel EntityTableIntfc EntityTableNeck 
try
save ([MatDir, 'Entities'], 'EntityTableBESensorless'); 
catch
end


AtpCfgTemp.CommType = CommType; 
AtpCfgTemp.Udp = struct('On',0) ; 
AtpCfgTemp.Support = struct('Udp',0,'BlockUpload',1) ;

if exist('AtpCfg','var') && isfield(AtpCfg,'Done') && AtpCfg.Done 
    SlaveDetectComplete = 1 ; 
end
AtpCfg = AtpCfgTemp ; 
if ~isempty(SlaveDetectComplete)
    AtpCfg.Done = 1 ; 
end

