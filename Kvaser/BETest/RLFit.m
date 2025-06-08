function Effect = RLFit(v)  
global g  %#ok<GVMIS>
global w  %#ok<GVMIS>
% Effect = abs(exp(-sqrt(-1) * d * x) ./ ( R + sqrt(-1) * L * x ) ./ g(:) - 1)  ; 
w1 = w(2:end) ; 
g1 = g(2:end) ; 
Effect = abs(exp(-sqrt(-1) * v(3) * w1(:)) ./ ( v(1) + sqrt(-1) * v(2) * w1 ) ./ g1(:) - 1 ) ;
% disp( abs(Effect) ) 
