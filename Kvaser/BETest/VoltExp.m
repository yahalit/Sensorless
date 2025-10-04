% VoltExp: Make  a "Volt experiment" - identification of motor parameters without any movement 
CanId = TargetCanId  ; 
CurrentLevel = 10 ; 
% Direction = 6 ; 

% Program experiment data 
SendObj( [hex2dec('2225'),29,CanId] , 3  , DataType.float , 'Low threshold' ) ;
SendObj( [hex2dec('2225'),30,CanId] , CurrentLevel  , DataType.float , 'High threshold' ) ;
SendObj( [hex2dec('2225'),31,CanId] , 0.2  , DataType.float , 'TholdZero' ) ;
SendObj( [hex2dec('2225'),32,CanId] , 0.02  , DataType.float , 'RecTime' ) ;
SendObj( [hex2dec('2225'),33,CanId] , 0.04  , DataType.float , 'Tout' ) ;

% Go to the experiment of the first branch 
SendObj( [hex2dec('2220'),38,CanId] , Direction  , DataType.long , 'Activate + direction ' ) ;

pause(1) ; 

% Bring the records 
UseBlockDownload = 1 ; 
owner = FetchObj([hex2dec('2000'),111],DataType.long,'Get recorder owner') ; 
RecAction = struct( 'InitRec' ,  0, 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1  ,'BlockUpLoad',UseBlockDownload ) ; 
[~,~,r0] = Recorder({'Vdc','PhaseCur0','PhaseCur1','PhaseCur2','ExtLmeasState'} , RecStruct , RecAction   );
r = r0 ; 
t = r.t ; 
figure(1) ;  clf 
subplot(2,1,1) ; 
plot( t ,  r.Vdc) ; title( 'VDc') ; 
subplot(2,1,2) ; 
plot( t, r.PhaseCur0 , t, r.PhaseCur1,  t, r.PhaseCur2  );

expfault = FetchObj([hex2dec('2223'),10],DataType.long,'Get fault') ; 
if ( expfault) 
    disp('A fault occured') ; 
    pause ;
end
if max(t) < 0.01 
    disp('Recorder did not cover entire waveform') ; 
    pause ;
end




fname = "FEsraVoltExpRslt_" + num2str(ExpMng.AnglePU) + "_" + num2str(CurrentLevel) + "_" + num2str(Direction) +  ".mat" ;
disp( "Written file: " + fname ) ; 
save ( fname,'r') ;  