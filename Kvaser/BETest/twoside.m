function y = twoside ( x , z ) 
% function y = twoside ( x , z ) : Two sided symmetric (delayless) filtering of a signal
nx = length(x) ; 
x1 = x ; 
for cnt = 2:nx 
    x1(cnt) = x1(cnt-1)  + (1-z) * (x(cnt) - x1(cnt-1)) ; 
end
x1 = x1(end:-1:1) ; 
x2 = x1; 
for cnt = 2:nx 
    x2(cnt) = x2(cnt-1) + (1-z) * (x1(cnt) - x2(cnt-1)) ; 
end
y = x2(end:-1:1) ; 