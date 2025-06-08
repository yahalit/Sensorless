function  [ pS , Fail] = FindSplineRoute( x1,  y1,  tht1,  x2,  y2,  tht2 , Geom ) 

	pS = [] ; 
    % The reference frame is the line connecting the start point and the end point
    tht = atan2( y2 - y1 , x2 - x1 ) ;

    % Make the entry and exit angles relative to the connection line
    tht1 =   (tht1 - tht)  ; 
    tht2 =   (tht2 - tht)  ;

    s1 = sin(tht1) ; c1 = cos(tht1) ;
    s2 = sin(tht2) ; c2 = cos(tht2) ;

    if ( abs(c1) < 0.01  || abs(c2) < 0.01   )
     % Thats impossible
        Fail = -1;
        return  ;
    end
    d1 = s1 / c1 ;
    d2 = s2 / c2 ;

    x0 = norm ( [x2 - x1, y2 - y1]) ;
    if (abs(x0) <= 1e-3)
     % Trivial case - straight segment
        return ; % No curvature
    end
	
    pS = struct ( 'a' , (d1+d2)/(x0*x0) , 'b' , -(2*d1+d2)/x0 ,'c' , d1 ) ;

    junk = ( 1 + d1 * d1 );
    slen = x0 ;
    curv0 = 2.0 *pS.b / ( junk * sqrt(junk) ) ;
    
	dp = (3*pS.a*slen +2*pS.b)*slen+pS.c ;
	d2p = 6*pS.a*slen+2*pS.b ;
	junk = ( 1 + dp * dp );
	curvf = d2p / ( junk * sqrt(junk) ) ;
 		
	Fail = 0;
	
	C = curv0 ; 
% 	Geom = struct ( 'Center2WheelDist',0.251, 'SteerColumn2WheelDist' , 0.065 )  ; 
	ManRouteCmd = struct( 'CrabCrawl',1) ; 
	a = Geom.Center2WheelDist ;

	theta  = atan ( C * a ) ;
	pS.RSteer0 = ManRouteCmd.CrabCrawl * ( 1.570796326794897 + theta )   ;
	pS.LSteer0 = ManRouteCmd.CrabCrawl * ( 1.570796326794897 - theta )   ;

	theta  = asin ( curvf * a ) ;
	pS.RSteerf = ManRouteCmd.CrabCrawl * ( 1.570796326794897 + theta )   ;
	pS.LSteerf = ManRouteCmd.CrabCrawl * ( 1.570796326794897 - theta )   ;
    
    pS.curv0 = curv0; 
	pS.curvf = curvf; 
	pS.slen = slen; 
    
    pS.Pars = struct ( 'x1' , x1 , 'y1' , y1 , 'x2' , x2 , 'y2' , y2 , 'tht1', tht1 , 'tht2' , tht2 ) ; 
    
    T = [cos(tht) , -sin(tht) ; sin(tht) , cos(tht) ] ; 
    xv = [0:slen/200:slen] ; 
    yv = ( (pS.a*xv +pS.b).*xv+pS.c ) .* xv ;
    for cnt = 1:length(xv)
        aa = T * [xv(cnt) ; yv(cnt) ]; 
        xv(cnt) = aa(1) ; 
        yv(cnt) = aa(2) ;
    end 
%     figure(1) ; clf ; 
%     plot( xv , yv ); 
%     axis('square') ; axis('equal') ; 
end
