global RecStruct %#ok<GVMIS> 

%uiwait( msgbox('Use WheelDrv to set the motor on in torque mode'))  ;

Ts = 50e-6 ; 
CurrentAmp = 2.0 ; 
LimitAmp = 2.5 ; 
ColorFunc = tf(1,1,Ts) ; 
nf = 1 ; 
NPoints = 100 ; 
Fstart  = 10 ; 
FEnd    = 1000 ; 
SetCfg = 1 ; 

% NPoints = 1 ; 
% Fstart  = 200 ; 
% FEnd    = 200 ; 


[fout,Ncyc,Ntake,f1] = FPicker( Fstart , FEnd , NPoints, 3 , Ts ); 

% NPoints = 1 ; 
% [fout,Ncyc,Ntake,f1] = FPicker( 100 , 100 , 1, 1 , Ts ) ; 

% If recorder is used, name of recorded vars
RecVarNames = {'CurrentCommand','UserPos','Iq','CorrelationState'} ; % ,'InterruptTime'};   
if NPoints == 1 
    takerec = 1;     
else
    takerec = ones(1,NPoints)* 0 ; 
end

% Set configuration (if not configured, just repeat)  
if SetCfg 
    MyCgf = SaveCfg([],'StamCfg.jsn') ; 
    ProgCfg('StamCfg.jsn') ; 
end 

% Set to manual mode
SendObj([hex2dec('2220'),12],RecStruct.Enums.SysModes.E_SysMotionModeManual,DataType.long,'Set system mode to manual') ;

% Set motor off 
SendObj([hex2dec('2220'),4],0,DataType.long,'Set motor disable') ;

% Set to torque mode
SendObj([hex2dec('2220'),8],RecStruct.Enums.LoopClosureModes.E_LC_Torque_Mode ,DataType.long,'Set torque mode') ;

% Reset any possible failure 
SendObj([hex2dec('2220'),10],1,DataType.long,'Reset fault') ;

% Start the motor 
SendObj([hex2dec('2220'),4],1,DataType.long,'Set motor enable') ;

% Set the reference mode (it was reset to stay-in-place during the motor-on process) 
SendObj([hex2dec('2220'),14],RecStruct.Enums.ReferenceModes.E_PosModeDebugGen,DataType.long,'Set reference mode') ;

SignalNames = {'CurrentCommand','UserPos','Iq'};
SetIdentSignals(SignalNames{1},SignalNames{2},SignalNames{3}) ; 

strriv = [] ; 

for nExp = 1: NPoints
    NextF   = fout(nExp) ; 
    
    disp(['Frequency: ' , num2str(NextF)   ' :  ', num2str(nExp),' Off: ' num2str(NPoints) ] ) 

    IdentStr = struct('nCyclesInTake',Ncyc(nExp),'nSamplesForFullTake',Ntake(nExp),'nWaitTakes',6,'nSumTakes',2) ; 
    IdentSetup( IdentStr );
