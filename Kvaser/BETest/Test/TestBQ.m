%      { .ind = 18 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.qf0.PBw , .lower =  1.0f,.upper = 1000000.0f, .defaultVal = 40.0f },// :qf0PBw [Control] {Filter 0 parameter Pole BW}
%      { .ind = 19 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.qf0.PXi , .lower =  0.05f,.upper = 10.0f, .defaultVal = 0.5f },// :qf0PXi [Control] {Filter 0 parameter Pole BW}
%      { .ind = 20 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.qf0.ZBw , .lower =  1.0f,.upper = 1000000.0f, .defaultVal = 40.0f },// :qf0ZBw [Control] {Filter 0 parameter zero BW}
%      { .ind = 21 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.qf0.ZXi , .lower =  0.02f,.upper = 10.0f, .defaultVal = 0.5f },// :qf0ZXi [Control] {Filter 0 parameter zero BW}
%      { .ind = 22 ,  .Flags = 0 , .ptr = (float*) &ControlPars.qf0.Cfg.ul , .lower =  0.0f,.upper = 127.0f, .defaultVal = 0.0f },// :qf0Cfg [Control] {Filter 0 configuration}
%      { .ind = 23 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.qf1.PBw , .lower =  1.0f,.upper = 1000000.0f, .defaultVal = 60.0f },// :qf1PBw [Control] {Filter 1 parameter Pole BW}
%      { .ind = 24 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.qf1.PXi , .lower =  0.05f,.upper = 10.0f, .defaultVal = 0.5f },// :qf1PXi [Control] {Filter 1 parameter Pole BW}
%      { .ind = 25 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.qf1.ZBw , .lower =  1.0f,.upper = 1000000.0f, .defaultVal = 60.0f },// :qf1ZBw [Control] {Filter 1 parameter zero BW}
%      { .ind = 26 ,  .Flags = CFG_FLOAT , .ptr = (float*) &ControlPars.qf1.ZXi , .lower =  0.02f,.upper = 10.0f, .defaultVal = 0.5f },// :qf1ZXi [Control] {Filter 1 parameter zero xi}
%      { .ind = 27 ,  .Flags = 0 , .ptr = (float*) &ControlPars.qf1.Cfg.ul , .lower =  0.0f,.upper = 127.0f, .defaultVal = 0.0f },// :qf1Cfg [Control] {Filter 1 Configuration}
Ts = 50e-6 ; 
NPoints = 10 ; 
ExpAmp = 2 ; 
[fout,Ncyc,Ntake,f1] = FPicker( 10 , 500 , NPoints, 3 , Ts ) ; 

SetIdentSignals('TRefOut','fDebug0','qf0out') ; 
wnp0  = 100 ; 
xip0 = 0.2 ; 
wnz0  = 80 ; 
xiz0  = 0.45 ; 
pi2   = pi * 2 ; 
sys1  = tf( 1 , [1, wnp0 * pi2 * xip0 * 2 , wnp0^2 * pi2^2]) ; 
sys2  = tf( 1 , [1, wnz0 * pi2 * xiz0 * 2 , wnz0^2 * pi2^2]) ; 
sys1d = c2d(sys1 , Ts ); d1d = sys1d.den{1} ; d1d = d1d / d1d(1); 
sys2d = c2d(sys2 , Ts ); d2d = sys2d.den{1} ; d2d = d2d / d2d(1);  


sysd  = tf( d2d * sum(d1d) / sum(d2d) , d1d , Ts ); 



SetCfgPar('qf0PBw',wnp0)   ; 
SetCfgPar('qf0PXi',xip0 )   ; 
SetCfgPar('qf0ZBw',wnz0)   ; 
SetCfgPar('qf0ZXi',xiz0)   ; 
SetCfgPar('qf0Cfg',1 )   ; 
SetCfgPar('qf1Cfg',0 )   ; 
SetSignal( 'fDebug1' , 100 ) ; % Set the limiter far 

AllowRefGenInMotorOff(1);
SetTestBiquad(1) ; 
TGenStr = struct('Gen','T','Type',RecStruct.Enums.SigRefTypes.E_S_Sine,'On',0,...
    'Dc',0,'Amp',ExpAmp,'F',fout(1),'Duty',0.5,'bAngleSpeed',0)  ;
SetRefGen(TGenStr) ; 

strriv = [] ; 

for nExp = 1: NPoints

    IdentStr = struct('nCyclesInTake',Ncyc(nExp),'nSamplesForFullTake',Ntake(nExp),'nWaitTakes',20,'nSumTakes',20) ; 
    IdentSetup( IdentStr );

    % Create the basis for the T generator 
    TGenStr = struct('Gen','T','Type',RecStruct.Enums.SigRefTypes.E_S_Sine,'On',1,...
        'Dc',0,'Amp',ExpAmp,'F',fout(nExp),'Duty',0.5,'bAngleSpeed',0)  ;

    % Set the reference mode to debug
    SendObj([hex2dec('2220'),14],RecStruct.Enums.ReferenceModes.E_PosModeDebugGen,DataType.long,'Set reference mode') ;
    SetRefGen(TGenStr,0.3) ; 

    StartFrequencyMeas() ; 
    Time4Cycle = Ts * IdentStr.nSamplesForFullTake * ( 1 + IdentStr.nWaitTakes + 2 * IdentStr.nSumTakes) ; 

    disp(['Frequency: ' , num2str(fout(nExp))   ' :  ', num2str(nExp),' Off: ' num2str(NPoints) , '  Wait: ', num2str(Time4Cycle) ] ) 
    
    pause(Time4Cycle) ; 
    stri = GetIdentData();
    strri = GetIdentRslt(stri);

    strriv = [strriv, strri] ; %#ok<AGROW>     
end 

gp = zeros(1,NPoints) ;
gd = zeros(1,NPoints) ;
for nExp = 1: NPoints
    next = strriv(nExp) ; 
    gd(nExp)    = next.a11 * exp(sqrt(-1) * next.p11 ) * sqrt(next.a12 / next.a11) * exp(sqrt(-1) * 0.5 * mod2piS (next.p12 - next.p11) )   ;  
    gp(nExp)    = next.a21 * exp(sqrt(-1) * next.p21 ) * sqrt(next.a22 / next.a21) * exp(sqrt(-1) * 0.5 * mod2piS (next.p22 - next.p21) )   ;  
end
g = gp ./ gd ;

gtarget = freqresp(sysd,fout*2*pi); 
gtarget = gtarget(:) ; 
figure(101) ;
subplot( 2,1,1) ; 
logamp = 20 * log10(abs(g)); 
semilogx( fout , logamp , fout , 20 * log10(abs(gtarget)),'d'  ) ; legend('Act','Desired') ; grid on
subplot( 2,1,2) ; 
a = angle(g) ;
if ( a(1) > 0 )
    a = a - 2 * pi ; 
end
phdeg = unwrap(a) * 180 / pi; 
at = angle(gtarget) ;
if ( at(1) > 0 )
    at = at - 2 * pi ; 
end
tphdeg = unwrap(at) * 180 / pi; 
semilogx( fout ,  phdeg,fout ,  tphdeg,'d' ) ; legend('Act','Desired') ; grid on 

