% BitzerBEmfForm: Get the EMF forms by the recoil with zero current after pressure buildup
LoadFile = 0 ; 
if ( LoadFile )
    x = load('SigRecSave20_1.mat');  %#ok<UNRCH>
    rx = x.RecStr ; 

    %                 t: [1×2047 double]
    %                Ts: 4.0000e-04
    %        ThetaElect: [1×2047 double]
    %       VarMirrorVa: [1×2047 double]
    %       VarMirrorVb: [1×2047 double]
    %       VarMirrorVc: [1×2047 double]
    %       VarMirrorIa: [1×2047 double]
    %       VarMirrorIb: [1×2047 double]
    %       VarMirrorIc: [1×2047 double]
    %     SixThetaRawPU: [1×2047 double]
    tRange = [0.365, 0.404] ; 
    % tRange = [0, 5] ; 
    r = GetRecTimeRange(rx,tRange) ; 
    r = InterpolateSteps( r ,'ThetaElect', 3*r.Ts ) ;
else
    r = InterpolateSteps( r ,'ThetaElect', 1.3e-3 ) ;
end


t = r.t ; 
nplot = 3 ; 
nfig = 1 ; 
figure(nfig) ; clf ; 
subplot(nplot,1,1) ;
plot ( t , r.VarMirrorIa,t , r.VarMirrorIb , t  , r.VarMirrorIc ) ;
subplot(nplot,1,2) ;
vn =  ( r.VarMirrorVa +  r.VarMirrorVb + r.VarMirrorVc) / 3 ; 

R = 0.05 ;
va = r.VarMirrorVa - vn - R * r.VarMirrorIa; 
vb =  (r.VarMirrorVc - r.VarMirrorVb - R * (r.VarMirrorIc - r.VarMirrorIb)  ) / sqrt(3) ; 
plot ( t , r.VarMirrorVa - vn ,t , r.VarMirrorVb - vn  , t  , r.VarMirrorVc - vn , t , va , t , vb ) ;legend( 'U','V','W','A','B') 
subplot(nplot,1,3) ;
plot ( t , r.ThetaElect ) ;
figure(2) ; 
subplot(3,1,1) ;
tht = unwrap(atan2(vb,va) ) / (2*pi) +0.027 * sin( 6 * 20 * 2 * pi * (t-0.5e-3) ) ;
p = polyfit( t , tht , 2 ) ;  
plot( t , tht , t , polyval( p,t) ) ; 
title('Raw angle and fit') ; 
subplot(3,1,2) ;
plot( t , tht  - polyval( p,t) ) ; 
title('Fit error') ; grid on

subplot(3,1,3) ;
r.Omega = ddt(tht ,t)   ; 
rs = IntegrateOverSteps( r ,'ThetaElect' ) ; 

plot( t , r.Omega , rs.t , rs.Omega ) ; 
title('Raw Omega and step-wise') ; 

