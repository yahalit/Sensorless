addpath('..\..\Control') ; 
SetEnums; 

global EPWM1_O_CMPA EPWM1_O_CMPB EPWM2_O_CMPA EPWM2_O_CMPB EPWM3_O_CMPA EPWM3_O_CMPB %#ok<*NUSED> 
global c ClaControlPars ClaState ClaMailIn ClaSimState SinTable SysState ControlPars HallDecode Commutation ClaMailOut GRefGenPars TRefGenPars%#ok<*GVMIS> 
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

Ts   = CUR_SAMPLE_TIME_USEC * 1e-6  ; 
LLL  = 1e-3 ; 
RLL  = 0.17 ; 
KErmsLL = 0.3  ; 
Rphase = RLL / 2 ; 
Lphase = LLL / 3  ;
fcpu = 120e6 ; 
rev2pos = 1/10 ; 

frame = Ts * fcpu / 2 ; 
tAnalogSamp = 1.5e-6 ; 
pwmin = tAnalogSamp * fcpu ; 

ClaMailOut= struct('StoEvent',0) ; 

Profiler = struct( 'ProfileSpeedBuf', zeros(1,8) ,'ProfilePosBuf', zeros(1,8) , 'ProfileSpeed' , 0 ,...
    'ProfilePos',0,'tau',0.01,'accel',150,'dec',150,'vmax',3,'PosTarget',1,'UnfilteredPos',0,...
    'PosDiff',0,'PosMax',10000,'PosMin',-10000,'BufCnt',0,'ProfilerMode',0,'Done',0) ;



MCanSupport = struct('IntervalCorrectionFac',1,'NomInterMessageTime',8.192e-3,'SyncValid',0,'MinInterMessage',7e-3,'MaxInterMessage',10e-3,...
    'LastInterMessageTime',8192e-6 ,'Usec4Sync' , 0 ,'Usec4ThisMessage', 0 ) ; 
Encoder = struct('UserSpeed',0,'MotSpeedHz',0,'UserPos',0,'Pos',0,'SpeedTime',0,'EncoderOnZero',0,'MotSpeedHzFilt',0) ;
Timing = struct('TsTraj',Ts,'Ts',Ts,'UsecTimer',0) ; 
PVT = struct('TsCont',0,'VrFac',0,'dT',0,'x0',0,'vFixed',1,'Init',0,'NewMsgReady',0) ; 
Mot = struct('CurrentLimitFactor', 1,'LoopClosureMode',E_LC_Pos_Mode,'QuickStop',0,'ReferenceMode', E_PosModePT,'CurrentLimitCntr',0) ; 
Status = struct('HaltRequest',0,'HomingRequest',0) ; 
GRef = struct('Time',0,'Out',0,'dOut',0,'Type',E_S_Fixed,'On',1 ); 
TRef = struct('Time',0,'Out',0,'dOut',0,'Type',E_S_Fixed,'On',1 ); 

Debug   = struct('GRef', GRef,'TRef', TRef ) ; 
SpeedControl = struct('SpeedReference',0,'PIState',0 ,'SpeedCommand',0 ) ; 
PosControl = struct('PosReference',0,'PosError',0) ; 

AmpFull = 30 ; 

SysState = struct('Mot',Mot,'ProfileConverged',0,'Timing',Timing,'PVT',PVT,'Encoder',Encoder,'Status',Status,'Debug',Debug,'MCanSupport',MCanSupport,...
    'SpeedControl',SpeedControl,'PosControl',PosControl,'Profiler',[Profiler; Profiler],'ActiveProfiler',0) ; 
ControlPars = struct('MaxCurCmd',20,'FullAdcRangeCurrent',AmpFull,'Rev2Pos',rev2pos,'I2tCurTime',24,'I2tCurLevel',20,'EncoderCountsFullRev',10000,...
    'MaxSpeedCmd',130,'SpeedFilterBWHz',500,'MaxAcc',400, ...
        'MaxPositionCmd',50,'MinPositionCmd',-50) ;

GRefGenPars = struct( 'Amp',0,'f',100,'Dc',2,'Duty',0.5); 
TRefGenPars = struct( 'Amp',0,'f',100,'Dc',0,'Duty',0.5); 


HallDecode = struct('HallValue',0,'HallException',0)  ; 
Commutation = struct('OldEncoder',0,'EncoderCounts',0 ,'CommutationMode',2,'MaxCommChangeInCycle',0.17,'ComAnglePu',0,'Init',0) ; 

InitHallModule ; 
SysState.Encoder.MinSpeed   = 0.1 / SysState.Timing.Ts ;
SysState.Timing.TsInTicks = (CPU_CLK_MHZ * CUR_SAMPLE_TIME_USEC  ) ;


