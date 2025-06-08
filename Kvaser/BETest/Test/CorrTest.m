global RecStruct %#ok<GVMIS> 

Ts = 50e-6 ; 
ExpAmp = 2 ; 
nf = 1 ; 
NPoints = 100 ; 
[fout,Ncyc,Ntake,f1] = FPicker( 10 , 1000 , NPoints, 3 , Ts ) ; 

SetIdentSignals('Iq','MotorPos','MotSpeedHz') ; 

strriv = [] ; 

for nExp = 1: NPoints
    
    disp(['Frequency: ' , num2str(fout(nExp))   ' :  ', num2str(nExp),' Off: ' num2str(NPoints) ] ) 

    IdentStr = struct('nCyclesInTake',Ncyc(nExp),'nSamplesForFullTake',Ntake(nExp),'nWaitTakes',2,'nSumTakes',2) ; 
    IdentSetup( IdentStr );
% AllowRefGenInMotorOff(1);

    % Kill the G generator 
    SetRefGen( struct('Gen','G','Type',RecStruct.Enums.SigRefTypes.E_S_Nothing,'On',0) ) ; 
    % Create the basis for the T generator 
    SetRefGen( struct('Gen','T','Type',RecStruct.Enums.SigRefTypes.E_S_Fixed,'On',0) ) ; 
    TGenStr = struct('Gen','T','Type',RecStruct.Enums.SigRefTypes.E_S_Sine,'On',0,...
        'Dc',0,'Amp',ExpAmp,'F',fout(nExp),'Duty',0.5,'bAngleSpeed',0)  ;
    GGenStr = struct('Gen','G','Type',RecStruct.Enums.SigRefTypes.E_S_Sine,'On',0,...
        'Dc',0,'Amp',ExpAmp * 2 ,'F',fout(nExp),'Duty',0.5,'bAngleSpeed',0)  ;

    % Set the reference mode to debug
    SendObj([hex2dec('2220'),14],RecStruct.Enums.ReferenceModes.E_PosModeDebugGen,DataType.long,'Set reference mode') ;
    SetRefGen(TGenStr,0.3) ; 
    SetRefGen(GGenStr) ; 

    StartFrequencyMeas() ; 
    Time4Cycle = Ts * IdentStr.nSamplesForFullTake * ( 1 + IdentStr.nWaitTakes + 2 * IdentStr.nSumTakes) ; 
    
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
figure(101) ;
subplot( 2,1,1) ; 
logamp = 20 * log10(abs(g)); 
semilogx( fout , logamp ) ; grid on
subplot( 2,1,2) ; 
a = angle(g) ;
if ( a(1) > 0 )
    a = a - 2 * pi ; 
end
phdeg = unwrap(a) * 180 / pi; 
semilogx( fout ,  phdeg ) ; grid on
fp = struct('g',g,'logamp',logamp,'phdeg',phdeg ) ; 
save fpout fp




