x = load('SigRecSave.mat') ; 
r = x.RecStr ; 
t = r.t ; 
% {'TimeLat2'  'MotSpeedHz2'  'Pos2'  'SpeedTime2'  'UserPosDelta2','EncoderNow2'}
dp = r.UserPosDelta2 * 4000; 
figure(100) ; subplot(2,1,1) ; 
plot(diff(r.SpeedTime2)) ;
subplot( 2,1,2) 
plot(t,dp) ;
