
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

ThetaEst    = mod(r.ThetaElect - 0.25 ,1 ) ; 
I1 = r.SLessDataI0 ; 
I2 = r.SLessDataI1 ; 
I3 = r.SLessDataI2 ;  


SLPars = struct ( 'PhiM', 0.15,'Ld',5e-4,'Lq',5e-4,'R',0.13) ; 

s = sin(ThetaEst * 2 * pi );
c = cos(ThetaEst * 2 * pi);
    IAlpha = 0.666666  * (I1 - 0.5 * (I2 + I3));
    IBeta = 0.577350269189626  * (I2 - I3);
        
Id = c .* IAlpha + s .* IBeta;
Iq = -s .* IAlpha + c .* IBeta;

figure(100) ; plot( t , IAlpha , t , IBeta ) ; legend('A','B')
figure(101) ; 
subplot(2,1,1) ; 
plot( t , Iq ); legend('Iq') ; 
subplot(2,1,2) ; 
plot( t , Id ); legend('Id') ; 
    
