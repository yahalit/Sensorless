
global DataType
global TargetCanId 
global TargetCanIdPD 
global ProjectRoot 
global ProjectDir 
global HexName 
global AtpCfg 
global BitKillTime 
global RecStruct 
global PdCalibFields
global PdManipCalibFields
global ProjectHexLoc
global CodeStartAddress 
global SciStream
global SharedProjectRoot

try
    classSciStream = class(SciStream) ;
catch
    classSciStream = [] ; 
end
if isequal(classSciStream, 'internal.Serialport') 
    delete(SciStream) ; 
end

CodeStartAddress = hex2dec('84000') ;

BitKillTime = clock ; 

% global UdpHandle 
% global UdpReadHandle 

IPOlivierPC = '192.168.10.100' ; 
IPOwnPc   = '192.168.10.102' ; 
IPOlivierR1 = '192.168.10.101' ; 
IPOlivierR2 = '192.168.10.102' ; 
IPOlivierR3 = '192.168.10.103' ; 

Secutiry = 'bionicDemo&development';

warning('off','instrument:fread:unsuccessfulRead'); % Dont bomb screen with unsuccessful UDP reads

AtpCfg = struct ( 'FetchRetry' , 3 , 'DefaultCom', @KvaserCom , 'GuiTimerPeriod' , 0.4 , ...
    'Udp' ,struct('On', 0 , 'HostIP' , IPOlivierR3,'HostPort',1234,'IPOwnPc', IPOwnPc,'TxCnt',0 )  ,'RobotId', 103  ) ; 
AtpCfg.Support = struct('Udp',0,'BlockUpload',0) ;


addpath('..\KvaserCom');
addpath('..\DownloadFW');  
addpath('..\Recorder');  
addpath('..\..\Matlab\JavaTreeWrapper' ) ; % Add path for tree GUI
addpath('..\..\Matlab\jsonlab-1.5') ; % Add path for JSON 

ProjectRoot = '..\..\PDSoft\'; 

ProjectHexLoc   = '..\..\Exe' ; 

% ProjectHexLoc = [ProjectRoot,'Debug\'] ; 
ProjectDir  = [ProjectRoot,'Application\'] ; % 'C:\Nimrod\BHT\kvaser\PdTest\CCS';
HexName = 'NimrodPD.hex'; 
SharedProjectRoot = '..\..\PDSoft\PdLpShared\'; 

success = KvaserCom(1) ; 
ParTable = ReadParTable([ProjectDir,'PdParRecords.h']) ;

ErrCodes = ParseErrorCodes( [SharedProjectRoot,'ErrorCodes.h']) ; 
if isempty( ErrCodes) 
    return 
end 
TargetCanId = 126 ; 
TargetCanIdPD = 126 ;  
DataType=struct( 'long' , 0 , 'float', 1 , 'short' , 2 , 'char' , 3 ,'string', 9 ,'lvec' , 10 ,'fvec' , 11 , 'ulvec' , 20 ) ; 
RecStruct = struct('Gap',1,'Len',300,'TrigSig',26,'TrigVal',2,'TrigType',0,'Signals',[16,19,25,26,28],...
    'Sync2C', 0 ,'PreTrigCnt', 150 , 'SigList' , ...
    {ReadSigList( [ProjectDir,'\ProjRecorderSignals.h'])},'ParList', {ParTable} ) ; 
RecStruct.ErrCodes = ErrCodes;

m = length(RecStruct.SigList) ; 
RecStruct.SigNames = cell( 1, m) ; for cnt = 1:m , RecStruct.SigNames{cnt} = RecStruct.SigList{cnt}{2} ; end 

PdCalibFields = cell( 1,18) ; for cnt = 1:18 ,PdCalibFields{cnt} = ['ParArr',num2str(cnt)] ; end 
PdCalibFields(1:10) = {'GainFacV36','OffsetV36','GainFacV24','OffsetV24','GainFacV12','OffsetV12','GainFacVBat','OffsetVBat','GainFacVSrv','OffsetVSrv'} ;
PdManipCalibFields = cell( 1,18) ; for cnt = 1:18 ,PdManipCalibFields{cnt} = ['ParManipArr',num2str(cnt)] ; end 
PdManipCalibFields(1:7) = {'RDoorCenter','RDoorGainFac','LDoorCenter','LDoorGainFac','ShoulderCenter','ElbowCenter','WristCenter'} ;


