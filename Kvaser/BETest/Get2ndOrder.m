function tf2 = Get2ndOrder(Ts,IsSimplepole,IsSimplezero,F1,F2,Xi1,Xi2,SimpleP,SimpleZ) 
% function tf2 = Get2ndOrder(Ts,IsSimplepole,IsSimplezero,F1,F2,Xi1,Xi2,SimpleP,SimpleZ) Get a 2nd order filter based on ts
% parameters
if IsSimplepole
    if isfinite(SimpleP) 
        den = [1 , -exp(-SimpleP*2*pi*Ts), 0 ]   ; 
    else
        den = [1,0,0] ; 
    end
else
    den = disc2(F1,Xi1,Ts); 
end

if IsSimplezero
    if isfinite(SimpleZ) 
        num = [1 , -exp(-SimpleZ*2*pi*Ts), 0 ]   ; 
    else
        num = [1,0,0] ; 
    end
else
    num = disc2(F2,Xi2,Ts); 
end
% Normalize DC gain 
if sum(den) <= 1e-8 
    error('Functions normalizes DC gain to unity, can''t take integrators') ; 
end 
num = num * sum(den) / sum(num) ; 
tf2 = tf( num,den, Ts ) ; 
end

function p = disc2(f,xi,Ts) 
    wn = 2 * pi * f ; 
    p = real(poly(exp(roots([1 , 2  *xi * wn  , wn^2])*Ts))) ; 
end