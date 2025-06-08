x = load('ErrorInFinal.mat') ; 
x = x.RecStr ; 
t = x.t ;
Ts = x.Ts ; 

%                         Ts: 0.0082
%                    SegDone: [1×2000 double]
%               FullSegsDone: [1×2000 double]
%                       RunS: [1×2000 double]
%               LWheelEncPos: [1×2000 double]
%             LwSpeedCmdAxis: [1×2000 double]
%             LWheelDriveEnc: [1×2000 double]
%               LineSpeedCmd: [1×2000 double]
CalcGeomData() ; 
we = x.LWheelDriveEnc ; we = we - we(1); 
we = unwrap( we * 2 * pi / 2^18) * 2^18 / 2/ pi ; 
Dist = cumsum(x.LineSpeedCmd) * Ts ;
disp(['Line speed integration: ',num2str(Dist(end))]) ; 
figure(10) ; clf
fac = Geom.Calc.WheelEncoder2MeterGnd ;
plot( t , we / Geom.Calc.WheelEncoder2MotEncoder * fac  , t , x.LWheelEncPos * fac ) ; 
figure(20) ; clf
plot( t , x.LWheelEncPos * fac , t, Dist) ; 