function AtpUpdateDbase() 
EntityDir   = '..\..\Entity\'; 
addpath('..\LBTest');  
addpath('..\LBTest\Geom');  
addpath('..\DownloadFW');  
addpath('..\Tunnel');  
addpath('..\Util');  
addpath('..\Recorder');  
addpath('..\..\Matlab\JavaTreeWrapper' ) ; % Add path for tree GUI
addpath('..\..\Matlab\jsonlab-1.5') ; % Add path for JSON 
addpath('..\..\Matlab\Rgb') ; % Add path for JSON 
addpath('..\..\..\Drivers\Kvaser\WhTest');  

ProjectShared   = '..\..\BhAxes\'; 
ProjectRoot   = '..\..\BolshoyMain\CcsPrj\'; 
ProjectRoot2   = '..\..\BolshoyManipCpu2R3\'; 


PdProjectRoot = '..\..\PDSoft\'; 
%SharedProjectRoot = '..\..\PdLpShared\'; 
ProjectDir  = [ProjectRoot,'Application\'] ; % 'C:\Nimrod\BHT\kvaser\PdTest\CCS';
ProjectDir2  = [ProjectRoot2,'Application\'] ; % 'C:\Nimrod\BHT\kvaser\PdTest\CCS';
PdProjectDir  = [PdProjectRoot,'Application\'] ; % 'C:\Nimrod\BHT\kvaser\PdTest\CCS';

srcver  = GetSourceVersion([ProjectDir,'Constdef.h'], 1); %1 for core1
%srcver2  = GetSourceVersion([ProjectDir2,'Constdef2.h'], 2); %2 for core2

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

ManipulatorType  = ParseEnum( [ProjectRoot,'Application\ConstDef.h'],'E_ManipulatorType',1) ; 
WheelArmType  = ParseEnum( [ProjectRoot,'Application\ConstDef.h'],'E_WheelArmType',1) ; 
%RailSensorType  = ParseEnum( [ProjectRoot,'Application\StructDef.h'],'E_RailSensorType',1) ; 
ProtocolType  = ParseEnum( [ProjectRoot,'Application\ConstDef.h'],'E_RCProtocolType',1) ; 
VerticalRailPitchType  = ParseEnum( [ProjectRoot,'Application\ConstDef.h'],'E_VerticalRailPitchType',1) ; 


Enums = struct('WheelArmStates',WheelArmStates ,'WakeUpStates',WakeUpStates','MotionModes',MotionModes,'ManipulatorType',ManipulatorType,'WheelArmType',...
    WheelArmType,'ProtocolType',ProtocolType,'VerticalRailPitchType',VerticalRailPitchType,'PsWakeUpStates',PsWakeUpStates) ; 

% BH Error codes are left open as we dont know driver version

RecStruct = struct('Gap',1,'Len',300,'TrigSigName','UsecTimer','TrigSig',26,'TrigVal',2,'TrigType',0,'Signals',[16,19,25,26,28],...
    'Sync2C', 0 ,'PreTrigCnt', 150 , 'SigList' ,{SigTable}, 'SigNames' , {SigNames} , ...
    'SigList2' ,{SigTable2}, 'SigNames2' , {SigNames2} , ...
	'ParList', {ParTable} ,'ParList2',{ParTable2},'PdParList', {PdParTable} ,'ErrCodes', {ErrCodes} ,...
    'BHErrCodes', {[]},'Enums',Enums,'Ver',srcver) ;% ,...
	%,'ParList', {ReadParTable('.\Application\ParRecords.h')} 	) ; 

SupplementStr = struct('CalibTable',{CalibTable},'CalibTable2',{CalibTable2},'TunnelCodes',TunnelCodes) ; 

save([EntityDir,'LpEntity_',num2str(srcver) ],'RecStruct','SupplementStr'); %OBB: this file is named after core 1 version but has both core 1 and core 2 data.


end

    