% AllowRefGenInMotorOff(1);

    s = SGetState() ; 
    if ~s.Bit.MotorOn
        error('Motor cut off prematurely') ; 
    end 

    % Kill the G generator 
    ExpAmp = min( CurrentAmp * abs( freqresp( ColorFunc , NextF*2*pi )) , LimitAmp ) ; 

    SetRefGen( struct('Gen','G','Type',RecStruct.Enums.SigRefTypes.E_S_Nothing,'On',0) ) ; 
    % Create the basis for the T generator 
    SetRefGen( struct('Gen','T','Type',RecStruct.Enums.SigRefTypes.E_S_Fixed,'On',0) ) ; 
    TGenStr = struct('Gen','T','Type',RecStruct.Enums.SigRefTypes.E_S_Sine,'On',0,...
        'Dc',0,'Amp',ExpAmp,'F',NextF,'Duty',0.5,'bAngleSpeed',0)  ;
    GGenStr = struct('Gen','G','Type',RecStruct.Enums.SigRefTypes.E_S_Sine,'On',0,...
        'Dc',0,'Amp',ExpAmp * 2 ,'F',NextF,'Duty',0.5,'bAngleSpeed',0)  ;

    Time4Cycle = Ts * IdentStr.nSamplesForFullTake * ( 1 + IdentStr.nWaitTakes + 2 * IdentStr.nSumTakes) ; 
    if takerec(nExp)
        RecStruct.Sync2C = 1 ;
        RecTime = Time4Cycle + 0.05 ; 
        MaxRecLen = 1000 ; 
        RecAction = struct( 'InitRec' ,  0, 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ,'MaxLen', MaxRecLen ,'BlockUpLoad',0 ,'OwnerFlag',30001) ; 
        Recorder(RecVarNames , RecStruct , RecAction   );
    end


    
    % Set the reference mode to debug
    SendObj([hex2dec('2220'),14],RecStruct.Enums.ReferenceModes.E_PosModeDebugGen,DataType.long,'Set reference mode') ;
    SetRefGen(TGenStr,0) ; 
    SetRefGen(GGenStr) ; 

    if takerec(nExp)
       SendObj( [hex2dec('2000'),100] , 30002 , DataType.short  , 'Set the recorder on' ) ;
    end 

    StartFrequencyMeas() ; 
    
    pause(Time4Cycle) ; 
    stri = GetIdentData();
    strri = GetIdentRslt(stri);

    strriv = [strriv, strri] ; %#ok<AGROW> 

    if takerec(nExp)
        RecAction = struct( 'InitRec' ,  0, 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1  ,'BlockUpLoad',1,'OwnerFlag',30002 ) ; 
        [~,~,r] = Recorder(RecVarNames , RecStruct , RecAction   );
    end
end

SendObj([hex2dec('2220'),4],0,DataType.long,'Set motor enable/disable') ;

Rev2Pos = GetFloatPar('ClaControlPars.Rev2Pos') ;  

gp = zeros(1,NPoints) ;
gd = zeros(1,NPoints) ;
gc = zeros(1,NPoints) ;
for nExp = 1: NPoints
    next = strriv(nExp) ; 
    % Drive 
    gd(nExp)    = next.a11 * exp(sqrt(-1) * next.p11 ) * sqrt(next.a12 / next.a11) * exp(sqrt(-1) * 0.5 * mod2piS (next.p12 - next.p11) )   ;  
    % Position 
    gp(nExp)    = next.a21 * exp(sqrt(-1) * next.p21 ) * sqrt(next.a22 / next.a21) * exp(sqrt(-1) * 0.5 * mod2piS (next.p22 - next.p21) )   ;  
    % Current 
    gc(nExp)    = next.a31 * exp(sqrt(-1) * next.p31 ) * sqrt(next.a32 / next.a31) * exp(sqrt(-1) * 0.5 * mod2piS (next.p32 - next.p31) )   ;  
end
% Plant: Current command to position 
g = gp ./ gd ;
% figure(101) ;
% subplot( 2,1,1) ; 
[logamp,phdeg]  = G2DbDeg(g,-180) ; 

% Plant: Current command to current
gcc = gc ./ gd ;
[clogamp,cphdeg]  = G2DbDeg(gcc,0) ; 

% logamp = 20 * log10(abs(g)); 
figure(40); clf
subplot( 2,1,1) ; 
semilogx( fout , logamp ) ; grid on
xlabel('Log amplitude of position / (current cmd)') ; 
ylabel('dB') ; 

subplot( 2,1,2) ; 
semilogx( fout ,  phdeg ) ; grid on
xlabel('Phase of position / (current cmd)') ; 
ylabel('deg') ; 

figure(41); clf
subplot( 2,1,1) ; 
semilogx( fout , clogamp ) ; grid on
xlabel('Log amplitude of current loop') ; 
ylabel('dB') ; 
subplot( 2,1,2) ; 
semilogx( fout ,  cphdeg ) ; grid on
xlabel('Phase of current loop') ;
ylabel('deg') ; 

fp = struct('f',fout,'g',g,'logamp',logamp,'phdeg',phdeg ,'Invar',SignalNames{1},'Outvar',SignalNames{2},...
    'Rev2Pos',Rev2Pos,'Ts',Ts,'gcc',gcc) ; 

save fpout fp
[file,path] = uiputfile('*.mat','Save identification file','..\IdentResult\');
save([path,file] ,'fp')  ;



