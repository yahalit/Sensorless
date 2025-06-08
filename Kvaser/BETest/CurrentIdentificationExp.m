global RecStruct %#ok<GVMIS> 
CreateStruct =  struct('Interpreter','tex','WindowStyle' , 'modal') ; 

SetCfg = 1 ; 


Axis = RecStruct.Axis; 
Side = RecStruct.Side ; 
UseAngle = 0 * pi / 180 ; 
MaxVolts = 6 ; 

switch Axis 
    case 'Neck' 
        ExpMng = struct('R',0.87,'L',1.e-3,'CurLevel',1,'F1',100,'F2',1500,'nPoints',20) ; 
        % Experiment parameters 
        ExperimentSafeLimits = struct( 'OverCurrent' , 16 , 'Undervoltage' , 20  , 'Overvoltage' , 60) ; 
    case 'Wheel'
%        ExpMng = struct('R',0.38,'L',1.e-3,'CurLevel',2,'F1',100,'F2',300,'nPoints',3) ; 
        error('No pars') ; 
    case 'Steering'
        error('No pars') ; 

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


% Set correct axis and side 


% Set to manual mode
SendObj([hex2dec('2220'),12],RecStruct.Enums.SysModes.E_SysMotionModeManual,DataType.long,'Set system mode to manual') ;

% Set motor off 
SendObj([hex2dec('2220'),4],0,DataType.long,'Set motor enable/disable') ;

% Set to open loop commutation 
SendObj([hex2dec('220d'),RecStruct.CfgTable.CommutationMode.Ind],RecStruct.Enums.CommutationModes.COM_OPEN_LOOP ,DataType.long,'Set open loop commutation') ;

% Set the reference mode 
SendObj([hex2dec('2220'),14],RecStruct.Enums.ReferenceModes.E_PosModeDebugGen,DataType.long,'Set reference mode') ;

% Set to identification mode 
SendObj([hex2dec('2220'),15],1,DataType.long,'Set identification mode') ;

% Reset any possible failure 
SendObj([hex2dec('2220'),10],1,DataType.long,'Reset fault') ;

%             ExpMng = struct ( 'R', app.AssumeROhmEditField.Value , ...
%             'L',app.AssumeLMHEditField.Value , ...
%             'CurLevel' , app.AssumeCurrentlevelEditField.Value , ...
%             'F1' , app.StartFrequencyEditField.Value , ...
%             'F2' , app.EndFrequencyEditField.Value , ...
%             'nPoints' , app.FrequencyPointsEditField.Value ) ; 
% ExpMng = load('IdSetup.mat' ) ; 
% ExpMng = ExpMng.ExpMng ; 

TestStructFields(ExpMng,{'R','L','CurLevel','F1','F2','nPoints'},'ExpMng') ; 

% Get Vdc 
Vdc = GetSignal('Vdc') ; 

n = ExpMng.nPoints ; 
if min( ExpMng.F1,ExpMng.F2) < 1 || max( ExpMng.F1,ExpMng.F2) > 8000 || ExpMng.F2 < ExpMng.F1 || ~(fix(n)==n) || n < 1 || n > 500 || ExpMng.CurLevel < 0 || ...
        ExpMng.CurLevel > ExperimentSafeLimits.OverCurrent * 0.9 || Vdc < ExperimentSafeLimits.Undervoltage * 0.9  
    error ('Bad experiment setup') ; 
end 

if n == 1 
    if ( ExpMng.F2 ~= ExpMng.F1) 
        error ('In one point experiment F1 must equal F2') ; 
    end
    Fvec = ExpMng.F1 ; 
else
    Fvec = round( logspace( log10(ExpMng.F1),log10(ExpMng.F2) , ExpMng.nPoints ))  ; %: (ExpMng.F2-ExpMng.F1) / (ExpMng.nPoints-1) : ExpMng.F2 ; 
end

wvec = Fvec * 2 * pi ; 
gvec = Fvec * 0 + abs ( 1./ ( ExpMng.R + sqrt(-1) * wvec * ExpMng.L ))   ;

vvec = min( ExpMng.CurLevel ./ gvec , MaxVolts) ; 

% Kill the G generator 
SetRefGen( struct('Gen','G','Type',RecStruct.Enums.SigRefTypes.E_S_Nothing,'On',0) ) ; 

SendObj([hex2dec('2220'),8],RecStruct.Enums.LoopClosureModes.E_LC_OpenLoopField_Mode,DataType.long,'Set the loop closure mode to open loop commutation') ;                      
SendObj([hex2dec('2220'),4],1,DataType.long,'Set motor enable') ;

% Create the basis for the T generator 
SetRefGen( struct('Gen','T','Type',RecStruct.Enums.SigRefTypes.E_S_Sine,'On',0) ) ; 

% Set the reference mode 
SendObj([hex2dec('2220'),14],RecStruct.Enums.ReferenceModes.E_PosModeDebugGen,DataType.long,'Set reference mode') ;

