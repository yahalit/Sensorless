% Test the calculation of the sensorless filter

tht = 0:0.01:pi/2 ;
s = sin(tht) ; c = cos(tht) ; 
alpha =  0.4 ; beta = -0.7 ; 
d1 = alpha * s + beta * c ; 
q1 = alpha * c - beta * s ; 
d2 =  alpha * c + beta * s ; 
q2 = -alpha * s + beta * c ; 

figure(2) ; clf ; 
plot( d1 , q1 , d1(1) , q1(1) , 'x' ) ; 
hold on
plot( d2 , q2 , d2(1) , q2(1),'d' ) ; 
set ( gca , 'xlim',[-1,1] , 'ylim',[-1,1]) ; 
axis square



tht = r.ThetaElect * 2*pi ; 

c = struct('sqrt3',sqrt(3) ) ; 
ClaState = struct('s',sin(tht),'c',cos(tht) ) ; 

    ClaState.c120 = -0.5 * ( ClaState.c + ClaState.s * c.sqrt3 ) ;
    ClaState.c240 = -0.5 * ( ClaState.c - ClaState.s * c.sqrt3 ) ;
    ClaState.s120 = -0.5 * ( ClaState.s - ClaState.c * c.sqrt3 ) ;
    ClaState.s240 = -0.5 * ( ClaState.s + ClaState.c * c.sqrt3 ) ;
    
%     figure(1) ; clf 
%     plot( tht,  ClaState.s120 + 0.1 , tht , sin(tht +2 * pi / 3 )) ;
PhaseCur0 = r.SLessDataI0 ; 
PhaseCur1 = r.SLessDataI1 ; 
PhaseCur2 = r.SLessDataI2 ; 

ClaState.Iq = 2/3*(PhaseCur0 .* ClaState.c + PhaseCur1 .* ClaState.c120 + PhaseCur2 .* ClaState.c240) ;
ClaState.Id = 2/3*(PhaseCur0 .* ClaState.s + PhaseCur1 .* ClaState.s120 + PhaseCur2 .* ClaState.s240) ;

IAlpha = 0.666666  * (PhaseCur0 - 0.5  * (PhaseCur1 + PhaseCur2));
IBeta  = 0.577350269189626  * (PhaseCur1 - PhaseCur2);
Id2 =   ClaState.s  .* IAlpha + ClaState.c  .* IBeta ; 
Iq2 =   ClaState.c  .* IAlpha - ClaState.s  .* IBeta ; 

tht2 = r.SlessThetaEst * 2*pi ; 
c2 = cos(tht2) ; s2 = sin(tht2) ; 
ido =  c2  .* IAlpha - s2  .* IBeta ; 
iqo =  s2  .* IAlpha + c2  .* IBeta ; 


figure(1) ; clf 
subplot(3,1,1) ; 
plot( tht , ClaState.Iq , tht , ClaState.Id ) 
subplot(3,1,2) ; 
plot( tht , Iq2 , tht , Id2 ) 
subplot(3,1,3) ; 
plot( tht , iqo , tht , ido ) 

