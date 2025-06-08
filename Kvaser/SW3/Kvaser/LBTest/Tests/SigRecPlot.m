r = load('SigRecSave'); 
r = r.RecStr ; 
t = r.t ; 
figure(23) ; clf 
subplot(3,1,1) ;
plot( t , r.LeftSteerUserSpeed + 0.02, t , r.RightSteerUserSpeed ,  t , r.LeftSteerAvgIntervalSpeed,  t , r.RightSteerAvgIntervalSpeed ) ; 
legend('LeftSteerUserSpeed','RightSteerUserSpeed', 'LeftSteerAvgIntervalSpeed', 'RightSteerAvgIntervalSpeed')  ; 
subplot(3,1,2) ;
plot( t , r.RightWheelUserSpeed , t , r.LeftWheelUserSpeed + 0.01 ) ; 
legend('RightWheelUserSpeed','LeftWheelUserSpeed')  ; 
subplot(3,1,3) ;
CalcGeomData ; 
plot( t , r.RWheelEncPos / Geom.WheelCntRad , t , r.LWheelEncPos  / Geom.WheelCntRad  + 0.01, t ,r.RsteerOuterPos + 0.02 , t , r.LsteerOuterPos + 0.03 ) ; 
legend('RWheelEncPos','LWheelEncPos', 'RsteerOuterPos', 'LsteerOuterPos')  ; 