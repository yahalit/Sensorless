global DataType %#ok<*GVMIS> 
global TargetCanId 
global TargetCanId2 
global TargetCanIdPD 
global ProjectDir 
global ProjectDir2
global ProjectRoot 
global PdProjectRoot
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

% global ManipCalibFields

BitKillTime = clock ; %#ok<CLOCK> 

% ManipCalibFields = cell( 1,18) ; 
% for cnt = 1:18 
%     ManipCalibFields{cnt} = ['ParManipArr',num2str(cnt)] ; 
% end 
% ManipCalibFields(1:7) = {'RDoorCenter','RDoorGainFac','LDoorCenter','LDoorGainFac','ShoulderCenter','ElbowCenter','WristCenter'} ;


if ( ~isa(LsTimer,'timer') ) 
    LsTimer =  timer(...
    'ExecutionMode', 'fixedSpacing', ...       % Run timer repeatedly.
    'Period', 10e-2  ) ; 
end

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
addpath('..\..\Matlab\JavaTreeWrapper' ) ; % Add path for tree GUI
addpath('..\..\Matlab\jsonlab-1.5') ; % Add path for JSON 
addpath('..\..\Matlab\Rgb') ; % Add path for JSON 
addpath('..\..\..\Drivers\Kvaser\WhTest');  
CreateStruct =  struct('Interpreter','tex','WindowStyle' , 'modal') ; 

% Copy entities, enabling the recording from driver projects
try 
    !xcopy ..\..\..\Drivers\Kvaser\WhTest\Entities.mat .\Entities.mat /q /y > blabla.txt
    load('Entities.mat')  ;
    BHErrCodes = EntityTableWheel.ErrCodes ; 
catch 
end

% Moran: Mark here if UDP. 1 for UDP, 0 for CAN 
%        and set the number of selected robot
if isempty(UseUdp) 
    UseUdp = 0  ; 
end 
if isempty(GuiTimerPeriod) || ~isnumeric(GuiTimerPeriod) || GuiTimerPeriod < 0.1 || GuiTimerPeriod > 10 
    GuiTimerPeriod = 0.4 ; 
end 

% RobotNumber =  209;
% RobotNumber = x.RobotUdpId ; 

% IPOlivierPC = '192.168.10.105' ; 


    % IPOlivierRBP = [192,168,40,128] ; 
    % TargetIP = [192,168,10,199] ; % Ari's laptop
%     TargetIP = [192,168,40,128] ; % Playground PI 
%     if RobotNumber
%     end
% Secutiry = 'bionicDemo&development';
% warning('off','instrument:fread:unsuccessfulRead'); % Dont bomb screen with unsuccessful UDP reads

% Default comm may be UdpComm, KvaserCom
DefaultUdpSetup = struct('DefaultGateWay','192.168.10.1','LocalPort',1234,'RobotUdpId',205) ;
UdpIdValid = 1  ;
try 
    x = load('UdpId.mat') ; 
    if ~isfield(x,'DefaultGateWay') || ~isfield(x,'LocalPort') || ~isfield(x,'RobotUdpId')  
        UdpIdValid = 0  ; 
    end 
catch 
   UdpIdValid = 0  ; 
end 
if ~UdpIdValid 
    LocalPort = DefaultUdpSetup.LocalPort ; 
    DefaultGateWay = DefaultUdpSetup.DefaultGateWay ; 
    RobotUdpId = DefaultUdpSetup.RobotUdpId;
    save UdpId.mat LocalPort DefaultGateWay RobotUdpId 
    x = load('UdpId.mat') ; 
end

DefaultGateWay   = x.DefaultGateWay ;
DefaultLocalPort = x.LocalPort ; 

TargetIP = [192,168,10,x.RobotUdpId]; 
AtpCfgTemp = struct ( 'FetchRetry' , 3 ,  'FetchRetryCnt' , 0 , 'DefaultCom', @NoneCom , 'GuiTimerPeriod' , GuiTimerPeriod ,'CanChannelAvailable',0 , 'CommType','None','Suspend',0,...
    'Udp' ,struct('On', 0 , 'HostIP' , TargetIP,'HostPort',1234,'IPOwnPc', [0,0,0,0],'TxCnt',0 ,'RobotNumber',x.RobotUdpId)   ) ; 
