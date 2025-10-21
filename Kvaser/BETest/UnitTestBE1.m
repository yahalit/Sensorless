% UnitTestBE1: This unit test tests that all the voltages and currents are as planned 
% Currents Alpha and Beta are sinusoidal, and PWM and voltage measurements yield acceptable similarity 
% Run SetSpeed, when speed reaches steady state run this test 

CanId = TargetCanId  ; 

TakeNewRecords = 0 ; 
RecStruct.Sync2C = 1 ; 
% RecStruct.Gap = 1; 
% RecStruct.Len = 600; 
RecTime = 0.5 ; 

MatFileName = 'UnitTestBE1b.mat' ;

if TakeNewRecords
% Bring the records 
    UseBlockDownload = 1 ;  %#ok<UNRCH>
    owner = FetchObj([hex2dec('2000'),111],DataType.long,'Get recorder owner') ; 
    vmax  = FetchObj([hex2dec('2225'),38],DataType.float,'Get Profiler vmax') ; 
    RecAction = struct( 'InitRec' ,  1, 'BringRec' , 1 ,'ProgRec' , 1 ,'Struct' , 1  ,'BlockUpLoad',UseBlockDownload,'T',RecTime ) ; 
    [~,~,r0] = Recorder({'SlessThetaEst','SLessDataI0','SLessDataI1','SLessDataI2',...
         'SLessDataV0','SLessDataV1','SLessDataV2',...
         'Vdc','PwmA','PwmB','PwmC','ThetaElect','SlessOmegaHat','SlessFluxErrIntA','SlessFluxErrIntB'  } , RecStruct , RecAction   );
    PhiM = GetFloatPar('SLPars.PhiM');
    Ld0  = GetFloatPar('SLPars.Ld0');
    Lq0  = GetFloatPar('SLPars.Lq0');
    R    = GetFloatPar('SLPars.R');
    PwmFrame = FetchObj([hex2dec('2220'),50],DataType.short,'PwmFrame')  ; % PwmFrame

    save(MatFileName, 'r0', 'PhiM', 'Ld0', 'Lq0', 'R', 'vmax','PwmFrame') ; 
end

a = load(MatFileName) ; 
r = a.r0 ; 
t = r.t ; 
PwmInPeriod = 2 * PwmFrame ; 


ThetaEst    = r.SlessThetaEst ; 
I1 = r.SLessDataI0 ; 
I2 = r.SLessDataI1 ; 
I3 = r.SLessDataI2 ;  

V1 = r.SLessDataV0 ; 
V2 = r.SLessDataV1 ; 
V3 = r.SLessDataV2 ;  



SLPars = struct ( 'PhiM', PhiM,'Ld',Ld0,'Lq',Lq0,'R',R) ; 

s = sin(ThetaEst * 2 * pi );
c = cos(ThetaEst * 2 * pi);
    IAlpha = 0.666666  * (I1 - 0.5 * (I2 + I3));
    IBeta = 0.577350269189626  * (I2 - I3);
    
VAlpha = 0.666666  * (V1 - 0.5 * (V2 + V3));
VBeta = 0.577350269189626  * (V2 - V3);
    
Id = c .* IAlpha + s .* IBeta;
Iq = -s .* IAlpha + c .* IBeta;

    

    figure(1) ; 
    subplot(3,1,1) ; 
    plot( t , I1 , t , I2 , t , I3 ) ; legend( '1','2','3')  ; 
    grid on 
    title( 'Motor phase currents') ; 
    
    subplot(3,1,2) ; 
    plot( t , IAlpha , t , IBeta ) ; legend( 'a','b' )  ; 
    grid on 
    title( 'Motor currents at the A/B stationary frame') ; 
    
    subplot(3,1,3) ; 
    plot( t , Id , t , Iq ) ; legend( 'd','q' )  ; 
    title( 'D and Q currents by the observer''s angle estimate') ; 
    
  % Get voltage comparison 
  figure(2)
  subplot(3,1,1) ; 
  plot( t , ( r.PwmA - PwmFrame)  .* r.Vdc / PwmInPeriod , t , V1 ) ; legend('PWM','Measured phase') ; 
  title( 'Compare PWMA with voltage measurement A') ; 
  subplot(3,1,2) ; 
  plot( t , ( r.PwmC - PwmFrame)  .* r.Vdc / PwmInPeriod , t , V2 ) ; legend('PWM','Measured phase') ; 
  title( 'Compare PWMC with voltage measurement B') ; 
  subplot(3,1,3) ; 
  plot( t , ( r.PwmB - PwmFrame)  .* r.Vdc / PwmInPeriod , t , V3 ) ; legend('PWM','Measured phase') ; 
  title( 'Compare PWMB with voltage measurement C') ; 
    
    % Get the extended flux 
%     SLessState.Phida = SLPars.PhiM + (SLPars.Ld - SLPars.Lq) .* Id;
%    
%     % These are the fluxes; they should equal Va - Ia * R neglecting L for small f 
%     w = vmax * 2 * pi ; 
%     dIAlphadt = w * IBeta ; 
%     dIBetadt = -w * IAlpha ; 
%     
%     % Ideal rotor fluxes as predicted by model 
%     dFluxA1 =  s .* SLessState.Phida * w; % - FluxIntA;
%     dFluxB1 =  -c .* SLessState.Phida * w ; %- FluxIntB;  % Note inversion 
% 
%     % Voltage as predicted by motor equations 
%     dFluxA2 =  VAlpha - IAlpha .* SLPars.R - dIAlphadt * SLPars.Lq ; % - FluxIntA;
%     dFluxB2 =  VBeta - IBeta .* SLPars.R  - dIBetadt * SLPars.Lq ; %- FluxIntB;
%     
%     figure(3) ; 
%     subplot(3,1,1) ; 
%     plot( t , dFluxA1 , t , dFluxA2   ) ; legend( 'A magnet','A voltage')  ; 
%     subplot(3,1,2) ; 
%     plot( t , dFluxB1 , t , dFluxB2   ) ; legend( 'B magnet','B voltage')  ; 
