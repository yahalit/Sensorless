%r = load('Liran8.mat') ; 
% Place the robot horizontally with its head level. 
% The result (quat0) of this recording / analysis is its gyro calibration quaternion

TrigSig   = find( strcmpi( SigNames ,'RawQuat0')) ;  
TrigTypes = struct('Immediate', 0 , 'Rising' , 1 , 'Falling' , 2 ,'Equal' , 3) ; 
RecNames = {'RawQuat0','RawQuat1','RawQuat2','RawQuat3'} ; 
MyRecNames = RecNames ; 


RecStructUser = struct('TrigSig',TrigSig,'TrigType',TrigTypes.Immediate ,'TrigVal',0,...
    'Sync2C', 1 , 'Gap' , 2 , 'Len' , 300 ) ; 
RecStructUser.PreTrigCnt = RecStructUser.Len / 4;

RecStructUser = MergeStruct ( RecStruct, RecStructUser)  ; 

%Flags (set only one of them to 1) : 
% ProgRec = 1 just programs the signals, recorder remains inactive waiting an activating event 
% InitRec = 1 initates the recorder and makes it work 
% BringRec = 1 Programs the recorder, waits completion, and brings the
% results immediately
options = struct( 'InitRec' , 1 , 'BringRec' , 1 ,'ProgRec' , 1 , 'BlockUpLoad', 1  ); 

[~,~,r]= Recorder(RecNames , RecStructUser , options ) ; 

t = r.t ; 
q0 = mean(r.RawQuat0) ; 
q1 = mean(r.RawQuat1) ; 
q2 = mean(r.RawQuat2) ; 
q3 = mean(r.RawQuat3) ; 
qsys = [0 1 1 0 ] / sqrt(2) ; 
[yy,pp,rr]= Quat2Euler( QuatOnQuat(QuatOnQuat(qsys,[q0,-q1,-q2,-q3]),qsys))  ; 
quat0 = euler2quat(0, pp,rr) ; % This goes to calibration mat 
Qr0   = QuatOnQuat( qsys , quat0) ; 


