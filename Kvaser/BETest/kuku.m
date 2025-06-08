% FetchObj( [hex2dec('2002'),1] , DataType.long , 'ManipStat 47' )
% 
% 
% SendObj( [hex2dec('2002'),2] , 1.2345, DataType.float , 'ManipStat 47' )
% FetchObj( [hex2dec('2002'),2] , DataType.float , 'ManipStat 47' )
% 
% 
% SendObj( [hex2dec('2220'),2] , hex2dec('12345')  , DataType.long , 'Master Blaster' )
% SendObj( [hex2dec('2220'),3] , 1 , DataType.long , 'Set voltage mode' )
% SendObj( [hex2dec('2220'),4] , 1 , DataType.long , 'Motor On' )
% 
% SendObj( [hex2dec('2220'),4] , 0 , DataType.long , 'Motor Off' )
% 
% SendObj( [hex2dec('2220'),6] , -300 , DataType.float , 'Motor On' ); 
% 
% SendObj( [hex2dec('2220'),19] , 1 , DataType.long , 'Ena PS' ); 

 x = load('RecordSpeedRslt.mat');
 r = x.r ; 
 t = r.t ; 
 figure(100) ; clf
 Ts = 50e-6 ; 
 Ki = 500   ; 
 Kp = 5 ; 
 plot( t,  r.PIState(1) + Ki * cumsum(r.SpeedCommand * Ts -r.UserPosDelta) ,'+-', t  , r.PIState ,'d')
 figure(101) ; clf
F1 = 180 ; Xi1 = 0.5 ; F2 = 30 ; Xi2 = 0.85 ; IsSimplepole = 0 ; IsSimplezero = 1 ; SimpleP = inf ; SimpleZ = inf ;  
tf1 = Get2ndOrder(Ts,IsSimplepole,IsSimplezero,F1,F2,Xi1,Xi2,SimpleP,SimpleZ) %#ok<NOPTS> 
F1 = 30 ; Xi1 = 0.8 ; F2 = 24 ; Xi2 = 0.6 ; IsSimplepole = 0 ; IsSimplezero = 0 ; SimpleP = inf ; SimpleZ = inf ;  
tf2 = Get2ndOrder(Ts,IsSimplepole,IsSimplezero,F1,F2,Xi1,Xi2,SimpleP,SimpleZ) %#ok<NOPTS> 
ys = lsim(tf1*tf2,r.PiOut);
figure(51) ; 
plot( t,  r.PiOut , t , r.CurrentCommand , t , ys ,'d') ;
bbb = load('ccc.mat') ;
bbb = bbb.fp ; 
w    = bbb.f * 2 * pi ; 
g = c2d(tf( 60, [1,0,0]),Ts ) ; 
gv = c2d(tf( 60, [1,0]),Ts ) ; 
ag = freqresp ( gv , w ) ; ag = abs(ag(:) ) ; 
figure(60) ;
semilogx( w , 20 * log10( ag ) )

ag = freqresp ( g , w ) ; ag = abs(ag(:) ) ; 
figure(61) ; 
semilogx( w , bbb.logamp , w , 20 * log10( ag ) )

figure(52) ;
yp = lsim( g , r.CurrentCommand ); 
plot( t , yp , t , cumsum(r.UserPosDelta+0.0000083) ) ; legend('sim','act') 
gpi = (Kp + Ki * Ts * tf ([1,0],[1,-1],Ts)) * tf1 * tf2 ;



