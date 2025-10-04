% PulseSequenceForStart - Generate a voltage pulse sequence that takes a stationary motor back to same position, zero speed
xx = ones(1,100) ; 
xxg = zeros(1,50) ; 
xxgg = zeros(1,25) ; 
xxh = ones(1,200)/2 ; 
%xx = [xx , -xx , -xxh , xxh , xx , -xx] ; 
xx = [xx , -xx , xxg ,-xx , xxg , xxg ,  xx , xxg  , xx , -xx] ; 
figure(100) ; 
clf 
subplot(4,1,1) ;
plot(xx)
subplot(4,1,2) ;
plot( cumsum(xx))
subplot(4,1,3) ;
plot( cumsum(cumsum(xx)))
subplot(4,1,4) ;
plot( cumsum(cumsum(cumsum(xx))))
