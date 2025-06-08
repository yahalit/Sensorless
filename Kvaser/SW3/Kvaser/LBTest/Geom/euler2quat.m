function quat = euler2quat(yaw, pitch,roll)
    quat2 = zeros(1,4);
    cy = cos(yaw/2) ;
    sy = sin(yaw/2) ;

    cp = cos(pitch/2);
    sp = sin(pitch/2);

    cr = cos(roll/2);
    sr = sin(roll/2);

    quat2(1) = cp*cr ;
	quat2(2) = cp*sr ;
	quat2(3) =  sp *cr ;
	quat2(4) = -sp * sr ;

    quat(1) = cy*quat2(1) - sy * quat2(4) ;
	quat(2) = cy*quat2(2) - sy * quat2(3) ;
	quat(3) = cy*quat2(3) + sy*quat2(2) ;
	quat(4) = cy*quat2(4) + sy*quat2(1) ;

	if ( quat(1) < 0 )
	
		quat(1) = -(quat(1)) ;
        quat(2) = -quat(2) ; 
        quat(3) = quat(3) ; 
        quat(4) = quat(4) ;
    end

end

