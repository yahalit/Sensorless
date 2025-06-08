function r = Quat2Rot( q) 

    qri = 2 * q(1) * q(2) ;
    qrj = 2 * q(1) * q(3) ;
    qrk = 2 * q(1) * q(4) ;
    qii = 2 * q(2) * q(2) ;
    qij = 2 * q(2) * q(3) ;
    qik = 2 * q(2) * q(4) ;
    qjj = 2 * q(3) * q(3) ;
    qjk = 2 * q(3) * q(4) ;
    qkk = 2 * q(4) * q(4) ;

    r = zeros(3,3) ; 
    r(1,1) = 1 - qjj - qkk ;
    r(1,2) = qij - qrk ;
    r(1,3) = qik + qrj ;
    r(2,1) = qij + qrk ;
    r(2,2) = 1 - qii - qkk ;
    r(2,3) = qjk - qri ;
    r(3,1) = qik - qrj ;
    r(3,2) = qjk + qri ;
    r(3,3) = 1 - qii - qjj ;
end
