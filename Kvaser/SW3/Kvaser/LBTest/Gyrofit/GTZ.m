d = 0.0811578 ; 
alpha = asin( 0.1658) * 2 - d  ;  % Was  + 

T1 = [cos(alpha) 0 -sin(alpha) ; 0 , 1 , 0 ; sin(alpha) , 0 , cos(alpha) ] ; 
T2 = [0 , 1 , 0 ;  1 , 0 , 0 ; 0 , 0, -1] ; 
T3 = T2 ; % eye(3) ; % T1 * T2 ; 

qGyro2Body = Rot2Quat(T3) ;
qPre = [ 9.863542089242091e-01     8.108548164598666e-03     1.644317449898964e-01    -1.351748400297069e-03] ; 
qsys = [0 1 1 0 ] / sqrt(2) ; 
qYosef = QuatOnQuat(qsys,InvertQuat(QuatOnQuat( qsys , QuatOnQuat(qPre ,qsys)))) ; 
qYosef1 = QuatOnQuat(InvertQuat(qPre),qsys) ; 

% {'UsecTimer'  'RawQuat0'  'RawQuat1'  'RawQuat2'  'RawQuat3'  'RawW0'  'RawW1'  'RawW2'}
y = load('Liran8.mat') ; 

t = y.t ; 
r = y.RecStr ; 

sgn = 1; 
figure(1) ; clf 
figure(2) ; clf 

figure(1) ; 
% subplot( 3,1,1) ; 
w = [r.RawW0; r.RawW1 ; r.RawW2] ; 
plot( t , w ) ; legend('x','y','z' ) ; ylabel('Y') ; grid on 

yyy = t * 0 ; ppp = yyy  ; rrr = yyy ; 
for cnt = 1:length(t) 
    wg = [r.RawW0(cnt) ; r.RawW1(cnt) ; r.RawW2(cnt)  ] ; 
    wb = RotateVecByQuat( qYosef , wg )  ; 
    yyy(cnt) = wb(1) ; 
    ppp(cnt) = wb(2) ; 
    rrr(cnt) = wb(3) ; 
end 
figure(2) ; 
% subplot( 3,1,1) ; 
plot( t , yyy , t , ppp , t , rrr ) ; legend('R','P','Y' ) ; ylabel('Omega') ; grid on 


