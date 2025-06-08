% SplineTest  = struct( 'StartAz',0.00 , 'TargetAz' , -0.00 , 'TargetLoc' , [    -0.04  , 0.3 ] , ...
%     'MaxLineSpeed' , 0.3 , 'MaxLineAcc' , 0.2 , 'MaxSteerSpeed' , 0.3 ) ; 
SplineTest  = struct( 'StartAz',0.08 , 'TargetAz' , 0 , 'TargetLoc' , [ +0.06 , 0.355 ] , ...
    'MaxLineSpeed' , 0.3 , 'MaxLineAcc' , 0.2 , 'MaxSteerSpeed' , 0.3 ) ; 


Geom = struct ( 'Center2WheelDist',0.251, 'SteerColumn2WheelDist' , 0.06500 ,'rg' ,0.1,'WheelCntRad',722.0860)  ; 

% Estimate the outcomes of our spline 
[ pS , Fail] = FindSplineRoute( 0, 0 ,  SplineTest.StartAz+pi/2,  SplineTest.TargetLoc(1),  SplineTest.TargetLoc(2),  SplineTest.TargetAz+pi/2 , Geom );


Odo =   0; % 1 for measured data 

facw = Geom.rg / Geom.WheelCntRad ;
useact =1 ;         cst =  1; 

