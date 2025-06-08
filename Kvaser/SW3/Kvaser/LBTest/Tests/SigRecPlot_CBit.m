x = load('SigRecSave.mat')
r = x.RecStr 

figure(99) ; clf
subplot(3,1,1);
t = r.t ; 
next = r.C2_RotatorCBitField  
plot(t, next.MotionConverged, t, next.ProfileConverged + 0.05 , t , next.MotorOn + 0.1) ;  
legend('MotionConv','ProfConv','MotorOn') ;

subplot(3,1,2);
next = r.C2_TapeArmCBitField ; 
plot(t, next.MotionConverged, t, next.ProfileConverged + 0.05 , t , next.MotorOn + 0.1) ;  
legend('MotionConv','ProfConv','MotorOn') ;

subplot(3,1,3);
next = r.C2_TapeArmCBitField ; 
plot(t, next.MotionConverged, t, next.ProfileConverged + 0.05 , t , next.MotorOn + 0.1) ;  
legend('MotionConv','ProfConv','MotorOn') ;

