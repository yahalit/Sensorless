function [rat,zone , tilt, dtilt, bwvd  ] = GetWheelVelocityRatio2(s) 
Geom = struct () ;
Geom.DistanceFromShoulderJoint2Slidewheel = 0.0685 ; 
Geom.Center2WheelDist=0.251;
Geom.ClimbArcRadi=0.22025;
tilt    = 0 ; dtilt = 0; bwvd = 0  ;
    if (s <= 0)
    % Never entered
        zone = 0;
        rat = 1.0;
        return ; 
    end


    R = Geom.ClimbArcRadi;
    ArcCurvature = 1.0  / R;
    theta = s * ArcCurvature;
    a = Geom.DistanceFromShoulderJoint2Slidewheel;
    d = 2 * Geom.Center2WheelDist  ;
    Ra = R - a;


    if (theta <= 1.570796326794897)
     % Leader on the arc , other wheel on floor
        zone = 1;
        ks = Ra * sin(theta); 
        kc = Ra * cos(theta);
        kc1 = Ra * cos(theta+0.005);
        
        kc11 = kc - R + a + d;
        kc12 = kc11 - 2 * d;
        dtht = -0.5*ks*(kc11 + kc12) / sqrt(-kc11*kc12) + kc;
        bwv = dtht * ArcCurvature;

        dy = Ra - kc ;
        tilt  = asin ( dy / d ) ;
        
        tilt2 = asin ( (Ra-kc1)/d) ;      
        dtilt = (tilt2-tilt)/0.005/R ; 

        rat = bwv;
        t = theta ;
        bwvd = (cos(t)*Ra + Ra^2*(1 - cos(t))*sin(t)/sqrt(d^2 - Ra^2*(1 - cos(t))^2))/R ; 
        return ; 
    end

    passdist = s - 1.570796326794897  * R;

    if (passdist >= d)
     % Over the rainbow, just run straight and square
        zone = 4;
        tilt = 1.570796326794897   ;
        dtilt = 0 ; 
        rat = 1;
        bwvd = 1 ; 
        return ; 
    end

    y2a = s - (1.570796326794897  - 1.0 ) * R - a; % Difference of height between the shoulders
    sq = d*d - y2a * y2a;                           % Horizontal difference between shoulders

    if (sq > 0)
    
        sq = sqrt(sq); %  Horizontal difference between shoulders
        X1Cand = R - a - sq;
    else
    
        X1Cand = 1; % Stam, just need be > 0
    end

    if (X1Cand > 0)
    
        zone = 3;
        % Second wheel is on the arc - left the ground already
        x0 = -passdist;
        aa = 2 * Ra * Ra; bb = 2 * x0 * Ra; bb2 = bb * bb;
        cc = d * d - x0 * x0 - aa;
        Delta = sqrt(bb2 * (aa * aa + bb2 - cc * cc));
        theta = atan2((-bb2 * cc - Delta*aa) / bb, -aa*cc + Delta);
        ks =  Ra *sin(theta); 

        passdist2 = passdist + 5e-3 ; 
        x0 = -passdist2;
        bb = 2 * x0 * Ra; bb2 = bb * bb;
        cc = d * d - x0 * x0 - aa;
        Delta = sqrt(bb2 * (aa * aa + bb2 - cc * cc));
        theta2 = atan2((-bb2 * cc - Delta*aa) / bb, -aa*cc + Delta);
        ks2 =  Ra *sin(theta2); 

        p = passdist ; 
        r = Ra ; 
        g = roots([4*p^2 + 4*r^2,(-4*d^2*p + 4*p^3 + 8*p*r^2), d^4 - 2*d^2*p^2 - 4*d^2*r^2 + p^4 + 4*p^2*r^2]) ; 
        g1 = max(g) ; 
        a1 = sqrt(r^2-g1^2) ; 
        b1 = r-a1 ;
        f1 = g1+p ; 

        p = passdist + 0.005 ; 
        r = Ra ; 
        g = roots([4*p^2 + 4*r^2,(-4*d^2*p + 4*p^3 + 8*p*r^2), d^4 - 2*d^2*p^2 - 4*d^2*r^2 + p^4 + 4*p^2*r^2]) ; 
        g1 = max(g) ; 
        a1 = sqrt(r^2-g1^2) ; 
        b2 = r-a1 ;
        f2 = g1+p ; 
        bwvd = sqrt((f2+0.005-f1)^2+(b2-b1)^2) / 0.005 ; 
        
        
        % %         g2 = max(g) ; 
% %         a2 = sqrt(r^2-g2^2) ; 
% %         b2 = r-a2 ;
% %         f2 = g2+p;
% %         plot( [0,a1,r,0,0],[g1,0,f1,f1,g1],[0,a2,r,0,0],[g2,0,f2,f2,g2]+g1-g2 ) ; legend('1','2') ; 
% %         axis equal 
%         
        tht2 = atan(f1/b1) ; 
        
        kc = Ra*cos(theta);
        kc11 = kc - R + a + d;
        kc12 = kc11 - 2 * d;
        dtht = -0.5 *ks*(kc11 + kc12) / sqrt(-kc11*kc12) + kc;
        bwv = R / dtht;

        dy = passdist + ks ;
        tilt = asin( dy / d ) ;
        dtilt = ( asin((passdist2 + ks2)/d)- tilt) / 5e-3 ; 
    else
    
        zone = 2;
        dy = Ra + passdist ;
        tilt = asin ( dy / d ) ;
        dtilt = 1/sqrt(d*d-dy*dy) ; 
        bwv  = y2a / sq;
        
        dx = -sqrt(d^2-(Ra+passdist+5e-3)^2 ) + sqrt(d^2-(Ra+passdist)^2 ); 
        bwvd = dx / 5e-3 ; 
        
    end
    rat = bwv;
end
