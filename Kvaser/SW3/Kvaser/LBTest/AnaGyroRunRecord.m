% Analize the recording of the limit switches 
CalcGeomData;
% Debug - program recording of run shelf vars 
global DataType
SendObj( [hex2dec('2222'),17] , 1 , DataType.long , 'Debug mode = lsw' ) ;

RecTime = 20; 


RecStruct.Sync2C = 1 ; 
% InitRec set zero , recorder shall start automatically
RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 


RecNames = {'lDebug0','lDebug1','lDebug2','fDebug0','fDebug1','LineSpeed',...
    'RightWheelEncoder','LeftWheelEncoder','RwSpeedCmdAxis','LwSpeedCmdAxis'} ;
% RecNames = {'lDebug0','lDebug1','lDebug2','lDebug3','lDebug4','fDebug0','fDebug1',...
%     'RightWheelEncoder','LeftWheelEncoder','ShelfMode','WheelProfile0Speed','WheelProfile0Pos','WheelProfile1Pos'} ;

L_RecStruct = RecStruct ;
L_RecStruct.BlockUpLoad = 0 ; 
[~,L_RecStruct] = Recorder(RecNames , L_RecStruct , RecInitAction   );

disp(['Wait recording time, Sec:  ',num2str(RecTime) ]) ; 
pause(RecTime + 5 ) ; 
[~,~,r] = Recorder(RecNames , L_RecStruct , RecBringAction   );
save('AnaGyroRecord.mat','r' ) ; 
t = r.t ; 
Ts = r.Ts ;


% st = r.lDebug0 ;
% r.Dist2End0 = r.fDebug0 ; 
% r.Dist2End1 = r.fDebug1 ;
% r.DistFromStart0 = r.fDebug2 ; 
% r.DistFromStart1 = r.fDebug3 ;
% r.PosTarget = r.fDebug4 ;
% r.stat = struct('bEndGame',bitextract(st , 1, 1 ),'Prof0Done', bitextract(st , 1, 2 ),'Prof1Done', bitextract(st , 1, 3 ),...
%     'TargetArmDone', bitextract(st , 7, 4 ) ,'RunDirection',bitextract(st , 3, 10 ),'bProfileStart',bitextract(st , 3, 12 ),...
%     'ShelfMode',bitextract(st , 15, 16 ),'NextStationIsPole',bitextract(st , 1, 20 ),'ChgModeState',bitextract(st , 127, 21 )) ; 

% figure(30) ; clf 
% plot( r.t, r.rstat.Value , r.t , r.rstat.Rise ,'+'  , r.t ,  r.rstat.Fall ,'-') ; legend('Sw value','Rise','Fall') ;
% set( gca , 'ylim' , [-0.2, 1.2 ]) 
% 
% whm = Geom.Calc.WheelEncoder2MeterShelf * r.RightWheelEncoder ; 
% rwm = whm ;
% figure(31) ; clf 
% plot( whm, r.rstat.Value , whm , r.rstat.Rise ,'+'  , whm ,  r.rstat.Fall ,'-') ; legend('Sw value','Rise','Fall') ;
% xlabel('Right wheel Pole travel, meters') ; 
% set( gca , 'ylim' , [-0.2, 1.2 ]) 
% 
% whm = Geom.Calc.WheelEncoder2MeterShelf * r.LeftWheelEncoder ; 
% lwm = whm ;
% figure(32) ; clf 
% plot( whm, r.lstat.Value , whm , r.lstat.Rise ,'+'  , whm ,  r.lstat.Fall ,'-') ; legend('Sw value','Rise','Fall') ;
% xlabel('Left wheel Pole travel, meters') ; 
% set( gca , 'ylim' , [-0.2, 1.2 ]) 






