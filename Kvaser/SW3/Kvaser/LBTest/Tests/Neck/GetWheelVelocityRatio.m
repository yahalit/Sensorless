function [rat,zone , tilt, dtilt, bwvd  ] = GetWheelVelocityRatio(s) 
Geom = struct () ;
Geom.DistanceFromShoulderJoint2Slidewheel = 0.05 ; 
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

        DELTA = 0.00390625; 
        INV_DELTA = 256.0 ; 

    if (theta <= 1.570796326794897)
     % Leader on the arc , other wheel on floor
        zone = 1;
        ks = Ra * sin(theta); 
        kc = Ra * cos(theta);
        kc1 = Ra * cos(theta+DELTA);
        
        kc11 = kc - R + a + d;
        kc12 = kc11 - 2 * d;
        dtht = -0.5*ks*(kc11 + kc12) / sqrt(-kc11*kc12) + kc;
        bwv = dtht * ArcCurvature;

        dy = Ra - kc ;
        tilt  = asin ( dy / d ) ;
        
        tilt2 = asin ( (Ra-kc1)/d) ;      
        dtilt = (tilt2-tilt)*INV_DELTA/R ; 

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
        
        r = Ra ;
        r2 = r * r ; 
        d2 = d * d ; 

        p = passdist+DELTA ; 
        p2 = p * p ; 
        aa = 4*(p2 + r2) ; 
        bb = 2*p*(-d2 + p2 + 2*r2) ; 
        cc = d2*(d2 - 2*p2 - 4*r2) + p2*(p2 + 4*r2)  ; 
        g  = (-bb + sqrtf(max(bb*bb-aa*cc,0))) / aa; 
        a = sqrt(r2-g*g) ; 
        b2 = r-a ;
        f2 = g+p ; 
        
        p = passdist ; 
        p2 = p * p ; 
        aa = 4*(p2 + r2) ; 
        bb = 2*p*(-d2 + p2 + 2*r2) ; 
        cc = d2*(d2 - 2*p2 - 4*r2) + p2*(p2 + 4*r2)  ; 
        g  = (-bb + sqrtf(max(bb*bb-aa*cc,0))) / aa; 
        a = sqrt(r2-g*g) ; 
        b1 = r-a ;
        f1 = g+p ; 

        bwvd = sqrt((f2+DELTA-f1)^2+(b2-b1)^2) * INV_DELTA ; 
        tilt = atan2(f1,b1); 
        dtilt = ( atan2(f2,b2) - tilt) * INV_DELTA ; 
    
        bwv = bwvd ; 
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
