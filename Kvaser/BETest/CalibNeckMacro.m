global RecStruct %#ok<GVMIS> 
DataType = GetDataType(); 
NeckCanId = 30; 
LpCanId = 124 ; 

%Use object 0x2225 GetFloatData to get geometry data

NGeom = struct('Pot1Rat2Rad',1,'Pot2Rat2Rad',1,'Pot1RatCenter',0.5) ;
NGeom.Pot1Rat2Rad = FetchObj([hex2dec('2225'),1,NeckCanId],DataType.float,'Pot1Rat2Rad') ; 
NGeom.Pot2Rat2Rad = FetchObj([hex2dec('2225'),2,NeckCanId],DataType.float,'Pot2Rat2Rad') ; 

NGeom.Pot1RatCenter = FetchObj([hex2dec('2225'),3,NeckCanId],DataType.float,'Pot1RatCenter') ; 
NGeom.Pot2RatCenter = FetchObj([hex2dec('2225'),4,NeckCanId],DataType.float,'Pot2RatCenter') ; 


% Make a commutation experiment 
% assume that the communication target has been setup before (see AtpStart) 

CreateStruct =  struct('Interpreter','tex','WindowStyle' , 'modal') ; 

SetCfg = 1 ; 
Axis = RecStruct.Axis ; 
Side = RecStruct.Side ; 
UseAngle = 0 * pi / 180 ; 

switch Axis 
    case 'Neck' 
        ExpMng = struct('CurLevel',3,'nCycle',10,'WaitTime',20,'CycleTime',3,'npp',4) ; 
        % Experiment parameters 
        ExperimentSafeLimits = struct( 'OverCurrent' , 16 , 'Undervoltage' , 20  , 'Overvoltage' , 60) ; 
    otherwise
        error ('This experiment is ony for the NECK axis ') ;
end 

% Set configuration - just confirm the existing 
if SetCfg 
    MyCgf = SaveCfg([],'StamCfg.jsn') ; 
    ProgCfg('StamCfg.jsn') ; 
end 

SendObj([hex2dec('2225'),5,NeckCanId],ExperimentSafeLimits.OverCurrent,DataType.float,'ClaControlPars.PhaseOverCurrent') ; 
SendObj([hex2dec('2225'),6,NeckCanId],ExperimentSafeLimits.Overvoltage,DataType.float,'ClaControlPars.VDcMax') ; 
SendObj([hex2dec('2225'),7,NeckCanId],ExperimentSafeLimits.Undervoltage,DataType.float,'ClaControlPars.VDcMin') ; 

% Be a master blaster
SendObj([hex2dec('2220'),5,LpCanId],hex2dec('1234'),DataType.long,'Brake set/release') ; 
% Block servo communication 
SendObj([hex2dec('2220'),13,LpCanId],1,DataType.long,'Brake set/release') ; 

% Set to manual mode
SendObj([hex2dec('2220'),12,NeckCanId],RecStruct.Enums.SysModes.E_SysMotionModeManual,DataType.long,'Set system mode to manual') ;

% Set motor off 
SendObj([hex2dec('2220'),4,NeckCanId],0,DataType.long,'Set motor enable/disable') ;

% Set to open loop commutation 
% SendObj([hex2dec('220d'),RecStruct.CfgTable.CommutationMode.Ind],RecStruct.Enums.CommutationModes.COM_OPEN_LOOP ,DataType.long,'Set open loop commutation') ;


% Reset any possible failure 
SendObj([hex2dec('2220'),10,NeckCanId],1,DataType.long,'Reset fault') ;

TestStructFields(ExpMng,{'CurLevel','nCycle','WaitTime','CycleTime','npp'},'ExpMng') ; 

% Get Vdc 
Vdc = FetchObj([hex2dec('2221'),36,NeckCanId],DataType.float,'Pot1Rat2Rad') ; 

n = ExpMng.nCycle ; 
if  n < 1 || n > 500 || ExpMng.CurLevel < 0.1 || ExpMng.CycleTime < 0.1 || ExpMng.CycleTime > 100 || ...
        ExpMng.CurLevel > ExperimentSafeLimits.OverCurrent * 0.9 || Vdc < ExperimentSafeLimits.Undervoltage * 0.9  
    error ('Bad experiment setup') ; 
end 

% % Kill the G generator 
% SetRefGen( struct('Gen','G','Type',RecStruct.Enums.SigRefTypes.E_S_Nothing,'On',0) ) ; 
% 
% SendObj([hex2dec('2220'),8],RecStruct.Enums.LoopClosureModes.E_LC_OpenLoopField_Mode,DataType.long,'Set the loop closure mode to open loop commutation') ;                      
% 
% % Create the basis for the T generator 
% SetRefGen( struct('Gen','T','Type',RecStruct.Enums.SigRefTypes.E_S_Fixed,'On',0) ) ; 

% Set the reference mode 
% SendObj([hex2dec('2220'),14],RecStruct.Enums.ReferenceModes.E_PosModeDebugGen,DataType.long,'Set reference mode') ;
% 
% % Start the motor 
% SendObj([hex2dec('2220'),4],1,DataType.long,'Set motor enable') ;
% 
% % Set the reference mode (it was reset to stay-in-place during the motor-on process) 
% SendObj([hex2dec('2220'),14],RecStruct.Enums.ReferenceModes.E_PosModeDebugGen,DataType.long,'Set reference mode') ;
% 
% % Bring the motor to standstill
% TGenStr = struct('Gen','T','Type',RecStruct.Enums.SigRefTypes.E_S_Fixed,'On',1,...
%     'Dc',ExpMng.CurLevel,'Amp',0,'F',1,'Duty',0.5,'bAngleSpeed',0)  ;
% 
% Gdc = 1/ExpMng.CycleTime ; 
% GGenStr = struct('Gen','G','Type',RecStruct.Enums.SigRefTypes.E_S_Fixed,'On',1,...
%     'Dc',Gdc,'Amp',0,'F',1,'Duty',0.5,'bAngleSpeed',1,'AnglePeriod',1)  ;
% 
% 
rslt = zeros( 8, 10000) ; 

