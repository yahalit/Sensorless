RecordSetList = struct( 'DiffTurn' , 1 ,'ClimbStart', 2 ,'ShelfNav' , 3 ,'NeckAngle',4) ; 

RecordSetName = RecordSetList.NeckAngle ; 
RecTime = 5; 


RecStruct.Sync2C = 1 ; 
RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1  ) ; 
RecNames = {''} ;
addpath('C:\Nimrod\Simulation\Nav\Geometry');


switch  RecordSetName
    case 1
        RecNames = {'RawImuAcc0','RawImuAcc1','RawImuAcc2','RawGyro0','RawGyro1','RawGyro2','GyrodT','GyroQuat0','GyroQuat1','GyroQuat2','GyroQuat3','CrabProfilePos','ImuID'} ;
    case 2
        RecNames = {'GyroFuckCnt','ImuID','ShelfMode','ShelfSubMode','ChgModeSubState','ChgModeState','Wbody_0','RawImuAcc0'} ;        
    case 3  
        RecNames = {'iPos0','iPos1','iPos2','RSteerPosEnc','ShelfMode','WheelEncoderNow0','Xbase','Destination0','Robotxc0'} ;   
    case 4  
        RecNames = {'iPos2','ShelfSubMode','ArcDistance0','ArcDistance1','ArcTilt','HeadRollFilt','NeckOuterPos'} ;   
end
%  

[~,RecStruct] = Recorder(RecNames , RecStruct , RecInitAction   );

pause(RecTime) ; 
[~,~,r] = Recorder(RecNames , RecStruct , RecBringAction   );
t = r.t ; 
Ts = r.Ts ;

switch  RecordSetName
    case 1
        figure(1) ; clf ; 
    plot ( t, r.RawImuAcc0 , t, r.RawImuAcc1,t, r.RawImuAcc2 ) ; legend('RawImuAcc0','RawImuAcc1','RawImuAcc2');
    figure(2) ; clf ; 
    % plot ( t, r.BodyQuat0 , t, r.BodyQuat1,t, r.BodyQuat2,t, r.BodyQuat3 ) ; legend('BodyQuat0','BodyQuat1','BodyQuat2','BodyQuat3');
    plot ( t, r.GyroQuat0 , t, r.GyroQuat1,t, r.GyroQuat2,t, r.GyroQuat3 ) ; legend('GyroQuat0','GyroQuat1','GyroQuat2','GyroQuat3');
    figure(3) ; clf ; 
%     plot ( t, r.GyroQuat0 , t, r.GyroQuat1,t, r.GyroQuat2,t, r.GyroQuat3 ) ; legend('GyroQuat0','GyroQuat1','GyroQuat2','GyroQuat3');
    plot( t,r.GyrodT ) ; 
    figure(4) ; clf
    fac = 8.7266e-05 ; 
    plot ( t, r.RawGyro0 * fac , t, r.RawGyro1 * fac ,t, r.RawGyro2 * fac ) ; legend('RawGyro0','RawGyro1','RawGyro2');
    figure(5) ; clf ; 
    plot( t , r.CrabProfilePos ) ; legend('CrabProfilePos' ) ; 
    
    m0 = cumsum( r.RawGyro0 * fac ) * Ts ; 
    m1 = cumsum( r.RawGyro1 * fac ) * Ts ; 
    m2 = cumsum( r.RawGyro2 * fac ) * Ts ; 
    mn = m0 * 0 ; 
    q = [ r.GyroQuat0 ; r.GyroQuat1; r.GyroQuat2 ; r.GyroQuat3 ] ; 
    for cnt = 1:length(t) 
        mn(cnt) = norm([m0(cnt),m1(cnt),m2(cnt)]) ; 
    end 

    figure(10) ; clf  ; plot( t , mn ) ; 
    q1 = q(:,1) ;
    q2 = q(:,end) ;

    qt = InvQuatOnQuat(  q1, q2 ); 
    tang = 2 * acos( qt(1)) ; 
    
    save('zuzuotamutu.mat')
    case 4 
    save('kukuriku2.mat')
    otherwise
    save('kukuriku1.mat')
end
