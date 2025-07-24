% global RecStruct %#ok<GVMIS> 
DataType = GetDataType(); 

% Make a commutation experiment 
% assume that the communication target has been setup before (see AtpStart) 

CreateStruct =  struct('Interpreter','tex','WindowStyle' , 'modal') ; 

SetCfg = 1 ; 
Axis = RecStruct.Axis ; 
Side = RecStruct.Side ; 
UseAngle = 0 * pi / 180 ; 

ExpMng = struct('CurLevel',10,'AnglePU',AnglePu,'nCycle',10,'WaitTime',20,'CycleTime',3,'npp',4) ; 
% Experiment parameters 
ExperimentSafeLimits = struct( 'OverCurrent' , 16 , 'Undervoltage' , 20  , 'Overvoltage' , 60) ; 

% Set motor off 
SendObj([hex2dec('2220'),4],0,DataType.long,'Set motor enable/disable') ;

% Set to open loop commutation 
SendObj([hex2dec('220d'),RecStruct.CfgTable.CommutationMode.Ind],RecStruct.Enums.CommutationModes.COM_OPEN_LOOP ,DataType.long,'Set open loop commutation') ;

% Reset any possible failure 
SendObj([hex2dec('2220'),10],1,DataType.long,'Reset fault') ;

TestStructFields(ExpMng,{'CurLevel','nCycle','WaitTime','CycleTime','npp'},'ExpMng') ; 

% Get Vdc 
Vdc = GetSignal('Vdc') ; 

% Kill the G generator 
SetRefGen( struct('Gen','G','Type',RecStruct.Enums.SigRefTypes.E_S_Nothing,'On',0) ) ; 

SendObj([hex2dec('2220'),8],RecStruct.Enums.LoopClosureModes.E_LC_OpenLoopField_Mode,DataType.long,'Set the loop closure mode to open loop commutation') ;                      

% Create the basis for the T generator 
SetRefGen( struct('Gen','T','Type',RecStruct.Enums.SigRefTypes.E_S_Fixed,'On',0) ) ; 

% Start the motor 
SendObj([hex2dec('2220'),4],1,DataType.long,'Set motor enable') ;

% Set the reference mode 
SendObj([hex2dec('2220'),14],RecStruct.Enums.ReferenceModes.E_PosModeDebugGen,DataType.long,'Set reference mode') ;

% Set the reference mode (it was reset to stay-in-place during the motor-on process) 
SendObj([hex2dec('2220'),14],RecStruct.Enums.ReferenceModes.E_PosModeDebugGen,DataType.long,'Set reference mode') ;

% Limit the current command slope 
AmpSecond = 2 ; 
SendObj([hex2dec('2225'),34],AmpSecond,DataType.float,'Slope limit') ; 

% Bring the motor to standstill
TGenStr = struct('Gen','T','Type',RecStruct.Enums.SigRefTypes.E_S_Fixed,'On',1,...
    'Dc',ExpMng.CurLevel,'Amp',0,'F',1,'Duty',0.5,'bAngleSpeed',0)  ;

Gdc = ExpMng.AnglePU ; 
GGenStr = struct('Gen','G','Type',RecStruct.Enums.SigRefTypes.E_S_Fixed,'On',1,...
    'Dc',Gdc,'Amp',0,'F',1,'Duty',0.5,'bAngleSpeed',0,'AnglePeriod',0)  ;

rslt = zeros( 6, 10000) ; 

RecTime = 20 ; 
MaxRecLen = 500 ; 

% Setup the recorder 
% RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ,'MaxLen', MaxRecLen ) ; 
% RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 
RecNames = {'Iq','CBit'}  ; 
% L_RecStruct = RecStruct ;
% L_RecStruct.BlockUpLoad = 0 ; 
TypeFlags = SetSnap( RecNames ) ; 

SetRefGen(  TGenStr ) ; % Let the torque converge 

disp( 'Initiating direction #1 ') ; 
 % Start the recorder
% [~,L_RecStruct] = Recorder(RecNames , L_RecStruct , RecInitAction   );

cnt = 0 ; 
tStart = tic ; 
tStep  = tStart ; 
state = 0 ; 
SetRefGen(  GGenStr ) ; % Start rotation
tclk = clock() ; %#ok<CLOCK> 
while cnt < 10000  
    
    % s = SGetState() ; 
%     if ( s.Bit.MotorOn == 0 )
%         uiwait( msgbox({'\fontsize{12}Motor turned off'},CreateStruct) ) ; 
%         break ; 
%     end 

    r = GetSnap(RecNames,TypeFlags) ; 

    if ( bitand(r.CBit,1) == 0 )
        excp =  GetSignal('KillingException') ; 
        excpInd = find( RecStruct.ErrCodes.Code== excp,1) ; 
        if isempty( excpInd)
            errstr = 'Unknown error' ; 
        else
            errstr = RecStruct.ErrCodes.Formal{excpInd} ; 
            place = strfind(errstr,'_') ; 
        end
        SetAngleError = -1 ; 
        disp("Motor turned off by fault , Exception code:" + errstr) ;
        % uiwait( msgbox(},struct('Interpreter','none','WindowStyle' , 'modal') ) ) ; 
        return  ; 
    end 

    cnt = cnt+ 1 ; 

    if toc(tStep) >= ExpMng.WaitTime 
        tStep = tic ; 
        disp( 'Done ') ; 
        break ; 
    end           
end 

SendObj([hex2dec('2220'),4],0,DataType.long,'Set motor enable/disable') ;

