% s is traveled distance
s = [0:0.0001:1] ; 
rat=s;
zone=s; 
tilt= s;
bwvd = s ; 
dtilt = s ; 
for cnt = 1:length(s) 
    [rat(cnt),zone(cnt)  , tilt(cnt) , dtilt(cnt),bwvd(cnt) ] = GetWheelVelocityRatio(s(cnt)) ; 
end

figure(50) ; 
subplot(4,1,1) ; 
plot( s, rat,'+', s , bwvd ) ; legend('rat','est') ; grid on
subplot(4,1,2) ; 
plot( s, zone) ; legend('zone') ; grid on
subplot(4,1,3) ; 
plot( s, tilt) ; legend('tilt'); grid on 
subplot(4,1,4) ; 
plot( s, dtilt,'+', s, dydt(tilt,s) ) ; legend('dtilt'); grid on 

