function y = InvertQuat(x) 
y = x ; 
y(2:4) = -x(2:4) ; 
end