% Setup the recorder 
RecTime = 25 ; 
MaxRecLen = 500 ; 


RecStruct.Sync2C = 1 ; 
% InitRec set zero , recorder shall start automatically
% RecInitAction = struct( 'InitRec' , 0 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 
RecInitAction = struct( 'InitRec' , 0 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ,'MaxLen', MaxRecLen ) ; 
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 

RecNames = {'PhaseCur0','PhaseCur1','PhaseCur2','PwmA','PwmB','PwmC','vqd','Vdc','va','vb','vc','Iq'}  ; 


L_RecStruct = RecStruct ;
L_RecStruct.BlockUpLoad = 0 ; 
[~,L_RecStruct] = Recorder(RecNames , L_RecStruct , RecInitAction   );

TGenStr = struct('Gen','T','Type',RecStruct.Enums.SigRefTypes.E_S_Sine,'On',1,...
    'Dc',0,'Amp',0,'F',max( Fvec(1) , 10 ),'Duty',0.5,'bAngleSpeed',0)  ;
GGenStr = struct('Gen','G','Type',RecStruct.Enums.SigRefTypes.E_S_Sine,'On',1,...
    'Dc',0,'Amp',0,'F',max( Fvec(1) , 10 ),'Duty',0.5,'bAngleSpeed',0,'AnglePeriod',1)  ;
for cnt = 1:n 
    s = SGetState() ; 
    if ( s.Bit.MotorOn == 0 )
        uiwait( msgbox({'\fontsize{12}Motor turned off'},CreateStruct) ) ; 
        break ; 
    end 

    nextF = round( min( max( Fvec(cnt) , 10 ) , 5000) ) ; 

    disp (['Next Frequency: ', num2str(nextF), '  :',num2str(cnt),' : out of ',num2str(n) ]) ; 

    TGenStr = struct('Gen','T','Type',RecStruct.Enums.SigRefTypes.E_S_Sine,'On',1,...
        'Dc',0,'Amp',vvec(cnt) * cos(UseAngle) ,'F',nextF,'Duty',0.5,'bAngleSpeed',0)  ;
    GGenStr = struct('Gen','G','Type',RecStruct.Enums.SigRefTypes.E_S_Sine,'On',1,...
        'Dc',0,'Amp',vvec(cnt) * sin(UseAngle),'F',nextF,'Duty',0.5,'bAngleSpeed',0,'AnglePeriod',1)  ;
    SetRefGen(  TGenStr ) 
    SetRefGen(  GGenStr ) 

    % Set the recorder length 
    RecTime = 5 / nextF ; 
    [L_RecStruct.Gap , L_RecStruct.Len] = SetRecTime(   RecTime , length(RecNames) , 1  , MaxRecLen );
    SendObj( [hex2dec('2000'),1] , L_RecStruct.Gap , DataType.short , 'recstruct.Gap' ) ;
    SendObj( [hex2dec('2000'),2] , L_RecStruct.Len , DataType.short  , 'recstruct.Len' ) ;

    pause( 3 / nextF ) ; 
    SendObj( [hex2dec('2000'),100] , 1 , DataType.short  , 'Set the recorder on' ) ;
    pause( RecTime ) ; 

    TGenStr.On = 0 ; % Stop excitation while recorder uploads 
    GGenStr.On = 0 ; % Stop excitation while recorder uploads 
    SetRefGen(  TGenStr ) 
    SetRefGen(  GGenStr ) 
    
    % Bring the records 
    [~,~,r] = Recorder(RecNames , L_RecStruct , RecBringAction   );

    figure(30+cnt) ; clf  
    subplot( 3,1,1) ;
    plot ( r.t , r.PhaseCur0 , r.t , r.PhaseCur1 , r.t , r.PhaseCur2 ) ;
    legend('CurA','CurB','CurC') ; 
    ylabel('Amp') ; 
    subplot( 3,1,2) ;
    plot ( r.t , r.PwmA , r.t , r.PwmB , r.t , r.PwmC ,'.-') ; 
    legend('PWMA','PWMB','PWMC') ; 
    subplot( 3,1,3) ;
    plot ( r.t , r.vqd  ) ;
    legend('Vq') ; 
    vn = ( r.va + r.vb + r.vc ) / 3 ; 
    van = r.va - vn ; 
    vbn = r.vb - vn ; 
    vcn = r.vc - vn ; 

    save( ['.\NeckCurrentId\CurIdentRslt_',Axis,'_',num2str(nextF),'Hz'], 'r',  'TGenStr',  'TGenStr','UseAngle') ; 

end 

% Set motor off , Clear ID mode anyway 
SendObj([hex2dec('2220'),4],0,DataType.long,'Set motor enable/disable') ;
SendObj([hex2dec('2220'),15],0,DataType.long,'Remove identification mode') ;

% Analyze the results 


