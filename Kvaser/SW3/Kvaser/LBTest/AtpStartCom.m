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

global CalibTable 
global CalibTable2 
global UdpStr   
global UseUdp 
global GuiTimerPeriod 
global TunnelCodes ; 
global BitKillTime 

if ~isdeployed %change by OBB to determine if run compiled on not.
    addpath('..\LBTest');  
    addpath('..\DownloadFW');  
    addpath('..\KvaserCom');  
    addpath('..\Recorder');  
    addpath('..\Tunnel');  
    addpath('..\Util');  
end

MatDir = '.\Mat\';
CreateStruct =  struct('Interpreter','tex','WindowStyle' , 'modal') ; 
DataType=struct( 'long' , 0 , 'float', 1 , 'short' , 2 , 'char' , 3 ,'string', 9 ,'lvec' , 10 ,'fvec' , 11 , 'ulvec' , 20 ) ; 
BitKillTime = clock ; %#ok<CLOCK> 
if isempty(GuiTimerPeriod) || ~isnumeric(GuiTimerPeriod) || GuiTimerPeriod < 0.1 || GuiTimerPeriod > 10 
    GuiTimerPeriod = 0.4 ; 
end 

% Moran: Mark here if UDP. 1 for UDP, 0 for CAN 
%        and set the number of selected robot
if isempty(UseUdp) 
    UseUdp = 0  ; 
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
    x = load([MatDir,'UdpId.mat']) ; %OBB - change folder
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
    save ([MatDir,'UdpId.mat'],  'LocalPort', 'DefaultGateWay', 'RobotUdpId');  %OBB - change folder
    x = load([MatDir,'UdpId.mat']) ; %OBB - change folder
end

DefaultGateWay   = x.DefaultGateWay ;
DefaultLocalPort = x.LocalPort ; 

TargetIP = [192,168,10,x.RobotUdpId]; 
AtpCfgTemp = struct ( 'FetchRetry' , 3 ,  'FetchRetryCnt' , 0 , 'DefaultCom', @NoneCom , 'GuiTimerPeriod' , GuiTimerPeriod ,'CanChannelAvailable',0 , 'CommType','None','Suspend',0,...
    'Udp' ,struct('On', 0 , 'HostIP' , TargetIP,'HostPort',1234,'IPOwnPc', [0,0,0,0],'TxCnt',0 ,'RobotNumber',x.RobotUdpId)   ) ; 
TargetCanId = 124 ; 
TargetCanId2 = 126 ; 


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
        if exist('AtpCfg','var') && isstruct(AtpCfg) && isfield(AtpCfg,'Port')
            port = AtpCfg.Port ; 
        else
            port = SelectCanPort(KvaserPortsDescriptor) ; 
        end
        try
            KvaserCom(2); 
            success = KvaserCom(1,[500000,port]) ; 
            AtpCfg.Port = port ;
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

