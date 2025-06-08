x = load('SigRecSave.mat') ; 
r = x.RecStr ; 



% lDebug1 is input 
plot( r.t , r.SpeedLimitedPosReference); 

b = b01 * 2 / 2^32 ; 
a = a21 * 2 / 2^32 ; 
n = length(r.t) ; 

u =  r.lDebug1 ; 
yv = zeros(1,n) ; 
yv(1) = r.lDebug2(1) ;
yv(2) = r.lDebug2(2) ;

ys1 = lsim(sys1,u) ; 
for cnt = 3:n 
    yv(cnt) = yv(cnt-1) + b * ( u(cnt) - yv(cnt-1) ) + a * ( yv(cnt-1) - yv(cnt-2) ) ; 
end 

y2x = zeros(1,n) ; 
y2x(1) = r.lDebug4(1) ;
y2x(2) = r.lDebug4(2) ;
b2 = b02 * 2 / 2^32 ; 
a2 = a22 * 2 / 2^32 ; 
u = r.lDebug2 ; 
ys2 = lsim(sys2,u) ; 

for cnt = 3:n 
    y2x(cnt) = y2x(cnt-1) + b2 * ( u(cnt) - y2x(cnt-1) ) + a2 * ( y2x(cnt-1) - y2x(cnt-2) ) ; 
end 


figure(4) ; 
plot( r.t, r.lDebug1 , r.t , yv ,'d', r.t , ys1,'+', r.t , r.lDebug2)

figure(5) ; 
plot( r.t, r.lDebug2 ,'r' , r.t, y2x ,'g' , r.t ,  ys2,'+', r.t , r.lDebug4,'+')

% Get equation error
figure(60) ; clf 
yvv = zeros(1,n) ; 
ind = find(r.lDebug3 < 0); 
fy = r.lDebug3 * 2^-32  ; 
fy(ind) = fy(ind) + 1  ;

yrec = r.lDebug2 + fy ; 

for cnt = 3:n 
    if ( cnt == 400 )
        xxx = 1 ; 
    end 
    x1 = r.lDebug2(cnt-1) + (b01/2^31) * ( u(cnt) - yrec(cnt-1) ) + (a21 / 2^31) * ( yrec(cnt-1) - yrec(cnt-2) ) ; 
    yvv(cnt) = r.lDebug2(cnt) - x1  ; 
end 
plot( r.t , yvv )


lPos = 1454026 ; 
b01 = 131453; 
a21 = 2114678849 ; 
yold = -2425168127810102; 
y    = -2381975724969470; 
t1 = b01 * lPos ;
t2 = a21 * (y-yold) 
t3 = y + a21 * (y-yold) 

a11 = '0x7239BB36'
a12 = '0x00001357'

yl='0xF4B267B2'
yh='0xFFF7B0A2'



