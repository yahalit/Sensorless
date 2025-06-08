% Analize the recording of the limit switches 
DataType = GetDataType() ; 

RecTime = 20; 


RecStruct.Sync2C = 1 ; 
% InitRec set zero , recorder shall start automatically
% RecInitAction = struct( 'InitRec' , 0 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 
RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 

% ArcTilt
% TrackTilt
% dArcTilt

% RecNames = {'LeftWheelEncoder','RightWheelEncoder','ArcDistance0','ArcDistance1',...
%     'LineSpeed','LeaderScale','FollowerScale','SpeedRatio','TorqueCorrection',...
%     'RUserSpeedCmd','LwSpeedCmdAxis','RUserSpeedCmd','LUserSpeedCmd','lDebug4','lDebug3','fDebug0','fDebug1'} ; 
RecNames = {'LeftWheelEncoder','RightWheelEncoder','ArcDistance0','ArcDistance1',...
    'LineSpeed','SpeedRatio','ShoulderRoll','GyroSwCapture','ArcCoverAngleEst','ShelfSubMode','TrackTilt','TotalRollByArc','RStatusAsPdo','LStatusAsPdo','SwitchStatus'} ; 
L_RecStruct = RecStruct ;
L_RecStruct.BlockUpLoad = 1 ; 
[~,L_RecStruct] = Recorder(RecNames , L_RecStruct , RecInitAction   );
save AnaJustClimbVars RecNames L_RecStruct RecBringAction

return 

r = load('AnaJustClimbVars.mat') ; %#ok<UNRCH> 
L_RecStruct = r.L_RecStruct ; 
RecNames    = r.RecNames    ; 
RecBringAction = r.RecBringAction ; 
[~,~,r] = Recorder(RecNames , L_RecStruct , RecBringAction   );  
% save('AnaWarmRecordOpenUp12KgFail.mat','r' ) ; 
t = r.t ; 
Ts = r.Ts ;

if isfield( r,'RStatusAsPdo' )
    r = DecodeSwStatus( r , 'R' ); 
end
if isfield( r,'LStatusAsPdo' )
    r = DecodeSwStatus( r , 'L' ); 
end
if isfield( r,'SwitchStatus')
    r = DecodeSwitchesStatus( r   ); 
end





