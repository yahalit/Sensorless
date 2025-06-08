global DataType
CanCom = [] ;

MisCellTest = struct('ParAz',  pi/2 ,'ParAzSpeed' , 2.5 ,'ParAzAcc' , 1.3 ) ; 
% SetFloatPar( 'AutomaticRunPars.DiffModeSpeed'

SendObj( [hex2dec('2207'),74] , 1 , DataType.float , 'yew') ;
SendObj( [hex2dec('2207'),75] , 1 , DataType.float , 'pitch') ;
SendObj( [hex2dec('2207'),76] , 3 , DataType.float , 'roll' ) ;

SendObj( [hex2dec('2207'),71] , MisCellTest.ParAz , DataType.float , 'ParAz') ;
SendObj( [hex2dec('2207'),72] , MisCellTest.ParAzSpeed , DataType.float , 'ParAzSpeed') ;
SendObj( [hex2dec('2207'),73] , MisCellTest.ParAzAcc , DataType.float , 'ParAzAcc' ) ;
SendObj( [hex2dec('2207'),70] , 1 , DataType.long , 'Diff start') ;

return 
addpath('C:\Nimrod\Simulation\Nav\Geometry');
x = load('AAA.mat') ; 
t = x.t ; 
Ts = mean( diff( t)) ; 
m0 = cumsum( x.RecVec(1,:) ) * Ts ; 
m1 = cumsum( x.RecVec(2,:) ) * Ts ; 
m2 = cumsum( x.RecVec(3,:) ) * Ts ; 
mn = m0 * 0 ; 
q = x.RecVec(4:7,:); 
for cnt = 1:length(t) 
    mn(cnt) = norm([m0(cnt),m1(cnt),m2(cnt)]) ; 
end 

figure ; plot( t , mn ) ; 
q1 = q(:,1) ;
q2 = q(:,end) ;

qt = InvQuatOnQuat(  q1, q2 ); 
tang = 2 * acos( qt(1)) ; 


