function [FollowerPos,zone,armFollower] = GetFollowerByLeader(leaderPos)

TrackWidthCtl = struct('RetractedWidth',0.506) ;
SysState = struct('TrackWidthCtl',TrackWidthCtl) ; 
Geom = struct('DistanceFromShoulderJoint2Slidewheel',0.05,'ClimbArcRadi',0.22) ; 
    d  = SysState.TrackWidthCtl.RetractedWidth  ; % Because we always climb retracted 
    Ra = Geom.ClimbArcRadi - Geom.DistanceFromShoulderJoint2Slidewheel;

    % find position to arm follower switch
    s = leaderPos - Geom.ClimbArcRadi * 1.570796326794897  ;
    s1 = sqrt(d*d-Ra*Ra) - Ra  ;

if ( s < 0 )
     % Leader on the arc, follower is straight
        tht = leaderPos / Geom.ClimbArcRadi ;
        dy =  ( 1 - cos(tht)) * Ra ;
        FollowerPos = Ra * sin(tht) - sqrt( max ( d * d - dy * dy,0)  )    ;
        zone = 1 ;
        armFollower = 1 ;
elseif ( s < s1 )
     % Leader and follower on straight segments
        FollowerPos = Ra - sqrtf(d * d - ( s + Ra)*(s+Ra)) ;
        zone = 2 ;
        armFollower = 1 ;
else
  %Leader on the straight, follower on the arc
    if  ( s < d )
    
        % The equation is a * sin(tht) + b * cos(tht) + c = 0 , with a > 0
        c = 2 * Ra * Ra + s * s - d  *d ;
        b = -2 * Ra * Ra  ;
        a = 2 * Ra * s ;
        dd = sqrtf (a * a + b * b - c * c ) ;
        tht =  1.570796326794897  - atan2(-a*c-dd*b , -b * c + dd * a ) ;
        armFollower = 0 ; 
        if (tht < 0.7854 ) 
            armFollower = 1 ;
        end

        u = sqrt( s^2+Ra^2) ;
        gamma = acos((d^2-u^2-Ra^2)/(-2*u*Ra)) ;
        alpha = atan( s / Ra ) ; 
        tht = pi/2 + alpha - gamma ; 

        FollowerPos = tht * Geom.ClimbArcRadi ;
        zone = 3 ;
    else
    
         zone = 4 ;
         armFollower = 0 ;
         FollowerPos = leaderPos - d ;
    end
end