RecTime = 20 ; 
MaxRecLen = 500 ; 

% Setup the recorder 
% RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ,'MaxLen', MaxRecLen ) ; 
% RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 
RecNames = {'Iq','EncCounts','PotRat1','PotRat2','UserPos','CBit'}  ; 
% L_RecStruct = RecStruct ;
% L_RecStruct.BlockUpLoad = 0 ; 
TypeFlags = SetSnap( RecNames , NeckCanId ) ; 

% SetRefGen(  TGenStr ) ; % Let the torque converge 


% Release the brake 
SendObj([hex2dec('2220'),23,NeckCanId],2,DataType.long,'Brake BrakeControlOverride') ; 
SendObj([hex2dec('2220'),20,NeckCanId],1,DataType.long,'Brake set/release') ; 

disp( ['Your time has begun Seconds: ',num2str(ExpMng.WaitTime)]) ; 
 % Start the recorder
% [~,L_RecStruct] = Recorder(RecNames , L_RecStruct , RecInitAction   );

cnt = 0 ; 
tStart = tic ; 
tStep  = tStart ; 
state = 0 ; 
% SetRefGen(  GGenStr ) ; % Start rotation
tclk = clock() ; %#ok<CLOCK> 
while cnt < 10000  
    
    % s = SGetState() ; 
%     if ( s.Bit.MotorOn == 0 )
%         uiwait( msgbox({'\fontsize{12}Motor turned off'},CreateStruct) ) ; 
%         break ; 
%     end 
    roll1 = FetchObj([hex2dec('2204'),54,LpCanId],DataType.float,'Roll') ;
    r = GetSnap(RecNames,TypeFlags,NeckCanId) ; 
    roll2 = FetchObj([hex2dec('2204'),54,LpCanId],DataType.float,'Roll') ;
    roll = 0.5 * (roll1 + roll2) ;

%     if ( bitand(r.CBit,1) == 0 )
%         excp =  GetSignal('KillingException') ; 
%         excpInd = find( RecStruct.ErrCodes.Code== excp,1) ; 
%         if isempty( excpInd)
%             errstr = 'Unknown error' ; 
%         else
%             errstr = RecStruct.ErrCodes.Formal{excpInd} ; 
%             place = strfind(errstr,'_') ; 
%         end
%         uiwait( msgbox({'Motor turned off by fault','Exception code:',errstr},struct('Interpreter','none','WindowStyle' , 'modal') ) ) ; 
%         return  ; 
%     end 

    cnt = cnt+ 1 ; 
    rslt(1,cnt) = r.UserPos ;
    rslt(2,cnt) = r.EncCounts ;
    rslt(3,cnt) = r.PotRat1 ; 
    rslt(4,cnt) = state ;
    rslt(5,cnt) = r.PotRat2 ; 
    rslt(6,cnt) = etime(clock , tclk )  ; %#ok<CLOCK,DETIM> 
    rslt(7,cnt) = roll ; 

    switch state

        case 0
            if toc(tStep) >= ExpMng.WaitTime 
                tStep = tic ; 
                disp( 'Starting direction #1 ') ; 
                state = 1 ; 
                break;
            end
%         case 1
%             if toc(tStep) >= ExpMng.CycleTime * ExpMng.nCycle 
%                 disp( 'Stopping direction #1 ') ; 
%                 GGenStr.Dc = 0 ; 
%                 SetRefGen(  GGenStr ) ; % Start rotation
%                 tStep = tic ; 
%                 state = 2 ; 
%             end
%         case 2
%             if toc(tStep) >= ExpMng.WaitTime 
%                 disp( 'Starting direction #2 ') ; 
%                 GGenStr.Dc = -Gdc ; 
%                 SetRefGen(  GGenStr ) ; % Start rotation
%                 tStep = tic ; 
%                 state = 3 ; 
%             end
%         case 3
%             if toc(tStep) >= ExpMng.CycleTime * ExpMng.nCycle 
%                 disp( 'Stopping direction #2 ') ; 
%                 GGenStr.Dc = 0 ; 
%                 SetRefGen(  GGenStr ) ; % Start rotation
%                 tStep = tic ; 
%                 state = 4 ; 
%             end
%         case 4
%             if toc(tStep) >= ExpMng.WaitTime 
%                 disp( 'Done ') ; 
%                 state = 6 ; 
%                 break ; 
%             end
    end
            
end 

% Set the brake again
disp('Time os up , dummy') ; 
SendObj([hex2dec('2220'),20,NeckCanId],0,DataType.long,'Brake set/release') ; 


SendObj([hex2dec('2220'),4,NeckCanId],0,DataType.long,'Set motor enable/disable') ;
rslt = rslt(:,1:cnt) ; % Keep only filled entries
save AnaCalibNeck.mat rslt ExpMng NGeom

    UserPos = rslt(1,:) ;
    EncCounts = rslt(2,:) ;
    PotRat1 = rslt(3,:) ; 
    %rslt(4,:) = state ;
    PotRat2 = rslt(5,:)  ; 
    t = rslt(6,:)   ; %#ok<CLOCK,DETIM> 
    Roll =  rslt(7,:); 
figure(1) ; clf 
plot( t , Roll,t , UserPos, t, (PotRat1 - PotRat1(1) ) * 8 , t, (PotRat2-PotRat2(1))*7.5 ) ; legend('Roll','UserPos','Pot1','Pot2') ; 