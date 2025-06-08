function [Kp,Ki,Awu] = CurrentController(LLL,RLL,Ts,BwHz, NormZero )
% Get a simple controller for a given inertia 
% Arguments: 
% BwHz : Desired 0db in Hz
% LLL  : Nominal inductance , line to line 
% Ts   : Sampling time 
% RLL  : rotor resistance , Line to line 
% NormZero : The place of the zero relative to the BW 
% Returns: 
% Kp,Ki : Proportional and integral gains for speed control 
% Awu   : Antiwindup for integrator 
 
if nargin < 5 
    NormZero = 1/3 ; 
end 

R = RLL / 2 ; 
L = LLL / 3 ; 

% bw in rad/sec 
bw = BwHz * 2 * pi ; 

% Controller is simple PI (unnormalized) 
con   = tf ([1 , -exp(-bw*Ts * NormZero)], [1,-1], Ts  ) ; 

% motor = resistance +  inductance 
motor = tf(1,[L , R] ) ;
% The plant was with ZOH, so this is PWM,
motor = c2d(motor,Ts,'zoh') ;

% we need however half Ts more delay for calculation time 
motor  = motor * tf( [1,1] * 0.5 , [1,0] , Ts ) ; 

% Set loop gain to 0db at BW 
con = con / abs(freqresp( con * motor , bw )) ; 

% Normalize the numerator so that the denominator becomes automativally [1,-1]  
Con_numer = con.num{1} / con.den{1}(1) ; 

% Transform to Kp/Ki. Note that Kp is immediate, integral update shall occur after use
Kp = Con_numer(1) ; 
Ki = sum ( Con_numer) / Ts ; 
Awu = 1/Kp;

% Simulation of the controller 
mn = motor.num{1} ; 
md = motor.den{1} ; 
ms = 0  ;
int = 0 ; 
us = [0,0] ; 
t = [0:Ts:5/BwHz] ; 
out = t * 0 ; 
v   = t * 0 ; 
n = length(t); 
vmax = 4 ; 
ref = 1 ; 
for cnt = 1:n 
    ms = -md(2) * ms + mn(2) * us(1) + mn(3) * us(2) ; 
    e  = ref - ms ; 
    vd = int + e * Kp ;
    v(cnt) = max( min( vd , vmax) , -vmax) ; 
    us = [ v(cnt) , us(1)]; 
    int = int + ( e + (v(cnt) - vd)*Awu  ) * Ki * Ts ; 
    out(cnt) = ms ; 
end 

figure(10) ; clf ;
subplot(2,1,1); 
plot( t, out ); 
subplot(2,1,2); 
plot( t, v ); 




