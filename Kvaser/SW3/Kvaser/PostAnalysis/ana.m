whCntRad = 722.0860 ; 
% x0 = 6.0 ; 
tQrDelay = 0.46 ; 

r = load('Recs20cmsec.mat');
% r = load('Recs30cmsec.mat');
% r = load('Recs40cmsec.mat');
% r = load('Recs50cmsec.mat');
r = r.Recs ; 

% 
%                    t: [1×488 double]
%                   Ts: 0.0410
%            UsecTimer: [1×488 double]
%         RawPosTStamp: [1×488 double]
%              RawSEst: [1×488 double]
%     HackedPosAzimuth: [1×488 double]
%       RawPosReport_0: [1×488 double]
%       RawPosReport_1: [1×488 double]
%         RWheelEncPos: [1×488 double]
%       RWheelEncSpeed: [1×488 double]
% Show results 
Qrx = r.RawPosReport_0 / 10000 ; 
Odo =  -0.1* ( r.RWheelEncPos - r.RWheelEncPos(1) ) / whCntRad + Qrx(1) ; 
t   = (r.UsecTimer - r.UsecTimer(1)) * 1e-6 ; 
tQr1 = (r.RawPosTStamp - r.UsecTimer(1)) * 1e-6 ; 
tQr =  tQr1 - tQrDelay; 
figure(1); clf 
plot( t ,Qrx , t , Odo , 'r', tQr1 , Qrx , '+m', tQr , Qrx , 'xb'); legend('Qr0','Position (Encoder) ','QR report','Qr report corrected'); 
return
% figure(1) ; clf
% plot( r.t , r.UsecTimer, r.t , r.RawPosTStamp); legend('Global time','QR relevance time'); 
% figure(2) ; clf
% subplot( 3,1,1) ; 
% plot( r.t , r.RawSEst); legend('Length in segment');
% subplot( 3,1,2) ; 
% plot( t , Odo , tQr , Qrx ); legend('Position (Encoder) ','QR report'); 
% subplot( 3,1,3) ; 
% plot( r.t , r.RWheelEncSpeed); legend('Speed (Encoder) '); 
% figure(3) ; clf
% subplot( 2,1,1) ; 
% plot( r.t , r.RawPosReport_0); legend('x reading of qr'); 
% subplot( 2,1,2) ; 
% plot( r.t , r.RawPosReport_1); legend('y reading of qr'); 



