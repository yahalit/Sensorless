function [yew,pitch,roll] = Quat2Euler(q) 
	ysqr = q(3) * q(3) ;

	% roll (x-axis rotation)
	t0 = 2 * (q(1) * q(2) + q(3) * q(4));
	t1 = 1 - 2 * (q(2) * q(2) + ysqr);
	roll = atan2(t0, t1);

	% pitch (y-axis rotation)
	t2 = 2 * (q(1) * q(3) - q(4) * q(2));
	pitch = asin(t2) ;

	% yew (z-axis rotation)
	t3 = 2 * (q(1) * q(4) + q(2) * q(3));
	t4 = 1 - 2 * (ysqr + q(4) * q(4));
	yew = atan2(t3, t4);

end