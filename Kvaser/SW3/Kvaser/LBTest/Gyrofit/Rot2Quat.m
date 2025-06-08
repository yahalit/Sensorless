function q =  Rot2Quat(mat  )
    t = mat(1,1)+mat(2,2)+mat(3,3) ; %  (trace of mat)
    r = sqrt(1+t) ;
    q(1) = 0.5*r ;
    q(2) = 0.5*sqrt(1+mat(1,1)-mat(2,2)-mat(3,3)) ; 
    if ( mat(3,2)-mat(2,3) <= 0 )  
        q(2) = -q(2) ; 
    end
    q(3) = 0.5*sqrt(1-mat(1,1)+mat(2,2)-mat(3,3)) ; 
    if (mat(1,3)-mat(3,1) <= 0 )
        q(3) = -q(3) ; 
    end
    q(4) = 0.5*sqrt(1-mat(1,1)-mat(2,2)+mat(3,3)) ; 
    if (mat(2,1)-mat(1,2) <= 0 )
        q(4) = -q(4) ;
    end 
end