% CurrentCalibExp: Calibrate the current sensors against scope measurements
global RecStruct %#ok<GVMIS> 

DataType = GetDataType() ; 
% Make a commutation experiment 
% assume that the communication target has been setup before (see AtpStart) 
CreateStruct =  struct('Interpreter','tex','WindowStyle' , 'modal') ; 

uiwait( msgbox({'\fontsize{12}Use a scope to measure the sine currents of the motor, set 200msec/div:','Vertical scale should be to 10Amp'}...
    ,CreateStruct ) ) ; 

CalibOption = questdlg('\fontsize{12}Calibrate or just check?', ...
                         'Decision', ...
                         'Calibrate', 'Check', struct('Interpreter','tex','WindowStyle' , 'modal','Default','Calibrate'));

SetCfg = 1 ; 
Axis = RecStruct.Axis ; 
Side = RecStruct.Side ; 
UseAngle = 0 * pi / 180 ; 

switch Axis 
    case 'Neck' 
        ExpMng = struct('CurLevel',3,'nCycle',5,'WaitTime',3,'CycleTime',3,'npp',4) ; 
        % Experiment parameters 
        ExperimentSafeLimits = struct( 'OverCurrent' , 16 , 'Undervoltage' , 20  , 'Overvoltage' , 60) ; 
    case 'Wheel'
%        ExpMng = struct('R',0.38,'L',1.e-3,'CurLevel',2,'F1',100,'F2',300,'nPoints',3) ; 
        error('No pars') ; 
    case 'Steering'

        ExpMng = struct('CurLevel',2,'nCycle',5,'WaitTime',1,'CycleTime',3,'npp',2) ; 
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

Gdc = 3/ExpMng.CycleTime ; 
GGenStr = struct('Gen','G','Type',RecStruct.Enums.SigRefTypes.E_S_Fixed,'On',1,...
    'Dc',Gdc,'Amp',0,'F',1,'Duty',0.5,'bAngleSpeed',1,'AnglePeriod',1)  ;


rslt = zeros( 7, 10000) ; 

RecTime = 20 ; 
MaxRecLen = 500 ; 

% Setup the recorder 
% RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ,'MaxLen', MaxRecLen ) ; 
% RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 
if isequal(CalibOption,'Check') 
    RecNames = {'Iq','ThetaElect','CBit','PhaseCur0','PhaseCur1','PhaseCur2'}  ; 
else
    RecNames = {'Iq','ThetaElect','CBit','PhaseCurUncalibA','PhaseCurUncalibB','PhaseCurUncalibC'}  ; 
end
% L_RecStruct = RecStruct ;
% L_RecStruct.BlockUpLoad = 0 ; 
TypeFlags = SetSnap( RecNames ) ; 

SetRefGen(  TGenStr ) ; % Let the torque converge 

disp( 'Rotating #1 ') ; 
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
    if isequal(CalibOption,'Check') 
        rslt(1,cnt) = r.PhaseCur0 ;
        rslt(2,cnt) = r.PhaseCur1 ;
        rslt(3,cnt) = r.PhaseCur2 ;
    else
        rslt(1,cnt) = r.PhaseCurUncalibA ;
        rslt(2,cnt) = r.PhaseCurUncalibB ;
        rslt(3,cnt) = r.PhaseCurUncalibC ;
    end

    rslt(4,cnt) = r.TimeUsec ; 
    rslt(5,cnt) = state ;
    rslt(6,cnt) = r.ThetaElect ; 
    rslt(7,cnt) = etime(clock , tclk )  ; %#ok<CLOCK,DETIM> 
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
save AnaCalibCur.mat rslt

State    = rslt(5,:) ; 
indfw    = find(State==1) ; 
PhaseCur0 = rslt(1,indfw) ; 
PhaseCur1  = rslt(2,indfw) ; 
PhaseCur2  = rslt(3,indfw) ; 
ThetaElect  = rslt(6,indfw) ; 

% ThetaElectFw = unwrap( ThetaElectFw * 2 * pi ) / 2 / pi ; 
% ThetaElectBw = unwrap( ThetaElectBw(end:-1:1) * 2 * pi ) / 2 / pi ; 
% HallKeyBw = HallKeyBw(end:-1:1) ; 
figure(10) ; clf

plot( ThetaElect , PhaseCur0, '+',ThetaElect , PhaseCur1 ,'x' , ThetaElect , PhaseCur2 ,'d')
H = [PhaseCur0(:) , PhaseCur1(:) , PhaseCur2(:) , 1+PhaseCur2(:)*0] ; 
[~,s,v] = svd(H) ; 
[~,n] = size(s) ; 
PhaseGain = v(1:3,end); 
if PhaseGain(1) < 0 
    PhaseGain = -PhaseGain ; 
end 
s = diag(s(1:n,1:n));
if  s(end) >= 15 * min(s(1:2)) || any(PhaseGain < 0.5)
    error ('No clear linear relation') ; 
end
relgain = ( PhaseGain./PhaseGain(1)-1)  ; 
if any(relgain > 0.07)
    error ('Too big discrepancy between currents');
end 
ppExpectedAmp = ExpMng.CurLevel*2 ; 
ppAmp = InputByRange('P-P amplitude of sin wave in scope',[0.0,inf],ExpMng.CurLevel*2) ; 
if  abs( ( ppAmp / ppExpectedAmp - 1 )) > 0.07  
    error('Unexpected big deviations, please check hardware') ; 
end 

relgain = (1 -sqrt(1/3) * norm(PhaseGain)./ PhaseGain)  ; 
disp(['Relative gains : ' , num2str(transpose(relgain(:))) ]) 
if isequal(CalibOption,'Check') 
    if any( relgain > 0.025 ) 
        disp('Driver requires calibration') ;
    else
        disp('Driver ok, does not requires calibration') ;
    end
else
    Calib = SaveCalib ( []  ,'Temporary.jsn' , RecStruct.CalibCfg) ; 
    
    
    
    Calib.ACurGainCorr = relgain(1) ; 
    Calib.BCurGainCorr = relgain(2) ; 
    Calib.CCurGainCorr = relgain(3) ;  
    
    
    ProgCalib ( Calib , 1 , RecStruct.CalibCfg ) ; 
end 


disp('Done');
% Amplitudes shall not be corrected since it will just introduce big error ...