EPWM1_O_CMPA = frame/ 2 ; 
EPWM1_O_CMPB = frame/ 2 ; 
EPWM2_O_CMPA = frame/ 2 ; 
EPWM2_O_CMPB = frame/ 2 ; 
EPWM3_O_CMPA = frame/ 2 ; 
EPWM3_O_CMPB = frame/ 2 ; 

ClaMailIn = struct('Ts',Ts,'SimVdc',38,'IaOffset',0,'IbOffset',0,'IcOffset',0,'ThetaElect',0,...
     'SimdT',Ts,'SimKe',KErmsLL * sqrt(3)/4  ,'SimR',Rphase ,'SimDtOverL', Ts / Lphase ,'SimKtOverJdT', 0.025 , 'SimBOverJdT', 2.5e-5  ) ; 

SpeedControlBwHz = 80 ; 
[ControlPars.SpeedKp , ControlPars.SpeedKi] = CalcSpeedControl( ClaMailIn , SpeedControlBwHz , rev2pos ) ; 
ControlPars.PosKp = SpeedControlBwHz * 2 * pi / 4  ; 
ControlPars.SpeedCtlDelay = 1 / pi / SpeedControlBwHz ;

c = struct( 'TwoThirds' , 2/3,'OneOverTwoPi',1/(2*pi),'TwoPi',pi*2,'OneOver3GoodBehavior',1/3,'piOver32',pi/32,'sqrt3',sqrt(3)); 

CurrentControl = struct('Error_q',0,'Error_d',0,'Iq',0,'Id',0,'vpre_q',0,'vpre_d',0,'CurrentCommandFiltered',0,'Int_q',0,'Int_d',0,'CurrentCommand',0,...
    'CurrentCommandSlopeLimited',0,'CurrentCmdFilterState0',0,'CurrentCmdFilterState1',0,'CurrentReference',0) ; 

npp = 4 ; 
ClaControlPars = struct('KeHz',KErmsLL * sqrt(3)/4 / 4 ,'KpCur', 2.5692,'KiCur',6.0678e+03,'KAWUCur',0.3892,'OneOverPP',1/npp,'nPolePairs',npp,'VectorSatFac',0.9,...
    'Bit2Amp',AmpFull/2048,'MaxCurCmdDdt',10000,'CurrentRefFiltA0', 0 ,'CurrentRefFiltA1',0 ) ; 
%    'Bit2Amp',AmpFull/2048,'MaxCurCmdDdt',10000,'CurrentRefFiltA0',-0.80 ,'CurrentRefFiltA1',0 ) ; 
%    'Bit2Amp',AmpFull/2048,'MaxCurCmdDdt',10000,'CurrentRefFiltA0',-1.745485231989130 ,'CurrentRefFiltA1',0.776790921324546 ) ; 

ClaControlPars.Amp2Bit = 1/ClaControlPars.Bit2Amp ; 
ClaControlPars.CurrentRefFiltB = 1 + ClaControlPars.CurrentRefFiltA1 + ClaControlPars.CurrentRefFiltA0; 

Analogs = struct('Vdc',38,'PhaseCurAdc',[0,0,0]) ; 

ClaState = struct('MotorOn',1,'Vsat',0.9,'SaturationFac4AWU',0,'q2v1',0,'q2v2',0,'d2v1',0,'d2v2',0,'SpeedHz',0,...
	'vqd',0,'vdd',0,'va',0,'vb',0,'vc',0,'PwmMinB',pwmin,'PwmMin',0,'PwmOffset',(frame-pwmin)/2,'PwmMax',frame+100,'PwmFac',1,'PwmFrame',frame,'InvPwmFrame',1/frame,...
	'c',1,'c120',-0.5,'c240',-0.5,'s',0,'s120',sqrt(3)/2,'s240',-sqrt(3)/2,...
	'CurrentControl',CurrentControl,'Analogs',Analogs,...
    'SystemMode',E_SysMotionModeManual) ;

	

ClaSimState = struct('Speed',0,'MotorPos', 0 , 'w', 0 ,'ia',0,'ib',0,'ic',0,'vn',19, 'MotorModuloPos',0) ; 

InitControlParams() ; 
SysState.Encoder.MinMotSpeedHz   = 0.1 / ( ControlPars.EncoderCountsFullRev * SysState.Timing.Ts)  ;

SysState.Profiler(1) = ResetProfiler ( SysState.Profiler(1) ,  0 ,  0  , 1 ) ; 
SysState.Profiler(1) = ResetProfiler ( SysState.Profiler(1) ,  1 ,  0  , 0 ) ; 
SysState.Profiler(2) = ResetProfiler ( SysState.Profiler(1) ,  0 ,  0  , 1 ) ; 


