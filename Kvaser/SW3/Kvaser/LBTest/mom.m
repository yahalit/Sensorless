x = load('momo.mat') ;
t = x.t ; r = x.RecStr ; 
figure(10) ; plot( t, r.RWheelEncPos-r.RWheelEncPos(1), t, r.LWheelEncPos-r.LWheelEncPos(1))
figure(10) ; plot( t, r.RWheelEncPos-r.RWheelEncPos(1), t, r.LWheelEncPos-r.LWheelEncPos(1)) ; legend('r','l') 
figure(11) ; plot( t, r.RwSpeedCmdAxis, t, r.LwSpeedCmdAxis) ; legend('r','l')
figure(12) ; plot( t, r.RwCurrent, t, r.LwCurrent) ; legend('r','l')
