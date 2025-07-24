
% R 
%     V = Vvec{seq};
%     Cur = Cvec{seq};
%     State = Svec{seq};
% Equation: Cur(k+1) = Cur(k) + (L0 + L1 * Cur + L2 * Cur^2)  *( V - I * R ) ; 

ind1 = 2:length(V) ;

veff = V(ind1) - Cur(ind1) * R ; 
ceff = Cur(ind1) ; 
H    = [ veff , veff.* ceff ] ; % , veff .* (ceff.^2) ] ;
Y    = diff( Cur) / Ts  ; 
tht  = (H' * H) \ H' * Y  ;
tht = [tht ; 0];

figure(seq+10) ; 
CurSim = Cur * 0 ; 
plot( t , Cur , t , CurSim ) ;


