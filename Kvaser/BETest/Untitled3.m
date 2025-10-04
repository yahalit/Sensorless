a = load('SigRecSave.mat') ; 
r = a.RecStr ; 
t = r.t ; 

%              t: [1×558 double]
%             Ts: 8.0000e-04
%     ThetaElect: [1×558 double]
%             Iq: [1×558 double]
%             Id: [1×558 double]
%      PhaseCur0: [1×558 double]
%      PhaseCur1: [1×558 double]
%      PhaseCur2: [1×558 double]

I1 = r.PhaseCur0 ; 
I2 = r.PhaseCur2 ; 
I3 = r.PhaseCur1 ; 

    IAlpha = 0.666666  * (I1 - 0.5 * (I2 + I3));
    IBeta = 0.577350269189626  * (I2 - I3);
figure(200) ; clf
plot( t , IAlpha , t , IBeta ) ; legend('A','B') ; 
tht    = r.ThetaElect * 2 * pi ; 
%thtEst = mod( r.ThetaElect -0.25 , 1 ) * 2 * pi ; 

thtEst =  r.SlessThetaEst * 2 * pi ; 
s = sin(tht) ; 
c = cos(tht ) ; 
s2 = sin(thtEst) ; 
c2 = cos(thtEst ) ; 
q =  c .* IAlpha + s .* IBeta; 
d2 =  c2 .* IAlpha + s2 .* IBeta; 
d = s .* IAlpha - c .* IBeta ; 
q2 = -s2 .* IAlpha + c2 .* IBeta ; 


figure(201) ; clf
subplot( 2,1,1) ; 
plot ( t , q , t , r.Iq + 0.1) ; 
subplot( 2,1,2) ; 
plot ( t ,d , t , r.Id + 0.1) ; 

