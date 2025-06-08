function tf2 = Lead2(Ts,F1,F2,maxangle,Xi2,SimpleZ) 
den = disc2(F1,Xi1,Ts); 
if IsSimplezero
    if isfinite(SimpleZ) 
        num = [1 , -exp(-SimpleZ*2*pi*Ts), 0 ]   ; 
    else
        num = [1,0,0] ; 
    end
else
    num = disc2(F2,Xi2,Ts); 
end
num = num * sum(den) / sum(num) ; 
tf2 = tf( num,den, Ts ) ; 
end

function p = disc2(f,xi,Ts) 
    wn = 2 * pi * f ; 
    p = real(poly(exp(roots([1 , 2  *xi * wn  , wn^2])*Ts))) ; 
end