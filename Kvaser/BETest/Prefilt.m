wnfac = 0.5 ; 
wn = 50*2*pi * wnfac; 
Ts = 50e-6 ; 
sys1 = c2d( tf(wn^2,[1,1.96*wn,wn^2]) , Ts) ; 
sys1.num{1} = [sum(sys1.num{1}),0,0]; 
step( sys1)
wn = 60*2*pi * wnfac; 
sys2 = c2d( tf(wn^2,[1,1.65*wn,wn^2]) , Ts) ; 
sys2.num{1} = [sum(sys2.num{1}),0,0]; 
clf
figure(2) ; 
step( sys2 * sys1, 0.070);

u0 = 1 ;  
u = ones(1,6400) * u0 ; 
for cnt = 1:(length(u)/120-10)
    u((cnt-1)*120+(1:120)) = rand() ; 
end

t = 50e-6 * (0:(length(u)-1)); 
y = lsim(sys1 * sys2 , u ) ; 


figure(3) ;
clf 
subplot( 2,1,1); 
plot( t , y , t , u ) ; 
subplot(2,1,2); 
plot( t(2:end) , diff(y) / Ts ) ; 

b01 = round(sum(sys1.num{1}) * 2^31) ;
b02 = round(sum(sys2.num{1}) * 2^31) ;

a21 = round(sys1.den{1}(end)* 2^31) ; 
a22 = round(sys2.den{1}(end)* 2^31) ; 








