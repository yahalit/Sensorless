function y = UL2SL(x,n)
% Take a number of n binary bits and go to signed
    if x < 2^(n-1)
        y = x ; 
    else
        y = x - 2^n ; 
    end
end