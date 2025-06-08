function y =mod2piS(x) 
	y = mod( mod(x,2*pi) + 3 * pi , 2 *pi ) - pi ; 
end 