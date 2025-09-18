% Make  a "EMF experiment" - identification of motor parameters without
% any movement 
CanId = TargetCanId  ; 

RecStruct.Sync2C = 1 ; 
RecStruct.Gap = 1; 
RecStruct.Len = 300; 

% Bring the records 
UseBlockDownload = 1 ; 
owner = FetchObj([hex2dec('2000'),111],DataType.long,'Get recorder owner') ; 
RecAction = struct( 'InitRec' ,  1, 'BringRec' , 1 ,'ProgRec' , 1 ,'Struct' , 1  ,'BlockUpLoad',UseBlockDownload ) ; 
[~,~,r0] = Recorder({'Vdc','PhaseVoltMeas0','PhaseVoltMeas1','PhaseVoltMeas2'} , RecStruct , RecAction   );
r = r0 ; 
t = r.t ; 
figure(1) ;  clf 
subplot(2,1,1) ; 
plot( t ,  r.Vdc) ; title( 'VDc') ; 
subplot(2,1,2) ;
n = 1/3 *( r.PhaseVoltMeas0 + r.PhaseVoltMeas1 + r.PhaseVoltMeas2) ; 
plot( t, r.PhaseVoltMeas0 - n ,'r', t, r.PhaseVoltMeas1 - n , 'g', t, r.PhaseVoltMeas2 - n ,'b' );

