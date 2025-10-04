function AtpUpdateDbase() 
%AtpUpdateDbase : Build parameter recorder and other databases on the basis of source project files


KvaserLibRoot = '..\SW3\Kvaser'; 

addpath([KvaserLibRoot,'\KvaserCom']);  
addpath([KvaserLibRoot,'\Recorder']);  
addpath([KvaserLibRoot,'\Util']);  
addpath('..\SW3\Matlab\JavaTreeWrapper' ) ; % Add path for tree GUI

addpath('..\ControlDes');  
addpath('..\Control');  
addpath('..\Emulation');  
addpath('.\Test');  
addpath('.\HelpDoc');  
addpath('..\Identification');  
addpath('..\DownloadFW' );  

[BESensorLessRoot,BESensorLessDir,ExeDir,EntityDir] = GetProjDirInfo();
% Get the versions 
besensorless_srcver  = GetSourceVersion([BESensorLessDir,'Constdef.h']);

% Get the list of implemented SW projects 
BESensorLessProjList = GetProjectsList(BESensorLessDir) ; 
ProjList = BESensorLessProjList ;
%save ProjcectsList ProjList ;
save ([EntityDir, 'ProjcectsList'], "ProjList");  %OBB - changed directory to entity

CalibTableBESensorLess = ReadCalibList([BESensorLessDir,'CalibDefs.h']) ;

WhoIsThisProject = ReadWhoIsThisProject([BESensorLessDir,'WhoIsThisProject.h']) ; 
[ParTableBESensorLess,ParFullTableBESensorLess] = ReadParTable([BESensorLessDir,'ParRecords.h'],[],[BESensorLessDir,'HwConfig.h'],WhoIsThisProject) ;

SigTableBESensorLess = ReadSigList( [BESensorLessDir,'ProjRecorderSignals.h'] , 0 , 1 );


[CfgTableBESensorLess,CfgFullTableBESensorLess] = ReadCfgList( [BESensorLessDir,'ConfigPars.h']  );


SigNamesBESensorLess =cell(length(SigTableBESensorLess),1)  ; 
for cnt = 1:length(SigNamesBESensorLess) , SigNamesBESensorLess{cnt} = SigTableBESensorLess{cnt}{2} ; end 
ErrCodesBESensorLess = ParseErrorCodes( [BESensorLessRoot,'SelfTest\ErrorCodes.h']) ; 


BaseSignalsBESensorLess = {'LongException','Vdc','UserPos','ThetaElect','Iq','UserSpeed'} ;

LoopClosureModes  = ParseEnum( [BESensorLessRoot,'Application\HwConfig.h'],'E_LoopClosureMode') ; 
SysModes  = ParseEnum( [BESensorLessRoot,'Control\ClaDefs.h'],'E_SysMode') ; 
ReferenceModes = ParseEnum( [BESensorLessRoot,'Application\ConstDef.h'],'E_ReferenceModes') ; 
CommutationModes  = ParseEnum( [BESensorLessRoot,'Application\ConstDef.h'],'E_CommutationModes') ; 
SigRefTypes = ParseEnum( [BESensorLessRoot,'Application\ConstDef.h'],'E_SigRefType') ; 


EnumsBESensorLess = struct('SysModes',SysModes,'LoopClosureModes',LoopClosureModes,'ReferenceModes',ReferenceModes,...
    'CommutationModes',CommutationModes,'SigRefTypes',SigRefTypes) ; 
% 'SysModes',SysModes,'LoopClosureModes',LoopClosureModes,'ReferenceModes',ReferenceModes) ; 

AnalogsListBESensorLess = {'PhaseCur0','PhaseCur1','PhaseCur2'} ; 


EntityTableBESensorLess = struct('Entity','Sensorless','CalibTable',{CalibTableBESensorLess},'ParTable',{ParTableBESensorLess},'SigTable',{SigTableBESensorLess},'CfgTable',CfgTableBESensorLess,...
    'CfgFullTable',CfgFullTableBESensorLess,...
    'SigNames',{SigNamesBESensorLess},'ErrCodes',{ErrCodesBESensorLess},'BaseSignals',{BaseSignalsBESensorLess},'Enums',{EnumsBESensorLess},'ParsXlsFile','BESensorLessParams.xlsx',...
    'CfgXlsFile','BESensorLessCfg.xlsx','AnalogsList',{AnalogsListBESensorLess},'CalibCfg',struct('ProjType','Servo'),...
    'ProjList',BESensorLessProjList,'ParFullTable',ParFullTableBESensorLess ,'Ver',besensorless_srcver,'ExeDir',ExeDir) ; 


% besensorless_srcver = GetSourceVersion([BESensorLessDir,'\Constdef.h']);

EntityTable = EntityTableBESensorLess ;
save([EntityDir,'BESensorLessEntity_',num2str(besensorless_srcver) ],'EntityTable');

ParTable2Xls(ParFullTableBESensorLess,'BESensorLessParamsB.xlsx','DefaultPars') ;
ParTable2Xls(CfgFullTableBESensorLess,'BESensorLessCfgB.xlsx','DefaultCfg') ;

copyfile('BESensorLessParamsB.xlsx',[EntityDir,'BESensorLessParams_',num2str(besensorless_srcver),'.xlsx' ]) ; 

copyfile('BESensorLessCfgB.xlsx',[EntityDir,'BESensorLessCfg_',num2str(besensorless_srcver),'.xlsx' ]) ; 

%save RecentVer neck_srcver wheel_srcver Intfc_srcver EntityDir
save ([EntityDir, 'RecentVer.mat'], "besensorless_srcver");

%save (EntityDirName, "EntityTableBESensorLess" , "EntityTableIntfc" , "EntityTableNeck");
end

