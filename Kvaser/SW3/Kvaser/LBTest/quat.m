function [yaw, pitch, roll] = quat(quat_array)
ysqr = quat_array(3)*quat_array(3);

t0 = 2.0 * (quat_array(1) * quat_array(2) + quat_array(3) * quat_array(4));
t1 = 1.0 - 2.0 * (quat_array(2) * quat_array(2) + ysqr);
roll = atan2(t0, t1);

t2 = 2.0*(quat_array(1) * quat_array(3) - quat_array(4) * quat_array(2));
pitch = asin(t2) ;

t3 = 2.0 * (quat_array(1) * quat_array(4) + quat_array(2) * quat_array(3));
t4 = 1.0 - 2.0 * (ysqr + quat_array(4) * quat_array(4));
yaw = atan2(t3, t4);

end

