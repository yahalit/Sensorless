addpath('..\..\Control') ; 


global EPWM1_O_CMPA EPWM1_O_CMPB EPWM2_O_CMPA EPWM2_O_CMPB EPWM3_O_CMPA EPWM3_O_CMPB %#ok<*NUSED> 
global c ClaControlPars ClaState ClaMailIn ClaSimState SinTable %#ok<*GVMIS> 

SinTable = [0.0,     1.950903220161282e-1,     3.826834323650898e-1, ...
          5.555702330196022e-1,     7.071067811865475e-1,     8.314696123025452e-1,...
          9.238795325112867e-1,     9.807852804032304e-1,     1.000000000000000,...
          9.807852804032304e-1,     9.238795325112867e-1,     8.314696123025453e-1,...
          7.071067811865476e-1,     5.555702330196022e-1,     3.826834323650899e-1,...
          1.950903220161286e-1,     1.224646799147353e-16,    -1.950903220161284e-1,...
         -3.826834323650897e-1,    -5.555702330196020e-1,    -7.071067811865475e-1,...
         -8.314696123025452e-1,    -9.238795325112865e-1,    -9.807852804032303e-1,...
         -1.000000000000000e+0,    -9.807852804032304e-1,    -9.238795325112866e-1,...
         -8.314696123025455e-1,    -7.071067811865477e-1,    -5.555702330196022e-1,...
         -3.826834323650904e-1,    -1.950903220161287e-1,    -2.449293598294706e-16,...
          1.950903220161282e-1,     3.826834323650899e-1,     5.555702330196018e-1,...
          7.071067811865474e-1,     8.314696123025452e-1,     9.238795325112865e-1,...
          9.807852804032303e-1,     1.000000000000000e+00,     9.807852804032307e-1,...
          9.238795325112867e-1,     8.314696123025456e-1,     7.071067811865483e-1,...
          5.555702330196023e-1,     3.826834323650905e-1,     1.950903220161280e-1 ] ;


Ts   = 5e-5 ; 
LLL  = 1e-3 ; 
RLL  = 0.17 ; 
KErmsLL = 0.1  ; 
Rphase = RLL / 2 ; 
Lphase = LLL / 3  ;
fcpu = 120e6 ; 
frame = Ts * fcpu / 2 ; 
tAnalogSamp = 1.5e-6 ; 
pwmin = tAnalogSamp * fcpu ; 

AmpFull = 30 ; 

EPWM1_O_CMPA = frame/ 2 ; 
EPWM1_O_CMPB = frame/ 2 ; 
EPWM2_O_CMPA = frame/ 2 ; 
EPWM2_O_CMPB = frame/ 2 ; 
EPWM3_O_CMPA = frame/ 2 ; 
EPWM3_O_CMPB = frame/ 2 ; 

c = struct( 'TwoThirds' , 2/3,'OneOverTwoPi',1/(2*pi),'TwoPi',pi*2,'OneOver3GoodBehavior',1/3,'piOver32',pi/32,'sqrt3',sqrt(3)); 

CurrentControl = struct('Error_q',0,'Error_d',0,'Iq',0,'Id',0,'vpre_q',0,'vpre_d',0,'CurrentCommandFiltered',0,'Int_q',0,'Int_d',0,'CurrentCommand',10,...
    'CurrentCommandSlopeLimited',0,'CurrentCmdFilterState0',0,'CurrentCmdFilterState1',0) ; 

npp = 4 ; 
ClaControlPars = struct('Ke',0.115,'KpCur', 2.5692,'KiCur',6.0678e+03,'KAWUCur',0.3892,'OneOverPP',1/npp,'nPolePairs',npp,'VectorSatFac',0.9,...
    'Bit2Amp',AmpFull/2048,'MaxCurCmdDdt',10000000,'CurrentRefFiltA0', 0 ,'CurrentRefFiltA1',0 ) ; 
%    'Bit2Amp',AmpFull/2048,'MaxCurCmdDdt',10000,'CurrentRefFiltA0',-0.80 ,'CurrentRefFiltA1',0 ) ; 
%    'Bit2Amp',AmpFull/2048,'MaxCurCmdDdt',10000,'CurrentRefFiltA0',-1.745485231989130 ,'CurrentRefFiltA1',0.776790921324546 ) ; 

ClaControlPars.Amp2Bit = 1/ClaControlPars.Bit2Amp ; 
ClaControlPars.CurrentRefFiltB = 1 + ClaControlPars.CurrentRefFiltA1 + ClaControlPars.CurrentRefFiltA0; 

Analogs = struct('Vdc',38,'PhaseCurAdc',[0,0,0]) ; 

ClaState = struct('MotorOn',1,'Vsat',0.9,'SaturationFac4AWU',0,'q2v1',0,'q2v2',0,'d2v1',0,'d2v2',0,'SpeedRadSec',0,...
	'vqd',0,'vdd',0,'va',0,'vb',0,'vc',0,'PwmMinB',pwmin,'PwmMin',0,'PwmOffset',(frame-pwmin)/2,'PwmMax',frame+100,'PwmFac',1,'PwmFrame',frame,'InvPwmFrame',1/frame,...
	'c',1,'c120',-0.5,'c240',-0.5,'s',0,'s120',sqrt(3)/2,'s240',-sqrt(3)/2,...
	'CurrentControl',CurrentControl,'Analogs',Analogs) ;

	
ClaMailIn = struct('Ts',Ts,'SimVdc',38,'IaOffset',0,'IbOffset',0,'IcOffset',0,'ThetaElect',0,...
    'SimdT',Ts,'SimKe',KErmsLL * sqrt(1.5)  ,'SimR',Rphase ,'SimDtOverL', Ts / Lphase ,'SimKtOverJdT', 0.007 , 'SimBOverJdT', 2.5e-5  ) ; 

ClaSimState = struct('Speed',0,'MotorPos', 0 , 'w', 0 ,'ia',0,'ib',0,'ic',0,'vn',19 ) ; 

% BwHz = 1200 ; NormZero = 1/3 ; 
% [Kp,Ki,Awu] = CurrentController(Lphase,Rphase,Ts,BwHz, NormZero );
ClaState.CurrentControl.CurrentCommand = 10; 
dt = ClaMailIn.SimdT ; 
tf = 5e-3 ;
t = 0:dt:tf ; 
n = length(t) ; 

cf = t * 0 ; 
v_iq = cf ; 
v_id = cf ; v_ia = cf ; v_ib = cf ; 
v_sva = cf ; v_svb = cf ; v_vq = cf ; v_vd = cf ; v_vn = cf  ; 
for cnt = 1:n 
    if( t(cnt) > 1e-3 )
        kukiya = 1 ; 
    end
	ClaTask();
    cf(cnt) = ClaState.CurrentControl.CurrentCommandFiltered ; 
    v_iq(cnt) = ClaState.CurrentControl.Iq ; 
    v_id(cnt) = ClaState.CurrentControl.Id ; 
    v_ia(cnt) = ClaState.Analogs.PhaseCur(1) ; 
    v_ib(cnt) = ClaState.Analogs.PhaseCur(2) ; 
    v_sva(cnt) = ClaSimState.va - ClaSimState.vn ;
    v_svb(cnt) = ClaSimState.vb - ClaSimState.vn ;
    v_vq(cnt) = ClaState.vqd ; 
    v_vd(cnt) = ClaState.vdd ; 
    v_vn(cnt) = ClaSimState.vn ; 
end 

figure(21) ; clf 
plot( t , cf , t , v_iq, t , v_id )  ; legend('IqRef','Iq','Id'); 
