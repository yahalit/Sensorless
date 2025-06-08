 x = load('SigRecmissjunk.mat')  
r = x.RecStr ;
t = r.t ; 
 %{'LUserSpeedCmd'  'LwCurrent'  'LwSpeedEnc'  'RUserSpeedCmd'  'RwCurrent'  'RwSpeedEnc'  'TorqueCorrection'}

figure(100) ; 
subplot( 2,1,1) ; 
plot( t , r.RwCurrent , t , r.LwCurrent); legend('Rcurrent','Lcurrent') ; 
subplot( 2,1,2) ; 
plot( t , r.RUserSpeedCmd , t , r.LUserSpeedCmd);legend('Rspdcmd','Lspdcmd') ; 
