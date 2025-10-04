a = load('SigRecSaveE.mat') ; 
r = a.RecStr ; 
t = r.t ; 

R = 0.13 ; 
L = 5e-4 ; 
Ts = r.Ts ; 
%                    t: [1×384 double]
%                   Ts: 0.0016
%          SlessIAlpha: [1×384 double]
%           SlessIBeta: [1×384 double]
%          SlessVAlpha: [1×384 double]
%           SlessVBeta: [1×384 double]
%        SlessFluxIntA: [1×384 double]
%        SlessFluxIntB: [1×384 double]
%        SlessFluxErrA: [1×384 double]
%        SlessFluxErrB: [1×384 double]
%     SlessFluxErrIntA: [1×384 double]
%     SlessFluxErrIntB: [1×384 double]
%          SlessVcompA: [1×384 double]
%          SlessVcompB: [1×384 double]
%          SlessETheta: [1×384 double]
%        SlessOmegaHat: [1×384 double]
%        SlessThetaHat: [1×384 double]
VAnet = r.SlessVAlpha -  R * r.SlessIAlpha ; 
VBnet = r.SlessVBeta  -  R * r.SlessIBeta  ; 

PhiA = cumsum(VAnet * Ts ) - L * r.SlessIAlpha ; 
PhiB = cumsum(VBnet * Ts ) - L * r.SlessIBeta  ;

PhiA = PhiA - (max(PhiA)+min(PhiA))/2; 
PhiB = PhiB - (max(PhiB)+min(PhiB))/2; 


figure(500) ; 
subplot(3,1,1) 
plot( t , PhiA , t, r.SlessFluxIntA- L * r.SlessIAlpha) ; 
subplot(3,1,2) ; 
plot( t, PhiB , t, r.SlessFluxIntB - L * r.SlessIBeta) ;   
subplot( 3,1,3) ;
plot( t, atan2(PhiB,PhiA) , t, atan2(r.SlessFluxIntB- L * r.SlessIBeta,r.SlessFluxIntA- L * r.SlessIAlpha), ...
    t , r.SlessThetaHat * 2 * pi , t , atan2(r.SlessVBeta,r.SlessVAlpha),'.' ) ;   





