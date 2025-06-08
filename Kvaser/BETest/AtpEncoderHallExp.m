global RecStruct %#ok<GVMIS> 
DataType = GetDataType(); 

% Make a commutation experiment 
% assume that the communication target has been setup before (see AtpStart) 

CreateStruct =  struct('Interpreter','tex','WindowStyle' , 'modal') ; 

SetCfg = 1 ; 
Axis = RecStruct.Axis ; 
Side = RecStruct.Side ; 
UseAngle = 0 * pi / 180 ; 

switch Axis 
    case 'Neck' 
        ExpMng = struct('CurLevel',2,'nCycle',10,'WaitTime',3,'CycleTime',3,'npp',4) ; 
        % Experiment parameters 
        ExperimentSafeLimits = struct( 'OverCurrent' , 16 , 'Undervoltage' , 20  , 'Overvoltage' , 60) ; 
    case 'Wheel'
%        ExpMng = struct('R',0.38,'L',1.e-3,'CurLevel',2,'F1',100,'F2',300,'nPoints',3) ; 
        error('No pars') ; 
    case 'Steering'

        ExpMng = struct('CurLevel',2,'nCycle',10,'WaitTime',1,'CycleTime',3,'npp',2) ; 
        % Experiment parameters 
        ExperimentSafeLimits = struct( 'OverCurrent' , 6 , 'Undervoltage' , 20  , 'Overvoltage' , 60) ;         

    otherwise
        error ('Unknown axis ') ;
end 

% Set configuration 
if SetCfg 
    MyCgf = SaveCfg([],'StamCfg.jsn') ; 
    ProgCfg('StamCfg.jsn') ; 
end 


SetFloatPar( 'ClaControlPars.PhaseOverCurrent', ExperimentSafeLimits.OverCurrent ) ; 
SetFloatPar( 'ClaControlPars.VDcMax', ExperimentSafeLimits.Overvoltage ) ; 
SetFloatPar( 'ClaControlPars.VDcMin', ExperimentSafeLimits.Undervoltage ) ; 

% Set to manual mode
SendObj([hex2dec('2220'),12],RecStruct.Enums.SysModes.E_SysMotionModeManual,DataType.long,'Set system mode to manual') ;

% Set motor off 
SendObj([hex2dec('2220'),4],0,DataType.long,'Set motor enable/disable') ;

% Set to open loop commutation 
SendObj([hex2dec('220d'),RecStruct.CfgTable.CommutationMode.Ind],RecStruct.Enums.CommutationModes.COM_OPEN_LOOP ,DataType.long,'Set open loop commutation') ;


% Reset any possible failure 
SendObj([hex2dec('2220'),10],1,DataType.long,'Reset fault') ;

TestStructFields(ExpMng,{'CurLevel','nCycle','WaitTime','CycleTime','npp'},'ExpMng') ; 

% Get Vdc 
Vdc = GetSignal('Vdc') ; 

n = ExpMng.nCycle ; 
if  n < 1 || n > 500 || ExpMng.CurLevel < 0.1 || ExpMng.CycleTime < 0.1 || ExpMng.CycleTime > 100 || ...
        ExpMng.CurLevel > ExperimentSafeLimits.OverCurrent * 0.9 || Vdc < ExperimentSafeLimits.Undervoltage * 0.9  
    error ('Bad experiment setup') ; 
end 

% Kill the G generator 
SetRefGen( struct('Gen','G','Type',RecStruct.Enums.SigRefTypes.E_S_Nothing,'On',0) ) ; 

SendObj([hex2dec('2220'),8],RecStruct.Enums.LoopClosureModes.E_LC_OpenLoopField_Mode,DataType.long,'Set the loop closure mode to open loop commutation') ;                      

% Create the basis for the T generator 
SetRefGen( struct('Gen','T','Type',RecStruct.Enums.SigRefTypes.E_S_Fixed,'On',0) ) ; 

% Set the reference mode 
SendObj([hex2dec('2220'),14],RecStruct.Enums.ReferenceModes.E_PosModeDebugGen,DataType.long,'Set reference mode') ;

