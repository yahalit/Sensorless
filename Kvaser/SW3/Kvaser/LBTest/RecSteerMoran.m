%r = load('Liran8.mat') ; 
% Place the robot horizontally with its head level. 
% The result (quat0) of this recording / analysis is its gyro calibration quaternion
global StopAfterRecProg 
StopAfterRecProg = 0 ; 

TrigSig   = find( strcmpi( SigNames ,'bPauseFlag')) ;  
TrigTypes = struct('Immediate', 0 , 'Rising' , 1 , 'Falling' , 2 ,'Equal' , 3) ; 
RecNames = {'bPauseFlag','SegDone','LineSpeed','LineSpeedCmd','RWheelEncSpeed','RunS','RundS','SegIndex'} ; 
MyRecNames = RecNames ; 
RecTime = 5 ; 
TsRec   = 4.096e-3 ; 
RecGap  = 2 ; 
nRec    = fix( RecTime / ( RecGap* TsRec ) ) ; 
MaxRecLen = 10000 / length(RecNames) ; 
while nRec > MaxRecLen
	RecGap = RecGap + 1 ; 
	nRec    = fix( RecTime / ( RecGap* TsRec ) ) ; 
end 


RecStructUser = struct('TrigSig',TrigSig,'TrigType',TrigTypes.Immediate ,'TrigVal',0,...
    'Sync2C', 1 , 'Gap' , RecGap , 'Len' , nRec ) ; 
RecStructUser.PreTrigCnt = fix( nRec / 4) ;

RecStructUser = MergeStruct ( RecStruct, RecStructUser)  ; 

%Flags (set only one of them to 1) : 
% ProgRec = 1 just programs the signals, recorder remains inactive waiting an activating event 
% InitRec = 1 initates the recorder and makes it work 
% BringRec = 1 Programs the recorder, waits completion, and brings the
% results immediately
options = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 , 'BlockUpLoad', 1  ); 
Recorder(RecNames , RecStructUser , options ) ; 

if StopAfterRecProg	
	return ;  %#ok<UNRCH>
end

disp('Retrieving queue info ') ; 
disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>') ; 
disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>') ; 
[MQ,nGet,nPut,UsrQ] = GetMotionQueue() ; 

disp('Bringing records') ; 
disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>') ; 
disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>') ; 
options = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 , 'BlockUpLoad', 1 ,'Struct', 1 ); 
[~,~,r]= Recorder(RecNames , RecStructUser , options ) ; 

disp('Storing results') ; 
disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>') ; 
save MoranR.mat r MQ nGet nPut UsrQ ;

disp('Done') ; 
disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>') ; 
disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>') ; 

t = r.t ; 
figure(1) ; clf 
subplot( 4,1,1) ; 
plot( t , r.bPauseFlag); 
subplot( 4,1,2) ; 
plot( t , r.SegDone',t,r.RunS) ; legend('SegDone','Runs') ;
subplot( 4,1,3) ; 
plot( t , r.LineSpeed,t , r.LineSpeedCmd,t , r.RundS) ;  legend('LineSpeed','LineSpeedCmd','RundS') ;
subplot( 4,1,4) ; 
plot( t , r.RWheelEncSpeed); 

