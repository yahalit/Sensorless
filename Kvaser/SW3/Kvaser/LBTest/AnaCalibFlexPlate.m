function [corr, estr] = AnaCalibFlexPlate() 

estr = [] ; corr = [] ; 
x =  load('CalibFlexPlatePot.mat'); 
r = x.r ; 
% t = r.t ;

travel = max(r.AxisReadout_6) - min(r.AxisReadout_6) ; 
tol = 0.08 ; 
if ( travel < pi/2-tol || travel > pi/2+tol )
    estr = 'Travel was too big or too small, retry experiment' ; 
    return ; 
end

if abs( x.PotCenter - r.FlexPlateRatio(1) ) > 0.05 
    estr = 'You moved to fast, missed the start, retry experiment' ; 
    return ; 
end


dvec = 1:20 ; 
ee   = dvec * 0 ; 
ppv = [ee ; ee ] ; 
for cnt = 1:length(dvec) 
    delay = dvec(cnt) ; 
    enc1 = r.AxisReadout_6((1+delay):end) ; 
    pot1 = r.FlexPlateRatio((1):end-delay) ; 
%     t1   = r.t((1):end-delay) ;  
    d = diff(enc1) ; 
    ind = find(d)+1 ; 
    p = polyfit( enc1(ind) , pot1(ind) , 1 ) ; 
    e = pot1(ind) - polyval( p , enc1(ind)) ; 
    ee(cnt) = sum( e.*e) ; 
%     figure(40) ; clf 
%     plot( t1 , enc1 - enc1(1) , t1(ind) , enc1(ind)-enc1(1),'d' , t1(ind) , (pot1(ind)-pot1(1)) * -0.985 * x.nomgain,'x')
    ppv(:,cnt) = p(:) ; 
end 

[~,m] = min(ee) ; 
p     = ppv(:,m) ; 

fac = 1/ ( p(1) * x.nomgain) ; % -0.985 ;

delay = m ; 
enc1 = r.AxisReadout_6((1+delay):end) ; 
pot1 = r.FlexPlateRatio((1):end-delay) ; 
t1   = r.t((1):end-delay) ;  
d = diff(enc1) ; 
ind = find(d)+1 ; 

figure(10) ; clf 
%plot( t1(ind) , (enc1(ind)-enc1(1)) ,'+' , t1 , (enc1-enc1(1)) , t1 , (pot1-pot1(1))* x.nomgain * fac  )
plot( t1(ind) , (enc1(ind)-enc1(1)) ,'+' , t1(ind) , (pot1(ind)-pot1(1))* x.nomgain * fac  )
legend('Encoder','Potentiometer') ; 
drawnow 
ButtonName = questdlg('Is the fit good?','FIT Question', 'Yes', 'No', 'No');
if isequal(ButtonName,'Yes')
    corr = 1 - fac ; 
    if abs(corr) > 0.07
        estr = ['Correction factor too big: ', num2str(corr) ]; 
        corr = [] ; 
    end
else
    corr = [] ; 
    estr = 'User aborted fit' ; 
end
end