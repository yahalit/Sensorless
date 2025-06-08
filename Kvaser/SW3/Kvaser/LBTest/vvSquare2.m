global SimTime ;  %#ok<*NUSED>
global RxCtr ; 
global TxCtr ; 

global DataType
global RecStruct ; 
global TargetCanId 
global DatType 

% Mission configuration

xTargetVec = [ 3.3 , 3.3   , 5.725 , 5.725, 3.3   , 3.3  ] ; 
yTargetVec = [ 1.2 , 0     , 0     , 2.67 , 2.67  , 1.2  ] ; 
thtEnterVec= [-90, -90 , 0   , 90   , 180   , -90   ] * pi / 180; 
thtExitVec=  [-90, 0   , 90  , 180  , -90   , -90   ] * pi / 180  ; 


% Recorder programming
RecTime = 10; 

RecStruct.Sync2C = 1 ; 
RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 
RecProgAction = struct( 'InitRec' , 0 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1  ) ; 
RecNames = {'RWheelEncPos','LWheelEncPos','Wbody_2','CrabProfileSpeed','CrabProfilePos','GyroQuat0','GyroQuat1','GyroQuat2','GyroQuat3',...
    'fDebug0','FullSegsDone','SegDone'} ; 
[~,RecStruct] = Recorder(RecNames , RecStruct , RecProgAction   );

Geom = struct(); 
Geom.SteerColumn2WheelDist = GetFloatPar('Geom.SteerColumn2WheelDist') ; 
Geom.Center2WheelDist = GetFloatPar('Geom.Center2WheelDist') ; 
Geom.WheelCntRad = GetFloatPar('Geom.WheelCntRad') ; 
Geom.rg = GetFloatPar('Geom.rg') ; 

CountPerTurn = ((Geom.SteerColumn2WheelDist+ Geom.Center2WheelDist ) * (pi/2) / Geom.rg) * Geom.WheelCntRad ; 


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


% Set navigation 
[str,reply] = SpiSetPosRpt( [xTargetVec(1),yTargetVec(1),0] , thtExitVec(1)  , 4 , SpiDoTx ) ; %#ok<*ASGLU>

% Set a queue destination 
SpiClearQueue( Qindex , SpiDoTx); 
NextPt = 0 ; 


nTarget = length( xTargetVec) ; 
for cnt = 1:nTarget
    disp([num2str(cnt),'............................................................................']) ; 
    DirIn   = [cos(thtEnterVec(cnt)),sin(thtEnterVec(cnt)) , 0] ; 
    DirOut  = [cos(thtExitVec(cnt)),sin(thtExitVec(cnt)) , 0] ; 
    if cnt > 1 
%        [[xTargetVec(cnt),yTargetVec(cnt),0] , DirIn ]
        [str,reply] = SpiSetPathPt( Qindex , NextPt , [xTargetVec(cnt),yTargetVec(cnt),0] , DirIn , SpiDoTx) ; 
        NextPt = NextPt + 1 ; 
    end 
    if cnt < nTarget 
%         [[xTargetVec(cnt),yTargetVec(cnt),0] , DirOut]   
        [str,reply] = SpiSetPathPt( Qindex , NextPt , [xTargetVec(cnt),yTargetVec(cnt),0] , DirOut , SpiDoTx) ; 
        NextPt = NextPt + 1 ; 
    end 
%     x = 1  ; 
end 


% End the queue
[str,reply] = SpiSetPathWait( Qindex , NextPt , inf , SpiDoTx ) ;

cntmax = 1000 ; 
probcatch = 0  ;
for cnt = 1:cntmax 

    % and execute it 
    [str,reply] = SpiQueueExec( Qindex , 0 , 1 , SpiDoTx ) ; 

     for c1 = 1:10000
        pause (1) ; 
        MAbort = FetchObj( [hex2dec('2207'),32] , DataType.float , 'MAbort' ) ; 

         switch MAbort 
             case 2 
                 pause(0.01) ; % Runnning 
             case 0
                 pause(1) ; 
                 break ; % Done 
             otherwise
                [~,~,r] = Recorder(RecNames , RecStruct , RecBringAction   );
                t = r.t ; 
                Ts = r.Ts ;
                figure(1); clf ; 
                subplot( 2,1,1) ; 
                plot( r.t , r.LWheelEncPos - r.LWheelEncPos(1) , r.t , r.RWheelEncPos - r.RWheelEncPos(1))
                subplot(2,1,2) ; 
                plot( r.t , r.Wbody_2)   ; 
                
                figure(2) ; clf
                subplot( 2,1,1) ; 
                plot( r.t, r.CrabProfilePos);
                subplot( 2,1,2) ; 
                plot( r.t, r.CrabProfileSpeed);                
                
                figure(3) ; clf
                plot( r.t, r.GyroQuat0 ,r.t, r.GyroQuat1 , r.t, r.GyroQuat2 , r.t, r.GyroQuat3) ; legend('q0','1','2','3'); 
                
                
                drawnow ; 
                probcatch = 1; 
                save balbalaw.mat r  ;
                break
         end
     end 
     
     if probcatch 
         break ; 
     end 
end
