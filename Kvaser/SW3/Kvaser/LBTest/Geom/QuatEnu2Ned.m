function q2 = QuatEnu2Ned(q1) 
    q3t(1) =  - q1(2) - q1(3)  ;
    q3t(2) =    q1(1) + q1(4)  ;
    q3t(3) =    q1(1) - q1(4) ;
    q3t(4) =    q1(3) - q1(2) ;
    q2 = NormalizeQuat(q3t) ; 
end 