if ( Odo ) 

    [s,t] = GetFVars('spline8.mat') ; %#ok<UNRCH>
    H = [s.RWheelDriveEnc,s.RWheelDriveEnc*0+1] ; 
    tht = (H'*H)\H'*s.RWheelEncPos ; 
    resencdrive = 2.757550884373431e+04 ; 
%     figure(1) ; clf 
%     plot( t, s.RWheelEncPos , t , H * tht , '.');

    H = [s.RwSteerCmdAxis,s.RwSteerCmdAxis*0+1] ; 
    tht = (H'*H)\H'*s.RSteerPosEnc ; 

    figure(2) ; clf 
    subplot( 2,1,1); 
    plot( t, s.RSteerPosEnc , '+',t , H * tht , '.');

    subplot( 2,1,2); 
    LsteerH = -H * tht;
    plot( t, s.LSteerPosEnc,'+' , t , LsteerH - LsteerH(1) + s.LSteerPosEnc(1) , '.');

    % Find relation between steer and act angle 
    H = [s.RSteerPosEnc(1) , 1 ; s.RSteerPosEnc(end) , 1] ; thtR = H\[pS.RSteer0;pS.RSteerf];
    H = [s.LSteerPosEnc(1) , 1 ; s.LSteerPosEnc(end) , 1] ; thtL = H\[pS.LSteer0;pS.LSteerf];
    
    if ( useact) 
        RSteer = thtR(1) * s.RSteerPosEnc + thtR(2) ; 
        LSteer = thtL(1) * s.LSteerPosEnc + thtL(2) ; 

        REnc = (s.RWheelEncPos - s.RWheelEncPos(1))  * facw ;
        LEnc = (s.LWheelEncPos - s.LWheelEncPos(1))  * facw ;
    else
        RSteer =  s.RwSteerCmdAxis * thtR(1)  ; 
        LSteer =  s.LwSteerCmdAxis * thtR(1)  ; 

        REnc =  cumsum( s.RwSpeedCmdAxis) * (t(2)-t(1)) / resencdrive * Geom.rg ; 
        LEnc =  cumsum( s.LwSpeedCmdAxis) * (t(2)-t(1)) / resencdrive * Geom.rg ; 

        % Compensation of pole radi 
        REnc = REnc - cst *  (RSteer - RSteer(1) ) * Geom.SteerColumn2WheelDist ;
        LEnc = LEnc + cst *  (LSteer - LSteer(1) ) * Geom.SteerColumn2WheelDist ;
    end 
    
    RSteerm = RSteer; 
    LSteerm = LSteer; 
    REncm = REnc ; 
    LEncm = LEnc ; 
    tv = t ; 
    tm = t ; 
    try 
        cvm = s.LineCurvature  ; 
        vvm = s.LineSpeed ; 
        xvm = s.CrabProfilePos ; 
    catch 
        disp ('No curvature or profile data' ) ; 
    end 
    
else
    % Just theoretical calculation 
    ac = 0.3 * 0.5 ; 
    sl = pS.slen ;  % Total length
    sp = sqrt( 2 * ac * sl/3) ; % Speed, after running 1/3 of interval indesired acceleration from stand still
    ts = 8.192e-3 * 0.01; 
    t1 = sqrt(2*sl/3/ac) ; % Time of acceleration 
    t2 = sl/(3*sp) ; % Time at constant speed 
    tv  = [0:ts:(t2+2*t1)]; %#ok<NBRAK>
    xv = tv * 0 ; vv = tv * 0 ; cv = xv ; lsv = xv ; yv = xv ; dd = xv ; ddd = xv ;  dddd = xv ; ddddd = xv  ; 
    RSteer = pS.RSteer0 + xv ; 
    LSteer = pS.LSteer0 + xv  ; 
    REnc = xv ; LEnc = xv ; 
    REnc0 = 0 ;
    LEnc0 = 0 ; 
    
    for cnt = 1:length(tv)  
        t = tv(cnt) ; 
        
        % Get position on the parameter line as a trapezoidal function of time 
        if ( t < t1 ) 
            xv(cnt) = 0.5 * ac * t^2 ; vv(cnt) = ac * t ; 
        else
            if ( t < t1 + t2 ) 
                xv(cnt) = 0.5 * ac * t1^2 + sp * ( t-t1) ; vv(cnt) = sp  ; 
            else
                xv(cnt) = 0.5 * ac * t1^2 + sp * t2 + sp * (t-t1-t2) - 0.5 * ac * (t-t1-t2)^2; vv(cnt) = sp - ac * (t-t1-t2) ; 
            end 
        end
        
%         if ( t > 1 ) 
%             fff = 1 ; 
%         end 
        
        x  = xv(cnt) ; 
        % Decode the spline and its spatial deriviatives 
        yv(cnt)  = pS.a * x^3 + pS.b * x^2 + pS.c * x ; 
        dp = (3*pS.a*x +2*pS.b)*x+pS.c ;
        d2p = 6*pS.a*x+2*pS.b ;
        junk = ( 1 + dp * dp );
        % Curvature and line speed 
        C = d2p / ( junk * sqrt(junk) ) ;
        cv(cnt) = C ; 
        LineSpeedCmd = vv(cnt) * sqrt (1 + dp * dp  ) ;
        lsv(cnt) = LineSpeedCmd;
        
        a = Geom.Center2WheelDist ;

        theta = atan ( C * a ) ;

        ctheta =  C * Geom.SteerColumn2WheelDist   ; % cos( theta );
        RSteer(cnt) = ( 1.570796326794897 + theta )   ;
        LSteer(cnt) = ( 1.570796326794897 - theta )   ;
        
        % Steering rate for speed correction 
        if ( cnt > 1 ) 
            dRSteer = RSteer(cnt) - RSteer(cnt-1) ; 
            dLSteer = LSteer(cnt) - LSteer(cnt-1) ; 
        else
            dRSteer = 0  ; 
            dLSteer = 0 ; 
        end 
        
%         cst =  1; 
        dd(cnt) = LineSpeedCmd * ( sqrt(1.0 +  C * a* C * a)  - ctheta  ) * ts ; 
        ddd(cnt) = - cst *  dRSteer * Geom.SteerColumn2WheelDist ; 
        dddd(cnt) = LineSpeedCmd * ( sqrt(1.0 +  C * a* C * a) + ctheta  ) * ts ; 
        ddddd(cnt) =  cst *  dLSteer * Geom.SteerColumn2WheelDist ; 
        REnc(cnt) = REnc0 + LineSpeedCmd * ( 1.0 - ctheta  ) * ts - cst *  dRSteer * Geom.SteerColumn2WheelDist ;
        LEnc(cnt) = LEnc0 + LineSpeedCmd * ( 1.0 + ctheta  ) * ts + cst *  dLSteer * Geom.SteerColumn2WheelDist ;
        REnc0 = REnc(cnt) ; 
        LEnc0 = LEnc(cnt) ; 
        
    end 
    t = tv ; 
end
dREnc = diff( REnc ) ; 
dLEnc = diff( LEnc ) ;



% Simulation of results 
% Do the integration 
Rc = Geom.SteerColumn2WheelDist;
dir = 0 * RSteer ; 
xR = 0 * RSteer - Rc * sin(pS.RSteer0) ; 
yR = 0 * RSteer + Geom.Center2WheelDist + Rc * cos(pS.RSteer0); 
xL = 0 * LSteer + Rc * sin(pS.LSteer0) ; 
yL = 0 * LSteer - Geom.Center2WheelDist -  Rc * cos(pS.LSteer0); 
if  Odo == 0  
    dir = dir + SplineTest.StartAz ; 
end

xRj = 0 * RSteer  ; 
yRj = 0 * RSteer + Geom.Center2WheelDist ;
xLj = 0 * LSteer  ; 
yLj = 0 * LSteer - Geom.Center2WheelDist ; 



for cnt = 1:length(t) 
    
%     if t(cnt) >1 
%         xxx = 9 ; 
%     end 
    
    if ( cnt > 1) 
        ThetaB = dir(cnt-1) ; 
        dThetaR = RSteer(cnt) - RSteer(cnt-1);
        dThetaL = LSteer(cnt) - LSteer(cnt-1);
        DeltaR = dREnc (cnt-1) ; 
        DeltaL = dLEnc (cnt-1) ;
    else
        ThetaB = dir(1)  ; 
        dThetaR = 0 ; 
        dThetaL = 0 ; 
        DeltaR = 0 ; 
        DeltaL = 0 ; 
    end
    
    ThetaR = RSteer(cnt)+ ThetaB ; % Absolute wheel angles
    ThetaL = LSteer(cnt)+ ThetaB ; 
    
    % Motion of right wheel 
    dxr = cos( ThetaR) * DeltaR ; % + Rc * cos(ThetaR) * dThetaR ;
    dyr = sin( ThetaR) * DeltaR ; % + Rc * sin(ThetaR) * dThetaR ;
    
    % Motion of left wheel 
    dxl = cos( ThetaL) * DeltaL ; % - Rc * cos(ThetaL) * dThetaL ;
    dyl = sin( ThetaL) * DeltaL ; % - Rc * sin(ThetaL) * dThetaL ;
    
    % Next wheel coordinates 
    if (cnt > 1 ) 
        xRn = xR(cnt-1) + dxr ; 
        yRn = yR(cnt-1) + dyr ; 
        xLn = xL(cnt-1) + dxl ; 
        yLn = yL(cnt-1) + dyl ; 
    else
        xRn = xR(cnt) ; 
        yRn = yR(cnt) ; 
        xLn = xL(cnt) ; 
        yLn = yL(cnt) ;         
    end
    
    % Nominal locations (suppose that robot center is at (0,0) and shouldered aligned along the y axis 
    xRloc = - Rc * sin(RSteer(cnt)) ; 
    yRloc = Geom.Center2WheelDist + Rc * cos(RSteer(cnt)); 
    xLloc =   Rc * sin(LSteer(cnt)) ; 
    yLloc = -Geom.Center2WheelDist -  Rc * cos(LSteer(cnt));  
    % Distance between wheel touch points 
    distf = norm( [ xRloc - xLloc , yRloc - yLloc ]) / norm( [ xRn - xLn , yRn - yLn ])   ; 
        
    % direction of nominal L->R touch w.r.t robot soulders 
    waf_nom   = atan2( yRloc - yLloc, xRloc - xLloc ) ; 
    
    % Center of wheel touch points 
    xcn = ( xRn + xLn) / 2 ;
    ycn = ( yRn + yLn) / 2 ;
    
    % Normalize distance between touch points 
    xR(cnt) = xcn + (xRn-xcn) * distf ;
    yR(cnt) = ycn + (yRn-ycn) * distf ;
    xL(cnt) = xcn + (xLn-xcn) * distf ;
    yL(cnt) = ycn + (yLn-ycn) * distf ;
    
    % Connection of actual L-R touch 
    waf_act = atan2(yR(cnt)-yL(cnt),xR(cnt)-xL(cnt) )  ;
    
    % Rotation angle from nom to act 
    tht_nom_2_act = waf_act - waf_nom ; 
    mm = [cos(tht_nom_2_act) , -sin(tht_nom_2_act) ; sin(tht_nom_2_act) , cos(tht_nom_2_act)  ];
    
    % Transformation offset 
    TOffset = mm \ [xR(cnt);yR(cnt)] - [xRloc;yRloc] ; 
    
    % Joints 
    aa = mm * ( [0;Geom.Center2WheelDist] + TOffset ) ; 
    bb = mm * ( [0;-Geom.Center2WheelDist] + TOffset ) ; 
    
    xRj(cnt) = aa(1) ; 
    yRj(cnt) = aa(2) ; 
    xLj(cnt) = bb(1) ; 
    yLj(cnt) = bb(2) ; 

    dir_shoulder = atan2(yRj(cnt)-yLj(cnt),xRj(cnt)-xLj(cnt) ) - pi / 2 ;  
          
    dir(cnt) = dir_shoulder ;   
end 

xc = (xRj + xLj) /2 ; 
yc = (yRj + yLj) /2 ; 
dist = sqrt( xc.^2 + yc.^2) ; 


stt = SplineTest.StartAz ; 
T   = [cos(stt), -sin(stt) ; sin(stt) , cos(stt) ] ; 
Tc  = T * [xc ; yc ] ; 

figure(3) ; clf; 
hold on 

xxx = T * [xR; yR]; yyy =  T * [xL ; yL]; zzz =T * [xc ; yc ]; 
plot( xxx(1,:) , xxx(2,:)  , yyy(1,:) , yyy(2,:) , zzz(1,:) , zzz(2,:)  ) ;  
dd = [1:round(length(t)/20):length(t), length(t) ] ; 
for cnt = 1:length(dd) 
    n = dd(cnt) ; 
    xxx = T * [xL(n) xLj(n) xRj(n) xR(n) ;yL(n) yLj(n) yRj(n) yR(n)];
    plot( xxx(1,:), xxx(2,:) , Tc(1,n) , Tc(2,n) ,'rd') ; 
end


axis square ; axis equal ; grid on ; 
figure(4) ; clf 
plot ( dist , dir + stt ) ; 
xlabel('Distance') ; ylabel('Direction')
title( ['xc (desired:',num2str(SplineTest.TargetLoc(1)) ,') :', num2str(Tc(1,end)) , ...
    ' yc (desired:',num2str(SplineTest.TargetLoc(2)) ,' ) :',num2str(Tc(2,end)), ....
    ' az (desired: ',num2str(SplineTest.TargetAz) ,') :',num2str(dir(end)+stt)]) ; 
grid on

 



% Get act curvature 
% cest = cv * 0 ;
% tht1 = cest ; 
% s1 = cest ; 
% for cnt = 2:length(cv) 
%     tht1(cnt) = atan2( yc(cnt)-yc(cnt-1) ,  xc(cnt)-xc(cnt-1)   )  ; 
%     s1(cnt)   = norm( [yc(cnt)-yc(cnt-1) ,  xc(cnt)-xc(cnt-1)] ) ;
% end
% tht1 (1) = tht1(2) ; 
% s1(1) = s1(2) ; 
% for cnt = 2:length(cv) 
%     cest(cnt) = 2 * ( tht1(cnt) - tht1(cnt-1) ) / ( s1(cnt) + s1(cnt-1) )  ; 
% end
% 
% 
%     



