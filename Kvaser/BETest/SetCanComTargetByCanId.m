function [TargetCanId,RecStruct,GetStateList,CalibTable] = SetCanComTargetByCanId(CanId) 
% function SetCanComTargetByCanId(CanId) 
% CanId: CAN ID of target 
% Returns: 
% TargetCanId: CAN ID for selected target 
% RecStruct: Modofied Data structure for project operations
% GetStateList: Variables list for the SGetState function 
% CalibTable  : Calibrations definition 

switch CanId
    case 11
        RecStruct = struct('Gap',1,'Len',300,'TrigSigName','UsecTimer','TrigSig',26,'TrigVal',2,'TrigType',0,'Signals',[1,2,3],...
            'Sync2C', 0 ,'PreTrigCnt', 150 , ...
            'Card','Servo','Axis','Steer','Side','Left','Proj','Dual') ;  
        entity = 'Servo';
    case 12
        RecStruct = struct('Gap',1,'Len',300,'TrigSigName','UsecTimer','TrigSig',26,'TrigVal',2,'TrigType',0,'Signals',[1,2,3],...
            'Sync2C', 0 ,'PreTrigCnt', 150 , ...
            'Card','Servo','Axis','Wheel','Side','Left','Proj','Dual') ;  
        entity = 'Servo';
    case 14
        RecStruct = struct('Gap',1,'Len',300,'TrigSigName','UsecTimer','TrigSig',26,'TrigVal',2,'TrigType',0,'Signals',[1,2,3],...
            'Sync2C', 0 ,'PreTrigCnt', 150 , ...
            'Card','Intfc','Axis','Wheel','Side','Left','Proj','Dual') ;  
        entity = 'Intfc';
    case 21
        RecStruct = struct('Gap',1,'Len',300,'TrigSigName','UsecTimer','TrigSig',26,'TrigVal',2,'TrigType',0,'Signals',[1,2,3],...
            'Sync2C', 0 ,'PreTrigCnt', 150 , ...
            'Card','Servo','Axis','Steer','Side','Right','Proj','Dual') ;  
        entity = 'Servo';
    case 22
        RecStruct = struct('Gap',1,'Len',300,'TrigSigName','UsecTimer','TrigSig',26,'TrigVal',2,'TrigType',0,'Signals',[1,2,3],...
            'Sync2C', 0 ,'PreTrigCnt', 150 , ...
            'Card','Servo','Axis','Wheel','Side','Right','Proj','Dual') ;  
        entity = 'Servo';

    case 24
        RecStruct = struct('Gap',1,'Len',300,'TrigSigName','UsecTimer','TrigSig',26,'TrigVal',2,'TrigType',0,'Signals',[1,2,3],...
            'Sync2C', 0 ,'PreTrigCnt', 150 , ...
            'Card','Intfc','Axis','Wheel','Side','Right','Proj','Dual') ;  
        entity = 'Intfc';
    case 30
        RecStruct = struct('Gap',1,'Len',300,'TrigSigName','UsecTimer','TrigSig',26,'TrigVal',2,'TrigType',0,'Signals',[1,2,3],...
            'Sync2C', 0 ,'PreTrigCnt', 150 , ...
            'Card','Neck','Axis','Neck','Side','None','Proj','Single') ;  
        entity = 'Neck';

    case 34
        RecStruct = struct('Gap',1,'Len',300,'TrigSigName','UsecTimer','TrigSig',26,'TrigVal',2,'TrigType',0,'Signals',[1,2,3],...
            'Sync2C', 0 ,'PreTrigCnt', 150 , ...
            'Card','Neck','Axis','Rotator','Side','None','Proj','Single') ;  
        entity = 'Neck';

    case 35
        RecStruct = struct('Gap',1,'Len',300,'TrigSigName','UsecTimer','TrigSig',26,'TrigVal',2,'TrigType',0,'Signals',[1,2,3],...
            'Sync2C', 0 ,'PreTrigCnt', 150 , ...
            'Card','Neck','Axis','Tape','Side','None','Proj','Single') ;  
        entity = 'Neck';
    case 36
        RecStruct = struct('Gap',1,'Len',300,'TrigSigName','UsecTimer','TrigSig',26,'TrigVal',2,'TrigType',0,'Signals',[1,2,3],...
            'Sync2C', 0 ,'PreTrigCnt', 150 , ...
            'Card','Neck','Axis','Shifter','Side','None','Proj','Single') ;  
        entity = 'Neck';
    otherwise
        error('Unrecognized CAN ID') ; 
end

[TargetCanId,RecStruct,GetStateList,CalibTable] = SetCanComTarget(entity,RecStruct.Side,RecStruct.Axis,RecStruct.Proj,RecStruct,CanId) ;
end
