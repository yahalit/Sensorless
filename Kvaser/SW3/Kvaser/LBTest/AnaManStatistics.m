r = load('liran8.mat') ; 
r = r.RecStr ; 
s = r.C2_ManStatistics ; 
r.PumpOn = bitand( s , 1 ) ; 
r.IsDepleted = bitand( s , 2 )/2 ; 
r.NoSuck1 = bitand( s , 4 )/4 ; 
r.IsHolding = bitand( s , 8 )/8 ; 

r.LaserMedianValid = bitand( s , 16 )/16 ; 
r.State = bitand( s , 32*31 )/32 ; 
r.PumpCmd = bitand( s , 1024 )/ 1024 ; 
r.SuckRequest = bitand( s , 2048*7 )/ 2048 ; 

r.StopError = bitand( s , 63 * 2^16 )/ 2^16  ; 

figure(1000); 
t = r.t ; 
subplot( 3,1,1) ; 
d = 0.04 ; 
plot( t , r.PumpOn , t , r.IsDepleted + d  , t , r.NoSuck1 + d * 2 , t , r.IsHolding + d * 3 ,...
    t , r.LaserMedianValid + d * 4 , t , r.PumpCmd + d * 5 , t , r.SuckRequest/4 + d * 6  ) ; 
set( gca,'ylim',[-0.1,1+8*d])
legend( 'Pumpon' ,'depleted','nosuck','hold','laservalid','PumpCmd','SuckRequest') ;
subplot( 3,1,2) ; 
plot( t , r.State ) ; set( gca,'ylim',[0,15]) ; grid on ;  
subplot( 3,1,3) ; 
plot( t , r.C2_y , t , r.C2_LaserDistMedian ) ; 