% Start the motor 
SendObj([hex2dec('2220'),4],1,DataType.long,'Set motor enable') ;

% Set the reference mode (it was reset to stay-in-place during the motor-on process) 
SendObj([hex2dec('2220'),14],RecStruct.Enums.ReferenceModes.E_PosModeDebugGen,DataType.long,'Set reference mode') ;

% Bring the motor to standstill
TGenStr = struct('Gen','T','Type',RecStruct.Enums.SigRefTypes.E_S_Fixed,'On',1,...
    'Dc',ExpMng.CurLevel,'Amp',0,'F',1,'Duty',0.5,'bAngleSpeed',0)  ;

Gdc = 1/ExpMng.CycleTime ; 
GGenStr = struct('Gen','G','Type',RecStruct.Enums.SigRefTypes.E_S_Fixed,'On',1,...
    'Dc',Gdc,'Amp',0,'F',1,'Duty',0.5,'bAngleSpeed',1,'AnglePeriod',1)  ;


rslt = zeros( 6, 10000) ; 

RecTime = 20 ; 
MaxRecLen = 500 ; 

% Setup the recorder 
% RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ,'MaxLen', MaxRecLen ) ; 
% RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 
RecNames = {'Iq','EncCounts','HallKey','ThetaElect','CBit'}  ; 
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
        uiwait( msgbox({'Motor turned off by fault','Exception code:',errstr},struct('Interpreter','none','WindowStyle' , 'modal') ) ) ; 
        return  ; 
    end 

    cnt = cnt+ 1 ; 
    rslt(1,cnt) = r.HallKey ;
    rslt(2,cnt) = r.EncCounts ;
    rslt(3,cnt) = r.TimeUsec ; 
    rslt(4,cnt) = state ;
    rslt(5,cnt) = r.ThetaElect ; 
    rslt(6,cnt) = etime(clock , tclk )  ; %#ok<CLOCK,DETIM> 

    switch state

        case 0
            if toc(tStep) >= ExpMng.WaitTime 
                tStep = tic ; 
                disp( 'Starting direction #1 ') ; 
                state = 1 ; 
            end
        case 1
            if toc(tStep) >= ExpMng.CycleTime * ExpMng.nCycle 
                disp( 'Stopping direction #1 ') ; 
                GGenStr.Dc = 0 ; 
                SetRefGen(  GGenStr ) ; % Start rotation
                tStep = tic ; 
                state = 2 ; 
            end
        case 2
            if toc(tStep) >= ExpMng.WaitTime 
                disp( 'Starting direction #2 ') ; 
                GGenStr.Dc = -Gdc ; 
                SetRefGen(  GGenStr ) ; % Start rotation
                tStep = tic ; 
                state = 3 ; 
            end
        case 3
            if toc(tStep) >= ExpMng.CycleTime * ExpMng.nCycle 
                disp( 'Stopping direction #2 ') ; 
                GGenStr.Dc = 0 ; 
                SetRefGen(  GGenStr ) ; % Start rotation
                tStep = tic ; 
                state = 4 ; 
            end
        case 4
            if toc(tStep) >= ExpMng.WaitTime 
                disp( 'Done ') ; 
                state = 6 ; 
                break ; 
            end
    end
            
end 

SendObj([hex2dec('2220'),4],0,DataType.long,'Set motor enable/disable') ;
rslt = rslt(:,1:cnt) ; % Keep only filled entries
save AnaComm.mat rslt

State    = rslt(4,:) ; 
indfw    = find(State==1) ; 
indbw    = find(State==3) ; 
HallKeyFw = rslt(1,indfw) ; 
HallKeyBw = rslt(1,indbw) ; 
EncCountsFw  = rslt(2,indfw) ; 
EncCountsBw  = rslt(2,indbw) ; 
ThetaElectFw  = rslt(5,indfw) ; 
ThetaElectBw  = rslt(5,indbw) ; 


