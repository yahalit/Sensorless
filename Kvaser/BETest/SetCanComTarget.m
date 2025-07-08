function [CanId,RecStruct,GetStateList,CalibTable] = SetCanComTarget(entity,Side,servo,proj,RecStruct,CanId) 
% function SetCanComTarget(entity,Side,servo,Project,RecStruct)
% Set the default entity to communicate with
% entity: an entity struct, or a string 'Servo' or 'Intfc' or 'Neck';
% Side  : 'Right' or 'Left' 
% servo : Required only for wheel card ('Wheel' or 'Steering') 
% Project: 'Dual' for wheel/steering cards 'Single' for neck etc..
% RecStruct:  Data structure for project operations, to be modified 
% Returns: 
% TargetCanId: CAN ID for selected target 
% RecStruct: Modofied Data structure for project operations
% GetStateList: Variables list for the SGetState function 
% CalibTable  : Calibrations definition 


% global ProjectDir %#ok<*GVMIS> 
% global ProjectRoot 

CanId = 44 ; 

% [NeckRoot,WheelRoot,IntfcRoot,NeckDir,WheelDir,IntfcDir] = GetProjDirInfo(); 
% AxisName = 'BESensorless' ; 

baseEnt = 1 ; 
if isstruct(entity) 
    f = fieldnames(entity) ;
    if isempty( setdiff({'Entity','SigTable','SigNames','ProjList','Ver','ExeDir'},f )  )
        baseEnt = 0 ;
    end
end

if baseEnt
    entity = evalin('base','EntityTableBESensorless')  ;
end

card   = entity.Entity ; 

if ~any( strcmp( lower(char(card)) ,{'sensorless'  } ) ) %#ok<STCI> 
    error('Entity points an unknown card' ) ;
end
% if isequal(lower(char(card)),'servo')
% %     ProjectRoot   = WheelRoot; 
% %     ProjectDir  = WheelDir ; 
% else
%     if isequal(lower(char(card)),'intfc')
% %         ProjectRoot   = IntfcRoot; 
% %         ProjectDir  = IntfcDir ;  
%     else
%         if isequal(lower(char(card)),'neck')
% %             ProjectRoot   = NeckRoot; 
% %             ProjectDir  = NeckDir ;  
%         else
%             error('Entity points an unknown card' ) ;
%         end
%     end
% end 
CalibTable  = entity.CalibTable  ; 

RecStruct.SigList = entity.SigTable ; 
RecStruct.SigNames = entity.SigNames ; 
RecStruct.ParList  = entity.ParTable ; 
RecStruct.ErrCodes   = entity.ErrCodes ;
RecStruct.CfgTable   = entity.CfgTable ;
RecStruct.CfgFullTable   = entity.CfgFullTable ;
RecStruct.Enums = entity.Enums ;
RecStruct.ParsXlsFile = entity.ParsXlsFile;
RecStruct.CfgXlsFile= entity.CfgXlsFile;
RecStruct.CalibCfg = entity.CalibCfg ; 


RecStruct.TargetCanId = CanId ;
RecStruct.TargetCanId2 = CanId ;

GetStateList = GetSignalIndex(entity.BaseSignals,[],RecStruct) ; 
RecStruct.AnalogsList =  GetSignalIndex(entity.AnalogsList,[],RecStruct) ;
end
