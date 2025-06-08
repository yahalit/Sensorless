%     SendObj( [hex2dec('2103'),41] , -300 , DataType.long , 'Set left shelf motor on' ) ;
%     SendObj( [hex2dec('2103'),51] , 2000 , DataType.long , 'Set left right motor on' ) ;
x = load('.\Tests\Misc\SigRecSave.mat') ;
r = x.RecStr ; 
t = x.t ; 
figure(1) ; 

c




































































f
subplot( 2,1,1) ; 
plot( t , r.RwSteerCmdAxis,'+', t , r.RSteerPosEnc) 
subplot(2,1,2) ; 
plot( t , r.RsteerTorque )  ; 
figure(2) ; clf
subplot( 2,1,1) ; 
plot( t , r.LwSteerCmdAxis,'+', t , r.LSteerPosEnc)
subplot(2,1,2) ; 
plot( t , r.LsteerTorque )  ; 
