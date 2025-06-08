% Session start for Malinki 
global DataType
global TargetCanId 
global ProjectRoot 
global ProjectDir 
global HexName 
global AtpCfg 
global BitKillTime 
global RecStruct 
global ProjectHexLoc 

BitKillTime = clock ; 


AtpCfg = struct ( 'FetchRetry' , 3 , 'DefaultCom', @KvaserCom , 'GuiTimerPeriod' , 0.4  ) ; 

addpath('..\KvaserCom');
addpath('..\DownloadFW');  
addpath('..\Recorder');  
addpath('..\..\Matlab\JavaTreeWrapper' ) ; % Add path for tree GUI
addpath('..\..\Matlab\jsonlab-1.5') ; % Add path for JSON 

ProjectRoot = '..\..\Malinki\'; 
ProjectHexLoc = [ProjectRoot,'Debug'] ; 
ProjectDir  = [ProjectRoot,'Application\'] ; % 'C:\Nimrod\BHT\kvaser\PdTest\CCS';
HexName = 'Malinki.hex'; 

success = KvaserCom(1) ; 
%ParTable = ReadParTable([ProjectDir,'ParRecords.h']) ;


TargetCanId = 120 ; 
DataType=struct( 'long' , 0 , 'float', 1 , 'short' , 2 , 'char' , 3 ,'string', 9 ,'lvec' , 10 ,'fvec' , 11 , 'ulvec' , 20 ) ; 
RecStruct = struct('Gap',1,'Len',300,'TrigSig',26,'TrigVal',2,'TrigType',0,'Signals',[16,19,25,26,28],...
    'Sync2C', 0 ,'PreTrigCnt', 150 , 'SigList' ,{}) ; % ,'ParList', {ParTable} ) ; 

% m = length(RecStruct.SigList) ; 
% RecStruct.SigNames = cell( 1, m) ; for cnt = 1:m , RecStruct.SigNames{cnt} = RecStruct.SigList{cnt}{2} ; end 




