x = load('SigRecSave.mat') ; 
x = x.RecStr ; t = x.t ; 
%       RSteerPosEnc: [1×1000 double]
%     RsteerOuterPos: [1×1000 double]
fac = GetFloatPar('Geom.RSteerMotCntRad') ; 
e = x.RSteerPosEnc / fac ; e = e - e(1) ; 
p = x.RsteerOuterPos ; p  = p - p(1) ; 
figure(1) ; clf 































plot( t , e , t , p ) ; legend('e','p') ; 

