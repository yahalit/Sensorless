
global DataType
global RecStruct ; 
global TargetCanId 

RecTime = 12; 


RecStruct.Sync2C = 1 ; 
% InitRec set zero , recorder shall start automatically
RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 

% EncoderPosTarget0,EncoderPosTarget1

L_RecStruct = RecStruct ;
L_RecStruct.BlockUpLoad = 1 ; 
 


% Mission configuratio
vvvmode = struct ( 'DoClimb' , 1 , 'DoRotateDisc' , 1, 'DoShelfTravel' , 1, 'DoPackage' , 1 ) ; 



InterShelfDist = 0.487 ; 
xTargetVec = [0 , 2.0 , 2.0 , 0 , 0] ; 
yTargetVec = [0 , 0 , 2.0 , 2.0 , 0] ; 
xTarget =xTargetVec(1) ;
yTarget =yTargetVec(1) ;

% DO NOT CHANGE BELOW THIS 
%%%%%%%%%%%%%%%%%%%%%%%%%%

Qindex = 1 ; 
SpiDoTx = 2 ; 
TsBase = 4.096e-3 ; 

RxCtr = 0 ; 
TxCtr = 0 ; 
SimTime = 0 ;

RGeom = struct ('YellowLineRect',[0.3,-0.2,0.6,0.25],'YellowLineMaxAz',0.15,'YellowLineProcDelay',0.75,'QrCodeRect',[-0.1,-0.2,0.35,0.25],'QrCodeMaxAz',0.15,'QrCodeProcDelay',0.75) ; 
CalcGeomData;
Constraint = struct( 'vmax', 1.2 , 'DiffRotS' , 0.5  );  
Setup = struct( 'ErrorCatch' , 0 ) ; 
Pars = struct ( 'Constraint' , Constraint , 'Setup' , Setup ,'RobotGeom', RGeom  ) ;


% Robot initial position 
X = [xTarget(1) ,0,0] ;

% Right wheel is to the y , left to -y 
ey =[0 1 0] ; 

% Set navigation 
[str,reply] = SpiSetPosRpt( X , 0  , 4 , SpiDoTx ) ; %#ok<*ASGLU>

% Set a queue destination 
SpiClearQueue( Qindex , SpiDoTx); 
NextPt = 0 ; 
[str,reply] = SpiSetPathPt( Qindex , NextPt , X , [1,0,0] , SpiDoTx) ; 

for cnt = 1:1 
    NextPt = NextPt + 1 ; 
    [str,reply] = SpiSetPathPt( Qindex , NextPt , [xTargetVec(cnt+1),yTargetVec(cnt),0] , [1,0,0] , SpiDoTx) ; 
end 

% End the queue
NextPt = NextPt + 1 ; 
[str,reply] = SpiSetPathWait( Qindex , NextPt , inf , SpiDoTx ) ;

RecNames = {'LineSpeed','LineSpeedCmd','SegDone','SegIndex','FullSegsDone','RunS','RundS','RunState',...
    'RwSpeedEnc','Robotxc1','RwSpeedCmdAxis','LWheelEncPos','RUserSpeedCmd'} ;
% Activate recorder 
[~,L_RecStruct] = Recorder(RecNames , L_RecStruct , RecInitAction   );

% and execute it 
[str,reply] = SpiQueueExec( Qindex , 0 , 1 , SpiDoTx ) ; 


L_RecStruct.BlockUpLoad = 1 ;  %#ok<UNRCH>
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 
[~,~,r] = Recorder(RecNames , L_RecStruct , RecBringAction   ); 

figure(20) ; clf 
subplot( 2,1,1); 
plot( r.t , r.SegDone )

figure(30)
subplot( 2,1,1); 
plot( r.t, r.LineSpeed ,'+', r.t, r.RUserSpeedCmd * Geom.rg , r.t, r.LineSpeedCmd, r.t, r.RwSpeedCmdAxis* Geom.rg); legend('LS','USC','LSC','SCA')  ;
subplot( 2,1,2); 
plot( r.t , r.Robotxc1,'+' , r.t , Geom.Calc.WheelEncoder2MeterGnd * (r.LWheelEncPos-r.LWheelEncPos(1)))