TargetCanId = 124 ; 
TargetCanId2 = 126 ; 
TargetCanIdPD = 126 ;  


% global GoRouteTimer ; 
% GoRouteTimer = timer('ExecutionMode', 'fixedSpacing','Period', 0.3,'TimerFcn', @yobt, 'UserData' , 'GoRouteTimer');

RxCtr = 0 ; 
TxCtr = 0 ; 
SimTime = 0 ; 


if ~exist('DispT','var') || ~isa(DispT,'DlgTimerObj')
    DispT = DlgTimerObj ; % Generate an object that owns a timer 
    TmMgrT = TimerManagerObj(); % This time mahager object issues timing events for all the dialogs
    TmMgrT.listenToTimer(DispT) ; 
end 


ProjectShared   = '..\..\BhAxes\'; 
ProjectRoot   = '..\..\BolshoyMain\CcsPrj\'; 
ProjectRoot2   = '..\..\BolshoyManipCpu2R3\'; 

PdProjectRoot = '..\..\PDSoft\'; 
%SharedProjectRoot = '..\..\PdLpShared\'; 
ProjectDir  = [ProjectRoot,'Application\'] ; % 'C:\Nimrod\BHT\kvaser\PdTest\CCS';
ProjectDir2  = [ProjectRoot2,'Application\'] ; % 'C:\Nimrod\BHT\kvaser\PdTest\CCS';
PdProjectDir  = [PdProjectRoot,'Application\'] ; % 'C:\Nimrod\BHT\kvaser\PdTest\CCS';
DataType=struct( 'long' , 0 , 'float', 1 , 'short' , 2 , 'char' , 3 ,'string', 9 ,'lvec' , 10 ,'fvec' , 11 , 'ulvec' , 20 ) ; 

CalibTable = ReadCalibList([ProjectDir,'CalibDefs.h']) ;
CalibTable2 = ReadCalibList([ProjectDir2,'CalibDefs2.h']) ;

ParTable = ReadParTable([ProjectDir,'ParRecords.h']) ;
ParTable2 = ReadParTable([ProjectDir2,'ParRecords2.h']) ;

PdParTable = ReadParTable([PdProjectDir,'PdParRecords.h']) ;
SigTable = ReadSigList( [ProjectDir,'ProjRecorderSignals.h'] , 0 );
SigTable2 = ReadSigList( [ProjectDir2,'ProjRecorderSignals2.h'] , 0 );
SigNames =cell(length(SigTable),1)  ; 
SigNames2 =cell(length(SigTable2),1)  ; 
for cnt = 1:length(SigTable) , SigNames{cnt} = SigTable{cnt}{2} ; end 
for cnt = 1:length(SigTable2)  
    SigTable2{cnt}{2} = ['C2_',SigTable2{cnt}{2}] ; 
    SigTable2{cnt}{3} = ['Z_',SigTable2{cnt}{3}] ; 
    SigNames2{cnt} = SigTable2{cnt}{2} ; 
end 

ErrCodes = ParseErrorCodes( [ProjectShared,'ErrorCodes.h']) ; 
TunnelCodes = ParseTunnelFields( [ProjectRoot,'Application\BitVars.h']) ; 
WheelArmStates  = ParseEnum( [ProjectRoot,'Application\StructDef.h'],'E_WheelArmState') ; 
WakeUpStates = ParseEnum( [ProjectRoot,'Application\StructDef.h'],'E_CAN_WAKEUP_STATE') ;  
MotionModes  = ParseEnum( [ProjectRoot,'Application\StructDef.h'],'E_SysMotionMode') ; 
PsWakeUpStates = ParseEnum( [ProjectRoot,'Application\StructDef.h'],'E_PsWakeStates') ;  

ManipulatorType  = ParseEnum( [ProjectRoot,'Application\StructDef.h'],'E_ManipulatorType',1) ; 
WheelArmType  = ParseEnum( [ProjectRoot,'Application\StructDef.h'],'E_WheelArmType',1) ; 
RailSensorType  = ParseEnum( [ProjectRoot,'Application\StructDef.h'],'E_RailSensorType',1) ; 
ProtocolType  = ParseEnum( [ProjectRoot,'Application\StructDef.h'],'E_RCProtocolType',1) ; 
VerticalRailPitchType  = ParseEnum( [ProjectRoot,'Application\StructDef.h'],'E_VerticalRailPitchType',1) ; 


Enums = struct('WheelArmStates',WheelArmStates ,'WakeUpStates',WakeUpStates','MotionModes',MotionModes,'ManipulatorType',ManipulatorType,'WheelArmType',...
    WheelArmType,'RailSensorType',RailSensorType,'ProtocolType',ProtocolType,'VerticalRailPitchType',VerticalRailPitchType,'PsWakeUpStates',PsWakeUpStates) ; 

RecStruct = struct('Gap',1,'Len',300,'TrigSigName','UsecTimer','TrigSig',26,'TrigVal',2,'TrigType',0,'Signals',[16,19,25,26,28],...
    'Sync2C', 0 ,'PreTrigCnt', 150 , 'SigList' ,{SigTable}, 'SigNames' , {SigNames} , ...
    'SigList2' ,{SigTable2}, 'SigNames2' , {SigNames2} , ...
	'ParList', {ParTable} ,'ParList2',{ParTable2},'PdParList', {PdParTable} ,'ErrCodes', {ErrCodes} ,...
    'BHErrCodes', {BHErrCodes},'Enums',Enums) ;% ,...
	%,'ParList', {ReadParTable('.\Application\ParRecords.h')} 	) ; 

handles.WheelArmStateTab = struct() ; 
    
    
% ProjectDir = 'C:\Nimrod\BHT\kvaser\LPTest\CCS';
% Kvaser may work independent of UDP 
CommType = 'None' ; 
UdpFail = 0 ; 
import java.io.*
import java.net.DatagramSocket
import java.net.DatagramPacket
import java.net.InetAddress
if UseUdp 

    
    junk = ver('Matlab'); 
    junk = strsplit(junk.Version,'.') ;
    if  0 &&  (( str2double(junk(1)) * 10000 + str2double(junk(2)) ) < 90013 ) 
         msgbox({'\fontsize{12}UDP is not available for this Matlab version','Must use Matlab 2022b at least'} ,CreateStruct) ; 
         UdpFail = 1 ; 
         UseUdp = 0 ; 
    else
        UdpPresent = 0 ; 
        try 
            IPOwnPc   = GetIpV4Address(DefaultGateWay) ; %  [192,168,10,105] ; % '192.168.10.102' ; 
            UdpPresent = 1 ; 
        catch IPOwnPcErr
            IPOwnPc   = [0,0,0,0] ; 
            msgbox({'\fontsize{12}Could not detect IP address of own PC', ['With the matching default gateway :',DefaultGateWay] ,...
                ['Error was: ',IPOwnPcErr.message],...
                'possibly the PC is not connected to Ethernet', ...
                'Or PC is not connected to robot network'},CreateStruct) ; 
            
            UdpFail = 1; 
        end 
    
        try 
            UdpAlready = 0 ; 
            if  ~isempty(UdpStr) && isfield(UdpStr,'Socket') && contains(class(UdpStr.Socket),'java.net.DatagramSocket' ) 
                %if isequal( UdpHandle.LocalHost, string(IpString(IPOwnPc)) ) 
                    UdpAlready = 1 ; 
                %end 
            end
%             if  contains(class(UdpHandle),'UDPPort' ) 
%                 if isequal( UdpHandle.LocalHost, string(IpString(IPOwnPc)) ) 
%                     UdpAlready = 1 ; 
%                 end 
%             end
            if ~UdpAlready
                UdpHandle = [] ; % udpport('datagram','IPV4','LocalHost',IpString(IPOwnPc),'LocalPort',DefaultLocalPort,'OutputDatagramSize',256);
                UdpStr = struct('msgtype',5,'msgcntr',1,'msgpayloadlen',0,'IPOwnPc',IPOwnPc,...
                'HostPort',AtpCfgTemp.Udp.HostPort,'LocalHost',IpString(IPOwnPc),'HostIP',IpString(TargetIP),'LocalPort',DefaultLocalPort)  ;     

                UdpStr.Socket = DatagramSocket(UdpStr.LocalPort) ; %  
                UdpStr.Socket.setReuseAddress(1);

            end
            UdpStr.LocalIpAddr = InetAddress.getByName(IpString(IPOwnPc)) ;
            UdpStr.HostIpAddr = InetAddress.getByName(IpString(TargetIP)) ;
            UdpStr.HostIP = IpString(TargetIP) ; 
            UdpStr.Socket.setSoTimeout(1) ; 
            % disp('Robot connection is now UDP, LP CAN shall be inactive') ; 
            CommType = 'UDP' ; 
            AtpCfgTemp.DefaultCom = @UdpComJava ;
            AtpCfgTemp.Udp.On = 1 ; 
        catch bgvir
            AtpCfgTemp.Udp.On = 0 ; 
            if UseUdp
                if contains( bgvir.message, 'Address already in use' ) 
                    msgbox({['\fontsize{12} The local port ',num2str(UdpStr.LocalPort)],'is already in use','Choose another in CommSetup'},CreateStruct) ;
                else
                    disp('Could not start UDP network, possibly the PC is not connected to Ethernet, or wrong wireless network') ; 
                end
            end 
            UdpFail = 1 ; 
        end
    end 

end

if ( UseUdp == 0 && ~UdpFail ) 

    KvaserPortsDescriptor = IdentifyMyKvaser() ; 
    [nCan,~]  = size(KvaserPortsDescriptor) ; 
    if nCan == 0 
        AtpCfgTemp.CanChannelAvailable = 0 ; 
        msgbox({'\fontsize{12}Can channel not available','Cannot find Kvaser CAN adapter',...
            'Use CommSetup to setup UDP'},CreateStruct) ; 
    end
    if nCan > 0 
        port = SelectCanPort(KvaserPortsDescriptor) ; 
        try
            KvaserCom(2); 
            success = KvaserCom(1,[500000,port]) ; 
            AtpCfgTemp.CanChannelAvailable = 1 ; 
        catch 
            AtpCfgTemp.CanChannelAvailable = 0 ; 
            msgbox({'\fontsize{12}Can channel not available','Cannot find Kvaser CAN adapter',...
                'Use CommSetup to setup UDP'},CreateStruct) ; 
        end
    end


    if AtpCfgTemp.CanChannelAvailable
        CommType = 'CAN' ; 
        AtpCfgTemp.DefaultCom = @KvaserCom ; 
    else
        CommType = 'None' ; 
        AtpCfgTemp.DefaultCom = @NoneCom ; 
    end
end
AtpCfgTemp.CommType = CommType; 
AtpCfgTemp.Support = struct('Udp',1,'BlockUpload',1) ;

% Mapped file to transfer state data from app to app 
AlreadyMapped = 0 ; 
if exist('GetStateMapFile','var')
    if isequal(class(GetStateMapFile),'memmapfile') 
        AlreadyMapped = 1 ; 
    end
end
if ~AlreadyMapped
    if ~exist('GetStateFile.dat','file')
        % Just write it a s dummy 
        h = fopen('GetStateFile.dat','w') ; 
        fwrite( h , zeros(1,18)) ; 
        fclose (h) ; 
    end
    GetStateMapFile = memmapfile('GetStateFile.dat','Format','double','Writable',true);
end
AtpCfgTemp.GetStateMapFile = GetStateMapFile ; 
AtpCfg = AtpCfgTemp ; 

