% Analize the recording of the limit switches  
global RecStruct 
global DataType

load ProgManipRec 

[~,~,r] = Recorder(RecNames , L_RecStruct , RecBringAction   ); 
save('AnaManipRunRecord.mat','r' ) ; 

x = load('AnaManipRunRecord16_02.mat') ; 


r = x.r ; 
t = r.t ; 
Ts = r.Ts ;

%RecNames = {'C2_LeftLockPosTgt','C2_RightLockPosTgt','C2_LeftDoorPosAct','C2_RightDoorPosAct','C2_DynStat12_0Statistic1','C2_DynStat12_1Statistic1',...
%    'C2_DStatistic1','C2_DStatistic2','C2_CtrlWord','C2_ShoulderPos'} ; 

bb = r.C2_DynStat12_0Statistic1 ;
sL = struct('MotorOn',bitget(bb,1),'MotorOnRequest',bitget(bb,2),'StopFail',bitget(bb,3),'ErrorCond',bitgetvalue(bb,(1:8)+3)) ; 
bb = r.C2_DynStat12_1Statistic1 ;
sR = struct('MotorOn',bitget(bb,1),'MotorOnRequest',bitget(bb,2),'StopFail',bitget(bb,3),'ErrorCond',bitgetvalue(bb,(1:8)+3)) ; 
bb  = r.C2_DStatistic1 ; 
cc =  r.C2_DStatistic2 ; 
sD1 = struct('DxlState',bitgetvalue(bb,(1:4)+0),'DxlSubState',bitgetvalue(bb,(1:4)+4),'Individual',bitget(bb,9),'NextAxis',bitgetvalue(bb,(1:3)+9),'ManCmdState',bitgetvalue(bb,(1:5)+12),...
		'MotorResetCmd',bitget(bb,18)) ; 
sD2 = struct('ControlConfirmCtr',bitgetvalue(cc,(1:8)+0),'FeedbackCtr',bitgetvalue(cc,(1:8)+8),'ControlConfirmFailCtr',bitgetvalue(cc,(1:8)+16),'FeedbackFailCtr',bitgetvalue(cc,(1:8)+24)) ; 
bb  = r.C2_CtrlWord;
CW  = struct( 'Automatic',bitget(bb,1),'MotorsOn',bitget(bb,2),'Standby',bitget(bb,3),'Package',bitget(bb,4),'PackageGet',bitget(bb,5),...
    'Side',bitget(bb,6),'LaserValid',bitget(bb,7)) ; 


figure(1) ; clf ; 
subplot(2,1,1) ; 
plot( t, sD2.ControlConfirmCtr , t , sD2.FeedbackCtr) ; legend('Control','Feedback') ; 
subplot(2,1,2) ; 
plot( t, sD2.ControlConfirmFailCtr , t , sD2.FeedbackFailCtr) ; legend('Control Fail','Feedback Fail') ; 

figure(2) ; 
subplot(2,1,1) ; 
plot( t, r.C2_LeftLockPosTgt,t, r.C2_LeftDoorPosAct)
subplot(2,1,2) ; 
plot( t, r.C2_RightLockPosTgt,t, r.C2_RightDoorPosAct)
