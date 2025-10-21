% UnitTestBE2: This unit test is for the flux equations 
% Run SetSpeed, when speed reaches steady state run this test 

CanId = TargetCanId  ; 

TakeNewRecords = 0 ; 
RecStruct.Sync2C = 1 ; 
% RecStruct.Gap = 1; 
% RecStruct.Len = 600; 
RecTime = 0.5 ; 

MatFileName = 'UnitTestBE2a.mat' ;
MatFileName = 'TryStepperRun1.mat' ;

if TakeNewRecords
% Bring the records 
    UseBlockDownload = 1 ;  %#ok<UNRCH>
    owner = FetchObj([hex2dec('2000'),111],DataType.long,'Get recorder owner') ; 
    vmax  = FetchObj([hex2dec('2225'),38],DataType.float,'Get Profiler vmax') ; 
    RecAction = struct( 'InitRec' ,  1, 'BringRec' , 1 ,'ProgRec' , 1 ,'Struct' , 1  ,'BlockUpLoad',UseBlockDownload,'T',RecTime ) ; 
    [~,~,r0] = Recorder({'SlessThetaEst','SLessDataI0','SLessDataI1','SLessDataI2',...
         'SLessDataV0','SLessDataV1','SLessDataV2',...
         'Vdc','ThetaElect','SlessOmegaHat','SlessFluxErrIntA','SlessFluxErrIntB'  } , RecStruct , RecAction   );
    PhiM = GetFloatPar('SLPars.PhiM');
    Ld0  = GetFloatPar('SLPars.Ld0');
    Lq0  = GetFloatPar('SLPars.Lq0');
    R    = GetFloatPar('SLPars.R');

    PwmFrame = FetchObj([hex2dec('2220'),50],DataType.short,'PwmFrame')  ; % PwmFrame
    save(MatFileName, 'r0', 'PhiM', 'Ld0', 'Lq0', 'R', 'vmax','PwmFrame') ; 
end
 a = load(MatFileName) ; 
try 
r = a.r0 ; 
catch 
r = a.RecStr ; 
end 

t = r.t ; 


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

% Estimate of real parameters 
% Line to line values 
L_LL = 5e-3 ; 
R_LL = 0.165 ; % Including cables 

% Get Y-branch values 
L  = L_LL / 3 ; % Assuming M = -1/2
R  = R_LL / 2 ; 
    

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
    
    
    % Flux integrals omitting inductive energy 
    inta = cumsum( VAlpha - R * IAlpha ) * r.Ts ;
    intb = cumsum( VBeta  - R * IBeta  ) * r.Ts ;
        
    % Flux integrals considering inductive energy 
    intaL = inta - L * IAlpha ; 
    intbL = intb - L * IBeta ; 
    
    figure(50) ; 
    plot(  t , inta , t, intaL ,  t , intb , t, intbL) ; legend('a','al','b','bl') 
    grid on 
    title('Flux integrals for A and for B, with and without deducing inductive energy') ; 
    
    figure(51) ; 
    plot( t , sqrt(intaL.^2 + intbL.^2) , t , sqrt(inta.^2 + intb.^2) ); legend('Deduced EL','Full')     
    grid on 
    title('Rotor Flux modulus for A and B combined, with deduced EL should be constant') ; 
    
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
