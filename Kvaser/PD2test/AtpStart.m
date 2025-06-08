% Session start for Malinki 
global DataType %#ok<*GVMIS> 
global TargetCanId 
global ProjectRoot 
global ProjectDir 
global HexName 
global AtpCfg 
global BitKillTime 
global RecStruct 
global ProjectHexLoc 
global DispT
global TmMgrTS

global GuiTimerPeriod

GuiTimerPeriod = 0.5 ;
BitKillTime = clock ; 

Support = struct('BlockUpload',0) ;
Udp  = struct('On',0) ; 
AtpCfg = struct ( 'FetchRetry' , 3 , 'DefaultCom', @KvaserCom , 'GuiTimerPeriod' , 0.4 ,'FetchRetryCnt', 2  ,'Support', Support,'Udp',Udp) ; 

KvaserLibRoot = '..\..\..\Sw3\Kvaser'; 
addpath([KvaserLibRoot,'\KvaserCom']);  
addpath([KvaserLibRoot,'\Recorder']);  
addpath([KvaserLibRoot,'\Util']);  
addpath([KvaserLibRoot,'\DownloadFW']);  
addpath('..\..\..\Sw3\Matlab\JavaTreeWrapper' ) ; % Add path for tree GUI
addpath('..\..\..\Sw3\Matlab\jsonlab-1.5') ; % Add path for JSON 
addpath('..\..\..\Sw3\Matlab\Rgb') ; % Add path for JSON 

ProjectRoot = '..\..\PD2_023\'; 
ProjectHexLoc = [ProjectRoot,'Debug'] ; 
ProjectDir  = [ProjectRoot,'Application\'] ; % 'C:\Nimrod\BHT\kvaser\PdTest\CCS';
SelfTestDir  = [ProjectRoot,'SelfTest\'] ; % 'C:\Nimrod\BHT\kvaser\PdTest\CCS';
ErrCodesPS = ParseErrorCodes([SelfTestDir,'ErrorCodes.h']) ; 
HexName = 'PD2_023.hex'; 

try 
    success = KvaserCom(1) ; 
catch
    disp('Kvaser not found ; working offline') ; 
end

%ParTable = ReadParTable([ProjectDir,'ParRecords.h']) ;
SigTable = ReadSigList( [ProjectDir,'ProjRecorderSignals.h'] , 0 );


TargetCanId = 100 ; 
DataType=GetDataType() ; 
RecStruct = struct('Gap',1,'Len',300,'TrigSig',1,'TrigVal',2,'TrigType',0,'Signals',[1,2,3],...
    'Sync2C', 0 ,'PreTrigCnt', 150 , 'SigList' ,{SigTable},'ErrCodes',{ErrCodesPS}) ; % ,'ParList', {ParTable} ) ; 

if ~exist('DispT','var') || ~isa(DispT,'DlgTimerObj')
    DispT  = DlgTimerObj ; % Generate an object that owns a timer 
    TmMgrTS = TimerManagerObj('WHBIT'); % This time mahager object issues timing events for all the dialogs
    TmMgrTS.listenToTimer(DispT) ; 
end 



% m = length(RecStruct.SigList) ; 
% RecStruct.SigNames = cell( 1, m) ; for cnt = 1:m , RecStruct.SigNames{cnt} = RecStruct.SigList{cnt}{2} ; end 




