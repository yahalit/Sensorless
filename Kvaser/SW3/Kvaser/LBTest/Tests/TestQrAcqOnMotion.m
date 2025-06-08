% User setup 
MaxSpeed = 0.4; 
StartPos = [3,2.6] ; 
EndPos   = [5.5,2.6] ; 
RecNames = {'UsecTimer','RawPosTStamp','RawSEst','HackedPosAzimuth','RawPosReport_0','RawPosReport_1',...
    'RWheelEncPos','RWheelEncSpeed'} ;

experimentNum =12 ; 
switch experimentNum 
    case 1
        MaxSpeed = 0.4; 
        RecSaveName = 'TestQrAcqOnMotion1.mat' ; 
    case 2
        MaxSpeed = 0.4; 
        RecSaveName = 'TestQrAcqOnMotion0p4_Try2.mat' ; 
    case 3
        MaxSpeed = 0.25; 
        RecSaveName = 'TestQrAcqOnMotion0p25_Try1.mat' ; 
    case 4
        MaxSpeed = 0.5; 
        RecSaveName = 'TestQrAcqOnMotion0p5_Try1.mat' ; 
    case 5
        MaxSpeed = 0.5; 
        RecSaveName = 'TestQrAcqOnMotion0p5_Try2.mat' ; 
    case 6
        MaxSpeed = 0.6; 
        RecSaveName = 'TestQrAcqOnMotion0p6_Try1.mat' ; 
    case 7
        MaxSpeed = 0.3; 
        RecSaveName = 'TestQrAcqOnMotion0p3_Try1.mat' ; 
    case 8
        MaxSpeed = 0.3; 
        RecSaveName = 'TestQrAcqOnMotion0p3_Try2.mat' ; 
    case 9
        MaxSpeed = 0.35; 
        RecSaveName = 'TestQrAcqOnMotion0p35_Try1.mat' ; 
    case 10
        MaxSpeed = 0.35; 
        RecSaveName = 'TestQrAcqOnMotion0p35_Try2.mat' ; 
    case 11
        MaxSpeed = 0.35; 
        RecSaveName = 'TestQrAcqOnMotion0p35_Try3.mat' ; 
    case 12
        MaxSpeed = 0.4; 
        RecSaveName = 'TestQrAcqOnMotion0p4_Try3.mat' ; 
    otherwise
        error('Bad experiment number') ; 
end
% End user setup 


global DataType 
if ~isempty(RecSaveName) && ~endsWith(RecSaveName,'.mat')
    error('Recorder save file must have .mat extension'); 
end

RecTime  = norm(StartPos-EndPos) / MaxSpeed + 2.5 ;

Qindex = 1 ; 
SpiDoTx = 2 ; 

% Parameters 
SetFloatPar('Constraint.vmax',MaxSpeed) ; % Maximum line speed on programmed motions 

% Kill line deviation response 

SendObj( [hex2dec('2220'),17] , 5678 , DataType.long ,'Enable Olivier') ;
SendObj( [hex2dec('2220'),70] , 1 , DataType.long ,'Ignore QR reports') ;
SendObj( [hex2dec('2220'),71] , 1 , DataType.long ,'Ignore line deviation reports') ;
 
% Set navigation 
[str,reply] = SpiSetPosRpt( [StartPos , 0] , 0  , 5 , SpiDoTx ) ; %#ok<*ASGLU>
 
 
% Recorder initialization 
RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1  ) ; 
RecStruct.Sync2C = 1 ; 
[~,RecStruct] = Recorder(RecNames , RecStruct , RecInitAction   );

% Right wheel is to the y , left to -y 

runangle = atan2(EndPos(2)-StartPos(2) , EndPos(1)-StartPos(1) ) ;
ex =[cos(runangle) sin(runangle) 0] ; 

% Set a queue destination 
SpiClearQueue( Qindex , SpiDoTx); 
NextPt = 0 ; 
[~,~] = SpiSetPathPt( Qindex , NextPt , [StartPos(1),StartPos(2),0] , ex , SpiDoTx) ; 
NextPt = NextPt + 1  ; 
[~,~] = SpiSetPathPt( Qindex , NextPt , [EndPos(1),EndPos(2),0] , ex , SpiDoTx) ; 

% End the queue
NextPt = NextPt + 1 ; 
[~,~] = SpiSetPathWait( Qindex , NextPt , inf , SpiDoTx ) ;

% and execute it 
[str,reply] = SpiQueueExec( Qindex , 0 , 1 , SpiDoTx ) ; 

% Bring the recorder 
pause(RecTime) ; 
[~,~,Recs] = Recorder(RecNames , RecStruct , RecBringAction   );

% Show results 
figure(1) ; clf
plot( Recs.t , Recs.UsecTimer, Recs.t , Recs.RawPosTStamp); legend('Global time','QR relevance time'); 
figure(2) ; clf
subplot( 3,1,1) ; 
plot( Recs.t , Recs.RawSEst); legend('Length in segment');
subplot( 3,1,2) ; 
plot( Recs.t , Recs.RWheelEncPos); legend('Position (Encoder) '); 
subplot( 3,1,3) ; 
plot( Recs.t , Recs.RWheelEncSpeed); legend('Speed (Encoder) '); 
figure(3) ; clf
subplot( 2,1,1) ; 
plot( Recs.t , Recs.RawPosReport_0); legend('x reading of qr'); 
subplot( 2,1,2) ; 
plot( Recs.t , Recs.RawPosReport_1); legend('y reading of qr'); 

if ~isempty(RecSaveName)
    str = ['save ',RecSaveName,' Recs'] ;
    eval(str) ; 
end 
