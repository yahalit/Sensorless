% Test the tracking of a yellow line over a straight motion line 

global RxCtr ; 
global TxCtr ; 

global DataType
global RecStruct ; 
global TargetCanId 
global DatType 

RecTime = 5; 

TsBase = 4.096e-3 ; 

InterShelfDist = 0.506 ; 
xTarget = 2 ; 
DistFromStart2Target = 1.5 ; 


% Robot initial position 
X = [xTarget - DistFromStart2Target ,0,0] ;

% DO NOT CHANGE BELOW THIS 
%%%%%%%%%%%%%%%%%%%%%%%%%%

Qindex = 1 ; 
SpiDoTx = 2 ; 

RxCtr = 0 ; 
TxCtr = 0 ; 

RGeom = struct ('YellowLineRect',[0.3,-0.2,0.6,0.25],'YellowLineMaxAz',0.15,'QrCodeRect',...
    [-0.1,-0.2,0.35,0.25],'QrCodeMaxAz',0.15) ; 

Geom = struct ('Center2WheelDist',0.256 , 'SteerColumn2WheelDist', 0.075 ,'ClimbArcRadi',0.22025 ,'WheelMotCntRadGnd',2.757550884373431e+04,'rg',0.1) ;
facw = Geom.rg / Geom.WheelMotCntRadGnd  ; 
Constraint = struct( 'vmax', 1.2 , 'DiffRotS' , 0.5  );  
Setup = struct( 'ErrorCatch' , 0 ) ; 
Pars = struct ( 'Constraint' , Constraint , 'Setup' , Setup ,'RobotGeom', RGeom ) ;


arclen = Geom.ClimbArcRadi*pi/2;

SendObj( [hex2dec('2220'),70] , 1 , DataType.short , 'Ignore QR codes' ) ;
SendObj( [hex2dec('2220'),71] , 1 , DataType.short , 'Ignore Line deviation reports' ) ;

%SetFloatPar( 'ControlPars.LateralPoleAccessTol', 0.023 , @KvaserCom) ; % 165  ) ;
%SetFloatPar( 'ControlPars.GyroXFiltBwRadSec' , 20 , @KvaserCom) ; % Was 1.5 
% SetFloatPar( 'ControlPars.AngularPoleAccessTol', 0.09  , @KvaserCom ) ;

% Program to work with manual disabler
% SendObj( [hex2dec('1f00'),3] , 1 , DataType.short , 'Set analog stop control' ) ;
SetFloatPar( 'GyroInt.kKalmanLineOpticalCorrect' , 0.95 , @KvaserCom) ; % Was 1.5 
SetFloatPar( 'GyroInt.kKalmanLineOpticalCorrect2' , 0.25 , @KvaserCom) ; % Was 1.5 
 
% Right wheel is to the y , left to -y 
ey =[0 1 0] ; 
Rw = X + (Geom.Center2WheelDist+Geom.SteerColumn2WheelDist) * ey ; 
Lw = X - (Geom.Center2WheelDist+Geom.SteerColumn2WheelDist) * ey ; 

% Set navigation 
[str,reply] = SpiSetPosRpt( X , 0  , 4 , SpiDoTx ) ; %#ok<*ASGLU>

% Set a queue destination 
SpiClearQueue( Qindex , SpiDoTx); 
NextPt = 0 ; 
[str,reply] = SpiSetPathPt( Qindex , NextPt , X , [1,0,0] , SpiDoTx) ; %C0 

NextPt = NextPt + 1 ; 
[str,reply] = SpiSetPathPt( Qindex , NextPt , [xTarget,0,0] , [1,0,0] , SpiDoTx) ;  %C1

% 
% End the queue
NextPt = NextPt + 1 ; 
[str,reply] = SpiSetPathWait( Qindex , NextPt , inf , SpiDoTx ) ;


% Set Recorder 
% RecNames = {'RWheelEncPos','LWheelEncPos','RwSpeedCmdAxis','LwSpeedCmdAxis','RobotDirection','LineSpeed','EulerYaw',...
%             'RwSteerPosTarget','LwSteerPosTarget','RobotXc0','RobotXc1','RawDevOffset','iPos0','iPos1','LineCurvature','ImuOmega2'} ; 
RecNames = {'RWheelEncPos','LWheelEncPos','RwSpeedCmdAxis','LwSpeedCmdAxis'} ; 
RecStruct.Len = 600 ; 
RecStruct.Gap = 2 ; 
RecStruct.Sync2C = 1 ; 
RecStruct.TrigType = 0 ; 

Recorder(RecNames , RecStruct ,  struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1  )   ); 


% and execute it 
[str,reply] = SpiQueueExec( Qindex , 0 , 1 , SpiDoTx ) ; 

Recs = Recorder(RecNames , RecStruct ,  struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1  )   ); 


% MatIntfc( 3 , 17 ) ; % Just to proccess the position report
% MatIntfc( 3 , 0.17 ) ; % Just to proccess the position report


expnum = FetchObj( [hex2dec('220b'),2] , DataType.long ,'Captured exceptions') ;
expnow = GetCode( expnum , 0 , 65535  ) ; 
expold = GetCode( expnum , 16 , 65535  ) ; 
if ( expnow ) 
    disp ( ['Exception: 0x',dec2hex(expnow),Errtext(expnow),' OldException: 0x', dec2hex(expold),Errtext(expold) ] ) ; 
end



        figure(1) ; clf 
        subplot( 2,1,1) ; 
        plot(  Recs.iPos0 * 1e-4,  Recs.iPos1 * 1e-4 , Recs.RobotXc0 , Recs.RobotXc1 ,'b' ); legend('Nav est y pos','Robot y pos') ; xlabel('X travel') ; 
        subplot( 2,1,2) ; 
        plot( t ,  Recs.iPos1 * 1e-4 , t , Recs.RobotXc1 ,'b' ); legend('Nav est y dev ','Robot y dev') ; xlabel('Time') ; 

        figure(2) ; clf 
        subplot( 3,1,1) ; 
        plot( t , Recs.RawDevOffset); 
        legend('RawDevOffset') ; 
        subplot( 3,1,2) ; 
        plot( t , Recs.LineCurvature); 
        legend('LineCurvature') ; 
        subplot( 3,1,3) ; 
        plot( t , Recs.RobotDirection, t , Recs.EulerYaw);  legend('True dir','Est yew') ; 
        legend('RobotDirection','Est dir') ; grid on 
        figure(3) ; clf 
        plot( t , Recs.LineSpeed , t , Recs.RwSpeedCmdAxis*facw * 1.003, t , Recs.LwSpeedCmdAxis*facw * 1.006 ) ; 
        legend('LineSpeed','Rw*1.003','Lw*1.006') ;
        figure(4) ; clf 
        plot( t , Recs.ImuOmega2) ; 
        legend('ImuOmega2') ;
