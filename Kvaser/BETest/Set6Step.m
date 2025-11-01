% tht = 0:0.001:1 ;
% thtr = tht ;
% delta = ( mod( tht,1) + 1 )  * 6.0  + 1  ;
%         delta = delta - mod(delta,1) ;
%         thtr = mod((delta-0.5) * 0.166666666666667,1)  ;
%         figure(1) ; clf
%         plot( tht , tht , tht , thtr) ; 

load SigRecSave6Step.mat ;
r = RecStr ; 
t = r.t ; 
R = 0.066 ; % 62 / 12 ; 
c1 = r.PhaseCur0 ;
c2 = r.PhaseCur1 ;
c3 = r.PhaseCur2 ;
v1r = r.PhaseVoltMeas0  ; 
v2r = r.PhaseVoltMeas1  ; 
v3r = r.PhaseVoltMeas2  ; 
v1 = v1r - R * c1 ; 
v2 = v2r - R * c2 ; 
v3 = v3r - R * c3 ; 
figure(1) ; clf
subplot( 3,1,1) ; 
plot( t , c1 , t , c2 , t, c3 ) ; legend( '1','2','3') ; 
subplot( 3,1,2) ; 
f = fix(r.ThetaElect * 6 ) ; 
plot( t , f )  ; 
ind3 = find( (f==0) | (f==3) ) ; 
ind2 = find( (f==2) | (f==5) ) ; 
ind1 = find( (f==1) | (f==4) ) ; 
vn = 1/3 * ( v1r + v2r + v3r ) ; 
% n(ind3) = (v1(ind3)+v2(ind3))/2 ; 
% n(ind2) = (v1(ind2)+v3(ind2))/2 ; 
% n(ind1) = (v2(ind1)+v3(ind1))/2 ; 


ve = v1 ; 
ve(ind3) = v3(ind3) - vn(ind3) ; 
ve(ind2) = v2(ind2) - vn(ind2) ; 
ve(ind1) = v1(ind1) - vn(ind1) ;
subplot( 3,1,3) ; 
%plot( t , v1 - vn , t , v2 - vn  , t , v3 - vn , t , ve ) ; legend('1','2','3','e') ; 
plot(   t , ve, 'd' ) ; 

% Locate segments between transitions 
df = diff(f) ; 
df = find( df); 
dt = mean( diff (t)) ; 
ndyn = ceil(1.3e-3 / dt) ; 
dfperiod = (df(end) - df(1)) /( length(df) - 1 ) ;
w = 2 * pi / (dfperiod*6 * dt) ; 
ve = ve(:) ; 
hold on ; 
nIntervals = length( df )-1 ; 
Evec = zeros(1,nIntervals) ; 
Pvec = zeros(1,nIntervals) ; 
Offset = pi/2 ; 
for cnt = 1 : nIntervals 
    ind = (df(cnt)+ndyn):(df(cnt+1)-2); 
    sarg = w *(1:length(ind))  * dt ; 
    sarg = sarg - mean(sarg) ; 
    C = cos(sarg ) ; C = C(:) ; 
    S = sin(sarg ) ; S = S(:) ; 
    H = [C S] ; 
    tht = (H' * H) \ H' *  ve(ind) ; 
    % disp( ['E: ',num2str(norm(tht)) ,'Angle : ' , num2str(180/pi*atan2(tht(2) , tht(1))) ]) ; 
    Evec(cnt ) = norm(tht) ; 
    Pvec(cnt)  = atan2(tht(2) , tht(1)) - (-1)^(cnt) * Offset ; 
    plot ( t(ind) , H * tht, 'r' ,'linewidth' , 2 ) ; 
end


% Estimation of resistance 
ncur = ceil(2e-3 / dt) ; 
rx = zeros(1,nIntervals-1) ; 
for cnt = 1 : nIntervals-1 
    ind2  = (df(cnt)+ndyn * 2):(df(cnt)+ndyn * 2 +ncur); 
    ind1 =  (df(cnt)-ncur-2):(df(cnt)-2); 
    indc = [ind1(:) ; ind2(:) ] ; 
    nind1 = length(ind1) ; 
    nind2 = length(ind2) ; 
    On1 = [ones(nind1,1) ; ones(nind2,1)];
    On2 = indc - mean(indc); 
    
    % Go for the current that changed 
    cd1 = c1(ind2(end)) - c1(ind1(1)) ;  
    cd2 = c2(ind2(end)) - c2(ind1(1)) ;  
    cd3 = c3(ind2(end)) - c3(ind1(1)) ;  
    [cdm,cdn] = min(abs([cd1,cd2,cd3])) ;
    if cdn == 1 
        On31 = c2(indc);
        vrv1 = v2r(:) - vn(:) ; 
        On32 = c3(indc);
        vrv2 = v3r(:) - vn(:) ; 
    elseif cdn == 2 
        On31 = c1(indc);
        vrv1 = v1r(:) - vn(:) ; 
        On32 = c3(indc);
        vrv2 = v3r(:) - vn(:) ; 
    else
        On31 = c1(indc);
        vrv1 = v1r(:) - vn(:) ; 
        On32 = c2(indc);
        vrv2 = v2r(:) - vn(:) ; 
    end
    
    figure(10) ; clf
    H = [On1 On2 On31(:)] ; 
    tht1 = (H' * H) \ H' *  vrv1(indc) ;
    r1 = tht1(3) ; 
    H = [On1 On2 On32(:)] ; 
    tht2 = (H' * H) \ H' *  vrv2(indc) ;
    r2 = tht2(3) ; 
    rx(cnt) = mean([r1,r2]);
    disp( [r1 , r2 , rx(cnt) ] );
%     plot( On2 ,v1rv(indc),'b', On2 ,v2rv(indc),'r', On2 ,v3rv(indc), 'y' , On2 , H * tht1 ,'b', On2 , H * tht2 ,'r', On2 , H * tht3 ,'y') ; 
    x = 1; 
end

figure(6) ; clf
subplot( 2,1,1) ; 
plot( 1 : nIntervals , Evec ) ; 
subplot( 2,1,2) ; 
plot( 1 : nIntervals , unwrap(Pvec ) * 180 / pi - 90 )  ; 


figure(7) ; clf
rawtht = atan2( -(v3-v2)/sqrt(3), -(v1-vn) )/2/pi; 
ind    = find(rawtht<0);
rawtht(ind) = rawtht(ind) + 1 ; 
plot( t ,r.ThetaElect , t,  mod( rawtht,1) ) ;  

figure(8) ; clf 
subplot( 2,1,1) ; 
plot( t , v1r - vn , t , v2r - vn  , t , v3r - vn ) ; legend('1','2','3') ;
subplot( 2,1,2) ; 
plot( t , v1 - vn , t , v2 - vn  , t , v3 - vn , t , ve ) ; legend('1','2','3','e') ;