% BwHz = 1200 ; NormZero = 1/3 ; 
% [Kp,Ki,Awu] = CurrentController(Lphase,Rphase,Ts,BwHz, NormZero );
ClaState.CurrentControl.CurrentRefernce = 0; 
dt = ClaMailIn.SimdT ; 
tf = 200e-3 ;
t = 0:dt:tf ; 
n = length(t) ; 

pvreft = (0:8.192e-3:tf+0.1); 
dpr    = diff( pvreft) ; 
dpr    = 0.0002 + dpr + randn(size(dpr)) * 3e-4 ;  
pvreft     = cumsum(dpr) ; 

% pvref  = 0.4 * sin( pvreft * 20 ) + 0.04 ; 
pvref  = 0.1 * pvreft.^2 * 20 ; 
n1 =find(pvreft>tf/2,1) ;
pvref(n1+1:end) = pvref(n1) -  pvref(1:length(pvref)-n1) ; 
pvcnt  = 1 ; 

tstop  = 0.016 ; 
cf = t * 0 ; 
v_iq = cf ; 
v_id = cf ; v_ia = cf ; v_ib = cf ; 
v_sva = cf ; v_svb = cf ; v_vq = cf ; v_vd = cf ; v_vn = cf ; v_te = cf ; v_w = cf  ; v_es = cf ; v_ep = cf ; v_hn = cf ; v_hk = cf ;  v_sp = cf ;  v_esf = cf ; 
v_pr = cf ; v_vr = cf ; v_vc = cf ; v_d1 = cf ; v_d2 = cf; v_d3 = cf ; v_d4 = cf ; 
for cnt = 1:n 
    if( t(cnt) > tstop )
        kukiya = 1 ; 
    end
    SysState.Timing.UsecTimer = SysState.Timing.UsecTimer + CUR_SAMPLE_TIME_USEC ; 
	ClaTask();
   
    ReadEncPosition() ;
    ClaState.SpeedHz = SysState.Encoder.MotSpeedHz * ClaControlPars.nPolePairs ;

    Commutation.Status = GetCommAnglePu(SysState.Encoder.Pos ) ;

    if ( SysState.Mot.ReferenceMode == E_PosModeDebugGen)
        SysState.Debug.GRef = RefGen( GRefGenPars , SysState.Debug.GRef , SysState.Timing.Ts );
        SysState.Debug.TRef = RefGen( TRefGenPars , SysState.Debug.TRef , SysState.Timing.Ts );
    else
        SysState.Debug.GRef.On = 0 ;
        SysState.Debug.GRef.Time = 0 ;
        SysState.Debug.TRef.On = 0 ;
        SysState.Debug.TRef.Time = 0 ;
    end

    if t(cnt) > pvreft(pvcnt) 
        % SysState.MCanSupport.Usec4ThisMessage = SysState.Timing.UsecTimer ;
        SysState.MCanSupport.PdoDirtyBoard = 1 ; 
        SysState.MCanSupport.uPDO1Rx.f(1+1) = pvref(pvcnt) ; 
        EstimateMessageTiming( ) ;

        % PVNewMessageDriver(pvref(pvcnt) ) ; 
        pvcnt = pvcnt + 1 ; 
    end 

    MotorOnSeq()  ; 
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
    v_te(cnt) = ClaMailIn.ThetaElect ; 
    v_w(cnt)  = ClaSimState.w ; 
    v_es(cnt) = SysState.Encoder.MotSpeedHz ;
    v_esf(cnt) = SysState.Encoder.MotSpeedHzFilt ;
    v_ep(cnt) = SysState.Encoder.Pos ; 
    v_hk(cnt) = HallDecode.HallKey ; 
    v_hn(cnt) = HallDecode.HallValue ; 
    v_sp(cnt) = ClaSimState.MotorModuloPos ; 
    v_pr(cnt) = SysState.PosControl.PosReference; 
    v_vr(cnt) = SysState.SpeedControl.SpeedReference ; 
    v_vc(cnt) = SysState.SpeedControl.SpeedCommand ; 
    v_d1(cnt) = SysState.MCanSupport.InterMessageTime ; 
    v_d2(cnt) = SysState.MCanSupport.LastInterMessageTime;
    v_d3(cnt) = SysState.MCanSupport.Usec4ThisMessage ; 
    v_d4(cnt) = SysState.MCanSupport.Usec4Sync; 
end 

figure(24) ; clf 
plot( t , cf , t , v_iq, t , v_id )  ; legend('IqRef','Iq','Id'); 
