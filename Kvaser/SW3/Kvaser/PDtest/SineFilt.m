wn1 = (50/20)*16 * 2 * pi ;
xi1 = 0.3 ; 

sys1 = tf ( [wn1,0] , [1  2*wn1*xi1 , wn1^2] ) ; 

wn2 = (50/20)* 24 * 2 * pi  ;
xi2 = 0.3 ; 
sys2 = tf ( [wn2,0] , [1  2*wn2*xi2 , wn2^2] ) ; 


% wn3 = (50/20)*24 * 2 * pi ;
% xi3 = 0.3 ; 
% sys3 = tf ( [wn3, 0 ] , [1  2*wn3*xi3 , wn3^2] ) ; 
% 
figure(1) ; clf ; 
bode ( sys1 + sys2  ); 
grid on

dsys = c2d(sys1 + sys2 , 4.096e-3 );
