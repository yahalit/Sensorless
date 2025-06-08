% CurIdentRslt1.mat             CurIdentRslt_Neck_321Hz.mat   CurIdentRslt_Neck_836Hz.mat   
% CurIdentRslt2.mat             CurIdentRslt_Neck_394Hz.mat   CurIdentRslt_Neck_910Hz.mat   
% CurIdentRslt3.mat             CurIdentRslt_Neck_468Hz.mat   CurIdentRslt_Neck_984Hz.mat   
% CurIdentRslt_Neck_100Hz.mat   CurIdentRslt_Neck_542Hz.mat   ProjSelectOutput.mat          
% CurIdentRslt_Neck_1057Hz.mat  CurIdentRslt_Neck_615Hz.mat   SigRecSave.mat                
% CurIdentRslt_Neck_173Hz.mat   CurIdentRslt_Neck_689Hz.mat   
% CurIdentRslt_Neck_247Hz.mat   CurIdentRslt_Neck_763Hz.mat  

%             t: [0 1.5000e-04 3.0000e-04 4.5000e-04 6.0000e-04 7.5000e-04 9.0000e-04 0.0010 0.0012 0.0013 0.0015 … ]
%            Ts: 1.5000e-04
%     PhaseCur0: [-3.1602 -3.0851 -2.9454 -2.7735 -2.5157 -2.2472 -1.9786 -1.6886 -1.4200 -1.1622 -0.8399 -0.4962 … ]
%     PhaseCur1: [1.5075 1.4324 1.4109 1.3786 1.2820 1.2390 1.1316 1.0241 0.8952 0.7771 0.6911 0.6052 0.4226 0.2615 … ]
%     PhaseCur2: [1.6076 1.5216 1.4249 1.3390 1.2208 1.0919 0.9308 0.7482 0.5656 0.4044 0.2433 0.1359 -0.0252 … ]
%          PwmA: [1.3145e+03 1.3198e+03 1.3258e+03 1.3323e+03 1.3394e+03 1.3469e+03 1.3546e+03 1.3631e+03 … ]
%          PwmB: [1.4675e+03 1.4622e+03 1.4562e+03 1.4497e+03 1.4426e+03 1.4351e+03 1.4274e+03 1.4189e+03 … ]
%          PwmC: [1.4675e+03 1.4622e+03 1.4562e+03 1.4497e+03 1.4426e+03 1.4351e+03 1.4274e+03 1.4189e+03 … ]
%           vqd: [0.8817 0.8202 0.7515 0.6760 0.5946 0.5079 0.4167 0.3217 0.2240 0.1242 0.0233 -0.0777 -0.1781 … ]
%           vdd: [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 … ]
%            va: [102.0352 94.9200 86.9623 78.2327 68.8087 58.7740 48.5228 37.2332 25.9183 14.3734 2.7009 -8.9956 … ]
%            vb: [-51.0176 -47.4600 -43.4811 -39.1163 -34.4044 -29.3870 -24.2614 -18.6166 -12.9592 -7.1867 -1.3504 … ]
%            vc: [-51.0176 -47.4600 -43.4811 -39.1163 -34.4044 -29.3870 -24.2614 -18.6166 -12.9592 -7.1867 -1.3504 … ]
%            Iq: [-3.1452 -3.0414 -2.9089 -2.7549 -2.5114 -2.2751 -2.0065 -1.7165 -1.4336 -1.1686 -0.8714 -0.5778 … ]

Axis = 'Neck' ; 
FVec = [ 100         115         132         153         176         203         235         ...
        271         312         360         415         479         553 ...
         637         735         848         978        1127        1300        1500] ; 
nf = length(FVec) ;
pwmframe = 3000 ;
curinvert = -1 ; 

g = FVec * 0 ; 
a = FVec * 0 ; 
p = FVec * 0 ; 


for cnt = 1:nf
    nextF = FVec(cnt) ; 
    r = load(['.\NeckCurrentId\CurIdentRslt_',Axis,'_',num2str(nextF),'Hz.mat']) ; 
    r = r.r ;
    r.vdc = 26 + r.t * 0 ; 
%     figure(cnt) ; clf ; subplot( 2,1,1)
%     plot( r.t , r.PhaseCur0 , r.t , r.Iq  ,'g')
    vn = ( r.va + r.vb + r.vc) / 3 ; 
    va = r.va - vn ; 
    vb = r.vb - vn ; 
    vc = r.vc - vn ; 
%     subplot( 2,1,2) ; 
%     plot( r.t , r.vqd , r.t , r.va .* r.vdc  / pwmframe ,'.') ;
    [g(cnt) , a(cnt) ,p(cnt) ] = fitsin( nextF , r.t  , r.vqd , r.Iq * curinvert  ) ; % , cnt + 100 ) ; 
    x = 1 ; 
end 
p = unwrap(p) ;
if ( p(1) < -pi)
    p = p + 2 * pi ; 
end 
if ( p(1) > -pi)
    p = p - 2 * pi ; 
end 
figure(200);
subplot(2,1,1); 
semilogx( FVec , 20 * log10(a) ,'-x'); 
subplot(2,1,2); 
semilogx( FVec , p * 180 / pi  ,'-x'); 

w = FVec(:) * 2 * pi ; 
global g
global w 

rng default % for reproducibility
opts = optimoptions(@lsqnonlin,'Display','off');

% x0 = [0.25 , 1.6e-4 , 60e-6 ] % arbitrary initial guess
% [vestimated,resnorm,residuals,exitflag,output] = lsqnonlin(@RLFit,x0);
% vestimated,resnorm,exitflag,output.firstorderopt

r = 0.28; 
l = r /( 2 * pi * 300 ) ;
vestimated = [r,l,60e-6] ;
g1 = exp(-sqrt(-1) * vestimated(3) * w(:)) ./ ( vestimated(1) + sqrt(-1) * vestimated(2) * w ); 

figure(200);
subplot(2,1,1); 
semilogx( FVec , 20 * log10(a) ,'-x',FVec,20*log10( abs(g1) ),'d-');  grid on 
subplot(2,1,2); 
semilogx( FVec , p * 180 / pi  ,'-x',FVec,180/pi*angle(g1),'d-'); grid on 

% Calculate current controller 
sys = tf( 1 , [l, r]) ; 
Ts  = 50e-6 ; 
dsys = c2d(sys,Ts,'zoh') * tf([0 1],[1,0],Ts) ; 

bw = 1000 * 2 * pi ; 
wdes = logspace( log10(bw) - 2 , log10(0.7 *  pi/Ts) , 300 ) ; 
g = freqresp( dsys , wdes ) ; 
ctl = c2d( tf ([1,bw/3],[1,0]),Ts ) / abs( freqresp( dsys , bw ) ) ; 
bode( ctl * dsys , wdes ) ; grid on 

d = ctl.den{1} ;
d = d(1) ; 
ctl.den{1} = ctl.den{1} / d ; 
ctl.num{1} = ctl.num{1} / d ; 

n  = ctl.num{1} ; 
kp = -n(2) ; 
ki = (n(1) + n(2))/Ts ; 









