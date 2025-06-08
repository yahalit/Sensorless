dd = 0.001 ; 
leaderPos = [0:dd:1] ;  
FollowerPos = leaderPos ; 
zone = leaderPos ; 
armFollower = leaderPos ; 
bwv = armFollower ; 
bwv2 = armFollower ; 
for cnt = 1:length(armFollower) 
s = leaderPos(cnt);
[FollowerPos(cnt),zone(cnt),armFollower(cnt)] = GetFollowerByLeader(s); 
fp2 = GetFollowerByLeader(leaderPos(cnt)+dd); 
fp1 = GetFollowerByLeader(leaderPos(cnt)-dd); 
bwv2(cnt) = ( fp2 - fp1) / (2*dd) ; 
bwv(cnt) = GetWheelVelocityRatio(s) ; 
end 
figure(1) ; clf 
plot(leaderPos , FollowerPos ,'x', r.ArcDistance0 , r.ArcDistance1) ; legend('lf','01') ; grid on 
figure(2) ; 
plot( t , r.ArcDistance0 , t,  r.ArcDistance1)
figure(3) ; 
plot(leaderPos,bwv,leaderPos,bwv2) ; 