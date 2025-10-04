

a = load('SigRecSave.mat') ; 
r = a.RecStr ; 
t = r.t ; 

%                 t: [1×600 double]
%                Ts: 8.0000e-04
%     SlessThetaEst: [1×600 double]
%           SlessId: [1×600 double]
%           SlessIq: [1×600 double]
%       SLessDataI0: [1×600 double]
%       SLessDataI1: [1×600 double]
%       SLessDataI2: [1×600 double]

ThetaEst    = r.SlessThetaEst ; 
I1 = r.SLessDataI0 ; 
I2 = r.SLessDataI1 ; 
I3 = r.SLessDataI2 ;  

V1 = r.SLessDataV0 ; 
V2 = r.SLessDataV1 ; 
V3 = r.SLessDataV2 ;  

SLPars = struct ( 'PhiM', 0.15,'Ld',5e-4,'Lq',5e-4,'R',0.13) ; 

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
    subplot(3,1,2) ; 
    plot( t , IAlpha , t , IBeta ) ; legend( 'a','b' )  ; 
    subplot(3,1,3) ; 
    plot( t , Id , t , Iq ) ; legend( 'd','q' )  ; 
  
    SLessState.Phida = SLPars.PhiM + (SLPars.Ld - SLPars.Lq) .* Id;
    
    % These are the fluxes; they should equal Va - Ia * R neglecting L for small f 
    w = Profiler.vmax * 2 * pi ; 
    dIAlphadt = w * IBeta ; 
    dIBetadt = -w * IAlpha ; 
    
    dFluxA1 =  s .* SLessState.Phida * w; % - FluxIntA;
    dFluxB1 =  -c .* SLessState.Phida * w ; %- FluxIntB;  % Note inversion 

    dFluxA2 =  VAlpha - IAlpha .* SLPars.R - dIAlphadt * SLPars.Lq ; % - FluxIntA;
    dFluxB2 =  VBeta - IBeta .* SLPars.R  - dIBetadt * SLPars.Lq ; %- FluxIntB;
    
    figure(3) ; 
    subplot(3,1,1) ; 
    plot( t , dFluxA1 , t , dFluxA2   ) ; legend( 'A1','B2')  ; 
    subplot(3,1,2) ; 
    plot( t , dFluxB1 , t , dFluxB2   ) ; legend( 'B1','B2')  ; 
