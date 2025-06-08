q= zeros(4,1) ;

qx = [0 ;1 ;0 ;0]; 
qz = [0 ;0 ;0 ;1]; 
qf = [-0.165896132693415 ;0 ;0.986143231562925 ;0]; 

q(1) = FetchObj( [hex2dec('2204'),112] , DataType.float , 'q0' ) ; 
q(2) = FetchObj( [hex2dec('2204'),113] , DataType.float , 'q1' ) ; 
q(3) = FetchObj( [hex2dec('2204'),114] , DataType.float , 'q2' ) ; 
q(4) = FetchObj( [hex2dec('2204'),115] , DataType.float , 'q3' ) ; 

qt = QuatOnQuat( q, qf) ; 
qt
[y,p,r] = Quat2Euler(qt) 

