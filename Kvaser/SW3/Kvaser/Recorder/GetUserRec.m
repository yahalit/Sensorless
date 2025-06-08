function [RecStructUser,options] = GetUserRec(handles) 

% global DataType ; 

% handles.RecFlags = puk(1:nFieldsInRec:end);
% handles.RecNames = puk(2:nFieldsInRec:end);
% handles.RecGroups = puk(3:nFieldsInRec:end);
% handles.RecHelps = puk(4:nFieldsInRec:end);

RecStructOriginal = handles.RecStruct;

TrigSig   = find( strcmpi( handles.RecNames ,'fDebug3')) ;  
TrigTypes = struct('Immediate', 0 , 'Rising' , 1 , 'Falling' , 2 ,'Equal' , 3) ; 


RecStructUser = struct('TrigSig',TrigSig,'TrigType',TrigTypes.Rising ,'TrigVal',20000,...
    'PreTrigCnt', fix(RecStructOriginal.Len / 4)) ; 

%Flags (set only one of them to 1) : 
% ProgRec = 1 just programs the signals, recorder remains inactive waiting an activating event 
% InitRec = 1 initates the recorder and makes it work 
% BringRec = 1 Programs the recorder, waits completion, and brings the
% results immediately
options = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 0 ); 