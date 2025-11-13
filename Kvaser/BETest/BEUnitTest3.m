% Unit test for the 6 step mode
x = load('SixStepSave.mat') ; 
r = x.RecStr ;
t = r.t ; 

%                 t: [1×2047 double]
%                Ts: 2.0000e-04
%        ThetaElect: [1×2047 double]
%       VarMirrorVa: [1×2047 double]
%       VarMirrorVb: [1×2047 double]
%       VarMirrorVc: [1×2047 double]
%       VarMirrorIa: [1×2047 double]
%       VarMirrorIb: [1×2047 double]
%       VarMirrorIc: [1×2047 double]
%     SixThetaRawPU: [1×2047 double]

% Ideal algorithm
R = 0.061 ; % 62 / 12 ; 
c1 = r.VarMirrorIa ;
c2 = r.VarMirrorIb ;
c3 = r.VarMirrorIc ;
v1r = r.VarMirrorVa  ; 
v2r = r.VarMirrorVb  ; 
v3r = r.VarMirrorVc  ; 
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
