function [TW,tilt] = SolveActualTrackWidth(L ,  r ,  theta1_in ,  theta2_in  )

%  * Solve track width M for given leg angle theta
%  * L : Nominal shoulder distance
%  * r : Leg length

    if ( theta1_in <= theta2_in )
    
        theta1 = theta1_in ;
        theta2 = theta2_in ;
        dir = 1 ;
    else
        theta1 = theta2_in ;
        theta2 = theta1_in ;
        dir = -1 ;
    end

    a = L + r * sin(theta1) + r * sin(theta2);
    b = r * ( cos(theta1) - cos(theta2)) ;
    TW = sqrt(a * a + b * b ) ;
    u =  sqrt( L*L+r*r+2*r*L*sin(theta1) )  ;

    theta_3 = solveCosines(u,r,L) ;
    theta_4 = solveCosines(u,TW,r) ;

    tilt = ( pi/2 - (theta_3 + theta_4 + theta1) ) * dir   ;
end


function out = solveCosines(   a,  b ,  c )
    d =  ( a *a + b * b  - c* c ) / (2.0*a*b);
    if ( abs(d) >= 1.0  )
        out = pi ;
    else
        out = acos( d ) ;
    end
end

