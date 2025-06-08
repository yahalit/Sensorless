function [g , a,p] = fitsin( f , t , u , y , nfig)
u = u(:) ; 
y = y(:) ; 
z = 0* u ; 
t = t(:) ; 
w =  2 * pi * f ; 
H = [z+1 , 2 * ( t - mean(t) ) / max(t) , sin(w*t) , cos(w*t)] ; 
thtu = (H' * H)\H' * u ;
thty = (H' * H)\H' * y ;
pu = atan2( thtu(3),thtu(4));
py = atan2( thty(3),thty(4));
au = norm( [thtu(3),thtu(4)]);
ay = norm( [thty(3),thty(4)]);
a  = ay / au  ;
p  = -(py-pu)+pi ;

g  = a * exp( sqrt(-1) * p ) ; 

if nargin > 4 && nfig 
    figure(nfig) ; clf 
    subplot( 2,1,1); 
    plot( t , u ,t ,  au * cos(w * t - pu) ,'.') ;legend('s','f')
    subplot(2,1,2) ; 
    plot( t , y ,t ,  ay * cos(w * t - py) ,'.') ;legend('s','f')
end

end 