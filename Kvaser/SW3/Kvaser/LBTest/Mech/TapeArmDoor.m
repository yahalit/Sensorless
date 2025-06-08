r1 = 18 ; 
r2 = 58 ; 
r3 = 12.13 ; 
x0 = -64.44 ; 
y0 = -10.22 ; 
DoorTiltDeg =  115.89; 
thtOffset = 0; 
thtVec = (-89:0.1:20) + thtOffset; 
x1Vec  = thtVec * 0 ; 
y1Vec = x1Vec ; 
outVec = x1Vec ;
nTht = length(thtVec); 
for cnt = 1:nTht
    tht = ( thtVec(cnt) - thtOffset )  * pi / 180; 
    x1 = x0 + cos(tht) * r1 ; 
    y1 = y0 + sin(tht) * r1 ; 
    x1Vec(cnt) = x1 ; 
    y1Vec(cnt) = y1 ; 
    delta = atan2(-y1,-x1) ; 
    c = norm([y1,x1]) ; 
    carg = (c^2+r3^2-r2^2)/(c * r3 * 2); 
    if abs( carg) > 1 
        error('Cant do this angle') ; 
    end 

    gamma = acos( carg )  ;
    outVec(cnt) = ( delta + gamma )* 180/pi - 180 + DoorTiltDeg ; 
end 

figure(2); clf
plot(thtVec, outVec) ; grid on 
xlabel('Motor') ; ylabel('Door') ; 


thtVec = (-15:94) ; 
outVec = thtVec * 0 ;
% thtVec = -45 + DoorTiltDeg ; 
nTht = length(thtVec); 
for cnt = 1:nTht
    thtDeg = thtVec(cnt);
    tht = ( thtDeg - DoorTiltDeg ) * pi / 180; 
    x2 = cos(tht) * r3 ; 
    y2 = sin(tht) * r3 ; 
    delta = atan2(y2-y0,x2-x0) ; 
    c = norm([y0-y2,x0-x2]) ; 
    carg = (c^2+r1^2-r2^2)/(c * r1 * 2); 
    if abs( carg) > 1 
        error('Cant do this angle') ; 
    end 
    gamma = acos( carg )  ;
    if ( thtDeg > 86 )
        gamma = -gamma ; 
    end 
    outVec(cnt) = ( delta - gamma )* 180/pi   ; 
end 

% figure(3); 
hold on
plot( outVec   ,thtVec ,'r.') ; grid on 
%ylabel('Motor') ; xlabel('Door') ; 

figure(3); clf
plot( thtVec , outVec  ) ; grid on 
ylabel('Motor') ; xlabel('Door') ; 

