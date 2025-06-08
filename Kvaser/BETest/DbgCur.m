r = load('SigRecSave.mat'); 
r = r.RecStr ; 
t = r.t ; 
figure(20) ; 
clf ; 
subplot( 2,1,1) 
plot( t , r.PhaseCur0  , t , r.PhaseCur1  , t , r.PhaseCur2 )
subplot( 2,1,2) 
plot( t , r.PhaseCur0 +  r.PhaseCur1  +  r.PhaseCur2 )