% ThetaElectFw = unwrap( ThetaElectFw * 2 * pi ) / 2 / pi ; 
% ThetaElectBw = unwrap( ThetaElectBw(end:-1:1) * 2 * pi ) / 2 / pi ; 
% HallKeyBw = HallKeyBw(end:-1:1) ; 
figure(10) ; clf

plot( ThetaElectFw , HallKeyFw + 0.05,'x', ThetaElectBw , HallKeyBw - 0.05 ,'d'  ) ; legend('Forward','Back') ; 
LoLimit = (0:1/6:5/6) - 1/24 ; 
HiLimit = (0:1/6:5/6) + 1/24 ; 

tht = ThetaElectFw ;
halls = HallKeyFw ; 
thtm = zeros(1,6) ; 
key  = zeros(1,6) - 1  ; 
for cnt = 1:6 
    ind = find(halls ==cnt) ;  
    thth = tht(ind) ; 
    if ( any(thth < 0.17 ) && any(thth > 0.83) )
        indg = find(thth > 0.7); 
        thth(indg) = thth(indg) - 1 ; 
    end 
    thtm(cnt) = mean(thth ) ; 
end 
off1 = mean(sort(thtm) - (0:1/6:5/6)) ; 
for cnt = 1:6 
    nextKey = find( (thtm(cnt)-off1 > LoLimit ) & (thtm(cnt)-off1 < HiLimit )  ) ; 
    if isempty( nextKey )
        error(['Hall value of ', num2str(cnt),' is missing']) ; 
    end  
    key(cnt)  = nextKey ; 
end
OffFw   = off1 ; 
iKeyFw = key-1 ; 

tht = ThetaElectBw ;
halls = HallKeyBw ; 
thtm = zeros(1,6) ; 
key  = zeros(1,6) - 1  ; 
ikey  = zeros(1,6) - 1  ; 
for cnt = 1:6 
    ind = find(halls ==cnt) ;  
    thth = tht(ind) ; 
    if ( any(thth < 0.17 ) && any(thth > 0.83) )
        indg = find(thth > 0.7); 
        thth(indg) = thth(indg) - 1 ; 
    end 
    thtm(cnt) = mean(thth ) ; 
end 
off1 = mean(sort(thtm) - (0:1/6:5/6)) ; 
for cnt = 1:6 
    key(cnt)  = find( (thtm(cnt)-off1 > LoLimit ) & (thtm(cnt)-off1 < HiLimit )  ) ; 
end
OffBw   = off1 ; 
iKeyBw = key - 1 ; 

if any( key < 1 ) 
    error('At least one Hall key is missing') ; 
end 
if ~isequal(iKeyFw,iKeyBw) 
    error('Hall ordering unequal between directions') ; 
end 
offs = mean(  [OffBw , OffFw] ) ;
disp(  ['Additive Offset: ', num2str(offs) ]); 
disp(  ['Key sequence: ', num2str(iKeyBw)]  ); 

figure(20) ; clf 
ThetaElectFw = unwrap( ThetaElectFw * 2 * pi ) / 2 / pi ; 
ThetaElectBw = unwrap( ThetaElectBw(end:-1:1) * 2 * pi ) / 2 / pi ; 
EncCountsBw = EncCountsBw(end:-1:1) ; 

plot( ThetaElectFw , EncCountsFw , ThetaElectBw , EncCountsBw  );

p1 = polyfit(ThetaElectFw,EncCountsFw,1) ; 
p2 = polyfit(ThetaElectBw,EncCountsBw,1) ; 

EncRes = mean([p1(1),p2(1)]) * ExpMng.npp ; 
EncSign = sign(EncRes) ; 
EncRes = EncRes * EncSign ; 
elog = log2(abs(EncRes)) ; 
if abs( elog - round(elog) ) < 0.005 
    EncRes = 2^round(elog); 
end

disp(['Estimated encoder resolution :' , num2str(EncRes)] ) ; 

if ( EncSign > 0 )
    disp('Encoder direction OK') ; 
else
    disp('You MUST negate encoder direction') ; 
end
    
